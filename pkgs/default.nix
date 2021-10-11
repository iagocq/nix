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
  zsh-f-sy-h = callPackage ./zsh-f-sy-h { };
}
