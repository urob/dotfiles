{
  description = "Urob's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
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
