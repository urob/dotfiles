{
  description = "Home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
            inherit (prev) config;
            # Pass only the bare system string so unstable elaborates the
            # platform with its own lib.systems. Inheriting the fully
            # elaborated prev.stdenv.hostPlatform leaks stable's schema (e.g.
            # the now-removed `linux-kernel` attr) and breaks across channels.
            localSystem = { inherit (prev.stdenv.hostPlatform) system; };
          };
        })
        # Pin the nix version used by home-manager.
        # (_: prev: {nix = prev.nixVersions.nix_2_29;})
      ];

      pkgsForSystem = system: import nixpkgs { inherit system config overlays; };

      mkHomeConfiguration = args:
        home-manager.lib.homeManagerConfiguration {
          modules = [ ./nix/home ];
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
