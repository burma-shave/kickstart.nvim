-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'fenetikm/falcon' },
  {
    'sindrets/diffview.nvim',
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
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
