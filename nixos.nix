let
  nixpkgs = (import <nixpkgs> { }).fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "3320a06049fc259e87a2bd98f4cd42f15f746b96";
    sha256 = "1g5l186d5xh187vdcpfsz1ff8s749949c1pclvzfkylpar09ldkl";
  };
in import "${nixpkgs}/nixos"
