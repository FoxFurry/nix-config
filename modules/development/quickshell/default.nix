{ pkgs, ... }:

{
  xdg.configFile."quickshell" = { source = ./../../../.config/quickshell; recursive = true; };
}