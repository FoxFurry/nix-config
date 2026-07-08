{ pkgs, ... }:

# Home Manager module: install the cmux agent skills for Claude Code.
#
# Claude Code discovers skills at ~/.claude/skills/<name>/SKILL.md. The cmux
# package already ships validated SKILL.md files (cmux, cmux-browser) with the
# correct frontmatter, matching the exact cmux version installed on this system
# -- so we symlink those rather than curl the upstream (macOS-oriented) set.
#
# Uses the same derivation as the system module (modules/development/cmux).

let
  cmux-linux = pkgs.callPackage ../cmux/package.nix { };
  skills = "${cmux-linux}/share/cmux/skills";
in
{
  home.file = {
    ".claude/skills/cmux".source = "${skills}/cmux";
    ".claude/skills/cmux-browser".source = "${skills}/cmux-browser";
  };
}
