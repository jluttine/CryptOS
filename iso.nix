# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.
{lib, config, pkgs, ...}:
let
  # Version ID contains the commit ID of this repo and the version ID of NixOS.
  gitCommitId  = lib.substring 0 7 (lib.commitIdFromGitRepo ./.git);
  version = "0.1.git.${gitCommitId}-${config.system.nixosVersion}";
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

  services.xserver = {
    enable = true;

    # Automatically login as root.
    displayManager.slim = {
      enable = true;
      defaultUser = "root";
      autoLogin = true;
    };

    # Use XFCE
    desktopManager.xfce = {
      enable = true;
    };

    # Enable touchpad support for many laptops.
    synaptics.enable = true;
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

  # Allow the user to log in as root without a password.
  users.extraUsers.root.initialHashedPassword = "";

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

  environment.systemPackages = with pkgs; [
    electrum
    electron-cash
    electrum-ltc
    monero
  ];

}
