{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.alcaide.applications.proton.enable = lib.mkEnableOption "proton config";

  config = lib.mkIf config.alcaide.applications.proton.enable {

    home.packages = with pkgs; [
      protonmail-desktop
      protonvpn-gui
      protonvpn-cli
      proton-vpn-local-agent
      proton-pass
    ];
  };
}
