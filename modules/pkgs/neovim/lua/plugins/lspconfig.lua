return {
  "nvim-lspconfig",
  before = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    local on_attach = function(client, bufnr)
      local opts = function(desc) return { noremap = true, silent = true, buffer = bufnr, desc = desc } end

      vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, opts("Open diagnostic float"))
      vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, opts("Next diagnostic"))
      vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
    end

    vim.lsp.config("*", {
      root_markers = { ".git" },
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.config("nixd", {
      settings ={
        nixd = {
          diagnostic = {
            suppress = { "sema-escaping-with", "var-bind-to-this", },
          },
        },
      },
    })
    vim.lsp.enable("nixd")

    -- Servers which only use defaults
    for _, lsp in ipairs({
      "ts_ls", "pyright", "cssls", "tailwindcss", "lua_ls", "hls", "svelte", "astro", "rust_analyzer", "blueprint_ls", "vala_ls", "tinymist", "html", "emmet_ls"
    }) do
      vim.lsp.config(lsp, {})
      vim.lsp.enable(lsp)
    end
  end,
}
