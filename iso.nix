# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{lib, config, pkgs, ...}:
let
  # Version ID contains the commit ID of this repo.
  gitCommitId  = lib.substring 0 7 (lib.commitIdFromGitRepo ./.git);
  # Get this version with `git describe --tags` somehow.
  version = "0.2.git.${gitCommitId}";
in
{
  imports = [

    # Support as many devices as possible
    <nixpkgs/nixos/modules/profiles/all-hardware.nix>

    # ISO image stuff
    <nixpkgs/nixos/modules/installer/cd-dvd/iso-image.nix>

  ];

  # ISO naming.
  isoImage.isoName = "cryptos-${version}-${pkgs.stdenv.system}.iso";
  isoImage.volumeID = lib.substring 0 11 "CRYPTOS_ISO";
  isoImage.appendToMenuLabel = " Live System";

  # EFI and USB booting
  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  isoImage.splashImage = pkgs.fetchurl {
    url = https://raw.githubusercontent.com/NixOS/nixos-artwork/5729ab16c6a5793c10a2913b5a1b3f59b91c36ee/ideas/grub-splash/grub-nixos-1.png;
    sha256 = "43fd8ad5decf6c23c87e9026170a13588c2eba249d9013cb9f888da5e2002217";
  };

  # This was needed on some old 32-bit computers, otherwise the boot fails. Not
  # sure if this affects other computers badly?
  boot.kernelParams = [ "forcepae" ];

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

  # Generate /etc/os-release.  See
  # https://www.freedesktop.org/software/systemd/man/os-release.html for the
  # format.
  environment.etc."os-release".text = lib.mkForce
    ''
      NAME=CryptOS
      ID=cryptos
      VERSION="${version}"
      VERSION_CODENAME=${version}
      VERSION_ID="${version}"
      PRETTY_NAME="CryptOS ${version}"
    '';

  # Enable GPG agent (includes pinentry too) for GPG encryption and decryption
  programs = {
    gnupg.agent.enable = true;
  };

  environment.systemPackages = with pkgs; [

    # Cryptocurrency wallets
    electrum
    electron-cash
    electrum-ltc
    monero
    monero-gui

    # Useful utilities
    zbar

    # Support LUKS encrypted USB sticks
    cryptsetup

  ];

}
