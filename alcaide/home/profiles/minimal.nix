{ lib, config, ... }:
{
  options.alcaide.profiles.minimal.enable = lib.mkEnableOption "minimal profile";

  config = lib.mkIf config.alcaide.profiles.minimal.enable {
    alcaide = {
      desktop.gtk.enable = true;
    };
};
}
