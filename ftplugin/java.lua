local home = os.getenv 'HOME'
local jdtls_home = '/opt/jdtls'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls/workspace/' .. project_name

vim.bo.tabstop = 2

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    jdtls_home .. '/bin/jdtls',
    '-configuration',
    home .. '/.cache/jdtls',
    '-data',
    workspace_dir,
    -- Keep Eclipse's .settings/.project metadata out of the actual repo.
    '--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false',
    -- Default heap is small enough to freeze on larger projects.
    '--jvm-arg=-Xmx8G',
  },

  -- vim.fs.root requires Neovim 0.10.
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
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  init_options = {
    bundles = {},
  },
}

-- ftplugin/java.lua runs on every buffer whose filetype becomes `java`,
-- so this reliably attaches jdtls to each Java file opened, not just the first.
require('jdtls').start_or_attach(config)
