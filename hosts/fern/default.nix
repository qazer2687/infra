{pkgs, config, ...}: {
  imports = [
    ../../hardware/fern
  ];

  networking.hostName = "fern";

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
    kernelParams = [
      "quiet"

      # https://wiki.cachyos.org/configuration/general_system_tweaks/#enable-rcu-lazy
      "rcutree.enable_rcu_lazy=1"
    ];
    blacklistedKernelModules = [
      "dvb_usb_rtl28xxu"
      "rtl2832_sdr"
      "rtl2832"
      "r820t"
    ];
    initrd.verbose = false;
    consoleLogLevel = 0;
    #kernelPackages = pkgs.linuxPackages_cachyos-server;
  };

    # fix a qbittorrent thing
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 0;
    "net.ipv4.conf.all.src_valid_mark" = 1;
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/33e56096-536d-410e-a2a8-cfd22ceb1db1";
    fsType = "ext4";
    options = [ "nofail" "noatime" ];
  };

  systemd.services.k3s = {
    after = ["mnt-storage.mount"];
    requires = ["mnt-storage.mount"];
  };


  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;


  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  sops.secrets.k3s = {
    sopsFile = ../../secrets/k3s.yaml;
    key      = "token";
    mode     = "0400";
    owner    = "root";
    group    = "root";
  };
  
  
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets.k3s.path;
    extraFlags = [
      # Bind node identity and overlay network to Tailscale
      "--flannel-iface=tailscale0"
      "--node-ip=100.77.88.58"
      "--tls-san=100.77.88.58"
      "--write-kubeconfig-mode=644"
      # Keep CPU and memory out of scheduler allocatable for OS and k8s daemons
      "--kubelet-arg=system-reserved=cpu=500m,memory=512Mi"
      "--kubelet-arg=kube-reserved=cpu=500m,memory=512Mi"
      # Hard floor; omitting inodesFree disables it entirely
      "--kubelet-arg=eviction-hard=memory.available<500Mi,nodefs.available<10%,nodefs.inodesFree<5%,imagefs.available<15%"
      # Graceful eviction before hitting the hard threshold
      "--kubelet-arg=eviction-soft=memory.available<1Gi"
      "--kubelet-arg=eviction-soft-grace-period=memory.available=30s"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      fluxcd
      kubernetes-helm
    ];
    sessionVariables = {
      KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
      
    };
  };
  

  # Support for vscode remote server.
  programs.nix-ld.enable = true;


  modules = {
    core.enable = true;
    dbus.enable = true;
    nh.enable = true;
    sudo-rs.enable = true;
    systemd-boot.enable = true;
    zram.enable = true;
    tailscale.enable = true;
    nfs.enable = true;

    # Security
    firewall.enable = true;
    chrony.enable = true;
  };

  # Did you read the comment?
  system.stateVersion = "25.11";
}