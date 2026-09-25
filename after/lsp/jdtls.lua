-- Merged on top of the `lsp/jdtls.lua` configs shipped by nvim-lspconfig and
-- nvim-jdtls (the latter adds nvim-jdtls' extendedClientCapabilities).
-- Installed by Mason and enabled by mason-lspconfig (see init.lua).
-- See `:help lsp-config-merge`.
local cache_dir = vim.fn.stdpath 'cache' .. '/jdtls'

---@type vim.lsp.Config
return {
  -- A function so the workspace can be derived from the resolved root_dir
  -- rather than the cwd Neovim happened to be started in.
  ---@param dispatchers vim.lsp.rpc.Dispatchers
  ---@param config vim.lsp.ClientConfig
  cmd = function(dispatchers, config)
    local root = config.root_dir or vim.fn.getcwd()
    -- Suffix with a hash so projects sharing a directory name don't share a workspace.
    local workspace_dir = cache_dir .. '/workspace/' .. vim.fn.fnamemodify(root, ':t') .. '-' .. vim.fn.sha256(root):sub(1, 8)

    return vim.lsp.rpc.start({
      'jdtls', -- Installed by Mason, which puts it on $PATH
      '-configuration',
      cache_dir .. '/config',
      '-data',
      workspace_dir,
      -- Keep Eclipse's .settings/.project metadata out of the actual repo.
      '--jvm-arg=-Djava.import.generatesMetadataFilesAtProjectRoot=false',
      -- Default heap is small enough to freeze on larger projects.
      '--jvm-arg=-Xmx8G',
    }, dispatchers, {
      cwd = config.cmd_cwd,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,

  root_markers = { '.git', 'mvnw', 'gradlew' },

  ---@param bufnr integer
  on_attach = function(_, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      -- Needs inlay hints enabled: vim.lsp.inlay_hint.enable()
      inlayHints = { parameterNames = { enabled = 'all' } },
      signatureHelp = { enabled = true },
      -- Decompile library classes that have no source jar.
      contentProvider = { preferred = 'fernflower' },
      -- Never collapse imports into wildcards.
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      -- Offer static members from these classes in completion, adding the static import.
      completion = {
        favoriteStaticMembers = {
          'org.junit.jupiter.api.Assertions.*',
          'org.mockito.Mockito.*',
          'org.mockito.ArgumentMatchers.*',
          'org.assertj.core.api.Assertions.*',
        },
      },
      -- format = { settings = { url = '/path/to/eclipse-formatter.xml', profile = 'GoogleStyle' } },
    },
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
  init_options = {
    bundles = {},
  },
}
