{

  # Import pinned nixpkgs
  nixpkgs ? import ./nixpkgs.nix,

  # 64-bit system
  system ? "x86_64-linux"

}:

let

  # NixOS configuration for an ISO image
  configuration = { lib, pkgs, ... }: let
    # Version ID contains the commit ID of this repo.
    gitCommitId  = lib.substring 0 7 (lib.commitIdFromGitRepo ./.git);

    # Get this version with `git describe --tags` somehow.
    version = "0.2.git.${gitCommitId}";

  in {

    imports = [

      # Support as many devices as possible
      "${nixpkgs}/nixos/modules/profiles/all-hardware.nix"

      # ISO image stuff
      "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"

      # Add nixpkgs channel
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"

      # The actual system configuration
      ./configuration.nix

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

  };

  nixos = import "${nixpkgs}/nixos" { inherit system configuration; };

in { iso = nixos.config.system.build.isoImage; }
