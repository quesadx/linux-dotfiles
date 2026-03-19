{
  config,
  pkgs,
  lib,
  ...
}:

# ============================================================================
# VARIABLES - User packages, aliases, and configurations
# ============================================================================

let
  username = "quesadx";
  homeDir = "/home/quesadx";

  # Git user information
  gitUser = {
    name = "Matteo Quesada"; # GitHub: @quesadx
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };

  # Shell aliases for common commands
  bashAliases = {
    # Listing
    ll = "ls -l"; # Long format
    ls = "ls -a --color=auto"; # Show hidden, color output
    # Git shortcuts
    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";
    # NixOS commands
    nrt = "cd ~/dotfiles/nixos-dotfiles && sudo nixos-rebuild test --flake .#nixos"; # Test rebuild
    nrs = "cd ~/dotfiles && git add . && cd nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos"; # Switch & commit
    # Docker shortcuts
    dcu = "docker compose up";
    dcud = "docker compose up -d"; # Background
    dcd = "docker compose down";
    dcdv = "docker compose down -v"; # Remove volumes
  };

  # User packages (not in system)
  userPackages = with pkgs; [
    # File management
    nautilus
    file-roller
    unzip
    unrar
    p7zip # GUI file manager, archive tools
    # GNOME apps
    gnome-photos
    gnome-music
    gnome-calendar # Media apps
    gnome-calculator
    gnome-text-editor # Utilities
    gnome-font-viewer
    gnome-console # System apps
    adwaita-icon-theme
    glib
    gtk3 # GNOME theming
    # Accessory & productivity
    fastfetch
    papers
    showtime
    rnote # System info, note-taking
    dconf-editor
    onlyoffice-desktopeditors # Config editor, Office suite
    obsidian
    dbeaver-bin
    mysql-workbench # Knowledge base, DB tools
    mongodb-compass
    spotify
    tmux
    alacritty # Database, music, terminal
    calcure
    gnome-calendar # Calendar/scheduling
    # Development tools
    claude-code
    direnv
    nix-direnv # CodeAI, environment management
    # Commented out packages (available if needed)
    # cisco-packet-tracer_9 xcape neovim openclaw
  ];

  # Enabled GNOME extensions
  gnome-extensions-enabled = [
    "AlphabeticalAppGrid@stuarthayhurst" # Alphabetical app grid
    "appindicatorsupport@rgcjonas.gmail.com" # System tray
    "caffeine@patapon.info" # Prevent screen lock
    "clipboard-history@alexsaveau.dev" # Clipboard history
    "luminus-desktop@dikasp.gitlab" # Status bar tweaks
  ];

  # VS Code extensions
  vscode-extensions-enabled = with pkgs.vscode-extensions; [
    # Viewers & formatters
    esbenp.prettier-vscode # Code formatter
    ecmel.vscode-html-css # HTML/CSS preview
    humao.rest-client # REST API client
    # Language support
    ms-python.python # Python
    vscjava.vscode-java-pack # Java
    james-yu.latex-workshop # LaTeX
    bbenoist.nix # Nix syntax
    yoavbls.pretty-ts-errors # TypeScript errors
    # Git & project tools
    eamodio.gitlens # Git integration
    github.vscode-github-actions # GitHub Actions
    cweijan.vscode-database-client2 # Database client
    # Development utilities
    ms-vscode.live-server # Live preview
    christian-kohler.path-intellisense # Path autocompletion
    christian-kohler.npm-intellisense # npm autocompletion
    mikestead.dotenv # .env support
    dbaeumer.vscode-eslint # ESLint
    usernamehw.errorlens # Inline error display
    formulahendry.auto-rename-tag # Auto tag rename
    formulahendry.auto-close-tag # Auto close HTML tags
    shardulm94.trailing-spaces # Highlight trailing spaces
    oderwat.indent-rainbow # Rainbow indentation
    ms-azuretools.vscode-containers # Container support
    # AI & productivity
    anthropic.claude-code # Claude AI assistant
    pkief.material-icon-theme # Material icon theme
  ];

  # Firefox extensions (auto-installed)
  firefoxExtensions = {
    "uBlock0@raymondhill.net" = {
      # Adblocker
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
      # Bitwarden password manager
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      installation_mode = "force_installed";
    };
  };

  # Config file sources
  configSources = {
    "fastfetch".source = ../.config/fastfetch; # System info tool config
  };

in

# ============================================================================
# HOME MANAGER CONFIGURATION
# ============================================================================

{
  # Home Manager metadata
  programs.home-manager.enable = true; # Enable Home Manager as NixOS module
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "26.05";
  home.packages = userPackages;

  # ---------- SYSTEM SERVICES ----------
  services.ssh-agent.enable = true; # SSH key management
  xdg.configFile = configSources; # Link config files from ../. config/

  # ---------- EDITOR: NEOVIM ----------
  programs.neovim = {
    enable = true;
    defaultEditor = true; # Set as default editor
    viAlias = true; # vi command alias
    vimAlias = true; # vim command alias
  }; # neovim end

  # ---------- SHELL: ZSH & BASH ----------
  programs.starship.enable = true; # Minimal shell prompt
  programs.zsh.enable = true;
  programs.bash.enable = true;
  programs.bash.shellAliases = bashAliases; # Sourced automatically

  # ---------- VERSION CONTROL: GIT ----------
  programs.git.enable = true;
  programs.git.package = pkgs.gitFull; # Full git with extras
  programs.git.settings.user = gitUser;
  programs.git.settings.init.defaultBranch = "main";
  programs.git.settings.pull.rebase = true; # Rebase on pull
  programs.git.settings.credential.helper = "libsecret"; # Keyring storage

  # ---------- ENVIRONMENT: DIRENV ----------
  programs.direnv.enable = true; # .envrc auto-loading
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true; # Nix environment support

  # ---------- SSH CONFIGURATION ----------
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false; # Manual SSH config
  programs.ssh.matchBlocks."*".addKeysToAgent = "yes"; # Auto-add keys

  # ---------- EDITOR: HELIX ----------
  programs.helix.enable = true; # Modern terminal editor
  programs.helix.settings.theme = "monokai_soda";
  programs.helix.settings.editor.lsp.display-messages = true; # Show LSP messages
  programs.helix.extraPackages = with pkgs; [
    nixd
    nixfmt # Nix formatter & LSP
    wl-clipboard
    xclip # Clipboard support
    nodePackages.typescript-language-server # TypeScript LSP
  ];

  # Language-specific settings in Helix
  programs.helix.languages.language = [
    {
      name = "nix";
      auto-format = true;
      formatter.command = "nixfmt"; # Auto-format Nix files
    }
    {
      name = "typescript";
      auto-format = true;
      language-servers = [ "typescript-language-server" ];
    }
    {
      name = "javascript";
      auto-format = true;
      language-servers = [ "typescript-language-server" ];
    }
  ];

  # ---------- OTHER EDITORS ----------
  programs.emacs.enable = true; # GNU Emacs

  # ---------- EDITOR: VS CODE ----------
  programs.vscode.enable = true; # Microsoft Visual Studio Code
  programs.vscode.profiles.default.extensions = vscode-extensions-enabled;
  programs.vscode.profiles.default.userSettings = {
    # Appearance
    "workbench.activityBar.location" = "top"; # Activity bar position
    "workbench.sideBar.location" = "right"; # Sidebar position
    "workbench.colorTheme" = "Monokai Dimmed"; # Color theme
    "workbench.iconTheme" = "material-icon-theme"; # Icon theme
    "editor.minimap.enabled" = false; # Disable minimap
    "window.commandCenter" = false; # Disable command center
    # Editing
    "editor.defaultFormatter" = "esbenp.prettier-vscode"; # Default formatter
    "files.autoSave" = "onFocusChange"; # Auto-save on focus lose
    "editor.linkedEditing" = true; # Edit opening/closing tags
    # Tabs
    "workbench.editor.scrollToSwitchTabs" = true; # Scroll to switch tabs
    "workbench.editor.wrapTabs" = true; # Wrap tabs if needed
    # UI
    "explorer.confirmDelete" = false; # No delete confirmation
    "explorer.confirmDragAndDrop" = false; # No drag & drop confirm
    "workbench.startupEditor" = "none"; # Don't open files on startup
    # Git
    "git.openRepositoryInParentFolders" = "always"; # Find git repos in parents
    "git.enableSmartCommit" = true; # Smart commit behavior
    "git.autofetch" = true; # Auto-fetch from remote
  };

  # ---------- BROWSER: FIREFOX ----------
  programs.firefox.enable = true; # Mozilla Firefox
  programs.firefox.profiles.${username} = {
    isDefault = true; # Set as default profile
    settings = {
      "browser.search.region" = "CR"; # Search region
      "browser.search.isUS" = false; # Non-US search
      "distribution.id" = "nixos"; # Distribution ID
    };
  };
  programs.firefox.policies.ExtensionSettings = firefoxExtensions; # Install extensions

  # ---------- GNOME DESKTOP CONFIGURATION ----------
  dconf.enable = true; # GNOME settings (dconf) management
  # GNOME Shell extensions
  dconf.settings."org/gnome/shell".enabled-extensions = gnome-extensions-enabled;
  # Extension: Alphabetical App Grid
  dconf.settings."org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "start";
  # Extension: AppIndicator (System Tray)
  dconf.settings."org/gnome/shell/extensions/appindicator".legacy-tray-enabled = false;
  # Extension: Caffeine (Prevent lock)
  dconf.settings."org/gnome/shell/extensions/caffeine".restore-state = true; # Restore after sleep
  dconf.settings."org/gnome/shell/extensions/caffeine".enable-fullscreen = false; # Off in fullscreen
  # Input method settings
  dconf.settings."org/gnome/desktop/input-sources".show-all-sources = true; # Show all keyboard layouts
  dconf.settings."org/gnome/desktop/input-sources".sources = [
    (lib.gvariant.mkTuple [
      "xkb" # Keyboard type
      "us+altgr-intl" # US layout with AltGr international characters
    ])
  ];
  # Window manager keybindings (Super = Windows key)
  dconf.settings."org/gnome/desktop/wm/keybindings".maximize = [ "<Super>F" ]; # Super+F to maximize
  dconf.settings."org/gnome/desktop/wm/keybindings".minimize = [ "<Super>D" ]; # Super+D to minimize
  dconf.settings."org/gnome/desktop/wm/keybindings".close = [ "<Super>Q" ]; # Super+Q to close
  # Power & system settings
  dconf.settings."org/gnome/settings-daemon/plugins/power".power-button-action = "nothing"; # Power button does nothing

  # Media key bindings (for folder/browser/settings access)
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".home = [ "<Super>e" ]; # Super+E = File manager
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".www = [ "<Super>b" ]; # Super+B = Browser
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".control-center = [ "<Super>i" ]; # Super+I = Settings
  # Custom media keybinding (terminal launcher)
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  ];
  # custom0: Super+T = Launch Terminal
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".binding =
    "<Super>t";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".command =
    "kgx";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".name =
    "gnome-console";
  # Mouse & accessibility
  dconf.settings."org/gnome/desktop/peripherals/mouse".accel-profile = "flat"; # No mouse acceleration
  dconf.settings."org/gnome/desktop/sound".event-sounds = false; # Disable system sounds

}
