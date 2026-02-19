{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.alcaide.desktop.fonts.enable = lib.mkEnableOption "fonts config";

  config = lib.mkIf config.alcaide.desktop.fonts.enable {
    fonts.packages = with pkgs; [
      corefonts
      vista-fonts
    ];

  };
}
