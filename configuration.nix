{ lib, config, pkgs, ... }:
{

  security.sudo.wheelNeedsPassword = false;
  users.users = {
    root = {
      password = null;
    };
    cryptos = {
      description = "CryptOS User";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "";
    };
  };

  services.xserver = {
    enable = true;

    displayManager = {

      # With LightDM, rendering in XFCE was totally broken. All kinds of errors
      # making it unusable.
      sddm = {
      #lightdm = {
        enable = true;
      };

      # Automatically log in
      autoLogin = {
        enable = true;
        user = "cryptos";
      };

    };

    # Use LXQt or XFCE
    desktopManager.plasma5 = {
    #desktopManager.xfce = {
    #desktopManager.lxqt = {
      enable = true;
    };

    # Enable touchpad support for many laptops.
    libinput.enable = true;
    #synaptics.enable = true;
  };

  # Disable networking
  networking = {
    networkmanager.enable = false;
    wireless.enable = false;
    useDHCP = false;
    interfaces = {};
  };

  # KDE complains if power management is disabled (to be precise, if
  # there is no power management backend such as upower).
  powerManagement.enable = true;

  # Enable GPG agent (includes pinentry too) for GPG encryption and decryption
  programs = {
    gnupg.agent.enable = true;
  };

  environment.systemPackages = with pkgs; [

    # Cryptocurrency wallets
    electrum
    #electron-cash
    electrum-ltc
    monero
    monero-gui

    # Useful utilities
    zbar

    # Support LUKS encrypted USB sticks
    cryptsetup

  ];

}
