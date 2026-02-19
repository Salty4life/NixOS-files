{
  lib,
  config,
  ...
}:
{
  options.alcaide.profiles.graphical.enable = lib.mkEnableOption "graphical profile";

  config = lib.mkIf config.alcaide.profiles.graphical.enable {
    alcaide = {
      profiles.minimal.enable = true;

      desktop = {
        kde.enable = true;
        fonts.enable = true;
      };
      services.pipewire.enable = true;

      style.catppuccin.enable = true;

      programs = {
        steam.enable = true;
      };
    };
  };
}
