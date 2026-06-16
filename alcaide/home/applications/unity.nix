{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.applications.unity.enable = lib.mkEnableOption "unity config";

  config = lib.mkIf config.alcaide.applications.unity.enable {

    home.packages = with pkgs; [
    unityhub
    alcom
    ];
  };
}
