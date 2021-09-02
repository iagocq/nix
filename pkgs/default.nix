final: prev:

let
  pkgs = prev;
  callPackage = pkgs.callPackage;
{
  lightspeed-ingest = callPackage ./lightspeed-ingest { };
  lightspeed-react = callPackage ./lightspeed-react { };
  lightspeed-webrtc = callPackage ./lightspeed-webrtc { };
}
