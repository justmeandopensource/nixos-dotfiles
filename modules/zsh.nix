{ config, pkgs, ... }: {

  programs.zsh = {
    enable = true;
    history = {
      size = 102400;
      save = 102400;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    initExtra = ''
      setopt HIST_IGNORE_ALL_DUPS

      # Powerlevel10k stuff
      [[ ! -f /etc/powerlevel10k/powerlevel10k.zsh-theme ]] || source /etc/powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      # Bitwarden stuff
      which keyctl >/dev/null 2>&1
      [[ "$?" == "0" ]] && keyctl link @u @s
    '';

    profileExtra = ''
      export PATH=$HOME/opt/scripts:$PATH;
    '';

    sessionVariables = {
      TERM = "xterm-256color";
      EDITOR = "vim";
      VISUAL = "vim";
      PAGER = "less";
    };

    shellAliases = {
      vi = "vim";
      sudo = "sudo ";
      watch = "watch ";
      k = "kubectl ";
      fan = "sensors | grep --color=none fan";
    };
  };

  programs.z-lua.enable = true;

}
