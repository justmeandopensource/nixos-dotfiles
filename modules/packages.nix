{ config, pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    awscli2
    bitwarden
    bitwarden-cli
    copyq
    gimp
    gnucash
    jq
    kube3d
    kubectl
    kubectx
    kubernetes-helm
    k9s
    minder
    pipe-viewer
    qutebrowser
    simplescreenrecorder
    slack
    teams
    thunderbird
    tmux
    todoist-electron
    vscode
    yt-dlp
    (
      let
        my-python-packages = python-packages: with python-packages; [
          colored
          GitPython
          humanize
          icalendar
          paramiko
          pyfiglet
          python-binance
          python-vagrant
          requests
          setuptools
          scp
          tabulate
        ];
        python-with-my-packages = python3.withPackages my-python-packages;
      in
      python-with-my-packages
    )
  ];
}