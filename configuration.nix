{ config, lib, pkgs, inputs, nvf, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixrewind"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  home-manager.backupFileExtension = "backup";
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    image = ./gruvbox-dark-blue.png;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 12;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "rewind" = import ./home.nix;
    };
  };

  services.gnome.gnome-keyring.enable = true;

 
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rewind = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "storage" "input" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.wget
    pkgs.flameshot
    pkgs.wl-clipboard
    pkgs.swaynotificationcenter
    pkgs.libnotify
    pkgs.home-manager
    pkgs.wofi
    pkgs.pamixer
    pkgs.jq
    pkgs.nh
    pkgs.zsh
    pkgs.btop
    pkgs.xdg-desktop-portal
    pkgs.xdg-desktop-portal-gtk
    pkgs.mangohud
    pkgs.protonup
    pkgs.wine64
    pkgs.zapret
    pkgs.nftables
    pkgs.git
    pkgs.lua
    pkgs.libreoffice-qt
    pkgs.hunspell
    #split lol
    pkgs.gcc
    pkgs.python3Full
    pkgs.gnum4
    pkgs.gnumake
    pkgs.bison
    
];

  programs.zsh.enable = true;

  programs.nvf = {
    enable = true;
    settings.vim = {
      theme = {
        enable = true;
      };

      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;

      languages = {
        enableLSP = true;
        enableTreesitter = true;
      
        nix.enable = true;
        ts.enable = true;
        python.enable = true;
        clang.enable = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;

  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  services.xserver.videoDrivers = ["amdgpu"];

  programs.gamemode.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  environment.sessionVariables = {
    NH_FLAKE = "/etc/nixos";
  };

  fonts.packages = [  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.flatpak.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #systemd.services.zapret = {
  #  description = "zapret";
  #  after = [ "network-online.target" ];
  #  wants = [ "network-online.target" ];
  #  serviceConfig = {
  #    Environment = "PATH=/run/current-system/sw/bin:$PATH";
  #    Type = "oneshot";
  #    WorkingDirectory = "/home/rewind/zapret-discord-youtube-linux";
  #    User = "root";
  #    ExecStart = "/run/current-system/sw/bin/bash /home/rewind/zapret-discord-youtube-linux/main_script.sh -nointeractive";
  #    ExecStop = "/run/current-system/sw/bin/bash /home/rewind/zapret-discord-youtube-linux/stop_and_clean_nft.sh";
  #    ExecStopPost = "/usr/bin/env echo 'zapret ded'";
  #    PIDFile = "/run/zapret.pid";
  #    RemainAfterExit = true;
  #  };
  #  wantedBy = [ "multi-user.target" ];
  #};

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

