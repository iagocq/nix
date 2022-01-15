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
  parprouted = callPackage ./parprouted { };

  pptpd = pkgs.pptpd.overrideAttrs (old: {
    configureFlags = [ "--enable-bcrelay" ];
  });

  streamlink-pr4022 = callPackage ./streamlink { };
  telegram-send = callPackage ./telegram-send { };
  truckersmp-cli = callPackage ./truckersmp-cli { };

  /*
  nixUnstable = prev.nixUnstable.override {
    patches = [ ./nix-unset-is-macho.patch ];
  };
  */

  zig = (pkgs.zig.override { llvmPackages = pkgs.llvmPackages_13; }).overrideAttrs (old: rec {
    version = "0.10.0-dev";
    src = pkgs.fetchFromGitHub {
      owner = "ziglang";
      repo = "zig";
      rev = "a5c7742ba6fc793608b8bb7ba058e33eccd9cfec";
      hash = "sha256-nObE1WX5nY40v6ryaAB75kVKeE+Q76yKgfR/DYRDcwA=";
    };
  });

  zls = pkgs.zls.overrideAttrs (old: rec {
    version = "0.2.0";
    src = pkgs.fetchFromGitHub {
      fetchSubmodules = true;
      owner = "zigtools";
      repo = "zls";
      rev = "189de1768dfc95086a15664123c11144e9ac1402";
      sha256 = "sha256-iTYwK76N0efm/e0JZbxKKZ/j+dej9BX/SNWeox+iLjA=";
    };
  });

  zsh-f-sy-h = callPackage ./zsh-f-sy-h { };
}
