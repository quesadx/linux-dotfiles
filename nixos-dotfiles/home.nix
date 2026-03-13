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
  };

  userPackages = with pkgs; [
    direnv # Development environment for shell
    nix-direnv # Nix integration for direnv
    file-roller # Archive manager
    unzip # Unarchiver for .zip files
    unrar # Unarchiver for .rar files
    p7zip # Unarchiver for .7z files
    gnome-photos # GNOME image viewer and organizer
    gnome-music # GNOME music player
    gnome-calculator # GNOME calculator
    gnome-text-editor # GNOME text editor
    gnome-font-viewer # GNOME font viewer
    gnome-console # GNOME terminal emulator
    nautilus # GNOME file manager
    adwaita-icon-theme # Default GNOME icon theme
    glib # GLib is a low-level core library that forms the basis for projects such as GTK and GNOME. It provides data structures, utilities, and interfaces for handling various aspects of software development, including memory management, event loops, and object-oriented programming.
    gtk3 # GTK is a multi-platform toolkit for creating graphical user interfaces. It provides a comprehensive set of widgets and tools for building applications with a native look and feel on various operating systems, including Linux, Windows, and macOS.
    # dbvisualizer
    # jdk21
    fastfetch # Fastfetch is a system information tool that provides a quick overview of your system's hardware and software details. It displays information such as CPU, GPU, RAM, storage, and more in a visually appealing format.
    papers # GNOME PDF viewer
    showtime # GNOME video player
    rnote # Note-taking application
    dconf-editor  # Graphical editor for dconf settings
    onlyoffice-desktopeditors # Office suite compatible with Microsoft Office formats
    # google-chrome
    obsidian # Note-taking and knowledge management application
    # input-leap # Virtual KVM for controlling multiple devices with a single keyboard and mouse
    # distrobox
    dbeaver-bin # Database management tool
    mysql-workbench # MySQL database design and administration tool
    # displaycal
    mongodb-compass # GUI for MongoDB database management
    cisco-packet-tracer_9 # Straight up garbage but I need it for networking class
  ];

  gnome-extensions-enabled = [
    "AlphabeticalAppGrid@stuarthayhurst" # Reorders the app grid alphabetically, making it easier to find applications in the overview.
    "appindicatorsupport@rgcjonas.gmail.com" # Provides support for AppIndicator-based system tray icons, allowing applications that use this standard to display their icons in the GNOME Shell's system tray area.
    "auto-accent-colour@Wartybix" # Automatically changes the accent color of the GNOME Shell based on the dominant color of the current wallpaper, providing a more cohesive and visually appealing desktop experience.
    "caffeine@patapon.info" # Prevents the system from going to sleep or activating the screensaver when certain applications are running, allowing you to keep your screen active while using those applications.
    "clipboard-history@alexsaveau.dev" # Provides a clipboard history manager that allows you to access and manage previously copied items, making it easier to retrieve and reuse clipboard content.
    "luminus-desktop@dikasp.gitlab" # Luminus Desktop is a GNOME Shell extension that provides a customizable and visually appealing desktop experience. It offers features such as dynamic wallpapers, customizable widgets, and a sleek design to enhance the overall look and feel of the GNOME desktop environment.
    "top-bar-organizer@julian.gse.jsts.xyz" # Top Bar Organizer is a GNOME Shell extension that allows you to customize and organize the top bar of the GNOME desktop environment. It provides features such as rearranging system indicators, adding custom widgets, and hiding or showing specific elements on the top bar, giving you more control over the layout and functionality of your desktop.
  ];

  vscode-extensions-enabled = with pkgs.vscode-extensions; [
    esbenp.prettier-vscode # Prettier code formatter for Visual Studio Code
    ms-python.python # Python extension for Visual Studio Code, providing features such as linting, debugging, and code navigation
    ms-vscode.live-server # Live Server extension for Visual Studio Code, allowing you to launch a local development server with live reload capability for static and dynamic web pages
    vscjava.vscode-java-pack # Java Extension Pack for Visual Studio Code, providing essential extensions for Java development, including language support, debugging, and testing tools
    eamodio.gitlens # GitLens extension for Visual Studio Code, enhancing Git capabilities with features like code annotations, blame information, and repository insights
    pkief.material-icon-theme # Material Icon Theme for Visual Studio Code, providing a comprehensive set of icons for files and folders based on the Material Design guidelines
    ecmel.vscode-html-css # HTML CSS Support extension for Visual Studio Code, offering features like auto-completion, validation, and formatting for HTML and CSS files
    christian-kohler.path-intellisense # Path Intellisense extension for Visual Studio Code, providing autocompletion for file paths in your project
    bbenoist.nix # Nix extension for Visual Studio Code, offering syntax highlighting, linting, and other features for Nix files
    humao.rest-client # REST Client extension for Visual Studio Code, allowing you to send HTTP requests and view responses directly within the editor
    mikestead.dotenv # DotENV extension for Visual Studio Code, providing support for .env files with features like syntax highlighting and autocompletion
    dbaeumer.vscode-eslint # ESLint extension for Visual Studio Code, integrating the ESLint JavaScript linter into the editor for real-time code analysis and error checking
    christian-kohler.npm-intellisense # NPM Intellisense extension for Visual Studio Code, providing autocompletion for npm modules in your project
    yoavbls.pretty-ts-errors # Pretty TypeScript Errors extension for Visual Studio Code, enhancing the readability of TypeScript error messages with improved formatting and styling
    usernamehw.errorlens # Error Lens extension for Visual Studio Code, highlighting errors and warnings directly in the editor with customizable styling
    james-yu.latex-workshop # LaTeX Workshop extension for Visual Studio Code, providing a comprehensive set of tools for LaTeX editing, including syntax highlighting, compilation, and previewing
    formulahendry.auto-rename-tag # Auto Rename Tag extension for Visual Studio Code, automatically renaming paired HTML/XML tags when one of them is edited
    formulahendry.auto-close-tag # Auto Close Tag extension for Visual Studio Code, automatically closing HTML/XML tags when the opening tag is typed
    shardulm94.trailing-spaces # Trailing Spaces extension for Visual Studio Code, highlighting and allowing you to easily remove trailing whitespace in your code
    oderwat.indent-rainbow # Indent Rainbow extension for Visual Studio Code, coloring indentation levels in your code to improve readability
    ms-azuretools.vscode-containers # Visual Studio Code extension for working with Docker containers, providing features like container management, image browsing, and integrated terminal access
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
  programs.helix.settings.theme = "monokai";
  programs.helix.extraPackages = with pkgs; [ nixd nixfmt ];
  programs.helix.languages.language = [ { name = "nix"; auto-format = true; formatter.command = "nixfmt"; } ];
  # vscode home-manager configuration
  programs.vscode.enable = true;
  programs.vscode.profiles.default.extensions = vscode-extensions-enabled;
  programs.vscode.profiles.default.userSettings = {
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
    "editor.linkedEditing" = true;
    "git.openRepositoryInParentFolders" = "always";
    "git.enableSmartCommit" = true;
    "explorer.confirmDelete" = false;
    "git.autofetch" = true;
  };
  # firefox home-manager configuration
  programs.firefox.enable = true;
  programs.firefox.profiles.${username}.isDefault = true;
  programs.firefox.policies.ExtensionSettings = firefoxExtensions;
  programs.firefox.profiles.${username}.settings = {
    "browser.search.region" = "CR";
    "browser.search.isUS" = false;
    "distribution.id" = "nixos";
  };

  dconf.enable = true;
  dconf.settings."org/gnome/shell".enabled-extensions = gnome-extensions-enabled;
  dconf.settings."org/gnome/shell/extensions/alphabetical-app-grid".folder-order-position = "start";
  dconf.settings."org/gnome/shell/extensions/appindicator".legacy-tray-enabled = false;
  dconf.settings."org/gnome/shell/extensions/caffeine".restore-state = true;
  dconf.settings."org/gnome/shell/extensions/caffeine".enable-fullscreen = false;
  dconf.settings."org/gnome/desktop/input-sources".show-all-sources = true;
  dconf.settings."org/gnome/desktop/input-sources".sources = [
    (lib.gvariant.mkTuple [ "xkb" "us+altgr-intl" ])
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
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".binding = "<Super>t";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".command = "kgx";
  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0".name = "gnome-console";
  dconf.settings."org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
  dconf.settings."org/gnome/desktop/sound".event-sounds = false;

}
