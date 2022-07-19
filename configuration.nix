
{ config, pkgs, ... }:

let

  primary_user = "venkatn";

in

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "junix";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  services = {
    blueman.enable = true;
    cron = {
      enable = true;
      systemCronJobs = [
        "#0 * * * *     ${primary_user} \$HOME/opt/scripts/backup"
      ];
    };
    xserver = {
      enable = true;
      layout = "gb";
      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          enable = true;
          greeter.enable = true;
        };
      };
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          adapta-gtk-theme
          arandr
          betterlockscreen
          brightnessctl
          dmenu
          dunst
          feh
          lxappearance
          networkmanagerapplet
          papirus-icon-theme
          pavucontrol
          picom
          playerctl
          ranger
          rofi
        ];
      };
      libinput.enable = true;
      videoDrivers = [ "displaylink" "modesetting" ];
    };
    printing.enable = true;
  };

  environment = {
    pathsToLink = [ "/libexec" ];
    etc = {
      hosts.mode = "0644";
      "powerlevel10k/powerlevel10k.zsh-theme".source = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };
  };

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  users.users.${primary_user} = {
    isNormalUser = true;
    initialPassword = "password1234";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "vboxusers" "libvirtd" "docker" "audio" "input" ];
  };

  security.sudo.extraRules= [
    {  users = [ "${primary_user}" ];
      commands = [
         { command = "ALL" ;
           options= [ "NOPASSWD" ]; 
        }
      ];
    }
  ];
 
  environment.systemPackages = with pkgs; [
    alacritty
    bc
    bitwarden
    bitwarden-cli
    copyq
    docker-compose
    firefox
    flameshot
    fusuma
    gimp
    git
    gnucash
    qutebrowser
    htop
    keyutils
    killall
    kube3d
    kubectl
    kubectx
    k9s
    leafpad
    libnotify
    libreoffice
    lm_sensors
    lsof
    minder 
    mpv
    mplayer
    redshift
    rclone
    ruby
    simplescreenrecorder
    slack
    teams
    thunderbird
    tmux
    todoist-electron
    unzip
    vagrant
    vim
    virt-manager
    virt-viewer
    vscode
    wget
    (pkgs.writers.writeDashBin "vboxmanage" ''
       ${pkgs.virtualbox}/bin/VBoxManage "$@"
    '')
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
    (
      let
        polybar = pkgs.polybar.override {
          pulseSupport = true;
        };
      in
      polybar
    )
    xdotool
    zathura
    zsh-powerlevel10k
  ];

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd.enable = true;
    virtualbox = {
      host = {
        enable = true;
      };
    };
  };

  programs = {
    dconf.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
    };
  };

  fonts.fonts = with pkgs; [
    font-awesome
    meslo-lgs-nf
    roboto
  ];

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "daily";
    };
    stateVersion = "22.05";
  };

}

