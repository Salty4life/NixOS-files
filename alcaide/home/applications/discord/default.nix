{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
let
  discordPackage = pkgs.discord.override {
    withMoonlight = true;
  };
in
{
  imports = [
    inputs.moonlight.homeModules.default
  ];

  options.alcaide.applications.discord.enable = lib.mkEnableOption "discord config";

  config = lib.mkIf config.alcaide.applications.discord.enable {
    programs.moonlight = {
      enable = true;
      configs.stable = import ./_moonlight-config.nix;
    };

    xdg.configFile."moonlight-mod/stable.json".force = true;

    home.packages = [
      discordPackage
      (pkgs.writeShellScriptBin "moonlight-config-updater" (
        builtins.readFile ./moonlight-config-updater.sh
      ))
    ];

    xdg.autostart.entries = lib.singleton (
      (pkgs.makeDesktopItem {
        name = "discord";
        destination = "/";
        desktopName = "Discord";
        noDisplay = true;
        exec = pkgs.writeShellScript "discord-delay-autostart" ''
          # workaround for starting before network is available
          sleep 2
          exec ${lib.getExe discordPackage}
        '';
      })
      + /discord.desktop
    );
  };
}
