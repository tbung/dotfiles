{ inputs, config, pkgs, home-manager, ... }:

{
  imports =
    [
      ../../system/common.nix
      ./hardware-configuration.nix
    ];

  boot.kernelParams = [ "intel_idle.max_cstate=1" "processor.max_cstate=1" ];

  # Use the Grub2 boot loader.
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    device = "nodev";
    efiSupport = true;
    gfxmodeEfi = "2560x1440";
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking.hostName = "deep-thought"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware = {
    pulseaudio.enable = false;
    cpu.intel.updateMicrocode = true;
  };

  fileSystems."/media/alexandria" = {
    device = "/dev/disk/by-label/alexandria";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "noautodefrag" ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = [ pkgs.zsh ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tillb = {
    createHome = true;
    description = "Till Bungert";
    isNormalUser = true;
    isSystemUser = false;
    shell = pkgs.zsh;
    useDefaultShell = false;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # Optionally, you may need to select the appropriate driver version for your specific GPU.
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    firefox
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    papirus-icon-theme
    gnome.gnome-tweaks
    openconnect
    evolution
    evolution-ews
  ];

  programs.steam.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    users.tillb = import ../../home/nixos.nix;
  };

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
  system.stateVersion = "21.11"; # Did you read the comment?

}

