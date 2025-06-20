{pkgs, ...}: let
  sources = import ../../_sources/generated.nix {
    inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;
  };
in {
  xdg.configFile."OpenTabletDriver/Plugins/BetterCalibrator.dll".source =
    "${sources.better-calibrator.src}/BetterCalibrator.dll";
}
