{ pkgs
, lib
, systemSettings
, userSettings
, storageDriver ? null
, ...
}:

let
  validStorageDrivers = [ null "aufs" "btrfs" "devicemapper" "overlay" "overlay2" "zfs" ];
  gpuType = systemSettings.gpuType or "";
  isNvidia = gpuType == "nvidia";
  isAmd = gpuType == "amd";
  username = userSettings.username or "root";
in
{
  assertions = [
    {
      assertion = storageDriver == null || builtins.elem storageDriver validStorageDrivers;
      message = ''
        storageDriver must be one of: ${lib.concatStringsSep ", "
          (builtins.filter (x: x != null) validStorageDrivers)} or null
        Got: ${if storageDriver == null then "null" else toString storageDriver}
      '';
    }
  ];

  hardware.nvidia-container-toolkit = {
    enable = isNvidia;
    mount-nvidia-executables = true;
    mount-nvidia-docker-1-directories = true;
  };
  virtualisation = {
    containers.enable = true;
    # oci-containers.backend = "docker";
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = [ pkgs.zfs ]; # Required if the host is running ZFS
      dockerSocket.enable = true;
    };
    docker = {
      package = pkgs.docker_28;
      enable = false;
      enableOnBoot = true;
      storageDriver = storageDriver;
      autoPrune.enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
          features.cdi = true;
          cdi-spec-dirs = [ "/home/${userSettings.username}/.config/cdi" ];
        };
      };
      daemon.settings = {
        features.cdi = true;
      };
    };

  };
  environment.systemPackages = with pkgs; [
    lazydocker
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ] ++ lib.optional isNvidia pkgs.nvidia-container-toolkit;
}
