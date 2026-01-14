# This file defines overlays
_: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    let
      inherit (prev) lib stdenv;
    in {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });

      ffmpeg-full = prev.ffmpeg-full.override {
        withFullDeps = true;
      };
    };
}