{
  #lib,
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    self.nixosModules.alcaide
  ];
  system.stateVersion = "25.05";

  networking.hostName = "padort";
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  console.keyMap = "us";

  services.xserver.videoDrivers = [ "amdgpu" ];

  alcaide = {
    profiles.graphical.enable = true;
    users.salty.enable = true;
    hardware = {
      amdgpu.enable = true;
      logitech.enable = true;
    };
  };

  services.printing.enable = true;
}
