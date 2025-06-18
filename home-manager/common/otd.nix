{pkgs, ...}: {
  xdg.configFile."OpenTabletDriver/Plugins/BetterCalibrator.dll".source = let
    version = "0.2.0";
    src = pkgs.fetchzip {
      url = "https://github.com/TheBlueOompaLoompa/BetterCalibrator/releases/download/${version}/BetterCalibrator.zip";
      hash = "sha256-ZNHuoZwBqzhIZywx3OcF4T5vSh8HXdA8nTkfnb5F13Y=";
      stripRoot = false;
    };
  in
    src + /BetterCalibrator.dll;
}
