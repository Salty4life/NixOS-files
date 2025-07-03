{config, ...}: {
  # Announces which drivers to enable
  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  # Enables the kernel modules for the graphics
  hardware.graphics.enable = true;

  # Configures the Nvidia Drivers
  hardware.nvidia = {
    # Modsetting is required
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # Requires Offload mode to be enabled on Prime
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    # Enables Optimus PRIME and it's modes
    # Double check and stress test your graphic intensive applications before commiting to one configuration
    # YOU CAN'T USE BOTH SYNC AND OFFLOAD AT THE SAME TIME
    prime = {
      # Enables Sync mode (uses the Dedicated Nvidia GPU as the main display device)
      #sync.enable = true;

      #Enables Offload mode (Uses the integrated GPU as the main display device)
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

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

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
