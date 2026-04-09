{
  config,
  pkgs,
  lib,
  shared,
  ...
}:

# ─── VARIABLES ───────────────────────────────────────────────────────────
# User packages, aliases, and configurations

let
  username = shared.username;
  homeDir = "/home/${username}";

  # ─── GIT CONFIGURATION ─────────────────────────────────────────────────────
  gitUser = {
    name = "Matteo Quesada";
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };

  # ─── SHELL ALIASES ────────────────────────────────────────────────────────
  bashAliases = {
    ll = "ls -l";
    ls = "ls -a --color=auto";
    # Git aliases
    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";
    # NixOS rebuild aliases
    nrt = "cd ~/dotfiles/nixos-dotfiles && sudo nixos-rebuild test --flake .#nixos";
    nrs = "cd ~/dotfiles && git add . && cd nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
    # Docker Compose aliases
    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcd = "docker compose down";
    dcdv = "docker compose down -v";

    # calcurse aliass to read from /home/quesadx/vault/calcurse/
    calcurse = "calcurse -D /home/${username}/vault/calcurse/";
  };

  # ─── USER PACKAGES ────────────────────────────────────────────────────────
  userPackages = with pkgs; [
    file-roller
    unzip
    unrar
    p7zip
    # gnome-music gnome-calendar gnome-calculator gnome-text-editor gnome-console gnome-font-viewer nautilus
    adwaita-icon-theme
    glib
    gtk3
    onlyoffice-desktopeditors
    obsidian
    papers
    rnote
    spotify
    dconf-editor
    dbeaver-bin
    mysql-workbench
    mongodb-compass
    wireshark
    postman
    zed-editor
    claude-code
    direnv
    nix-direnv
    fastfetch
    powertop
    intel-gpu-tools
    alacritty
    foot
    waybar
    swayidle
    swaylock
    libnotify
    mako
    grim
    slurp
    wl-clipboard
    cliphist
    swaybg
    pulsemixer
    btop
    yazi # xfce.thunar xfce.thunar-volman gvfs
    sov
    tofi
    xournalpp
    thunar
    calcurse
    zsh-powerlevel10k
  ];

  # ─── VS CODE EXTENSIONS ────────────────────────────────────────────────────
  vscode-extensions-enabled = with pkgs.vscode-extensions; [
    esbenp.prettier-vscode
    ecmel.vscode-html-css
    humao.rest-client
    ms-python.python
    vscjava.vscode-java-pack
    james-yu.latex-workshop
    bbenoist.nix
    ms-vscode.live-server
    christian-kohler.path-intellisense
    christian-kohler.npm-intellisense
    mikestead.dotenv
    formulahendry.auto-rename-tag
    formulahendry.auto-close-tag
    shardulm94.trailing-spaces
    mongodb.mongodb-vscode
    prisma.prisma
    pkief.material-icon-theme
  ];

  # ─── FIREFOX EXTENSIONS ────────────────────────────────────────────────────
  firefoxExtensions = {
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
    };
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
      installation_mode = "force_installed";
    };
  };

  # ─── CONFIG FILE SOURCES ───────────────────────────────────────────────────
  configSources = {
    # "fastfetch".source = ../../.config/fastfetch;
    "sway".source = ../../.config/sway;
    "waybar".source = ../../.config/waybar;
    "foot".source = ../../.config/foot;
    "tofi".source = ../../.config/tofi;
    "khal".source = ../../.config/khal;
  };

in

# ─── HOME MANAGER CONFIGURATION ────────────────────────────────────────────

{
  imports = [
    #../modules/desktop-gnome-user.nix
  ];

  # ─── HOME MANAGER METADATA ─────────────────────────────────────────────────
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "26.05";
  home.packages = userPackages;
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };
  home.file.".p10k.zsh".source = ./.p10k.zsh;

  # ─── SYSTEM SERVICES ───────────────────────────────────────────────────────
  services.ssh-agent.enable = true;
  services.gnome-keyring.enable = true; # Start GNOME Keyring daemon
  services.udiskie.enable = true; # Automounting of external drives
  xdg.configFile = configSources;
  wayland.windowManager.sway.systemd.variables = [ "--all" ];


  # ─── EDITOR: NEOVIM ────────────────────────────────────────────────────────
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # ─── SHELL: ZSH & BASH ─────────────────────────────────────────────────────
  # programs.starship.enable = false;
  programs.zsh = {
    enable = true;

  # With Oh-My-Zsh:
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"         # also requires `programs.git.enable = true;`
      ];
    };
    initExtra = ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  '';
  };

  programs.bash.enable = true;
  programs.bash.shellAliases = bashAliases;

  # ─── VERSION CONTROL: GIT ──────────────────────────────────────────────────
  programs.git.enable = true;
  programs.git.package = pkgs.gitFull;
  programs.git.settings.user = gitUser;
  programs.git.settings.init.defaultBranch = "main";
  programs.git.settings.pull.rebase = true;
  programs.git.settings.credential.helper = "libsecret";

  # ─── ENVIRONMENT MANAGEMENT: DIRENV ────────────────────────────────────────
  programs.direnv.enable = true;
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  # ─── SSH CONFIGURATION ─────────────────────────────────────────────────────
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.matchBlocks."*".addKeysToAgent = "yes";

  # ─── EDITOR: FRESH ────────────────────────────────────────────────────────
  programs.fresh-editor.enable = true;

  # ─── EDITOR: HELIX ────────────────────────────────────────────────────────
  programs.helix.enable = true;
  programs.helix.settings.theme = "base16_default";
  programs.helix.settings.editor = {
    lsp.display-messages = true;
    lsp.display-inlay-hints = true;
    auto-info = false;
    completion-timeout = 50;
  };

  programs.helix.extraPackages = with pkgs; [
    nixd
    nixfmt
    typescript-language-server
    vscode-json-languageserver
    marksman
    jdt-language-server
    clang-tools
    bash-language-server
    xclip
  ];

  # Helix TypeScript language server config
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

  # Helix language-specific configurations
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

  # ─── EDITOR: VS CODE ───────────────────────────────────────────────────────
  programs.vscode.enable = true;
  programs.vscode.profiles.default.extensions = vscode-extensions-enabled;
  programs.vscode.profiles.default.userSettings = {
    "workbench.activityBar.location" = "top";
    "workbench.sideBar.location" = "right";
    "workbench.colorTheme" = "Modern Purple Theme Dark";
    "workbench.iconTheme" = "material-icon-theme";
    "editor.minimap.enabled" = false;
    "window.commandCenter" = false;
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "files.autoSave" = "onFocusChange";
    "editor.linkedEditing" = true;
    "workbench.editor.scrollToSwitchTabs" = true;
    "workbench.editor.wrapTabs" = true;
    "explorer.confirmDelete" = false;
    "explorer.confirmDragAndDrop" = false;
    "workbench.startupEditor" = "none";
    "git.openRepositoryInParentFolders" = "always";
    "git.enableSmartCommit" = true;
    "git.autofetch" = true;
    "chat.viewSessions.orientation" = "stacked";
    "editor.fontFamily" = "'IBM Plex Mono', monospace";
  };

  programs.vscode.profiles.default.keybindings = [
    {
      key = "capslock";
      command = "extension.vim_escape";
      when = "textInputFocus && vim.active";
    }
  ];

  # ─── BROWSER: FIREFOX ──────────────────────────────────────────────────────
  programs.firefox.enable = true;
  programs.firefox.profiles.${username} = {
    isDefault = true;
    settings = {
      "browser.search.region" = "CR";
      "browser.search.isUS" = false;
      "distribution.id" = "nixos";
    };
  };
  programs.firefox.policies.ExtensionSettings = firefoxExtensions;
}
