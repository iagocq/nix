final: prev:
let
  pkgs = prev;
in
{
  zig = (pkgs.zig.override { llvmPackages = pkgs.llvmPackages_14; }).overrideAttrs (old: rec {
    version = "0.10.0-dev";
    src = pkgs.fetchFromGitHub {
      owner = "ziglang";
      repo = "zig";
      rev = "d852894dcf6143ff76575245f092d9e26b0e8fa6";
      hash = "sha256-YhspOaKOBqZVmfhiyQvQqn/3SKHelHQSU7G1JnWVnd0=";
    };
    patches = [];
  });

  zls = pkgs.zls.overrideAttrs (old: rec {
    version = "0.2.0";
    src = pkgs.fetchFromGitHub {
      fetchSubmodules = true;
      owner = "zigtools";
      repo = "zls";
      rev = "a18ec394f16a17cc1db20dedaabc42ce9b7f9a9d";
      sha256 = "sha256-lSGsUSHS1gQXzn0rKoKFKkQFOs9Ig7MUpL54PaLxLq8=";
    };
  });
}
