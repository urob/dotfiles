{
  description = "Urob's dotfiles";

  nixConfig = {
    # requires adding user to trusted-users. Either in nixos-flake, or for standalone in /etc/nix/configuration.nix
    # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/add-custom-cache-servers
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux"; # or aarch64-darwin for ARM-based macOS
      pkgs = nixpkgs.legacyPackages.${system};
      username = "urob";
      homeDirectory = "/home/${username}";

    in
    {
      formatter.${system} = pkgs.alejandra; # nixpkgs-fmt or alejandra

      # Entrypoint for NixOS
      /*
      nixosConfigurations = {
        your-hostname = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit system;};
          modules = [
            ./nixos/configuration.nix
          ];
        };
      };
      */

      # Entrypoint for standalone home-manager
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home.nix
            {
              # Let home-manager inherit username
              home = { inherit username homeDirectory; };
            }
          ];
        };

      # Default `nix run .` to use home-manager, only used for initialization
      defaultPackage.${system} = home-manager.defaultPackage.${system};
    };
}
