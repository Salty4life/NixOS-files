{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.alcaide.services.xr.enable = lib.mkEnableOption "xr config";

  config = lib.mkIf config.alcaide.services.xr.enable {
    alcaide.hardware.slimetora.enable = true;
    services = {
      wivrn = {
        enable = true;
        openFirewall = true;
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
    };
    systemd.user.services = {

      slimevr-server = {
        description = "SlimeVR server";
        partOf = [ "vr-session.service" ];
        wantedBy = [ "vr-session.service" ];
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.slimevr-server} run";
          Restart = "on-failure";
        };
      };

      slimetora = {
        description = "SlimeTora HaritoraX bridge";
        after = [ "slimevr-server.service" ];
        requires = [ "slimevr-server.service" ];
        partOf = [ "vr-session.service" ];
        wantedBy = [ "vr-session.service" ];
        serviceConfig = {
          ExecStart = lib.getExe pkgs.slimetora;
          Restart = "on-failure";
        };
      };

      # extends the service provided by services.wivrn
      # https://github.com/NixOS/nixpkgs/blob/adaa24fbf46737f3f1b5497bf64bae750f82942e/nixos/modules/services/video/wivrn.nix#L183-L213

      wivrn = {
        requires = [ "slimevr-server.service" ];
        partOf = [ "vr-session.service" ];
        wantedBy = [ "vr-session.service" ];

        # hold activating until the openxr compositor ipc socket exists
        serviceConfig.ExecStartPost = pkgs.writeShellScript "wait-wivrn" ''
          for _ in $(seq 1 100); do
            [ -S "$XDG_RUNTIME_DIR/wivrn/comp_ipc" ] && exit 0
            sleep 0.1
          done
          exit 1
        '';
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

      wayvr = {
        description = "wayvr";
        after = [ "wait-for-wivrn.service" ];
        requires = [ "wait-for-wivrn.service" ];
        partOf = [
          "vr-session.service"
          "wivrn.service"
        ];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.wayvr} --openxr --replace";
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
            "wivrn.service"
            "wayvr.service"
            "slimetora.service"
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
