{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];
  programs.steam = {
    enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
      proton-ge-rtsp-bin
    ];
  };
}
