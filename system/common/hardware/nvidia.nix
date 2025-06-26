{...}: {
  # Announces which drivers to enable
  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  # Enables the kernel modules for the graphics
  hardware.graphics.enable = true;

  # Configures the Nvidia Drivers
  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    # Enables Nvidia GPU to be used as the primary rendering device
    prime = {
      reverseSync.enable = true;
      nvidiaBusId = "PCI:1@0:0:0";
      amdgpuBusId = "PCI:4@0:0:0";
    };
    open = false;

    nvidiaSettings = true;

    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "555.58.02";
    #   sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
    #   sha256_aarch64 = lib.fakeSha256;
    #   openSha256 = lib.fakeSha256;
    #   settingsSha256 = lib.fakeSha256;
    #   persistencedSha256 = lib.fakeSha256;
    # };
  };

  nixpkgs.config.cudaSupport = true;
}
