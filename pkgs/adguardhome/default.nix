{ lib, stdenv, fetchurl, fetchzip, system ? stdenv.targetPlatform }:

stdenv.mkDerivation {
  pname = "adguardhome";
  version = "0.106.3";

  src = (import ./bins.nix { inherit fetchurl fetchzip; }).${system};

  installPhase = ''
    install -m755 -D ./AdGuardHome $out/bin/adguardhome
  '';
}
