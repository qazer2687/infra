{pkgs, config, ...}: {
  imports = [
    ../../hardware/alpha
  ];
  networking.hostName = "alpha";

  services.qemuGuest.enable = true;

  users = {
    mutableUsers = false;
    users = {
      root = {
        hashedPassword = "$6$qRDf73LqqlnrtGKd$fwNbmyhVjAHfgjPpM.Wn8YoYVbLRq1oFWN15fjP3b.cVW8Dv3s/7q8NY4WBYY7x1Xe71S.AHpuqL1PY6IJe0x1";
      };
      alex = {
        isNormalUser = true;
        extraGroups = ["networkmanager" "wheel" "video"];
        hashedPassword = "$6$qRDf73LqqlnrtGKd$fwNbmyhVjAHfgjPpM.Wn8YoYVbLRq1oFWN15fjP3b.cVW8Dv3s/7q8NY4WBYY7x1Xe71S.AHpuqL1PY6IJe0x1";
        shell = pkgs.fish;
      };
    };
  };

  programs.fish.enable = true;

  boot = {
    # Support for my external HDD.
    supportedFilesystems = ["exfat" "cifs"];
  };

  networking.networkmanager.enable = true;

  systemd.services.systemd-networkd-wait-online.enable = true;
  
  fileSystems."/mnt/storage" = {
    device = "//192.168.1.10/storage";
    fsType = "cifs";
    options = [
      "guest"
      "uid=1000"
      "gid=100"
      "file_mode=0666"
      "dir_mode=0777"
      "nofail"
      "x-systemd.automount"
      "noauto"
    ];
  };

  # Support for vscode remote server.
  programs.nix-ld.enable = true;

  environment.systemPackages = [
    pkgs.git
  ];

  modules = {
    core.enable = true;
    dbus.enable = true;
    nh.enable = true;
    sudo-rs.enable = true;
    systemd-boot.enable = true;
    zram.enable = true;
    docker.enable = true;
    samba.enable = false;
    tailscale.enable = true;

    # Security
    firewall.enable = true;
    chrony.enable = true;

  };

  # Did you read the comment?
  system.stateVersion = "25.05";
}
