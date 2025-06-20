{pkgs, ...}: {
  programs.git.enable = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    (discord.override {
      withMoonlight = true;
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
    davinci-resolve
    pcsx2
    rustdesk
    btop
    krita
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
    xfce.xfce4-battery-plugin
    samba
    r2modman
    nvfetcher
  ];
}
