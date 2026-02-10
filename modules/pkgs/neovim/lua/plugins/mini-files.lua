return {
  "mini.files",
  after = function()
    require("mini.files").setup()
  end,
  keys = {
    {"<leader>fm", function() MiniFiles.open() end, desc = "Mini.files"},
  },
}
