# This is your home-manager configuration file
# Use this to configure your home environment
{
  inputs,
  osConfig,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    ./programs.nix
    inputs.catppuccin.homeManagerModules.catppuccin
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  # TODO: Set your username
  home = {
    username = "salty";
    homeDirectory = "/home/salty";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    vlc
    (discord.override {
      withMoonlight = true;
    })
    wget
    (prismlauncher.override {
      jdks = with pkgs; [
        temurin-bin
        openjdk8-bootstrap
        openjdk17-bootstrap
      ];
    })
    krita
    alejandra # formatter
    nixd # nix language server
    protonmail-desktop
    protonvpn-gui
    blender
    openscad
    wpsoffice
    vrcx
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
        jnoortheen.nix-ide
      ];
      userSettings = {
        "editor.formatOnSave" = true;
        # https://github.com/nix-community/vscode-nix-ide
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings.nixd.formatting.command" = ["alejandra" "-" "--quiet"];
        "nix.serverSettings.nixd.options.nixos.expr" = "(builtins.getFlake \"${osConfig.programs.nh.flake}\").nixosConfigurations.<name>.options";
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";

  gtk.enable = true;
  # Catppuccin system config
  catppuccin = {
    enable = true;
    flavor = "mocha";
    gtk.enable = true;

    btop.enable = true;
    fish.enable = false;
    mpv.enable = false;
  };
}
