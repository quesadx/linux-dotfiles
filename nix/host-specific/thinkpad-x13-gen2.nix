{ pkgs, lib, ... }:

{
  # --- TTY only, no DE/WM ---
  services.displayManager.enable = false;

  # --- Headless server: never suspend on lid close ---
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";

  # --- Battery: cap charge at 65% to extend lifespan ---
  systemd.services.thinkpad-battery-limit = {
    description = "Cap ThinkPad battery charge at 65%";
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-module-thinkpad_acpi.device" ];
    serviceConfig.Type = "oneshot";
    script = ''
      echo 65 > /sys/class/power_supply/BAT0/charge_control_end_threshold
    '';
  };

  # --- No desktop, so no flatpak/portals ---
  services.flatpak.enable = lib.mkForce false;

  # --- Docker & compose ---
  environment.systemPackages = with pkgs; [
    docker-compose
    hdparm
    util-linux
  ];

  # --- Backup to external HDD via restic (docker compose) ---
  fileSystems."/mnt/backup-hdd" = {
    device = "/dev/disk/by-label/backup-hdd";
    fsType = "ext4";
    options = [ "noauto" "nofail" ];
  };

  systemd.services.selfhost-backup = {
    description = "Backup cloud-selfhost data to external HDD via restic (docker compose)";
    after = [ "docker.service" ];
    wants = [ "docker.service" ];
    path = with pkgs; [ bash util-linux docker docker-compose hdparm coreutils ];
    serviceConfig = {
      Type = "oneshot";
      RequiresMountsFor = [ "/mnt/backup-hdd" ];
      ExecStart = "${pkgs.bash}/bin/bash /home/quesadx/cloud-selfhost/backup-hdd.sh";
      TimeoutStartSec = "6h";
    };
  };

  systemd.timers.selfhost-backup = {
    description = "Run selfhost backup every 6 hours";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "0/6:00:00";
      Persistent = true; # if the laptop was off/asleep, run ASAP on boot
      RandomizedDelaySec = "10m";
    };
  };

  virtualisation.docker.autoPrune = {
    enable = true;
    dates = "weekly";
  };
}
