return {
  colorscheme = "catppuccin",
  plugins = {
    {"catppuccin/nvim", name="catppuccin", priority=1000, opts={ flavour="mocha", integrations={ cmp=true, gitsigns=true, nvimtree=true, treesitter=true } }},
    {"epwalsh/obsidian.nvim", version="*"}
  },
  options = { opt = { number = true, relativenumber = true } }
}
