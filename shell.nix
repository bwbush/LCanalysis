{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    (pkgs.octave.withPackages (ps: with ps; [ ps.statistics ]))
  ];
}
