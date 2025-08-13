{ lib, config, ... }:
{
  options.alcaide.profiles.graphical.enable = lib.mkEnableOption "graphical profile";

  config = lib.mkIf config.alcaide.profiles.graphical.enable {
    alcaide = {
      profiles.minimal.enable = true;
      applications = {
        applications-pkgs.enable = true;
        vscodium.enable = true;
      };
      games = {
        games-pkgs.enable = true;
      };
      style.catppuccin.enable = true;
    };
  };
}
