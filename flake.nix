{
  description = "Home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

      config = { allowUnfree = true; };

      overlays = [
        # Attach nixpkgs-unstable at pkgs.unstable
        (_: prev: {
          unstable = import inputs.nixpkgs-unstable {
            inherit (prev) system;
            inherit config;
          };
        })
        # Pin the nix input to the home-manager configuration.
        # (The CLI version doesn't affect home-manager.)
        (_: prev: {nix = prev.nixVersions.nix_2_25;})
      ];

      pkgsForSystem = system: import nixpkgs { inherit system config overlays; };

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
