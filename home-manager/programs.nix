{
  pkgs,
  inputs,
  ...
}: {
  programs.git.enable = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    (discord.override {
      withMoonlight = true;
      moonlight = inputs.moonlight.packages.${pkgs.system}.moonlight-mod;
    })
    (prismlauncher.override {
      jdks = with pkgs; [
        temurin-bin
        openjdk8-bootstrap
        openjdk17-bootstrap
      ];
    })
    (
      bottles.override {
        removeWarningPopup = true;
      }
    )
    # podman
    # podman-tui
    davinci-resolve
    pcsx2
    rustdesk
    btop
    krita # Drawing Software (Need to look into ways of finegrain configuration through a nix file)
    alejandra # formatter
    nixd # nix language server
    protonmail-desktop
    protonvpn-gui
    blender
    openscad
    wpsoffice
    vrcx
    lutris
    vlc
    wget
    r2modman
    owmods-gui
    nvfetcher
    gnome-keyring
    file-roller
    photoqt
    obs-studio
    firefox
    lshw
    podman
    podman-desktop
  ];
}
