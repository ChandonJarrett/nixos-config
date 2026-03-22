{ ... }: {
  programs.nixvim.plugins.which-key = {
    enable = true;
    settings = {
      delay = 300;  # ms before popup appears
      spec = [
        { __unkeyed = "<leader>f"; group = "find"; }
        { __unkeyed = "<leader>c"; group = "code"; }
        { __unkeyed = "<leader>g"; group = "git"; }
        { __unkeyed = "<leader>b"; group = "buffer"; }
        { __unkeyed = "<leader>s"; group = "splits"; }
        { __unkeyed = "<leader>r"; group = "rename"; }
      ];
    };
  };
}