@default:
	just --list

# run garbage-collector
clean:
    nix-collect-garbage --delete-old

# rebuild home-manager
build:
    home-manager switch --flake .

# upgrade all packages
upgrade:
    nix flake update --flake .
    just build
