{ config, pkgs, ... }:

{
  # Basic Home Manager configuration
  home.username = "ruben";
  home.homeDirectory = "/var/home/ruben";
  home.stateVersion = "24.05";

  # List of packages to be installed in the user environment
  home.packages = with pkgs; [
    git
    gh
    vim
    neovim
    fd
    neofetch
    ripgrep
    fzf
    go-task
    dotnet-sdk_8
    jdk
    sqlite
    rclone
    cmatrix
  ];

  # Does not work because of file persmission maybe works with new update when they add it
  # home.file = {
  #   "${config.home.homeDirectory}/.ssh/config" = {
  #     text = ''
  #       AddKeysToAgent yes
  #     '';
  #   };
  # };

  # Enable Home Manager and other programs
  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  systemd.user.startServices = true;

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Ruben van der Hout";
    userEmail = "ruben.vanderhout@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autostash = true;
      };
    };
  };

  # User session variables configuration
  home.sessionVariables = {
    XDG_RUNTIME_DIR = "/run/user/1000";
    SSH_AUTH_SOCK = "${config.home.sessionVariables.XDG_RUNTIME_DIR}/ssh-agent.socket";
  };

  # Systemd service for ssh-agent for an normal fedora silverblue system
  systemd.user.services.ssh-agent = {
    Unit = {
      Description="Turn on SSH key agent";
    };
    Install = {
      WantedBy=[ "default.target" ];
    };
    Service = {
      Type="simple";
      ExecStart="/usr/bin/ssh-agent -D -a ${config.home.sessionVariables.SSH_AUTH_SOCK}";
    };
  };

}
