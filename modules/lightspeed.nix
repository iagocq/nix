{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lightspeed;
  user = "lightspeed";
  group = user;

  systemd-config = {
    RuntimeDirectoryMode = "0750";
    CacheDirectoryMode = "0750";
    LogsDirectoryMode = "0750";
    UMask = "0027";
    ProcSubset = "pid";
    ProtectProc = "invisible";
    CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = mkDefault true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectHostname = true;
    ProtectClock = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
    RestrictNamespaces = true;
    LockPersonality = true;
    MemoryDenyWriteExecute = !(builtins.any (mod: (mod.allowMemoryWriteExecute or false)) cfg.package.modules);
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RemoveIPC = true;
    PrivateMounts = true;
    # System Call Filtering
    SystemCallArchitectures = "native";
    SystemCallFilter = "~@cpu-emulation @debug @keyring @ipc @mount @obsolete @privileged @setuid";
  };
in
{
  options = {
    services.lightspeed.ingest = {
      enable = mkEnableOption "FTL handshake server";

      address = mkOption {
        default = "0.0.0.0";
        type = types.str;
        description = "Address where the server will listen on.";
      };

      streamKey = mkOption {
        default = "changeme";
        type = types.str;
        description = "Stream key. Please modify this option.";
      };

      extraArgs = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "Extra command line arguments.";
      };

      package = mkOption {
        default = pkgs.lightspeed-ingest;
        defaultText = "pkgs.lightspeed-ingest";
        type = types.package;
        description = "lightspeed-ingest package to use.";
      };

      user = mkOption {
        default = user;
        type = types.str;
        description = "User account under which lightspeed-ingest runs.";
      };

      group = mkOption {
        default = group;
        type = types.str;
        description = "Group account under which lightspeed-ingest runs.";
      };
    };

    services.lightspeed.webrtc = {
      enable = mkEnableOption "RTP -> WebRTC server";

      address = mkOption {
        default = "localhost";
        type = types.str;
        description = "Address where the HTTP server will listen on.";
      };

      webrtcAddress = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = "Public address WebRTC will use.";
      };

      webrtcPorts = mkOption {
        default = "20000-20500";
        type = types.str;
        description = "Port range WebRTC will use to connect with clients.";
      };

      rtpPort = mkOption {
        default = 65535;
        type = types.port;
        description = "Port where the service will listen for RTP packets.";
      };

      wsPort = mkOption {
        default = 8080;
        type = types.port;
        description = "Port where the service will listen for websocket connections.";
      };

      sslCert = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = ''
          SSL certificate the HTTP server will use.
          Set to `null` if no encryption is desired.
        '';
      };

      sslKey = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = ''
          SSL private key the HTTP server will use.
          Set to `null` if no encryption is desired.
        '';
      };

      extraArgs = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "Extra command line arguments.";
      };

      package = mkOption {
        default = pkgs.lightspeed-webrtc;
        type = types.package;
        description = "Lightspeed-webrtc package to use.";
      };

      user = mkOption {
        default = user;
        type = types.str;
        description = "User account under which lightspeed-webrtc runs.";
      };

      group = mkOption {
        default = group;
        type = types.str;
        description = "Group account under which lightspeed-webrtc runs.";
      };
    };
  };

  config = (mkIf cfg.ingest.enable {
    users.users.${cfg.ingest.user} = {
      group = cfg.ingest.group;
      isSystemUser = true;
    };

    users.groups.${cfg.ingest.group} = { };

    systemd.services.lightspeed-ingest = {
      description = "lightspeed-ingest FTL handshake server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        LS_INGEST_ADDR = "${cfg.ingest.address}";
        STREAM_KEY = "${cfg.ingest.streamKey}";
      };

      serviceConfig = systemd-config // {
        ExecStart = concatStringsSep " " ([
          "${cfg.ingest.package}/bin/lightspeed-ingest"
        ] ++ cfg.ingest.extraArgs);
        Restart = "always";
        RestartSec = "10s";

        User = cfg.ingest.user;
        Group = cfg.ingest.group;

        RuntimeDirectory = "lightspeed-ingest";
        CacheDirectory = "lightspeed-ingest";
        LogsDirectory = "lightspeed-ingest";

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
  }) // (mkIf cfg.webrtc.enable {
    users.users.${cfg.webrtc.user} = {
      group = cfg.webrtc.group;
      isSystemUser = true;
    };

    users.groups.${cfg.webrtc.group} = { };

    systemd.services.lightspeed-webrtc = {
      description = "lightspeed-webrtc RTP -> WebRTC server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = systemd-config // {
        ExecStart = concatStringsSep " " ([
          "${cfg.webrtc.package}/bin/lightspeed-webrtc"
          "--addr ${cfg.webrtc.address}"
          "--ip ${cfg.webrtc.webrtcAddress}"
          "--ports ${cfg.webrtc.webrtcPorts}"
          "--rtp-port ${cfg.webrtc.rtpPort}"
          ''${optionalString (cfg.webrtc.sslCert != null) "--ssl-cert ${cfg.webrtc.sslCert}"}''
          ''${optionalString (cfg.webrtc.sslKey != null) "--ssl-key ${cfg.webrtc.sslKey}"}''
        ] ++ cfg.webrtc.extraArgs);
        Restart = "always";
        RestartSec = "10s";

        User = cfg.webrtc.user;
        Group = cfg.webrtc.group;

        RuntimeDirectory = "lightspeed-webrtc";
        CacheDirectory = "lightspeed-webrtc";
        LogsDirectory = "lightspeed-webrtc";

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
  });
}
