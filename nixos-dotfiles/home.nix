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
    name = "Matteo Quesada";
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
  };

  userPackages = with pkgs; [
    # Wayland / Desktop
    waybar fuzzel nwg-displays
    swaybg swayidle swaynotificationcenter
    wl-clipboard libnotify

    # Terminal & Shell
    foot direnv nix-direnv fastfetch

    # File Management
    file-roller unzip unrar p7zip

    # GTK / Theming
    adwaita-icon-theme glib gtk3

    # Development
    jdk21 dbvisualizer dbeaver-bin
    mysql-workbench mongodb-compass

    # Productivity & Office
    rnote onlyoffice-desktopeditors obsidian showtime

    # Internet & Media
    google-chrome spotify

    # Virtualization
    virtualbox
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
    "fuzzel".source = ../.config/fuzzel;
    "waybar".source = ../.config/waybar;
  };

in
{
  home = {
    username = username;
    homeDirectory = homeDir;
    stateVersion = "26.05";
    packages = userPackages;
  };

  xdg.configFile = configSources;
  wayland.windowManager.sway = {
    enable = true;
    config = null; # disable default generated config (prevents default bar at bottom)
    swaynag.enable = false;
    extraConfig = builtins.readFile ../.config/sway/config;
  };

  programs = {
    home-manager.enable = true;
    starship.enable = true;
    zsh.enable = true;

    bash = {
      enable = true;
      shellAliases = bashAliases;
    };

    git = {
      enable = true;
      settings = {
        user = gitUser;
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "yes";
      };
    };

    taskwarrior = {
      enable = true;
    };

    khal = {
      enable = true;
    };

    helix = {
      enable = true;
      settings = {
        theme = "monokai";
      };
      extraPackages = with pkgs; [
        nixd
        nixfmt
        # Add other LSPs here (e.g., pyright, gopls, rust-analyzer)
      ];
      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "nixfmt";
          }
        ];
      };
    };

    foot = {
      enable = true;
      settings = {
        main = {
          font = "JetBrains Mono:size=12";
        };
      };
    };

    vscode = {
      enable = true;
      # mutableExtensions = true; # Meh
      profiles.default.extensions = vscode-extensions-enabled;
      profiles.default.userSettings = {
        "workbench.activityBar.location" = "top";
        "workbench.sideBar.location" = "right";
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "workbench.colorTheme" = "Monokai";
        "files.autoSave" = "onFocusChange";
        "editor.minimap.autohide" = "mouseover";
        "window.commandCenter" = false;
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.editor.scrollToSwitchTabs" = true;
        "workbench.editor.wrapTabs" = true;
        "workbench.panel.alignment" = "justify"; # Does nothing :/
      };
    };

    firefox = {
      enable = true;
      profiles.${username} = {
        isDefault = true;
        settings = {
          "browser.search.region" = "CR";
          "browser.search.isUS" = false;
          "distribution.id" = "nixos";
        };
      };
      policies.ExtensionSettings = firefoxExtensions;
    };
  };

  services = {
    ssh-agent.enable = true;
  };
}
