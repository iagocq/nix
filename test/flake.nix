{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.iago-nix.url = "path:..";

  outputs = { self, nixpkgs, iago-nix }:
  let
    nixpkgs-ov = system: import nixpkgs ({ inherit system; overlays = [ iago-nix.overlay ]; });
  in
  {
    legacyPackages."x86_64-linux" = (nixpkgs-ov "x86_64-linux");
  };
}
