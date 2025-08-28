{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.applications.applications-pkgs.enable =
    lib.mkEnableOption "extra applications packages";

  config = lib.mkIf config.alcaide.applications.applications-pkgs.enable {
    # Git
    programs.git.enable = true;

    # Add stuff for your user as you see fit:
    # programs.neovim.enable = true;
    home.packages = with pkgs; [
      (bottles.override {
        removeWarningPopup = true;
      })
      davinci-resolve
      rustdesk
      btop
      neofetch
      krita
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
      waydroid
      libreoffice
      comic-mandown
    ];
  };
}
