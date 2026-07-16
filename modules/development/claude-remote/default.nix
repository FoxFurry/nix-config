{ pkgs, ... }:

{
  # Autostart Claude Code Remote Control for ViralMonoRepo at login,
  # inside a detached tmux session so the QR code / TUI stays reachable
  # via `tmux attach -t claude-remote` (alias: crc).
  systemd.user.services.claude-remote = {
    Unit = {
      Description = "Claude Code Remote Control (ViralMonoRepo)";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s claude-remote -c %h/viralvibe/ViralMonoRepo '/run/current-system/sw/bin/claude remote-control --spawn=worktree --capacity=5'";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-session -t claude-remote";
      Restart = "on-failure";
      RestartSec = 10;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
