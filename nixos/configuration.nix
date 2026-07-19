# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
  enable = true;
  settings = {
    main = {
      rc-manager = "resolvconf";
      # Force NetworkManager to use keyfile plugin for secrets
      plugins = "keyfile";
    };
  };
  };
#  networking.networkmanager.enable = false; # Disable NM
#networking.wireless = {
#  enable = true;
#  # Tell NixOS to read secrets from this secure path at boot
#  secretsFile = "/etc/nixos/wireless.env";
#
#  networks = {
#    # Use the variables defined inside wireless.env
#    "@HOME_SSID@" = {
#      psk = "@HOME_PASSWORD@";
#    };
#  };
#};


  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thinkpad = {
    isNormalUser = true;
    description = "thinkpad";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  programs.hyprland.enable = true;

  # Support dynamically linked binaries such as Python/PyTorch wheels.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # fonts.packages = with pkgs; [
  #        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  #];
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];




  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brightnessctl
    hyprsunset
    clang
    discord
    emacs
    fuse3
    git
    grim
    htop
    hyprpaper
    hyprshot
    kitty
    lazygit
    neovim
    networkmanager
    networkmanagerapplet
    obsidian
    ranger
    rclone
    ripgrep
    rustup
    python313
    stow
    stretchly
    tmux
    vscode
    waybar
    wget
    wl-clipboard
    wofi
    uv
    pavucontrol
    quickshell
    nodejs_24
    zed-editor
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  
  programs.dconf.profiles.user.databases = [
  {
    settings."org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita";
      icon-theme = "Flat-Remix-Red-Dark";
      font-name = "Noto Sans Medium 11";
      document-font-name = "Noto Sans Medium 11";
      monospace-font-name = "Noto Sans Mono Medium 11";
    };
  }
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

    systemd.sleep.extraConfig = ''
    AllowSuspendThenHibernate=yes
    HibernateDelaySec=30
   '';

  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandlePowerKey = "suspend-then-hibernate";
    HandlePowerKeyLongPress = "poweroff";
  };

  # Create the rclone mount point declaratively so the service can mount into it.
  systemd.tmpfiles.rules = [
    "d /home/thinkpad/google-drive 0755 thinkpad users - -"
  ];

  systemd.services.rclone = {
    description = "Rclone Mount Service";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "idle";
      User = "thinkpad";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /home/thinkpad/google-drive";
      ExecStart = "${pkgs.rclone}/bin/rclone mount --config /home/thinkpad/.config/rclone/rclone.conf drive: /home/thinkpad/google-drive --vfs-cache-mode=full --vfs-cache-max-size=150G --vfs-cache-max-age=12h";
      ExecStop = "/run/wrappers/bin/fusermount -u /home/thinkpad/google-drive";
      Restart = "on-failure";
      RestartSec = 15;
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ];
    };
    wantedBy = [ "default.target" ];
    script = ''
    '';
  
   };
}
