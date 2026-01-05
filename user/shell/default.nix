{ pkgs, userSettings, ... }:
let
  envExtra = ''
    ########## SHELL & SESSION ##########
    export ZSHDO
    export XDG_SESSION_LOG_DIR="$HOME/.cache"
    export XDG_SESSION_LOG_FILE="$XDG_SESSION_LOG_DIR/xsession-errors"

    ########## X11 & DISPLAY SERVER ##########
    export USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
    export USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
    export ALTUSERXSESSION="$XDG_CACHE_HOME/X11/Xsession"
    export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
    export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
    export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
    export XSERVERRC="$XDG_CONFIG_HOME"/X11/xserverrc

    ########## WINDOW MANAGERS & DESKTOP ENVIRONMENTS ##########
    # KDE
    export KDEHOME="$XDG_CONFIG_HOME"/kde
    # XMonad
    export XMONAD_CACHE_DIR="$XDG_CACHE_HOME/xmonad"
    export XMONAD_CONFIG_DIR="$XDG_CONFIG_HOME/xmonad"
    export XMONAD_DATA_DIR="$XDG_DATA_HOME/xmonad"

    ########## WAYLAND & COMPOSITORS ##########
    # Sway specific
    export __GL_GSYNC_ALLOWED=0
    export __GL_VRR_ALLOWED=0
    export WLR_DRM_NO_ATOMIC=1
    # Graphics/Display
    export QT_QPA_PLATFORM=${userSettings.wmType}
    export GDK_BACKEND=${userSettings.wmType}
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export MOZ_ENABLE_WAYLAND=1
    export SDL_VIDEODRIVER=${userSettings.wmType}
    export _JAVA_AWT_WM_NONREPARENTING=1

    ########## PROGRAMMING LANGUAGES & RUNTIMES ##########
    # Python
    export PYTHONPYCACHEPREFIX="$XDG_CACHE_HOME/python"
    export PYTHONUSERBASE="$XDG_DATA_HOME/python"
    export PYTHON_HISTORY=$XDG_STATE_HOME/
    export PATH="$PATH:~/.local/share/pyenv/versions/"
    # Go
    export GOPATH=$XDG_DATA_HOME/go
    # export GOBIN="$HOME/.local/share/go/bin"
    # Rust
    export CARGO_HOME="$XDG_DATA_HOME"/cargo
    export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
    # Haskell
    export STACK_XDG=1
    export GHCUP_USE_XDG_DIRS=true
    # export GHCUP_INSTALL_BASE_PREFIX=$XDG_CONFIG_HOME
    # export PATH="$PATH:$GHCUP_INSTALL_BASE_PREFIX"/.ghcup/bin
    # Node.js
    export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
    # Java
    export _JAVA_OPTIONS=-

    ########## PACKAGE MANAGERS & BUILD TOOLS ##########
    # npm/yarn
    export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
    alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'
    # NuGet
    export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
    # Gradle
    export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
    # Leiningen (Clojure)
    export LEIN_HOME="$XDG_DATA_HOME"/lein

    ########## TEXT EDITORS & IDEs ##########
    # Vim/Neovim
    export VIMINIT='let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" : "$XDG_CONFIG_HOME/nvim/init.vim" | so $MYVIMRC'
    export GVIMINIT='let $MYGVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/gvimrc" : "$XDG_CONFIG_HOME/nvim/init.gvim" | so $MYGVIMRC'

    ########## DEVELOPMENT TOOLS & SERVICES ##########
    # Docker
    export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
    # Jupyter
    export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME"/jupyter
    export JUPYTER_PLATFORM_DIRS="1"
    # Ansible
    export ANSIBLE_HOME="$XDG_CONFIG_HOME/ansible"
    export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible.cfg"
    export ANSIBLE_GALAXY_CACHE_DIR="$XDG_CACHE_HOME/ansible/galaxy_cache"
    # SageMath
    export DOT_SAGE="$XDG_CONFIG_HOME"/sage

    ########## HARDWARE & EMBEDDED DEVELOPMENT ##########
    # Arduino
    export ARDUINO_SKETCHBOOK="$HOME/.local/share/arduino"
    export ARDUINO_DATA_DIR="$HOME/.local/share/arduino"
    export ARDUINO_CONFIG_DIR="$HOME/.config/arduino"
    # CUDA
    export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
    # Graphics
    # export DRI_PRIME=1

    ########## CLOUD & INFRASTRUCTURE ##########
    # AWS
    export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
    export AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config
    # Kubernetes
    export KUBECONFIG="$XDG_CONFIG_HOME/kube"
    export KUBECACHEDIR="$XDG_CACHE_HOME/kube"

    ########## NETWORK & WEB TOOLS ##########
    # wget
    export WGETRC="$XDG_CONFIG_HOME/wgetrc"
    # elinks
    export ELINKS_CONFDIR="$XDG_CONFIG_HOME"/elinks
    # w3m
    export W3M_DIR="$XDG_STATE_HOME/w3m"

    ########## GRAPHICAL APPLICATIONS & TOOLKITS ##########
    # GTK
    export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
    # Qt
    # export QT_AUTO_SCREEN_SCALE_FACTOR=1
    # export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

    ########## DOCUMENTATION & TYPESETTING ##########
    # LaTeX/TeX
    export TEXMFHOME=$XDG_DATA_HOME/texmf
    export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var

    ########## SECURITY & CRYPTOGRAPHY ##########
    # GnuPG
    export GNUPGHOME="$XDG_DATA_HOME"/gnupg

    ########## APPLICATION-SPECIFIC ##########
    # Freeplane
    # export FREEPLANE_JAVA_HOME="/usr/lib/jvm/java-11-openjdk/bin/java"
    # export FREEPLANE_USE_UNSUPPORTED_JAVA_VERSION=1
    # Wakatime (commented)
    # export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
  '';
in
{
  imports = [
    ./zsh.nix
    ./bash.nix
  ];
  programs.zsh.envExtra = envExtra;
  programs.bash.bashrcExtra = envExtra;
  programs.zoxide.enable = true;
  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;
  home.packages = with pkgs; [
    disfetch
    onefetch
    gnugrep
    gnused
    bat
    eza
    bottom
    fd
    bc
    nix-direnv
  ];
}
