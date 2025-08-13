{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: {
  options.alcaide.applications.applications-pkgs.enable = lib.mkEnableOption "extra applications packages";

  config = lib.mkIf config.alcaide.applications.applications-pkgs.enable {
    # Git
    programs.git.enable = true;

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    home.packages = with pkgs; [
      (discord.override {
        withMoonlight = true;
        moonlight = inputs.moonlight.packages.${pkgs.system}.moonlight;
      })
      (
        bottles.override {
          removeWarningPopup = true;
        }
      )
      davinci-resolve
      rustdesk
      btop
      krita # Drawing Software (Need to look into ways of finegrain configuration through a nix file)
      alejandra # formatter
      nixd # nix language server
      protonmail-desktop
      protonvpn-gui
      protonvpn-cli
      blender
      vrcx
      vlc
      wget
      nvfetcher
      obs-studio
      firefox
      lshw
      podman
      podman-desktop
      drawpile
      gimp3
    ];
  };
}
