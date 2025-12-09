{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.alcaide.games.games-pkgs.enable = lib.mkEnableOption "extra games packages";

  config = lib.mkIf config.alcaide.games.games-pkgs.enable {
    home.packages = with pkgs; [
      r2modman
      lutris
      pcsx2
      owmods-gui
      ckan
      uzdoom
    ];
  };
}
