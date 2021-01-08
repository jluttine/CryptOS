# builtins.fetchGit {
#   url = "https://github.com/NixOS/nixpkgs.git";
#   rev = "c59ea8b8a0e7f927e7291c14ea6cd1bd3a16ff38";
#   #sha256 = "1ak7jqx94fjhc68xh1lh35kh3w3ndbadprrb762qgvcfb8351x8v";
# }
builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/c59ea8b8a0e7f927e7291c14ea6cd1bd3a16ff38.tar.gz"
