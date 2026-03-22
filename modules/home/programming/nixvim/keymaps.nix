{ ... }: {
  programs.nixvim.keymaps = [

    # ── Window Navigation ─────────────────────────────────────────────
    # Move between splits with Ctrl+hjkl instead of Ctrl+W then hjkl
    { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Go to left window"; }
    { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Go to lower window"; }
    { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Go to upper window"; }
    { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Go to right window"; }

    # ── Saving ────────────────────────────────────────────────────────
    { mode = ["n" "i" "v"]; key = "<C-s>"; action = "<cmd>w<cr><esc>"; options.desc = "Save file"; }

    # ── Buffer Navigation ─────────────────────────────────────────────
    # Move between buffers with Shift+l/h
    { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<cr>";     options.desc = "Next buffer"; }
    { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<cr>"; options.desc = "Prev buffer"; }
    { mode = "n"; key = "<leader>bd"; action = "<cmd>bdelete<cr>"; options.desc = "Delete buffer"; }

    # ── Scrolling (keep cursor centred) ──────────────────────────────
    { mode = "n"; key = "<C-d>"; action = "<C-d>zz"; options.desc = "Scroll down (centred)"; }
    { mode = "n"; key = "<C-u>"; action = "<C-u>zz"; options.desc = "Scroll up (centred)"; }

    # ── Search (keep cursor centred) ─────────────────────────────────
    { mode = "n"; key = "n"; action = "nzzzv"; options.desc = "Next result (centred)"; }
    { mode = "n"; key = "N"; action = "Nzzzv"; options.desc = "Prev result (centred)"; }

    # Clear search highlights with Escape in normal mode
    { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<cr>"; options.desc = "Clear highlights"; }

    # ── Indenting ─────────────────────────────────────────────────────
    # Stay in visual mode after indenting so you can re-indent quickly
    { mode = "v"; key = "<"; action = "<gv"; options.desc = "Indent left"; }
    { mode = "v"; key = ">"; action = ">gv"; options.desc = "Indent right"; }

    # ── Moving Lines ─────────────────────────────────────────────────
    { mode = "v"; key = "J"; action = ":m '>+1<cr>gv=gv"; options.desc = "Move selection down"; }
    { mode = "v"; key = "K"; action = ":m '<-2<cr>gv=gv"; options.desc = "Move selection up"; }

    # ── Paste without losing register ────────────────────────────────
    # Normally pasting over a selection replaces your clipboard. This prevents that.
    { mode = "v"; key = "p"; action = ''"_dP''; options.desc = "Paste (keep register)"; }

    # ── Splits ───────────────────────────────────────────────────────
    { mode = "n"; key = "<leader>sv"; action = "<cmd>vsplit<cr>"; options.desc = "Split vertical"; }
    { mode = "n"; key = "<leader>sh"; action = "<cmd>split<cr>";  options.desc = "Split horizontal"; }
    { mode = "n"; key = "<leader>sx"; action = "<cmd>close<cr>";  options.desc = "Close split"; }

    # ── Quickfix ─────────────────────────────────────────────────────
    { mode = "n"; key = "]q"; action = "<cmd>cnext<cr>";     options.desc = "Next quickfix"; }
    { mode = "n"; key = "[q"; action = "<cmd>cprevious<cr>"; options.desc = "Prev quickfix"; }
  ];
}