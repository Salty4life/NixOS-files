{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  options.alcaide.programs.steam.enable = lib.mkEnableOption "steam config";

  config = lib.mkIf config.alcaide.programs.steam.enable {
    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        proton-ge-rtsp-bin
      ];
    };
    hardware.steam-hardware.enable = true;
  };
}
