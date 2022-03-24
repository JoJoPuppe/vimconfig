-- Plugin management via Packer
require("plugins")
-- Vim mappings, see lua/config/which.lua for more mappings
require("mappings")
-- All non plugin related (vim) options
require("options")
-- Vim autocommands/autogroups
require("autocmd")
vim.cmd[[colorscheme tokyonight]]

-- illuminate settings
vim.g.Illuminate_delay = 500
vim.cmd[[autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline ]]
