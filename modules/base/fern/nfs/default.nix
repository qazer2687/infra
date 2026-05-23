{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options.modules.nfs.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.nfs.enable {
    services.nfs.server = {
      enable = true;
      exports = ''
        /mnt/storage *(rw,sync,no_subtree_check,no_root_squash,insecure)
      '';
    };
    
    networking.firewall.allowedTCPPorts = [ 2049 ];
    networking.firewall.allowedUDPPorts = [ 2049 ];
  };
}
