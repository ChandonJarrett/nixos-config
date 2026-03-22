{ ... }: {
  programs.nixvim.opts = {

    # --- Line Numbers ---
    number = true;           # Absolute line number on current line
    relativenumber = true;   # Relative numbers on other lines

    # --- Indentation ---
    tabstop = 2;             # Tab character = 2 spaces
    shiftwidth = 2;          # >> and << shift by 2 spaces
    expandtab = true;        # Use spaces instead of tab character
    smartindent = true;      # Auto-indent new lines based on syntax

    # --- UI ---
    cursorline = true;       # Highlight line the cursor is on
    signcolumn = "yes";      # Always show gutter
    scrolloff = 8;           # Keep 8 lines above/below the cursor when scrolling
    sidescrolloff = 8;       # Same but horizontal
    wrap = false;            # Don't wrap long lines 
    termguicolors = true;    # 24-bit color (stylix needs)
    showmode = false;        # Don't show -- INSERT -- etc (lualine handles)

    # --- Search ---
    ignorecase = true;       # Case-insensitive search...
    smartcase = true;        # ...unless capital letter
    hlsearch = true;         # Keep search results highlighted after search
    incsearch = true;        # Show search matches as you type

    # --- Files ---
    swapfile = false;        # No .swp files cluttering projects
    backup = false;          # No backup~ files
    undofile = true;         # Persistent undo history across sessions (saved in undodir)

    # --- Behaviour ---
    splitbelow = true;       # Horizontal splits open below
    splitright = true;       # Vertical splits open to the right
    mouse = "a";             # Allow mouse in all modes
    updatetime = 250;        # Faster CursorHold events
    timeoutlen = 300;        # Time to wait for a key sequence (which-key)
  };
}