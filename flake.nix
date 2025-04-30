{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:NoBrainSkull/nixvim-flake?tag=24.11_v2.1.10";
  };

  outputs = { nixvim, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = [
        pkgs.erlang_27
        pkgs.watchman
        pkgs.beam.packages.erlang_27.elixir_1_18
        pkgs.inotify-tools
        pkgs.nixfmt
        (nixvim.packages.${system}.default.extend {
          plugins.lsp = {
            enable = true;
            servers = {
              elixirls = {
                enable = true;
                package = pkgs.elixir_ls.overrideAttrs rec {
                  version = "0.27.1";
                  src = pkgs.fetchFromGitHub {
                    owner = "elixir-lsp";
                    repo = "elixir-ls";
                    rev = "v${version}";
                    hash = "sha256-YSu9uN0n8x1833iqvskk/47JnoXJ2Y8RCRmA12YYgDc=";
                  };
                };
              };
              nixd = {
                enable = true;
              };
            };
          };
        }
      )
      ];
    };
  };
}
