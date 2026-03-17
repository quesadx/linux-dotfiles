{
  config,
  pkgs,
  lib,
  ...
}:

let
  username = "quesadx";
  homeDir = "/home/quesadx";

  gitUser = {
    name = "Matteo Quesada"; # GitHub: @quesadx
    email = "matteo.vargas.quesada@est.una.ac.cr";
  };

  bashAliases = {
    ll = "ls -l";
    ls = "ls -a --color=auto";
    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";
    nrt = "cd ~/dotfiles/nixos-dotfiles && sudo nixos-rebuild test --flake .#nixos";
    nrs = "cd ~/dotfiles && git add . && cd nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
    dcu = "docker compose up";
    dcud = "docker compose up -d";
    dcd = "docker compose down";
    dcdv = "docker compose down -v";
  };

  userPackages = with pkgs; [
    nautilus
    claude-code
    direnv
    nix-direnv
    file-roller
    unzip
    unrar
    p7zip
    gnome-photos
    gnome-music
    gnome-calculator
    gnome-text-editor
    gnome-font-viewer
    gnome-console
    adwaita-icon-theme
    glib
    gtk3
    fastfetch
    papers
    showtime
    rnote
    dconf-editor
    onlyoffice-desktopeditors
    obsidian
    dbeaver-bin
    mysql-workbench
    mongodb-compass
    # cisco-packet-tracer_9
    spotify
    tmux
    alacritty
    # xcape
    neovim
    # openclaw
  ];

  gnome-extensions-enabled = [
    "AlphabeticalAppGrid@stuarthayhurst"
    "appindicatorsupport@rgcjonas.gmail.com"
    "auto-accent-colour@Wartybix"
    "caffeine@patapon.info"
    "clipboard-history@alexsaveau.dev"
    "luminus-desktop@dikasp.gitlab"
    "top-bar-organizer@julian.gse.jsts.xyz"
  ];

  vscode-extensions-enabled = with pkgs.vscode-extensions; [
    esbenp.prettier-vscode
    ms-python.python
    ms-vscode.live-server
    vscjava.vscode-java-pack
    eamodio.gitlens
    pkief.material-icon-theme
    ecmel.vscode-html-css
    christian-kohler.path-intellisense
    bbenoist.nix
    humao.rest-client
    mikestead.dotenv
    dbaeumer.vscode-eslint
    christian-kohler.npm-intellisense
    yoavbls.pretty-ts-errors
    usernamehw.errorlens
    james-yu.latex-workshop
    formulahendry.auto-rename-tag
    formulahendry.auto-close-tag
    shardulm94.trailing-spaces
    oderwat.indent-rainbow
    ms-azuretools.vscode-containers
    anthropic.claude-code
    cweijan.vscode-database-client2
    github.vscode-github-actions
  ];

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

  configSources = {
    "fastfetch".source = ../.config/fastfetch;
  };

in

{
  programs.home-manager.enable = true; # Enable Home Manager as a NixOS module
  home.username = username;
  home.homeDirectory = homeDir;
  home.stateVersion = "26.05";
  home.packages = userPackages;

  services.ssh-agent.enable = true;
  xdg.configFile = configSources;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      # LSP
      lua-language-server
      nil # Nix LSP
      nodePackages.typescript-language-server
    ];

    extraConfig = ''
      set number
      set relativenumber
    '';

    extraLuaConfig = ''
      vim.opt.termguicolors = true
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
    '';

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      vim-surround
      vim-commentary
      {
        plugin = nvim-tree-lua;
	type = "lua";
	config = ''
	  require("nvim-tree").setup({
	    view = { width = 30 },
	    renderer = { group_empty = true },
	  })
	'';
      }
    ];

  };

  # shell extras
  programs.starship.enable = true;
  programs.zsh.enable = true;
  # bash home-manager configuration
  programs.bash.enable = true;
  programs.bash.shellAliases = bashAliases;
  # git home-manager configuration
  programs.git.enable = true;
  programs.git.package = pkgs.gitFull;
  programs.git.settings.user = gitUser;
  programs.git.settings.init.defaultBranch = "main";
  programs.git.settings.pull.rebase = true;
  programs.git.settings.credential.helper = "libsecret";
  # direnv home-manager configuration
  programs.direnv.enable = true;
  programs.direnv.enableBashIntegration = true;
  programs.direnv.nix-direnv.enable = true;
  # ssh home-manager configuration
  programs.ssh.enable = true;
  programs.ssh.enableDefaultConfig = false;
  programs.ssh.matchBlocks."*".addKeysToAgent = "yes";
  # helix home-manager configuration
  programs.helix.enable = true;
  programs.helix.settings.theme = "monokai_soda";
  programs.helix.settings.editor.lsp.display-messages = true;
  programs.helix.extraPackages = with pkgs; [
    nixd
    nixfmt
    wl-clipboard
    xclip
    nodePackages.typescript-language-server
  ];
  programs.helix.languages.language = [
    {
      name = "nix";
      auto-format = true;
      formatter.command = "nixfmt";
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
  programs.emacs.enable = true;
  # vscode home-manager configuration
  programs.vscode.enable = true;
  programs.vscode.profiles.default.extensions = vscode-extensions-enabled;
  programs.vscode.profiles.default.userSettings = {
    "workbench.activityBar.location" = "top";
    "workbench.sideBar.location" = "right";
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "workbench.colorTheme" = "Monokai Dimmed";
    "files.autoSave" = "onFocusChange";
    "editor.minimap.enabled" = false;
    "window.commandCenter" = false;
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.editor.scrollToSwitchTabs" = true;
    "workbench.editor.wrapTabs" = true;
    "editor.linkedEditing" = true;
    "git.openRepositoryInParentFolders" = "always";
    "git.enableSmartCommit" = true;
    "explorer.confirmDelete" = false;
    "git.autofetch" = true;
    "explorer.confirmDragAndDrop" = false;
    "workbench.startupEditor" = "none";
  };
  # firefox home-manager configuration
  programs.firefox.enable = true;
  programs.firefox.profiles.${username} = {
    # ${} expressions can only be used once per attribute set
    isDefault = true;
    settings = {
      "browser.search.region" = "CR";
      "browser.search.isUS" = false;
      "distribution.id" = "nixos";
    };
  };
  programs.firefox.policies.ExtensionSettings = firefoxExtensions;

  dconf.enable = true;
  dconf.settings."org/gnome/shell".enabled-extensions = gnome-extensions-enabled;
  dconf.settings."org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "start";
  dconf.settings."org/gnome/shell/extensions/appindicator".legacy-tray-enabled = false;
  dconf.settings."org/gnome/shell/extensions/caffeine".restore-state = true;
  dconf.settings."org/gnome/shell/extensions/caffeine".enable-fullscreen = false;
  dconf.settings."org/gnome/desktop/input-sources".show-all-sources = true;
  dconf.settings."org/gnome/desktop/input-sources".sources = [
    (lib.gvariant.mkTuple [
      "xkb"
      "us+altgr-intl"
    ])
  ];
  dconf.settings."org/gnome/desktop/wm/keybindings".maximize = [ "<Super>F" ];
  dconf.settings."org/gnome/desktop/wm/keybindings".minimize = [ "<Super>D" ];
  dconf.settings."org/gnome/desktop/wm/keybindings".close = [ "<Super>Q" ];
  dconf.settings."org/gnome/settings-daemon/plugins/power".power-button-action = "nothing";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".home = [ "<Super>e" ];
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".www = [ "<Super>b" ];
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".control-center = [ "<Super>i" ];
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  ];
  # Custom keybinding to launch terminal with Super+t
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".binding =
    "<Super>t";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".command =
    "kgx";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".name =
    "gnome-console";
  dconf.settings."org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
  dconf.settings."org/gnome/desktop/sound".event-sounds = false;

}
