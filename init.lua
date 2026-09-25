-- Cache compiled Lua modules for faster startup. See `:help vim.loader`.
vim.loader.enable()

-- Set <space> as the leader key. Must happen before plugins are loaded.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help option-list`
vim.o.tabstop = 4 -- set tabs witdth to 4 spaces
vim.o.shiftwidth = 0 -- use tabstop value for indents
vim.o.expandtab = false -- do not inset spaces in place of tabs

-- Softwrap on whole words
vim.o.linebreak = true

-- Line numbers, relative to the cursor
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim. Scheduled after `UIEnter` because it
-- can increase startup time.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Show tabs, trailing spaces and non-breaking spaces
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Ask to save instead of failing on unsaved changes (e.g. `:q`)
vim.o.confirm = true

-- Default border for floating windows (hover, signature help, diagnostics, ...)
vim.o.winborder = 'rounded'

-- Dim background for inactive windows
vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#000000' })

-- [[ Basic Keymaps ]]

-- Clear search highlights with <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Allow easy window navigation out of a teminal buffer
vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', { desc = 'Exit terminal mode' })

vim.api.nvim_create_autocmd('BufEnter', {
  desc = 'Enter inset mode when entering a terminal buffer',
  group = vim.api.nvim_create_augroup('terminal-auto-insert', {}),

  callback = function()
    local buff = vim.bo
    if buff.buftype == 'terminal' then
      vim.cmd 'startinsert'
    end
  end,
})

-- Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Plugins ]]
--  Installed and loaded by the built-in plugin manager. See `:help vim.pack`.
--  :lua vim.pack.update()   update plugins (confirm with :w, cancel with :q)
--  Revisions are pinned in nvim-pack-lock.json.
local gh = function(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add {
  gh 'NMAC427/guess-indent.nvim',
  gh 'lewis6991/gitsigns.nvim',
  gh 'folke/which-key.nvim',
  gh 'nvim-mini/mini.nvim',
  gh 'folke/snacks.nvim',
  -- v2 is in development on main; stay on 1.x releases.
  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  -- Server config lives in after/lsp/jdtls.lua; mason-lspconfig enables it.
  gh 'mfussenegger/nvim-jdtls',
  gh 'MeanderingProgrammer/render-markdown.nvim',
}

-- Detect tabstop and shiftwidth automatically
require('guess-indent').setup {}

-- Adds git related signs to the gutter, as well as utilities for managing changes
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Show pending keybinds
require('which-key').setup {
  -- delay between pressing a key and opening which-key (milliseconds)
  -- this setting is independent of vim.o.timeoutlen
  delay = 0,
  icons = {
    -- set icon mappings to true if you have a Nerd Font
    mappings = vim.g.have_nerd_font,
  },

  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
  },
}

-- [[ mini.nvim ]]

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup { n_lines = 500 }

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- File type icons, used by mini.files, snacks and render-markdown.
if vim.g.have_nerd_font then
  require('mini.icons').setup()
end

require('mini.files').setup {}

local set_mark = function(id, path, desc)
  MiniFiles.set_bookmark(id, path, { desc = desc })
end
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesExplorerOpen',
  callback = function()
    set_mark('c', vim.fn.stdpath 'config', 'Config') -- path
    set_mark('w', vim.fn.getcwd, 'Working directory') -- callable
    set_mark('~', '~', 'Home directory')
  end,
})
vim.keymap.set('n', '<leader>e', MiniFiles.open, { desc = 'Open file [e]xplorer' })

-- [[ snacks.nvim ]]
require('snacks').setup {
  -- Also replaces vim.ui.select (e.g. code action menus).
  picker = { enabled = true },
  lazygit = {
    configure = true,
  },
}

vim.keymap.set('n', '<leader>gg', function()
  Snacks.lazygit()
end, { desc = 'Lazygit' })

-- See `:help snacks-picker-sources`
local picker = Snacks.picker
vim.keymap.set('n', '<leader>.', picker.smart, { desc = 'Smart search[.]' })
vim.keymap.set('n', '<leader>sh', picker.help, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', picker.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', picker.files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sF', function()
  picker.files { ignored = true }
end, { desc = '[S]earch All [F]iles' })
vim.keymap.set('n', '<leader>si', picker.git_files, { desc = '[S]earch G[i]t files' })
vim.keymap.set('n', '<leader>ss', picker.pickers, { desc = '[S]earch [S]elect picker' })
vim.keymap.set('n', '<leader>sw', picker.grep_word, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', picker.grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', picker.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', picker.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', picker.recent, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader><leader>', picker.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', picker.lines, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>s/', picker.grep_buffers, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>sn', function()
  picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })

-- [[ Autocompletion ]]
---@module 'blink.cmp'
---@type blink.cmp.Config
require('blink.cmp').setup {
  keymap = {
    -- <c-y> accept, <c-space> open menu/docs, <c-n>/<c-p> select,
    -- <c-e> hide, <c-k> toggle signature help, <tab>/<s-tab> snippet jumps.
    -- See :h blink-cmp-config-keymap
    preset = 'default',
  },

  appearance = {
    -- Icon spacing for 'Nerd Font Mono'
    nerd_font_variant = 'mono',
  },

  completion = {
    -- Press <c-space> to show documentation
    documentation = { auto_show = false },
  },

  sources = {
    default = { 'lsp', 'path' },
  },

  -- Lua matcher, so no prebuilt Rust binary is needed. See :h blink-cmp-config-fuzzy
  fuzzy = { implementation = 'lua' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}

-- [[ LSP ]]

-- Installs LSP servers and tools into stdpath('data')/mason and puts them on
-- $PATH. Must be set up before any server starts.
require('mason').setup {}
-- Enables every language server installed through Mason.
require('mason-lspconfig').setup {}
-- Language servers are installed with :Mason. Per-server settings live in
-- after/lsp/<name>.lua. See `:help lspconfig-all` for the available servers.
require('mason-tool-installer').setup {
  ensure_installed = { 'jdtls' },
}

-- Toggle inlay hints. Not gated on supports_method(): jdtls doesn't
-- advertise inlay hints, but still serves them.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-inlay-hint-toggle', { clear = true }),
  callback = function(event)
    vim.keymap.set('n', '<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
    end, { buffer = event.buf, desc = 'LSP: [T]oggle Inlay [H]ints' })
  end,
})

-- Report LSP progress (e.g. jdtls indexing) as progress messages, which
-- the default statusline shows. See `:help LspProgress`.
vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('lsp-progress', { clear = true }),
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or 'done' } }, false, {
      id = 'lsp.' .. ev.data.params.token,
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })
  end,
})

-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  severity_sort = true,
  float = { source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = { source = 'if_many', spacing = 2 },
  -- Show the full diagnostic in a float after jumping to it with ]d / [d.
  jump = {
    on_jump = function(diagnostic, bufnr)
      if diagnostic then
        vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
      end
    end,
  },
}

-- [[ Markdown ]]
-- Uses the markdown treesitter parsers bundled with Neovim.
require('render-markdown').setup {}

-- vim: ts=2 sts=2 sw=2 et
