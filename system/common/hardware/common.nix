{...}: {
  # Enables OpenTabletDriver and it's deamon (yes I know it's on the bluetooth file, this is definitely gonna bite me in the ass if I forget to clean it)
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
}
