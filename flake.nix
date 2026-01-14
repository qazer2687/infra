{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    asahi.url = "github:nix-community/nixos-apple-silicon";
    
    nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    textfox.url = "github:adriankarlen/textfox";

    vicinae.url = "github:vicinaehq/vicinae";

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen.url = "github:0xc000022070/zen-browser-flake";

    # Personal
    nix-base16.url = "github:qazer2687/nix-base16";
  };

  outputs = {self, ...} @ inputs: {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      p-vm-core-01 = (import ./flake/p-vm-core-01) {inherit inputs self;};

    };
  };
}
