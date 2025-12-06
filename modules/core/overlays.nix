{ inputs, ... }:
{
  nixpkgs.overlays = [
    # Provide pkgs.google-antigravity via antigravity-nix overlay
    inputs.antigravity-nix.overlays.default

    (_final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev) system;
      };
    })
  ];
}
