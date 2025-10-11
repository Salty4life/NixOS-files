{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
{

  options.alcaide.programs.steam.enable = lib.mkEnableOption "steam config";

  config = lib.mkIf config.alcaide.programs.steam.enable {
    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        inputs.nixpkgs-xr.packages.${pkgs.system}.proton-ge-rtsp-bin
      ];
    };
    hardware.steam-hardware.enable = true;
  };
}
