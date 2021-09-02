{ pkgs, lib, stdenv, buildRustCrate, defaultCrateOverrides }: (import ./Cargo.nix { inherit pkgs lib stdenv buildRustCrate defaultCrateOverrides; }).workspaceMembers.lightspeed-ingest.build

