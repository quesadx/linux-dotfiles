{ ... }:

{
  boot.initrd.kernelModules = [
    "coretemp"
    "applesmc"
  ];
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  services.mbpfan = {
    enable = true;
    settings.general = {
      min_fan1_speed = 1200;
      max_fan1_speed = 5000;
      low_temp = 55;
      high_temp = 70;
      max_temp = 90;
    };
  };

  services.logind.lidSwitch = "suspend";
}
