{
  inputs,
  self,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = builtins.currentSystem;
  specialArgs = {inherit inputs self;};
  modules = [
    ../../hosts/alpha
    ../../modules/base/shared
    ../../modules/base/alpha
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.nyx.nixosModules.default
    inputs.flatpak.nixosModules.nix-flatpak
    {
      home-manager = {
        users.alex = ../../homes/alpha;
        extraSpecialArgs = {inherit inputs self;};
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
        ];
      };
    }
  ];
}
