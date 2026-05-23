{pkgs, config, ...}: {
  imports = [
    ../../hardware/p-vm-core-01
  ];
  networking.hostName = "p-vm-core-01";

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

    boot = {
    kernelParams = [
      "i915.enable_guc=2"
    ];
    kernel.sysctl = {
      # Queue discipline algorithm for traffic control (CAKE reduces bufferbloat and latency).
      "net.core.default_qdisc" = "cake";

      # TCP congestion control algorithm (BBR provides better throughput and lower latency).
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
    #kernelPackages = pkgs.linuxPackages_cachyos;
    supportedFilesystems = [ "ntfs" "exfat" "cifs" ];
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # Modern VA-API driver for 8th Gen
      intel-compute-runtime # Enables HDR to SDR tone-mapping
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  programs.fish.enable = true;

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
