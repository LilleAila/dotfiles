return {
  "which-key.nvim",
  after = function()
    wk = require("which-key")
    wk.setup({
      preset = "helix",
      delay = 0,
      icons = {
        mappings = false,
        separator = "➜",
        group = "",
      },
    })

    wk.add({"<leader>f", desc="Picker"})
  end,
}
