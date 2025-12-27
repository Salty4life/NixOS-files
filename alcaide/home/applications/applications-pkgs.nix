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
      btop
      vrcx
      vlc
      wget
      obs-studio
      firefox-bin
      lshw
      libreoffice
      orca-slicer
      zola
      telegram-desktop
      nsz
      xclicker
    ];
  };
}
