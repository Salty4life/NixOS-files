{ lib, config, ... }:
{
  options.alcaide.profiles.graphical.enable = lib.mkEnableOption "graphical profile";

  config = lib.mkIf config.alcaide.profiles.graphical.enable {
    alcaide = {
      profiles.minimal.enable = true;
      applications = {
        vscodium.enable = true;
        proton.enable = true;
        applications-pkgs.enable = true;
      };
      games = {
        games-pkgs.enable = true;
        prism.enable = true;
      };
      style.catppuccin.enable = true;
    };
  };
}
