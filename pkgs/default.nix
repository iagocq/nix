final: prev:

let
  pkgs = prev;
  callPackage = pkgs.callPackage;
in
{
  adguardhome = callPackage ./adguardhome { };
  lightspeed-ingest = callPackage ./lightspeed-ingest { };
  lightspeed-react = callPackage ./lightspeed-react { };
  lightspeed-webrtc = callPackage ./lightspeed-webrtc { };
  telegram-send = callPackage ./telegram-send { };
  streamlink-pr4022 = callPackage ./streamlink { };
  truckersmp-cli = callPackage ./truckersmp-cli { };

  /*
  nixUnstable = prev.nixUnstable.override {
    patches = [ ./nix-unset-is-macho.patch ];
  };
  */

  zig = (pkgs.zig.override { llvmPackages = pkgs.llvmPackages_13; }).overrideAttrs (old: rec {
    version = "0.9.0";
    src = pkgs.fetchFromGitHub {
      owner = "ziglang";
      repo = "zig";
      rev = version;
      hash = "sha256-Hfl1KKtGcopMrn+U9r0/qr/wReWJIgb8+IgwMoguv/0=";
    };
  });

  zls = pkgs.zls.overrideAttrs (old: rec {
    version = "0.2.0";
    src = pkgs.fetchFromGitHub {
      fetchSubmodules = true;
      owner = "mattmurr";
      repo = "zls";
      rev = "1fa392c44b5c7427521f9bbdfc0fe40a404b0bd5";
      sha256 = "sha256-0J9nSuMF0gGBAxz9LThoPIQWZvZiF6WS1/mfqJIvhnI=";
    };
  });

  zsh-f-sy-h = callPackage ./zsh-f-sy-h { };
}
