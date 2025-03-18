{
  description = "Mike's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      mac-app-util,
      home-manager,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.vim
            pkgs.mkalias
            pkgs.vscode
            pkgs.nixfmt-rfc-style
            pkgs.oh-my-zsh
            #pkgs.docker
          ];

          # fonts.packages = [ pkgs.nerd-fonts.fira-code ];

          homebrew = {
            enable = true;
            taps = [
              "hashicorp/tap"
              "common-fate/granted"
            ];
            brews = [
              # "mas"
              "go"
              "hashicorp/tap/terraform"
              "gh"
              "k9s"
              "zsh-syntax-highlighting"
              "zsh-autosuggestions"
              "npm"
              "nvm"
              "awscli"
              "act"
              "common-fate/granted/granted"
              "ansible"
              "kubectl"
              "prettier"
              "lazygit"
              "tailwindcss"
              "wget"
            ];
            casks = [
              "ghostty"
              "firefox"
              "spotify"
              "iina"
              "the-unarchiver"
              "slack"
              "notion"
              "stats"
              "hiddenbar"
              "logi-options+"
              "whatsapp"
              "yubico-authenticator"
              "raycast"
              "font-fira-code"
              "balenaetcher"
              "rectangle"
              "zen-browser"
            ];
            masApps = {
              # "Yubico" = 1497506650;
            };
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          system.defaults = {
            dock.autohide = true;
            # dock.largesize = 60
            # dock.magnification = true; # doesnt seem to work
            dock.persistent-apps = [
              "/System/Applications/Calendar.app"
              "/System/Applications/Notes.app"
              # "/Applications/Firefox.app"
              "/Applications/Zen.app"
              "/Applications/Google Chrome.app"
              "/Applications/Nix Apps/Visual Studio Code.app"
              "/Applications/Notion.app"
              "/Applications/Yubico Authenticator.app"
              "/Applications/Ghostty.app"
              "/Applications/Spotify.app"
              "/System/Applications/System Settings.app"
            ];
            finder.FXPreferredViewStyle = "clmv";
            loginwindow.GuestEnabled = false;
            NSGlobalDomain.AppleICUForce24HourTime = true;
            NSGlobalDomain.AppleInterfaceStyle = "Dark";
          };

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Unfree packages
          nixpkgs.config.allowUnfree = true;

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."Mikes-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          mac-app-util.darwinModules.default
          home-manager.darwinModules.home-manager
          (
            {
              pkgs,
              config,
              inputs,
              ...
            }:
            {
              # To enable it for all users:
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
            }
          )
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              # Apple Silicon Only
              enableRosetta = true;
              user = "mikeschouw";
            };
          }
        ];
      };
    };
}
