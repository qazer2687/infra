{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/home
  ];

  home.packages = with pkgs; [
    gdu
    btop
  ];

  modules = {
    git.enable = true;
    direnv.enable = true;
    zoxide.enable = true;
    fish.enable = true;
    eza.enable = true;
    fastfetch.enable = true;
  };

  home.stateVersion = "25.11";
  home.homeDirectory = lib.mkForce "/home/alex";

  sops = {
    defaultSopsFormat = "yaml";
    defaultSopsFile = ../../../secrets/default.yaml;
    age.keyFile = "/home/alex/.config/sops/age/keys.txt";
  };
}
