{
  description = "Home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      defaultCfg = rec {
        username = "urob";
        homeDirectory = "/home/${username}";
        runtimeRoot = "${homeDirectory}/dotfiles";
        context = self;
      };

      overlays = [
        (_: prev: { unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system}; })
      ];

      pkgsForSystem = system: import nixpkgs { inherit system overlays; };

      mkHomeConfiguration = args:
        home-manager.lib.homeManagerConfiguration {
          modules = [ ./home ];
          pkgs = pkgsForSystem (args.system or "x86_64-linux");
          # Could add cfg.currentSystem = system if needed
          extraSpecialArgs = { cfg = defaultCfg // args.config or { }; };
        };

    in
    {
      homeConfigurations = rec {
        # TODO: add lib function to loop over systems
        x86_64-linux = mkHomeConfiguration { };

        aarch64-linux = mkHomeConfiguration {
          system = "aarch64-linux";
        };

        ${defaultCfg.username} = x86_64-linux;
      };

      # Make `home-manager` default action for `nix run .`
      inherit (home-manager) packages;
    };
}
