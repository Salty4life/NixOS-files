{
  lib,
  config,
  ...
}: {
  options.alcaide.services.pipewire.enable = lib.mkEnableOption "pipewire config";

  config = lib.mkIf config.alcaide.services.pipewire.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
