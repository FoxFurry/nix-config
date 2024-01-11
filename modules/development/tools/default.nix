{ pkgs, ... }:

{
  home.packages = let
    pythonEnv = pkgs.python311Full.withPackages (p: with p; [
      pygobject3
      requests
    ]);
  in [
    pythonEnv
    pkgs.go
    pkgs.jetbrains.goland
    pkgs.killall
  ];

  programs.git = {
    enable = true;
    userName = "FoxFurry";
    userEmail = "isacartur@gmail.com";
  };
}