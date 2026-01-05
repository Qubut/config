{ pkgs, lib, userSettings, storageDriver ? null, ... }:

assert lib.asserts.assertOneOf "storageDriver" storageDriver [
  null
  "aufs"
  "btrfs"
  "devicemapper"
  "overlay"
  "overlay2"
  "zfs"
];

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia-container-toolkit = {
    enable = true;
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
    nvidia-container-toolkit
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];
}
