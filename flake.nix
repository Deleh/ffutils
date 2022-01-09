{
  description = "A collection of FFmpeg wrapper scripts";
  nixConfig.bash-prompt = "\[\\e[1mffutils-dev\\e[0m:\\w\]$ ";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          packages = {
            ffconv = pkgs.stdenv.mkDerivation {
              name = "ffconv";
              src = self;
              patchPhase = with pkgs; ''
                substituteInPlace bin/ffconv \
                  --replace ffmpeg ${ffmpeg}/bin/ffmpeg
              '';
              installPhase = ''
                install -m 755 -D bin/ffconv $out/bin/ffconv
              '';
            };
            ffcut = pkgs.stdenv.mkDerivation {
              name = "ffcut";
              src = self;
              patchPhase = with pkgs; ''
                substituteInPlace bin/ffcut \
                  --replace ffmpeg ${ffmpeg}/bin/ffmpeg
              '';
              installPhase = ''
                install -m 755 -D bin/ffcut $out/bin/ffcut
              '';
            };
          };

          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              ffmpeg
            ];
          };
        }
      );
}
