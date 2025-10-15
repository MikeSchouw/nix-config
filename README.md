# Nix Installation Instructions

1. (optional) add configuration for new machine around "darwinConfigurations." If this is not done, the `--flake ~/nix` command should have something like `Mikes-MacBook-Air` after `~/nix` to get the correct configuration
1. Clone this repository into ~/nix
1. Download installer from: https://nixos.org/download/
1. `cd ~/nix && nix flake init -t nix-darwin/master --extra-experimental-features "nix-command flakes"`
1. `sudo -H nix run nix-darwin/master#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --flake ~/nix`
