{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rustup
    gcc
    gnumake
    pkg-config

    # LSPs (rust-analyzer comes from rustup: `rustup component add rust-analyzer`)
    lua-language-server
    nil
    clang-tools

    # Dev tools
    gh
    htop
    nixfmt
  ];

  programs.go = {
    enable = true;
    env.GOPATH = "~/go";
  };

  home.sessionVariables = {
    RUSTUP_HOME = "$HOME/.rustup";
    CARGO_HOME  = "$HOME/.cargo";
  };
}
