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
  systemd.services."systemd-suspend-then-hibernate".environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS =
    "false";

  services.mbpfan = {
    enable = true;
    settings.general = {
      min_fan1_speed = 1200;
      max_fan1_speed = 6000;
      low_temp = 55;
      high_temp = 70;
      max_temp = 90;
    };
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "nothing";
    HandleLidSwitchExternalPower = "nothing";
  };

  # ─── POWER MANAGEMENT WITH TLP ─────────────────────────────────────────────
  # Use TLP instead of power-profiles-daemon for optimized MacBook performance.
  # Balanced/low-power modes cause noticeable slowdowns, so we configure TLP with
  # a performance-oriented profile.
  services.tlp = {
    enable = true;
    settings = {
      # ─── CPU SCALING ───────────────────────────────────────────────────────
      # Use performance governor for responsive system behavior
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "performance";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "performance";

      # ─── CPU TURBO BOOST ───────────────────────────────────────────────────
      # Keep turbo boost enabled for better performance
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 1;

      # ─── DISK POWER MANAGEMENT ─────────────────────────────────────────────
      # Minimize disk parking for better responsiveness
      DISK_APM_LEVEL_ON_AC = 254;
      DISK_APM_LEVEL_ON_BAT = 254;
      DISK_SPINDOWN_TIMEOUT_ON_AC = 0;
      DISK_SPINDOWN_TIMEOUT_ON_BAT = 0;

      # ─── WIFI & BLUETOOTH ──────────────────────────────────────────────────
      # Keep Wi-Fi and Bluetooth on for consistent connectivity
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
      BLUETOOTH_PWR_ON_AC = "on";
      BLUETOOTH_PWR_ON_BAT = "on";

      # ─── USB POWER MANAGEMENT ──────────────────────────────────────────────
      # Keep USB power management disabled for device compatibility
      USB_AUTOSUSPEND = 0;

      # ─── POWER SAVE ───────────────────────────────────────────────────────
      # Minimal power saving to maintain performance
      SCHED_POWERSAVE_ON_AC = 0;
      SCHED_POWERSAVE_ON_BAT = 0;
    };
  };
}
