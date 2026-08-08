{
  self,
  inputs,
  config,
  ...
}: let
  theme = config.flake.theme.palette;
in {
  perSystem = {
    pkgs,
    lib,
    ...
  }: let
    themedTheme = pkgs.replaceVars ./theme.lua {
      inherit
        (theme)
        base00
        base01
        base02
        base03
        base04
        base05
        base06
        base07
        base08
        base09
        base0A
        base0B
        base0C
        base0D
        base0E
        base0F
        ;
    };

    themedPlugins = pkgs.replaceVars ./plugins.lua {
      codelldb = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
      debugpyPython = "${pkgs.python3.withPackages (ps: [ps.debugpy])}/bin/python3";
    };

    luaDir = pkgs.runCommand "nvim-lua" {} ''
      mkdir -p $out
      cp ${themedTheme} $out/theme.lua
      cp ${./init.lua} $out/init.lua
      cp ${themedPlugins} $out/plugins.lua
      cp ${./lsp.lua} $out/lsp.lua
      cp ${./keymaps.lua} $out/keymaps.lua
    '';
  in {
    packages.neovim = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.neovim.override {
        configure = {
          customRC = ''
            lua << EOF
            local ok, err = pcall(dofile, "${luaDir}/init.lua")

            if not ok then
              vim.api.nvim_err_writeln(err)
            end
            EOF
          '';

          packages.all.start = with pkgs.vimPlugins; [
            nvim-web-devicons

            fzf-lua

            nvim-tree-lua

            # Only the grammars for languages we actually edit — building all
            # grammars is slow and huge. (withGrammars was removed; use
            # withPlugins + builtGrammars.)
            (nvim-treesitter.withPlugins (ps: [
              ps.bash
              ps.c
              ps.cpp
              ps.css
              ps.fish
              ps.go
              ps.html
              ps.javascript
              ps.json
              ps.lua
              ps.markdown
              ps.markdown_inline
              ps.nix
              ps.python
              ps.rust
              ps.toml
              ps.tsx
              ps.typescript
              ps.vim
              ps.vimdoc
              ps.yaml
            ]))

            nvim-lspconfig

            blink-cmp
            luasnip
            friendly-snippets

            conform-nvim
            nvim-lint

            lualine-nvim
            bufferline-nvim
            gitsigns-nvim

            nvim-autopairs
            comment-nvim
            indent-blankline-nvim
            which-key-nvim
            neotest
            neotest-plenary
            neotest-python
            neotest-go
            neotest-rust
            nvim-dap
            nvim-dap-ui
            render-markdown-nvim
          ];
        };
      };

      runtimeInputs = with pkgs; [
        ripgrep
        fd
        fzf
        git
        alejandra
        statix
        deadnix
        stylua
        shfmt
        shellcheck
        jq
        ruff
        prettier
        golangci-lint
        clang-tools
        nil
        nixd
        lua-language-server
        bash-language-server
        vscode-langservers-extracted
        yaml-language-server
        taplo
        marksman
        pyright
        typescript-language-server
        rust-analyzer
        python3Packages.pytest
        go
        gcc
        delve
      ];

      env = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}
