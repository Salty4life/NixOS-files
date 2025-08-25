{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.applications.waydroid.enable = lib.mkEnableOption "waydroid config";

  config = lib.mkIf config.alcaide.applications.waydroid.enable {
    home.packages = with pkgs; [
      waydroid
      wl-clipboard
    ];
  };
}
