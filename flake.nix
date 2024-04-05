{
  description = "Urob's dotfiles";

  nixConfig = {
    # On non-NixOS systems, must add user to trusted-users in /etc/nix/configuration.nix
    # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/add-custom-cache-servers
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {self, ...} @ inputs: let
    system = "x86_64-linux";
    username = "urob";
    homeDirectory = "/home/${username}";

    # pkgs = inputs.nixpkgs.legacyPackages.${system}.extend unstable;
    pkgs = import inputs.nixpkgs {inherit system overlays;};
    overlays = [
      (_: prev: {unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};})
      inputs.neovim-nightly-overlay.overlay
    ];
  in {
    formatter.${system} = pkgs.nixpkgs-fmt; # nixpkgs-fmt or alejandra

    cfg = {
      inherit system username homeDirectory;
      runtimeRoot = "${homeDirectory}/dotfiles";
    };

    utils = import ./lib {
      inherit pkgs;
      inherit (inputs.home-manager.lib) hm;
      context = self;
    };

    # Entrypoint for NixOS
    /*
    nixosConfigurations = {
      your-hostname = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit system;};
    modules = [
      ./nixos/configuration.nix
      {
        # permission to add to substituters
        nix.settings.trusted-users = [ "${username}" ];
      }
    ];
      };
    };
    */

    # Entrypoint for standalone home-manager
    homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {context = self;};
      modules = [./home];
    };

    # Default `nix run .` to use home-manager, only used for initialization
    defaultPackage.${system} = inputs.home-manager.defaultPackage.${system};
  };
}
