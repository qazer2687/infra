{
  lib,
  config,
  ...
}: {
  options.modules.firewall.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.firewall.enable {
    networking = {
      firewall = {
        enable = true;

        #trustedInterfaces = ["tailscale0" "docker0"];

        allowedTCPPorts = [
          # SSH
          22
          # HTTP
          80
          81
          # rpcbind (NFS)
          111
          # HTTPS
          443
          # DNS
          53
          # NFS
          2049
          # XMPP
          5222
          5269
          # qBittorrent
          6881
          # Netbird
          33073
          10000
        ];

        allowedUDPPorts = [
          # DNS
          53
          # rpcbind (NFS)
          111
          # NFS
          2049
          # qBittorrent
          6881
          # Netbird
          443
          3478
          51820
        ];

        allowedUDPPortRanges = [
          {
            # Netbird
            from = 49152;
            to = 65535;
          }
        ];
      };
    };
  };
}
