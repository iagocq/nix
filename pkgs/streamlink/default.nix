{ lib
, fetchFromGitHub
, python3Packages
, rtmpdump
, ffmpeg
}:

python3Packages.buildPythonApplication rec {
  pname = "streamlink-pr4022";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "streamlink";
    repo = "streamlink";
    rev = "ae747a113199c119bced4613d33edcc67a222bb9";
    sha256 = "sha256-PGU28xJ2Di0lvi1F9YEXDhz35v/TMXz/R8HjxR7TaE0=";
  };

  checkInputs = with python3Packages; [
    pytestCheckHook
    mock
    requests-mock
    freezegun
  ];

  propagatedBuildInputs = (with python3Packages; [
    pycryptodome
    requests
    iso-639
    iso3166
    websocket-client
    isodate
    lxml
  ]) ++ [
    rtmpdump
    ffmpeg
  ];

  # note that upstream currently uses requests 2.25.1 in Windows builds
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'requests>=2.26.0,<3.0' 'requests'
  '';

  meta = with lib; {
    homepage = "https://streamlink.github.io/";
    description = "CLI for extracting streams from various websites to video player of your choosing";
    longDescription = ''
      Streamlink is a CLI utility that pipes videos from online
      streaming services to a variety of video players such as VLC, or
      alternatively, a browser.

      Streamlink is a fork of the livestreamer project.
    '';
    changelog = "https://github.com/streamlink/streamlink/raw/${version}/CHANGELOG.md";
    license = licenses.bsd2;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ dezgeg zraexy DeeUnderscore ];
  };
}
