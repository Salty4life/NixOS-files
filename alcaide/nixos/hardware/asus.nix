{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.alcaide.hardware.asus.enable = lib.mkEnableOption "asus config";

  config = lib.mkIf config.alcaide.hardware.asus.enable {
    boot = {
      kernelParams = [
        "amd_pstate=active"
      ];
      kernelModules = [
        "asus-nb-wmi"
        "asus-armoury"
      ];
    };
    environment.systemPackages = with pkgs; [
      asusctl
      ryzenadj
      amdctl
    ];

    services = {
      asusd = {
        enable = true;
      };
      power-profiles-daemon.enable = false;
    };

    programs.rog-control-center = {
      enable = true;
      autoStart = true;
    };

    systemd.services.ryzenadj-tdp = {
      description = "Apply custom Ryzen TDP limits";
      wantedBy = [
        "multi-user.target"
        "suspend.target"
      ];
      after = [ "multi-user.target" ];
      # Also re-run after waking from sleep, since limits reset
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=30000 --fast-limit=40000 --slow-limit=32000 --tctl-temp=87 --apu-skin-temp=50";
      };
    };

    # Reapply on resume specifically (this is the reliable trigger)
    systemd.services.ryzenadj-resume = {
      description = "Reapply Ryzen TDP limits after resume";
      after = [ "suspend.target" ];
      wantedBy = [ "suspend.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=35000 --fast-limit=41000 --slow-limit=32000 --tctl-temp=87 --apu-skin-temp=50";
      };
    };
  };
}
