{
  lib,
  config,
  ...
}: {
  options.alcaide.desktop.gtk.enable = lib.mkEnableOption "gtk config";

  config = lib.mkIf config.alcaide.desktop.gtk.enable {
    gtk = {
      enable = true;
      gtk2.force = true;
    };
  };
}
