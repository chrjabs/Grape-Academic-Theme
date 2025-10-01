{
  description = "Dev env for personal webpage.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      lib = nixpkgs.lib;
      pkgsFor = lib.genAttrs (import systems) (system: (import nixpkgs { inherit system; }));
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
    in
    {
      devShells = forEachSystem (pkgs: {
        default = pkgs.mkShell rec {
          nativeBuildInputs = with pkgs; [
            bundix
            ruby
            gnumake
          ];
          shellHook = ''
            bundle install
          '';
        };
      });
      formatter = forEachSystem (pkgs: pkgs.alejandra);
    };
}
