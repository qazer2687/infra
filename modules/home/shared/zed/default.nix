{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: {
  options.modules.zed.enable = lib.mkEnableOption "";

  config = lib.mkIf config.modules.zed.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor-fhs;
      installRemoteServer = (osConfig.networking.hostName == "p-vm-core-01");
    };

    home.shellAliases = {
      "zed" = "zeditor";
    };
  };
}
