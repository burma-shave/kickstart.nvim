vim.bo.tabstop = 2

-- nvim-jdtls extras, alongside the built-in gr* LSP mappings.
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = 'Java: ' .. desc })
end

map('n', 'gro', function() require('jdtls').organize_imports() end, '[O]rganize imports')
map('n', 'grs', function() require('jdtls').super_implementation() end, 'Goto [S]uper implementation')

map('n', 'grv', function() require('jdtls').extract_variable() end, 'Extract [V]ariable')
map('n', 'grV', function() require('jdtls').extract_variable_all() end, 'Extract [V]ariable (all occurrences)')
map('n', 'grc', function() require('jdtls').extract_constant() end, 'Extract [C]onstant')
-- Visual variants leave visual mode first so the '< and '> marks are set.
map('x', 'grv', "<Esc><Cmd>lua require('jdtls').extract_variable({ visual = true })<CR>", 'Extract [V]ariable')
map('x', 'grV', "<Esc><Cmd>lua require('jdtls').extract_variable_all({ visual = true })<CR>", 'Extract [V]ariable (all occurrences)')
map('x', 'grc', "<Esc><Cmd>lua require('jdtls').extract_constant({ visual = true })<CR>", 'Extract [C]onstant')
map('x', 'grm', "<Esc><Cmd>lua require('jdtls').extract_method({ visual = true })<CR>", 'Extract [M]ethod')
