#!/usr/bin/env bash
# Scratchpad child window handler
# Design Patterns Used:
# - Strategy Pattern: Different handling strategies for window placement
# - Registry Pattern: Centralized scratchpad class definitions
# - Chain of Responsibility: Sequential processing of window events
# - Command Pattern: Encapsulated hyprctl operations

# Don't use set -e as it causes premature exits
set -uo pipefail

SOCKET="/run/user/$(id -u)/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
LOG_PREFIX="[scratchpad-handler]"

# =============================================================================
# REGISTRY PATTERN: Centralized configuration for scratchpad definitions
# =============================================================================
declare -A SCRATCHPAD_REGISTRY=(
    ["special:scratch_term"]="^scratch_term$"
    ["special:scratch_ranger"]="^scratch_ranger$"
    ["special:scratch_thunar"]="^[Tt]hunar$"
    ["special:scratch_btm"]="^scratch_btm$"
    ["special:scratch_pavucontrol"]="^org\.pulseaudio\.pavucontrol$"
)

# =============================================================================
# UTILITY FUNCTIONS (Single Responsibility Principle)
# =============================================================================
log() {
    echo "$LOG_PREFIX [$(date '+%H:%M:%S')] $*"
}

log_debug() {
    [[ "${DEBUG:-0}" == "1" ]] && log "DEBUG: $*"
}

# =============================================================================
# QUERY FUNCTIONS (Data Access Layer)
# =============================================================================
query_window_by_address() {
    local address="$1"
    hyprctl clients -j | jq -r ".[] | select(.address == \"0x$address\")"
}

query_active_window() {
    hyprctl activewindow -j
}

query_workspace_windows() {
    local workspace="$1"
    hyprctl clients -j | jq -r ".[] | select(.workspace.name == \"$workspace\")"
}

# =============================================================================
# WINDOW INFO EXTRACTOR (Facade Pattern)
# =============================================================================
extract_window_class() {
    local window_json="$1"
    echo "$window_json" | jq -r '.class // empty'
}

extract_window_workspace() {
    local window_json="$1"
    echo "$window_json" | jq -r '.workspace.name // empty'
}

extract_grouped_count() {
    local window_json="$1"
    echo "$window_json" | jq -r '.grouped | length // 0'
}

# =============================================================================
# VALIDATORS (Guard Clauses / Specification Pattern)
# =============================================================================
is_special_workspace() {
    local workspace="$1"
    [[ "$workspace" == special:* ]]
}

is_registered_scratchpad() {
    local workspace="$1"
    [[ -n "${SCRATCHPAD_REGISTRY[$workspace]:-}" ]]
}

matches_scratchpad_class() {
    local workspace="$1"
    local window_class="$2"
    local expected_pattern="${SCRATCHPAD_REGISTRY[$workspace]}"
    [[ "$window_class" =~ $expected_pattern ]]
}

has_active_group() {
    local active_window_json="$1"
    local grouped_count
    grouped_count=$(extract_grouped_count "$active_window_json")
    [[ "$grouped_count" -gt 0 ]]
}

# =============================================================================
# COMMAND PATTERN: Encapsulated Hyprland operations
# =============================================================================
cmd_move_to_current_workspace() {
    local address="$1"
    log "Executing: move window 0x$address to current workspace"
    hyprctl dispatch movetoworkspace e+0,address:0x"$address"
}

cmd_focus_window() {
    local address="$1"
    log_debug "Focusing window 0x$address"
    hyprctl dispatch focuswindow address:0x"$address"
}

cmd_move_into_group() {
    local direction="${1:-l}"
    log "Executing: move window into group (direction: $direction)"
    hyprctl dispatch moveintogroup "$direction"
}

# =============================================================================
# STRATEGY PATTERN: Window placement strategies
# =============================================================================
strategy_move_to_workspace() {
    local address="$1"
    cmd_move_to_current_workspace "$address"
}

strategy_move_to_group() {
    local address="$1"
    
    # Get the target workspace (the one behind the special workspace)
    local target_workspace last_window_addr last_window_grouped
    target_workspace=$(hyprctl monitors -j | jq -r '.[0].activeWorkspace.id')
    log "Target workspace: $target_workspace"
    
    # Get the last focused window on that workspace (from workspace info)
    last_window_addr=$(hyprctl workspaces -j | jq -r ".[] | select(.id == $target_workspace) | .lastwindow")
    
    if [[ -n "$last_window_addr" && "$last_window_addr" != "0x0" ]]; then
        # Check if that window is part of a group
        last_window_grouped=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$last_window_addr\") | .grouped | length")
        log "Last focused window: $last_window_addr (grouped: $last_window_grouped)"
    else
        last_window_grouped=0
        log "No last focused window found on workspace $target_workspace"
    fi
    
    # Move window to workspace
    cmd_move_to_current_workspace "$address"
    sleep 0.15
    
    # If the last focused window was in a group, add the new window to that group
    if [[ "$last_window_grouped" -gt 0 ]]; then
        log "Last focused window is in a group, adding new window to it"
        
        # Focus the group member first
        hyprctl dispatch focuswindow "address:$last_window_addr"
        sleep 0.1
        
        # Now move the new window into this group using its address
        # The 'moveintogroup' dispatcher moves the focused window into an adjacent group
        # So we need to: 1) focus new window, 2) move it next to group, 3) merge
        
        # Focus the new window
        hyprctl dispatch focuswindow "address:0x$address"
        sleep 0.1
        
        # Try to move into group from all directions
        local result
        result=$(hyprctl dispatch moveintogroup l 2>&1)
        log "moveintogroup l: $result"
        
        # Check if it worked by seeing if the window is now grouped
        local new_window_grouped
        new_window_grouped=$(hyprctl clients -j | jq -r ".[] | select(.address == \"0x$address\") | .grouped | length")
        
        if [[ "$new_window_grouped" -eq 0 ]]; then
            # Try other directions
            hyprctl dispatch moveintogroup r
            hyprctl dispatch moveintogroup u  
            hyprctl dispatch moveintogroup d
        fi
        
        # Final check
        new_window_grouped=$(hyprctl clients -j | jq -r ".[] | select(.address == \"0x$address\") | .grouped | length")
        log "New window grouped status: $new_window_grouped"
    else
        log "Last focused window is not in a group, window stays standalone"
    fi
}

# =============================================================================
# CHAIN OF RESPONSIBILITY: Window event processing pipeline
# =============================================================================
process_window_event() {
    local window_address="$1"
    
    # Step 1: Allow window to settle
    sleep 0.1
    
    # Step 2: Query window information
    local window_info
    window_info=$(query_window_by_address "$window_address")
    
    # Guard: Window must exist
    if [[ -z "$window_info" ]]; then
        log_debug "Window 0x$window_address not found, skipping"
        return 0
    fi
    
    # Step 3: Extract window properties
    local window_class workspace_name
    window_class=$(extract_window_class "$window_info")
    workspace_name=$(extract_window_workspace "$window_info")
    
    log_debug "Processing: class='$window_class' workspace='$workspace_name'"
    
    # Step 4: Validate - must be in special workspace
    if ! is_special_workspace "$workspace_name"; then
        log_debug "Not in special workspace, skipping"
        return 0
    fi
    
    # Step 5: Validate - must be a registered scratchpad
    if ! is_registered_scratchpad "$workspace_name"; then
        log_debug "Unknown special workspace '$workspace_name', skipping"
        return 0
    fi
    
    # Step 6: Check if window belongs to this scratchpad
    if matches_scratchpad_class "$workspace_name" "$window_class"; then
        log_debug "Window '$window_class' belongs to '$workspace_name', keeping in place"
        return 0
    fi
    
    # Step 7: Window doesn't belong - apply placement strategy
    log "Child window detected: '$window_class' in '$workspace_name'"
    
    # Apply strategy: move to workspace and add to group if one exists
    strategy_move_to_group "$window_address"
    
    log "Successfully relocated '$window_class' from scratchpad"
}

# =============================================================================
# EVENT LISTENER (Observer Pattern)
# =============================================================================
parse_openwindow_event() {
    local event_data="$1"
    # Format: openwindow>>ADDRESS,WORKSPACE,CLASS,TITLE
    echo "$event_data" | cut -d',' -f1
}

listen_for_events() {
    log "Starting event listener on $SOCKET"
    
    local data window_address line
    
    # Single connection - if it fails, exit and let systemd/autostart restart
    socat -u UNIX-CONNECT:"$SOCKET" - 2>/dev/null | while IFS= read -r line; do
        if [[ "$line" == "openwindow>>"* ]]; then
            data="${line#openwindow>>}"
            window_address=$(parse_openwindow_event "$data")
            
            log_debug "Event received: openwindow, address=$window_address"
            
            # Process in subshell to not block event loop
            (process_window_event "$window_address") &
        fi
    done
    
    log "Event listener disconnected"
}

# =============================================================================
# MAIN ENTRY POINT
# =============================================================================
main() {
    log "Scratchpad handler initialized"
    log "Registered scratchpads: ${!SCRATCHPAD_REGISTRY[*]}"
    
    # Validate socket exists
    if [[ ! -S "$SOCKET" ]]; then
        log "ERROR: Hyprland socket not found at $SOCKET"
        exit 1
    fi
    
    listen_for_events
}

# Run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi