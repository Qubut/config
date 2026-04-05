#!/usr/bin/env bash
set -euo pipefail
readonly SCRIPT_NAME="show-keybinds"
readonly MENU_PROMPT_MAIN="✨ Hyprland Command Center"
readonly MENU_PROMPT_LIST="⌨ Keybind Browser"
readonly ROFI_CMD=(rofi -dmenu -i)

declare -a ESSENTIAL_SHORTCUTS=(
  "Super+T"
  "Super+Q"
  "Super+F1"
  "Super+F2"
  "Super+Space"
  "Super+E"
  "Super+H"
  "Super+J"
  "Super+K"
  "Super+L"
  "Super+1"
  "Super+2"
  "Super+3"
  "Super+4"
  "Super+5"
  "Super+6"
  "Super+7"
  "Super+8"
  "Super+9"
)

notify_user() {
  local message="$1"

  if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    hyprctl notify -1 5000 0 "$message" >/dev/null 2>&1 || printf '%s\n' "$message" >&2
    return
  fi

  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Hyprland keybind help" "$message" >/dev/null 2>&1 || printf '%s\n' "$message" >&2
    return
  fi

  printf '%s\n' "$message" >&2
}

show_prompt() {
  local title="$1"
  local body="$2"
  notify_user "${title}: ${body}"
}

require_dependencies() {
  local missing=()
  local command_name

  for command_name in hyprctl jq rofi; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      missing+=("$command_name")
    fi
  done

  if ((${#missing[@]} > 0)); then
    notify_user "${SCRIPT_NAME}: missing dependency: ${missing[*]}"
    exit 1
  fi
}

title_case_mod() {
  case "${1^^}" in
    SUPER|MOD4) printf 'Super' ;;
    SHIFT) printf 'Shift' ;;
    CTRL|CONTROL) printf 'Ctrl' ;;
    ALT|MOD1) printf 'Alt' ;;
    *)
      local token="$1"
      printf '%s' "${token^}"
      ;;
  esac
}

format_key_token() {
  local key="$1"
  case "$key" in
    code:121) printf 'XF86AudioMute' ;;
    code:122) printf 'XF86AudioLowerVolume' ;;
    code:123) printf 'XF86AudioRaiseVolume' ;;
    code:232) printf 'XF86MonBrightnessDown' ;;
    code:233) printf 'XF86MonBrightnessUp' ;;
    code:237) printf 'XF86KbdBrightnessDown' ;;
    code:238) printf 'XF86KbdBrightnessUp' ;;
    code:255) printf 'RFKill' ;;
    code:256) printf 'XF86AudioMute' ;;
    mouse:272) printf 'LMB' ;;
    mouse:273) printf 'RMB' ;;
    mouse:274) printf 'MMB' ;;
    mouse_up) printf 'MouseWheelUp' ;;
    mouse_down) printf 'MouseWheelDown' ;;
    mouse_left) printf 'MouseWheelLeft' ;;
    mouse_right) printf 'MouseWheelRight' ;;
    switch:on:*) printf 'SwitchOn(%s)' "${key#switch:on:}" ;;
    switch:off:*) printf 'SwitchOff(%s)' "${key#switch:off:}" ;;
    switch:*) printf 'Switch(%s)' "${key#switch:}" ;;
    code:*) printf 'Keycode %s' "${key#code:}" ;;
    '') printf 'Unknown' ;;
    *) printf '%s' "$key" ;;
  esac
}

format_shortcut() {
  local mods_raw="$1"
  local key_raw="$2"
  local mods="$mods_raw"
  local key
  local token
  local result=""

  mods="${mods//SUPERSHIFT/SUPER SHIFT}"
  mods="${mods//SUPERCTRL/SUPER CTRL}"
  mods="${mods//SUPERALT/SUPER ALT}"
  mods="${mods//ALTSHIFT/ALT SHIFT}"
  mods="${mods//CTRLALT/CTRL ALT}"
  mods="${mods//,/ }"
  mods="${mods//_/ }"
  mods="$(tr -s ' ' <<<"$mods" | sed 's/^ //;s/ $//')"

  if [[ "$mods" =~ ^[0-9]+$ ]]; then
    local mask="$mods"
    local -a decoded_mods=()
    ((mask & 64)) && decoded_mods+=("SUPER")
    ((mask & 8)) && decoded_mods+=("ALT")
    ((mask & 4)) && decoded_mods+=("CTRL")
    ((mask & 1)) && decoded_mods+=("SHIFT")
    if ((${#decoded_mods[@]} > 0)); then
      mods="${decoded_mods[*]}"
    else
      mods=""
    fi
  fi

  key="$(format_key_token "$key_raw")"

  if [[ -z "$mods" || "$mods" == "-" || "$mods" == "0" ]]; then
    printf '%s' "$key"
    return
  fi

  for token in $mods; do
    if [[ -z "$result" ]]; then
      result="$(title_case_mod "$token")"
    else
      result+="+$(title_case_mod "$token")"
    fi
  done

  if [[ "$key" != "Unknown" ]]; then
    printf '%s+%s' "$result" "$key"
  else
    printf '%s' "$result"
  fi
}

direction_label() {
  case "$1" in
    l) printf 'left' ;;
    r) printf 'right' ;;
    u) printf 'up' ;;
    d) printf 'down' ;;
    f) printf 'forward' ;;
    b) printf 'backward' ;;
    prev) printf 'previous' ;;
    *) printf '%s' "$1" ;;
  esac
}

category_icon() {
  case "$1" in
    "Applications") printf "󱓞" ;;
    "Workspaces") printf "󰆍" ;;
    "Window Management") printf "󱂬" ;;
    "Group Management") printf "󰉋" ;;
    "Input") printf "󰌌" ;;
    "System") printf "󰇄" ;;
    "Media") printf "󰕾" ;;
    *) printf "󰈔" ;;
  esac
}

is_essential_shortcut() {
  local shortcut="$1"
  local candidate
  for candidate in "${ESSENTIAL_SHORTCUTS[@]}"; do
    if [[ "$candidate" == "$shortcut" ]]; then
      return 0
    fi
  done
  return 1
}

map_bind_metadata() {
  local dispatcher="$1"
  local args="$2"
  local description="$3"
  local category="Other"
  local action_label=""
  local command_text=""

  if [[ "$dispatcher" == "exec" ]]; then
    command_text="$args"
  elif [[ -n "$args" ]]; then
    command_text="$dispatcher $args"
  else
    command_text="$dispatcher"
  fi

  case "$dispatcher" in
    exec)
      category="Applications"
      action_label="Run command"
      ;;
    togglespecialworkspace|workspace|movetoworkspace|workspaceopt|focusworkspaceoncurrentmonitor)
      category="Workspaces"
      action_label="Workspace action"
      ;;
    movefocus|movewindow|resizeactive|togglefloating|fullscreen|killactive|cyclenext|bringactivetotop|focusurgentorlast)
      category="Window Management"
      action_label="Window action"
      ;;
    togglegroup|changegroupactive|lockactivegroup)
      category="Group Management"
      action_label="Group action"
      ;;
    pass|sendshortcut)
      category="Input"
      action_label="Input action"
      ;;
    exit|submap)
      category="System"
      action_label="System action"
      ;;
  esac

  case "$dispatcher" in
    movefocus) action_label="Focus window $(direction_label "$args")" ;;
    movewindow) action_label="Move window $(direction_label "$args")" ;;
    resizeactive) action_label="Resize active window ($args)" ;;
    togglespecialworkspace) action_label="Toggle special workspace ${args:-default}" ;;
    fullscreen)
      if [[ "$args" == "1" ]]; then
        action_label="Toggle fullscreen"
      elif [[ "$args" == "0" ]]; then
        action_label="Toggle maximized mode"
      fi
      ;;
    killactive) action_label="Close active window" ;;
    cyclenext)
      if [[ "$args" == "prev" ]]; then
        action_label="Cycle to previous window"
      else
        action_label="Cycle to next window"
      fi
      ;;
    bringactivetotop) action_label="Bring active window to top" ;;
    togglegroup) action_label="Toggle group mode" ;;
    changegroupactive) action_label="Switch active group member $(direction_label "$args")" ;;
    lockactivegroup) action_label="Lock active group (${args:-toggle})" ;;
    workspaceopt) action_label="Toggle workspace option ${args:-value}" ;;
    focusurgentorlast) action_label="Focus urgent or last window" ;;
    exit) action_label="Exit Hyprland session" ;;
    exec)
      if [[ -n "$args" ]]; then
        action_label="Run: $args"
      fi
      ;;
  esac

  if [[ "$command_text" == *"swayosd-client"* || "$command_text" == *"brightnessctl"* ]]; then
    category="Media"
  fi

  if [[ "$command_text" == *"systemctl suspend"* || "$command_text" == *"loginctl lock-session"* ]]; then
    category="System"
  fi

  if [[ -n "$description" ]]; then
    action_label="$description"
  fi

  if [[ -z "$action_label" ]]; then
    if [[ -n "$args" ]]; then
      action_label="${dispatcher} ${args}"
    else
      action_label="$dispatcher"
    fi
  fi

  printf '%s\t%s\t%s\n' "$category" "$action_label" "$command_text"
}

copy_value() {
  local label="$1"
  local value="$2"

  if command -v wl-copy >/dev/null 2>&1; then
    printf '%s' "$value" | wl-copy
    notify_user "Copied ${label}"
  else
    notify_user "wl-copy not available. ${label}: ${value}"
  fi
}

run_action_now() {
  local dispatcher="$1"
  local args="$2"
  local command_text="$3"

  if [[ "$dispatcher" == "exec" ]]; then
    if [[ -z "$args" ]]; then
      show_prompt "Cannot run" "No command attached to this bind"
      return
    fi
    bash -lc "$args" >/dev/null 2>&1 &
    show_prompt "Launched" "$args"
    return
  fi

  if [[ -n "$args" ]]; then
    hyprctl dispatch "$dispatcher" "$args" >/dev/null 2>&1 || {
      show_prompt "Dispatch failed" "$dispatcher $args"
      return
    }
    show_prompt "Dispatched" "$dispatcher $args"
  else
    hyprctl dispatch "$dispatcher" "1" >/dev/null 2>&1 || {
      show_prompt "Dispatch failed" "$dispatcher"
      return
    }
    show_prompt "Dispatched" "$dispatcher"
  fi
}

select_bind_index() {
  local -n display_ref=$1
  local selection
  local idx

  selection="$(printf '%s\n' "${display_ref[@]}" | "${ROFI_CMD[@]}" -p "Hyprland keybind help" || true)"
  if [[ -z "$selection" ]]; then
    return 1
  fi

  for idx in "${!display_ref[@]}"; do
    if [[ "${display_ref[$idx]}" == "$selection" ]]; then
      printf '%s' "$idx"
      return 0
    fi
  done

  return 1
}

show_detail_menu() {
  local category="$1"
  local shortcut="$2"
  local action="$3"
  local command="$4"
  local dispatcher="$5"
  local args="$6"
  local choice

  while true; do
    choice="$({
      printf '%s\n' "▶ Run now" "Copy shortcut" "Copy action label" "Copy command" "Back"
    } | "${ROFI_CMD[@]}" -p "${category} | ${shortcut}" -mesg "$action" || true)"

    case "$choice" in
      "▶ Run now") run_action_now "$dispatcher" "$args" "$command" ;;
      "Copy shortcut") copy_value "shortcut: ${shortcut}" "$shortcut" ;;
      "Copy action label") copy_value "action label: ${action}" "$action" ;;
      "Copy command") copy_value "command: ${command}" "$command" ;;
      "Back"|"") return 0 ;;
    esac
  done
}

select_from_menu() {
  local prompt="$1"
  shift
  printf '%s\n' "$@" | "${ROFI_CMD[@]}" -p "$prompt" || true
}

build_cheatsheet_blob() {
  local -n display_ref=$1
  local blob=""
  local line
  for line in "${display_ref[@]}"; do
    blob+="${line}\n"
  done
  printf '%b' "$blob"
}

main() {
  local binds_json
  local rows
  local mods
  local key
  local dispatcher
  local args
  local description
  local shortcut
  local mapped
  local category
  local action_label
  local command_text
  local selected_index
  local sorted_rows
  local main_choice
  local list_mode="all"
  local icon
  local display_line
  local selected_line
  local cheatsheet

  local -a records=()
  local -a categories=()
  local -a shortcuts=()
  local -a actions=()
  local -a commands=()
  local -a dispatchers=()
  local -a args_list=()
  local -a display_rows=()

  require_dependencies

  binds_json="$(hyprctl -j binds 2>/dev/null || true)"
  if [[ -z "$binds_json" || "$binds_json" == "null" ]]; then
    notify_user "${SCRIPT_NAME}: unable to read keybinds from hyprctl"
    exit 1
  fi

  rows="$(jq -r '
      def clean:
        if . == null then ""
        else tostring | gsub("[\\t\\r\\n]+"; " ")
        end;

      .[]?
      | [
          (.mods // .modmask // .mod // "" | clean),
          (.key // .keycode // .mouse // .switch // "" | clean),
          (.dispatcher // "" | clean),
          (.arg // .args // "" | clean),
          (.description // .desc // "" | clean)
        ]
      | @tsv
    ' <<<"$binds_json" 2>/dev/null || true)"

  if [[ -z "$rows" ]]; then
    notify_user "${SCRIPT_NAME}: no keybinds found"
    exit 0
  fi

  while IFS=$'\t' read -r mods key dispatcher args description; do
    [[ -z "$dispatcher" && -z "$key" ]] && continue

    shortcut="$(format_shortcut "$mods" "$key")"
    mapped="$(map_bind_metadata "$dispatcher" "$args" "$description")"
    IFS=$'\t' read -r category action_label command_text <<<"$mapped"

    records+=("$(printf '%s\t%s\t%s\t%s\t%s\t%s' "$category" "$shortcut" "$action_label" "$command_text" "$dispatcher" "$args")")
  done <<<"$rows"

  if ((${#records[@]} == 0)); then
    notify_user "${SCRIPT_NAME}: no keybinds found"
    exit 0
  fi

  sorted_rows="$(printf '%s\n' "${records[@]}" | LC_ALL=C sort -t$'\t' -k1,1 -k2,2)"

  while IFS=$'\t' read -r category shortcut action_label command_text dispatcher args; do
    icon="$(category_icon "$category")"
    categories+=("$category")
    shortcuts+=("$shortcut")
    actions+=("$action_label")
    commands+=("$command_text")
    dispatchers+=("$dispatcher")
    args_list+=("$args")
    display_rows+=("${icon}  [${category}]  ${shortcut}  —  ${action_label}")
  done <<<"$sorted_rows"

  while true; do
    main_choice="$(select_from_menu "$MENU_PROMPT_MAIN" "⚡ Essentials" "🗂 Browse all keybinds" "📋 Copy full cheat sheet" "✕ Close")"

    case "$main_choice" in
      "⚡ Essentials")
        list_mode="essentials"
        ;;
      "🗂 Browse all keybinds")
        list_mode="all"
        ;;
      "📋 Copy full cheat sheet")
        cheatsheet="$(build_cheatsheet_blob display_rows)"
        copy_value "full cheat sheet" "$cheatsheet"
        continue
        ;;
      ""|"✕ Close")
        exit 0
        ;;
    esac

    local -a filtered_display=()
    local -a filtered_indices=()
    local idx
    for idx in "${!display_rows[@]}"; do
      if [[ "$list_mode" == "essentials" ]]; then
        if ! is_essential_shortcut "${shortcuts[$idx]}"; then
          continue
        fi
      fi
      filtered_display+=("${display_rows[$idx]}")
      filtered_indices+=("$idx")
    done

    if ((${#filtered_display[@]} == 0)); then
      show_prompt "No entries" "No keybinds matched this view"
      continue
    fi

    selected_line="$(printf '%s\n' "${filtered_display[@]}" | "${ROFI_CMD[@]}" -p "$MENU_PROMPT_LIST (${list_mode})" || true)"
    if [[ -z "$selected_line" ]]; then
      continue
    fi

    selected_index=""
    for idx in "${!filtered_display[@]}"; do
      if [[ "${filtered_display[$idx]}" == "$selected_line" ]]; then
        selected_index="${filtered_indices[$idx]}"
        break
      fi
    done

    if [[ -z "$selected_index" ]]; then
      continue
    fi

    show_detail_menu \
      "${categories[$selected_index]}" \
      "${shortcuts[$selected_index]}" \
      "${actions[$selected_index]}" \
      "${commands[$selected_index]}" \
      "${dispatchers[$selected_index]}" \
      "${args_list[$selected_index]}"
  done
}

main "$@"
