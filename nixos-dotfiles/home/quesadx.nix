{
  config,
  pkgs,
  lib,
  shared,
  ...
}:

# ============================================================================
# VARIABLES - User packages, aliases, and configurations
# ============================================================================

let
  username = shared.username;
  homeDir = "/home/${username}";

  # Git user information
  gitUser = {
    name = "Matteo Quesada";                                            # GitHub: @quesadx
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };

  # Shell aliases for common commands
  bashAliases = {
    # Listing
    ll = "ls -l";                                                       # Long format
    ls = "ls -a --color=auto";                                          # Show hidden, color output
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
    dcud = "docker compose up -d";                                      # Background
    dcd = "docker compose down";
    dcdv = "docker compose down -v";                                    # Remove volumes
  };

  # User packages (not in system)
  userPackages = with pkgs; [
    # File management
    nautilus
    file-roller
    unzip
    unrar
    p7zip                                                               # GUI file manager, archive tools
    # GNOME ap
    gnome-photos
    gnome-music
    gnome-calendar                                                      # Media apps
    gnome-calculator
    gnome-text-editor                                                   # Utilities
    gnome-font-viewer
    gnome-console                                                       # System apps
    adwaita-icon-theme
    glib
    gtk3                                                                # GNOME theming
    # Accessory & productivity
    fastfetch
    papers
    showtime
    rnote                                                               # System info, note-taking
    dconf-editor                                                        # Config editor
    onlyoffice-desktopeditors                                           # Office suite
    obsidian
    dbeaver-bin
    mysql-workbench                                                     # DB tools
    mongodb-compass
    spotify
    zed-editor
    # Development tools
    claude-code
    direnv
    nix-direnv                                                          # CodeAI, environment management
    wireshark
    postman
    # Commented out packages (available if needed)
    # cisco-packet-tracer_9 xcape neovim openclaw
  ];

  # VS Code extensions
  vscode-extensions-enabled = with pkgs.vscode-extensions; [
    # Viewers & formatters
    esbenp.prettier-vscode                                              # Code formatter
    ecmel.vscode-html-css                                               # HTML/CSS preview
    humao.rest-client                                                   # REST API client
    # Language support
    ms-python.python                                                    # Python
    vscjava.vscode-java-pack                                            # Java
    james-yu.latex-workshop                                             # LaTeX
    bbenoist.nix                                                        # Nix syntax
    # yoavbls.pretty-ts-errors # TypeScript errors
    # Git & project tools
    # eamodio.gitlens # Git integration
    # github.vscode-github-actions # GitHub Actions
    # cweijan.vscode-database-client2 # Database client
    # Development utilities
    ms-vscode.live-server                                               # Live preview
    christian-kohler.path-intellisense                                  # Path autocompletion
    christian-kohler.npm-intellisense                                   # npm autocompletion
    mikestead.dotenv                                                    # .env support
    # dbaeumer.vscode-eslint # ESLint
    # usernamehw.errorlens # Inline error display
    formulahendry.auto-rename-tag                                       # Auto tag rename
    formulahendry.auto-close-tag                                        # Auto close HTML tags
    shardulm94.trailing-spaces                                          # Highlight trailing spaces
    #oderwat.indent-rainbow # Rainbow indentation
    # ms-azuretools.vscode-containers # Container support
    mongodb.mongodb-vscode                                              # MongoDB utility
    # AI & productivity
    # anthropic.claude-code # Claude AI assistant
    pkief.material-icon-theme                                           # Material icon theme
    # vscodevim.vim # Vim emulation
    prisma.prisma                                                       # Prisma syntax hightlighting, formatting & more
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
    "fastfetch".source = ../../.config/fastfetch;                       # System info tool config
    "sway".source = ../../.config/sway;                                 # Sway window manager config
  };

in

# ============================================================================
# HOME MANAGER CONFIGURATION
# ============================================================================

{
  imports = [ ../modules/desktop-gnome-user.nix ];

  # Home Manager metadata
  programs.home-manager.enable = true;                                  # Enable Home Manager as NixOS module
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "26.05";
  home.packages = userPackages;

  # ---------- SYSTEM SERVICES ----------
  services.ssh-agent.enable = true;                                     # SSH key management
  xdg.configFile = configSources;                                       # Link config files from ../. config/

  # ---------- EDITOR: NEOVIM ----------
  programs.neovim = {
    enable = true;
    defaultEditor = true;                                               # Set as default editor
    viAlias = true;                                                     # vi command alias
    vimAlias = true;                                                    # vim command alias
  };

  # ---------- SHELL: ZSH & BASH ----------
  programs.starship.enable = true;                                      # Minimal shell prompt
  programs.zsh.enable = true;
  programs.bash.enable = true;
  programs.bash.shellAliases = bashAliases;                             # Sourced automatically

  # ---------- VERSION CONTROL: GIT ----------
  programs.git.enable = true;
  programs.git.package = pkgs.gitFull;                                  # Full git with extras
  programs.git.settings.user = gitUser;
  programs.git.settings.init.defaultBranch = "main";
  programs.git.settings.pull.rebase = true;                             # Rebase on pull
  programs.git.settings.credential.helper = "libsecret";                # Keyring storage

  # ---------- ENVIRONMENT: DIRENV ----------
  programs.direnv.enable = true;                                        # .envrc auto-loading
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;                             # Nix environment support

  # ---------- SSH CONFIGURATION ----------
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;                             # Manual SSH config
  programs.ssh.matchBlocks."*".addKeysToAgent = "yes";                  # Auto-add keys

  # ---------- EDITOR: FRESH ----------
  programs.fresh-editor.enable = true;                                         # Fresh terminal file manager

  # ---------- EDITOR: HELIX ----------
  programs.helix.enable = true;                                         # Modern terminal editor
  programs.helix.settings.theme = "base16_default";
  programs.helix.settings.editor = {
    lsp.display-messages = true;                                        # Show LSP messages
    lsp.display-inlay-hints = true;                                     # Show typescript inlay hints
    auto-info = false;                                                  # Disable automatic signature/doc popups
    completion-timeout = 50;                                            # Keep completion hints fast
  };
  programs.helix.extraPackages = with pkgs; [
    # LSPs
    nixd
    nixfmt
    nodePackages.typescript-language-server                             # TS/JS
    nodePackages.vscode-json-languageserver                             # JSON
    marksman                                                            # Markdown
    jdt-language-server                                                 # Java
    clang-tools                                                         # C/C++
    nodePackages.bash-language-server                                   # Bash
    # Utilities
    xclip
  ];

  # Language-specific settings in Helix
  programs.helix.languages.language-server.typescript-language-server.config = {
    typescript.inlayHints = {
      includeInlayEnumMemberValueHints = true;
      includeInlayFunctionLikeReturnTypeHints = true;
      includeInlayFunctionParameterTypeHints = true;
      includeInlayParameterNameHints = "all";
      includeInlayParameterNameHintsWhenArgumentMatchesName = true;
      includeInlayPropertyDeclarationTypeHints = true;
      includeInlayVariableTypeHints = true;
    };
    javascript.inlayHints = {
      includeInlayEnumMemberValueHints = true;
      includeInlayFunctionLikeReturnTypeHints = true;
      includeInlayFunctionParameterTypeHints = true;
      includeInlayParameterNameHints = "all";
      includeInlayParameterNameHintsWhenArgumentMatchesName = true;
      includeInlayPropertyDeclarationTypeHints = true;
      includeInlayVariableTypeHints = true;
    };
  };

  programs.helix.languages.language = [
    {
      name = "nix";
      auto-format = true;
      formatter.command = "nixfmt";
      language-servers = [ "nixd" ];
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
    {
      name = "json";
      auto-format = true;
      language-servers = [ "vscode-json-languageserver" ];
    }
    {
      name = "markdown";
      language-servers = [ "marksman" ];
    }
    {
      name = "java";
      language-servers = [ "jdt-language-server" ];
    }
    {
      name = "c";
      auto-format = true;
      language-servers = [ "clangd" ];
    }
    {
      name = "cpp";
      auto-format = true;
      language-servers = [ "clangd" ];
    }
    {
      name = "python";
      auto-format = true;
      language-servers = [ "pylsp" ];
    }
    {
      name = "bash";
      language-servers = [ "bash-language-server" ];
    }
  ];

  # ---------- EDITOR: VS CODE ----------
  programs.vscode.enable = true;                                        # Microsoft Visual Studio Code
  programs.vscode.profiles.default.extensions = vscode-extensions-enabled;
  programs.vscode.profiles.default.userSettings = {
    # Appearance
    "workbench.activityBar.location" = "top";                           # Activity bar position
    "workbench.sideBar.location" = "right";                             # Sidebar position
    "workbench.colorTheme" = "Monokai Dimmed";                          # Color theme
    "workbench.iconTheme" = "material-icon-theme";                      # Icon theme
    "editor.minimap.enabled" = false;                                   # Disable minimap
    "window.commandCenter" = false;                                     # Disable command center
    # Editing
    "editor.defaultFormatter" = "esbenp.prettier-vscode";               # Default formatter
    "files.autoSave" = "onFocusChange";                                 # Auto-save on focus lose
    "editor.linkedEditing" = true;                                      # Edit opening/closing tags
    # Tabs
    "workbench.editor.scrollToSwitchTabs" = true;                       # Scroll to switch tabs
    "workbench.editor.wrapTabs" = true;                                 # Wrap tabs if needed
    # UI
    "explorer.confirmDelete" = false;                                   # No delete confirmation
    "explorer.confirmDragAndDrop" = false;                              # No drag & drop confirm
    "workbench.startupEditor" = "none";                                 # Don't open files on startup
    # Git
    "git.openRepositoryInParentFolders" = "always";                     # Find git repos in parents
    "git.enableSmartCommit" = true;                                     # Smart commit behavior
    "git.autofetch" = true;                                             # Auto-fetch from remote
    "chat.viewSessions.orientation" = "stacked";                        # Make chat sessions be stacked and not split-view
  };

  # VS Code keybindings for Caps Lock to Escape (for vim.vim extension)
  programs.vscode.profiles.default.keybindings = [
    {
      key = "capslock";
      command = "extension.vim_escape";
      when = "textInputFocus && vim.active";
    }
  ];

  # ---------- BROWSER: FIREFOX ----------
  programs.firefox.enable = true;                                       # Mozilla Firefox
  programs.firefox.profiles.${username} = {
    isDefault = true;                                                   # Set as default profile
    settings = {
      "browser.search.region" = "CR";                                   # Search region
      "browser.search.isUS" = false;                                    # Non-US search
      "distribution.id" = "nixos";                                      # Distribution ID
    };
  };
  programs.firefox.policies.ExtensionSettings = firefoxExtensions;      # Install extensions

  # ---------- OTHER CONFIGURATION ----------

}
