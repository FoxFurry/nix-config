{ pkgs, ... }:

{
  xdg.configFile."cava" = { source = ./../../../.config/cava; recursive = true; };
}