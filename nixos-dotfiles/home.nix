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
    nautilus
    adwaita-icon-theme
    glib
    gtk3
    dbvisualizer
    jdk21
    fastfetch
    papers
    showtime
    rnote
    dconf-editor
    onlyoffice-desktopeditors
    google-chrome
    spotify
    obsidian
    input-leap
    distrobox
    dbeaver-bin
    mysql-workbench
  ];

  gnome-extensions-enabled = [
    "AlphabeticalAppGrid@stuarthayhurst"
    "CoverflowAltTab@palatis.blogspot.com"
    "appindicatorsupport@rgcjonas.gmail.com"
    "auto-accent-colour@Wartybix"
    "caffeine@patapon.info"
    "clipboard-history@alexsaveau.dev"
    "grand-theft-focus@zalckos.github.com"
    "hidetopbar@mathieu.bidon.ca"
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
  home = {
    username = username;
    homeDirectory = homeDir;
    stateVersion = "26.05";
    packages = userPackages;
  };

  xdg.configFile = configSources;

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

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = gnome-extensions-enabled;
      };
      "org/gnome/shell/extensions/alphabetical-app-grid" = {
        folder-order-position = "start";
      };
      "org/gnome/shell/extensions/appindicator" = {
        legacy-tray-enabled = false;
      };
      "org/gnome/shell/extensions/caffeine" = {
        restore-state = true;
        enable-fullscreen = false;
      };
      "org/gnome/shell/extensions/coverflowalttab" = {
        current-workspace-only = "all";
      };
      "org/gnome/shell/extensions/hidetopbar" = {
        hot-corner = true;
        enable-active-window = false;
        animation-time-overview = 0.2;
        animation-time-autohide = 0.2;
      };
      "org/gnome/desktop/input-sources" = {
        show-all-sources = true;
        sources = [
          (lib.gvariant.mkTuple [
            "xkb"
            "us+altgr-intl"
          ])
        ];
      };
      "org/gnome/desktop/wm/keybindings" = {
        maximize = [ "<Super>F" ];
        minimize = [ "<Super>D" ];
        close = [ "<Super>Q" ];
      };
      "org/gnome/settings-daemon/plugins/power" = {
        power-button-action = "nothing";
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>e" ];
        www = [ "<Super>b" ];
        control-center = [ "<Super>i" ];
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>t";
        command = "kgx";
        name = "gnome-console";
      };
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
        speed = 0.21;
      };
      "org/gnome/desktop/sound" = {
        event-sounds = false;
      };
    };
  };

  services.ssh-agent.enable = true;
}
