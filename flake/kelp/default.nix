{
  inputs,
  self,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs self;};
  modules = [
    ../../hosts/kelp
    ../../modules/base/shared
    ../../modules/base/kelp
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    inputs.nyx.nixosModules.default
    {
      home-manager = {
        users.alex = ../../homes/kelp;
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
