{
  lib,
  config,
  pkgs,
  ...
}: {
  options.alcaide.games.games-pkgs.enable = lib.mkEnableOption "extra games packages";

  config = lib.mkIf config.alcaide.games.games-pkgs.enable {
    home.packages = with pkgs; [
      (
        pkgs.prismlauncher.override {
          jdks = [
            temurin-bin
            openjdk8-bootstrap
            openjdk17-bootstrap
          ];
        }
      )
      r2modman
      lutris
      pcsx2
      owmods-gui
    ];
  };
}
