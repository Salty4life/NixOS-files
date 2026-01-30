{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.applications.blender.enable = lib.mkEnableOption "blender config";

  config = lib.mkIf config.alcaide.applications.blender.enable {

    home.packages = with pkgs; [
      pkgsRocm.blender
    ];
  };
}
