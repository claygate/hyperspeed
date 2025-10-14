return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        notify = true,
        mini = true,
      }
    }
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      options = {
        opt = {
          number = true,
          relativenumber = true,
        },
      },
    },
  },
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
