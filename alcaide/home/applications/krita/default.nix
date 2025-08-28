{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.applications.krita.enable = lib.mkEnableOption "krita config";

  config = lib.mkIf config.alcaide.applications.krita.enable {
    home.packages = with pkgs; [
      krita
    ];
  };
}
