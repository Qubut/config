{ ... }:
{
  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      # Limit parallel builds to prevent memory exhaustion
      max-jobs = 4; # Adjust based on your RAM (e.g., 4 for 16GB, 8 for 32GB)
      cores = 0; # Let Nix automatically determine core usage
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Enable garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
