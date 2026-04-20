{ ... }:

{
  boot.initrd.kernelModules = [
    "coretemp"
    "applesmc"
  ];
  boot.kernelParams = [
    # Deep sleep is unstable on this host; prefer suspend-to-idle for reliable wake.
    "mem_sleep_default=s2idle"
    # Override aggressive Kaby Lake defaults from nixos-hardware for resume stability.
    "i915.enable_psr=0"
    # Disable NVMe APST to avoid controller power-state resume failures.
    "nvme_core.default_ps_max_latency_us=0"
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/c0e5d438-f519-4894-872c-d6471ea518da";

  systemd.sleep.settings.Sleep = {
    MemorySleepMode = "s2idle";
    AllowSuspend = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
    HibernateMode = "shutdown";
  };

  # Work around systemd sleep regressions that can leave sessions unusable
  # after resume (broken login/authentication and missing GNOME shell state).
  systemd.services."systemd-suspend".environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
  systemd.services."systemd-hibernate".environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
  systemd.services."systemd-hybrid-sleep".environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";
  systemd.services."systemd-suspend-then-hibernate".environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";

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

  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "hibernate";
  };
}
