{ config, lib, pkgs, ... }:

# System-level module: installs the cmux-linux GPU terminal + its agent-browser
# CDP daemon (driving nixpkgs chromium) so AI coding agents can script a browser.
#
# This is a system module (not Home Manager) because the packaged binary needs
# the system OpenGL driver (/run/opengl-driver) and installs a system app.
# Import from configuration.nix, not modules/home.nix.

let
  cmux-linux = pkgs.callPackage ./package.nix { };
in
{
  environment.systemPackages = [
    cmux-linux
    # agent-browser drives this over CDP; kept explicit so it's in the closure
    # and available on PATH for `agent-browser install`-style discovery too.
    pkgs.chromium
  ];

  # cmux ships Claude Code / Codex skills describing its CLI + browser commands.
  # Expose them read-only so agents (and you) can find them.
  environment.pathsToLink = [ "/share/cmux" ];
}
