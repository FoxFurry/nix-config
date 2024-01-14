{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./../../../.config/nvim/init.vim;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      elixir-tools-nvim
      nvchad-ui
      catppuccin-nvim
    ];
  };
}