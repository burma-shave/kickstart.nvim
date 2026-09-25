-- Plugins loaded by `{ import = 'custom.plugins' }` in init.lua.
return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    -- Uses the markdown treesitter parsers bundled with Neovim.
    dependencies = { 'nvim-mini/mini.nvim' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    -- Server config lives in after/lsp/jdtls.lua; mason-lspconfig enables it.
    -- Not lazy-loaded: the plugin's lsp/jdtls.lua and LspAttach hook must be
    -- on the runtimepath before the first Java buffer starts the server.
    'mfussenegger/nvim-jdtls',
    lazy = false,
  },
}
