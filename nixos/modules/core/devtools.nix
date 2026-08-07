{...}: {
  flake.nixosModules.devtools = {
    pkgs,
    config,
    lib,
    ...
  }: let
    user = config.preferences.user.name;
    fullName = config.preferences.user.fullName;
    email = config.preferences.user.email;
  in {
    programs.git.enable = true;

    hjem.users.${user}.files = {
      ".config/git/config".text = ''
        ${lib.optionalString ("${email}" != "") ''
          [user]
            name = ${fullName}
            email = ${email}
        ''}
        [init]
          defaultBranch = main
        [advice]
          defaultBranchName = false
      '';
    };

    environment.systemPackages = with pkgs;
      (lib.optionals config.preferences.devtools.node [
        nodejs
        pnpm
        typescript
        tsx
      ])
      ++ (lib.optionals config.preferences.devtools.python [
        python3
        uv
        pipx
        python3Packages.pytest
      ])
      ++ (lib.optionals config.preferences.devtools.rust [
        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer
        cargo-audit
      ])
      ++ (lib.optionals config.preferences.devtools.go [
        go
        gopls
        gotools
        delve
        golangci-lint
      ])
      ++ (lib.optionals config.preferences.devtools.cc [
        gcc
        clang
        clang-tools
        cmake
        ninja
        gdb
        valgrind
        pkg-config
      ])
      ++ (lib.optionals config.preferences.devtools.java [
        jdk21
        maven
        gradle
      ])
      ++ (lib.optionals config.preferences.devtools.mobile [
        android-tools
      ]);
  };
}
