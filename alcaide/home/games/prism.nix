{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.alcaide.games.prism.enable = lib.mkEnableOption "prism packages";

  config = lib.mkIf config.alcaide.games.prism.enable {
    home.packages = with pkgs; [
      (prismlauncher.override {
        jdks = [
          temurin-bin
          openjdk8-bootstrap
          openjdk17-bootstrap
        ];
      })
    ];
  };
}
