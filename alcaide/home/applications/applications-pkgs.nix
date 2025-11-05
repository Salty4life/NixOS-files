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
      neofetch
      blender
      vrcx
      vlc
      wget
      nvfetcher
      obs-studio
      firefox
      lshw
      waydroid
      libreoffice
      comic-mandown
      orca-slicer
      zola
      zoneminder
    ];
  };
}
