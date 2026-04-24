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
    programs.git.enable = true;

    home.packages = with pkgs; [
      (bottles.override {
        removeWarningPopup = true;
      })
      vlc
      gimp
      wget
      obs-studio
      firefox-bin
      ungoogled-chromium
      lshw
      zola
      telegram-desktop
      nsz
      xclicker
      gallery-dl
      libreoffice-still
      chirp
      openboardview
      popsicle
    ];
  };
}
