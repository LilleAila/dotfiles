return {
  "fzf-lua",
  cmd = "FzfLua",

  keys = {
    { "<leader>ff", ":FzfLua files<cr>", desc="Files" },
    { "<leader>fs", ":FzfLua live_grep<cr>", desc="Grep" },
  },
}
