{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    initContent = ''
      # Attach to the autostarted Claude remote-control tmux session
      # (systemd user service claude-remote; the QR code lives in there).
      alias crc='tmux attach -t claude-remote'
    '';
    oh-my-zsh = {
      enable = true;
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./../../../.config/powerlevel10k;
        file = "p10k.zsh";
      }
    ];
  };
}