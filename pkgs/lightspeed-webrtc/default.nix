{ buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "lightspeed-webrtc";
  version = "git-20210504-a3d0d97fa9bd2f0d2eb7ca1745b6212b75959a12";

  src = fetchFromGitHub {
    owner = "GRVYDEV";
    repo = "Lightspeed-webrtc";
    rev = "a3d0d97fa9bd2f0d2eb7ca1745b6212b75959a12";
    sha256 = "sha256-B5Gy1X1NH7iPdyOCZsHc+PrhT+pUHaK+fhE4nkT6q+4=";
  };

  vendorSha256 = "sha256:0d0k35aib87aflf614k6znyyp3wrpm0vysx4ly26j7197nsy4irh";
}
