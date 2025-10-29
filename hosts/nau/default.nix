{
  #lib,
  inputs,
  self,
  ...
}:
{
  imports = [
    # keep-sorted start
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    self.nixosModules.alcaide
    # keep-sorted end
  ];
  system.stateVersion = "25.05";

  networking.hostName = "nau";
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pt";
    variant = "";
  };
  console.keyMap = "pt-latin1";

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.nvidia = {
    prime = {
      sync.enable = false;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # CONFIGURE WITH THE CORRECT BUS ID OTHERWISE SHIT BREAKS!
      # Use "lshw -c display" to verify
      # Note that the lshw command displays in hexadecimal, you need to convert to decimal to input it below
      nvidiaBusId = "PCI:1@0:0:0";
      amdgpuBusId = "PCI:6@0:0:0";
    };
  };

  alcaide = {
    profiles.graphical.enable = true;
    users.salty.enable = true;
    hardware = {
      asus.enable = true;
      nvidia.enable = true;
      logitech.enable = true;
      bluetooth.enable = true;
    };
  };

  services.printing.enable = true;
}
