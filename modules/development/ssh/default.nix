{ ... }:

{
  home.file = {
    ".ssh/config".text = ''
    # Default configuration for all hosts
    Host *
        IdentityFile ~/.ssh/id_ed25519
        AddKeysToAgent yes
        UseKeychain yes

    # Personal GitHub account
    Host github.com-personal
        HostName github.com
        User git
        IdentityFile ~/.ssh/isacartur
        IdentitiesOnly yes
    '';
  };
}