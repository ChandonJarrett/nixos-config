{ ... }: {
  programs.nixvim.plugins.blink-cmp = {
    enable = true;

    settings = {
      accept = {
        # Enter confirms, don't auto-accept on enter if nothing selected
        auto_brackets.enabled = true;  # Auto-inserts closing brackets after completion
      };

      keymap = {
        preset = "default";
        # Tab / Shift-Tab to cycle through completions
        "<Tab>"   = [ "select_next" "fallback" ];
        "<S-Tab>" = [ "select_prev" "fallback" ];
        # Enter to confirm
        "<CR>"    = [ "accept" "fallback" ];
        # Ctrl+Space to manually trigger
        "<C-Space>" = [ "show" "show_documentation" "hide_documentation" ];
        # Ctrl+e to dismiss
        "<C-e>" = [ "hide" "fallback" ];
        # Scroll docs popup
        "<C-d>" = [ "scroll_documentation_down" "fallback" ];
        "<C-u>" = [ "scroll_documentation_up" "fallback" ];
      };

      completion = {
        # Show completion menu automatically as you type
        trigger.show_on_insert_on_trigger_character = true;

        documentation = {
          auto_show = true;          # Automatically show docs popup alongside completion
          auto_show_delay_ms = 200;
        };

        # Ghost text shows the top suggestion inline as you type (like Copilot)
        ghost_text.enabled = false;  # Set true if you want inline ghost text
      };

      sources = {
        default = [ "lsp" "path" "snippets" "buffer" ];
      };

      # Fuzzy matching
      fuzzy = {
        use_typo_resistance = true;   # Still matches if you mistype slightly
        frecency.enabled = true;      # Ranks items you use more often higher
        use_proximity = true;         # Ranks nearby variables higher
      };
    };
  };
}
