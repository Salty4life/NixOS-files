{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.alcaide.services.xr.enable = lib.mkEnableOption "xr config";

  config = lib.mkIf config.alcaide.services.xr.enable {
    services.wivrn = {
      enable = true;

      openFirewall = true;
      defaultRuntime = true;

      config = {
        enable = true;
        json = {
          bitrate =
            let
              Mbps = 100;
            in
            Mbps * 1000000;

          encoders = lib.singleton {
            encoder = "vaapi";
            codec = "h264";
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          };
        };
      };
    };

    systemd.user.services = {

      # extends the service provided by services.wivrn
      # https://github.com/NixOS/nixpkgs/blob/adaa24fbf46737f3f1b5497bf64bae750f82942e/nixos/modules/services/video/wivrn.nix#L183-L213
      wivrn = {
        partOf = [ "vr-session.service" ];
      };

      wait-for-wivrn = {
        description = "Wait for Wivrn to be ready and remain active while it runs";
        after = [ "wivrn.service" ];
        requires = [ "wivrn.service" ];
        partOf = [ "wivrn.service" ];

        serviceConfig = {
          Type = "notify";
          ExecStart = lib.getExe (
            pkgs.writeShellScriptBin "wait-for-wivrn" ''
              set -eu pipefail

              timeout 15s journalctl --user -fu wivrn.service |
                grep -m1 "Service published: ${config.networking.hostName}"
              set -o pipefail

              sleep 0.5
              ${pkgs.systemd}/bin/systemd-notify --ready

              exec sleep infinity
            ''
          );
          NotifyAccess = "all";
        };
      };

      wlx-overlay-s = {
        description = "wlx-overlay-s";
        after = [ "wait-for-wivrn.service" ];
        requires = [ "wait-for-wivrn.service" ];
        partOf = [
          # keep-sorted start
          "vr-session.service"
          "wivrn.service"
          # keep-sorted end
        ];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.wlx-overlay-s} --openxr --replace";
          Restart = "on-failure";
          ExecStopSignal = "SIGKILL";
          KillSignal = "SIGKILL";
          SendSIGKILL = "yes";
          TimeoutStopSec = "1s";
        };
      };

      vr-session =
        let
          deps = [
            # keep-sorted start
            "wivrn.service"
            "wlx-overlay-s.service"
            # keep-sorted end
          ];
        in
        {
          description = "VR session meta service";
          after = deps;
          wants = deps;

          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.coreutils + /bin/true;
            RemainAfterExit = "yes";
          };
        };
    };
  };
}
