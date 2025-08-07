-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'mfussenegger/nvim-jdtls',
    event = 'BufNew *.java',
    config = function()
      local home = os.getenv 'HOME'
      local jdtls_home = '/opt/jdtls'
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local workspace_dir = home .. '/.cache/jdtls/workspace' .. project_name

      local config = {
        -- The command that starts the language server
        -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
        cmd = {
          jdtls_home .. '/bin/jdtls',
          '-configuration',
          home .. '/.cache/jdtls',
          '-data',
          workspace_dir,
        },

        -- 💀
        -- This is the default if not provided, you can remove it. Or adjust as needed.
        -- One dedicated LSP server & client will be started per unique root_dir
        --
        -- vim.fs.root requires Neovim 0.10.
        -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
        root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

        -- Here you can configure eclipse.jdt.ls specific settings
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- for a list of options
        settings = {
          java = {},
        },

        -- Language server `initializationOptions`
        -- You need to extend the `bundles` with paths to jar files
        -- if you want to use additional eclipse.jdt.ls plugins.
        --
        -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
        --
        -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
        init_options = {
          bundles = {},
        },
      }
      require('jdtls').start_or_attach(config)
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = '*.java',
        callback = function()
          require('jdtls').start_or_attach(config)
        end,
      })
    end,
  },
}
