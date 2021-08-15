local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local g = vim.g -- a table to access global variables
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local opt = vim.opt -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Map leader to space
g.mapleader = ","

require "paq-nvim" {
  "airblade/vim-gitgutter",
  "alvan/vim-closetag",
  "b3nj5m1n/kommentary",
  "glepnir/lspsaga.nvim",
  "hoob3rt/lualine.nvim",
  "hrsh7th/nvim-compe",
  "hrsh7th/vim-vsnip",
  "jiangmiao/auto-pairs",
  "kyazdani42/nvim-web-devicons",
  "mhartington/formatter.nvim",
  "neovim/nvim-lspconfig",
  "nvim-lua/plenary.nvim",
  "akinsho/flutter-tools.nvim",
  "nvim-lua/popup.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-treesitter/nvim-treesitter",
  "rmagatti/auto-session",
  "savq/paq-nvim",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "wellle/targets.vim",
  "habamax/vim-godot",
  "ggandor/lightspeed.nvim",
  "kevinhwang91/nvim-hlslens",
  "junegunn/fzf",
  "romgrk/barbar.nvim",
  "danilo-augusto/vim-afterglow",
  "ayu-theme/ayu-vim",
  "lukas-reineke/indent-blankline.nvim"
}


-- Session
local sessionopts = {
  auto_restore_enabled = true,
  log_level = "info",
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = true,
  auto_session_suppress_dirs = nil
}

require("auto-session").setup(sessionopts)

local lsp_conf = require'lspconfig'
lsp_conf.gdscript.setup{
    on_attach = function (client)
        local _notify = client.notify
        client.notify = function (method, params)
            if method == 'textDocument/didClose' then
                -- Godot doesn't implement didClose yet
                return
            end
            _notify(method, params)
        end
    end,
    flags = {
      debounce_text_changes = 150,
    },
    cmd = { "nc", "localhost", "6008" },
    filetypes = { "gd", "gdscript", "gdscript3" },
    root_dir = lsp_conf.util.root_pattern("project.godot", ".git"),
    on_attach = on_attach
}
local languages = {
    javascript = {
                formatCommand = "~/Documents/stuff/node/lib/node_modules/prettier --stdin-filepath ${INPUT}",
                formatStdin = true }
}

lsp_conf.efm.setup {
    init_options = {documentFormatting = true},
    cmd = { "efm-langserver" },
    filetypes = vim.tbl_keys(languages),
    settings = {
        rootMarkers = {".git/"},
        languages = languages
	}
}

lsp_conf.pyright.setup{}

lsp_conf.tsserver.setup{
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_dir = lsp_conf.util.root_pattern(".git")
}

-- LSP Saga config & keys https://github.com/glepnir/lspsaga.nvim
local saga = require "lspsaga"
saga.init_lsp_saga {
  code_action_icon = "",
  definition_preview_icon = "",
  error_sign = "🚫",
  dianostic_header_icon = "✈",
  finder_definition_icon = "➡",
  finder_reference_icon = "❓",
  hint_sign = "⚡",
  infor_sign = "",
  warn_sign = ""
}

-- fluuter setup
require("flutter-tools").setup{}

map("n", "<leader>cf", ":Lspsaga lsp_finder<CR>", {silent = true})
map("n", "<leader>ca", ":Lspsaga code_action<CR>", {silent = true})
map("v", "<leader>ca", ":<C-U>Lspsaga range_code_action<CR>", {silent = true})
map("n", "<leader>ch", ":Lspsaga hover_doc<CR>", {silent = true})
map("n", "<leader>ck", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', {silent = true})
map("n", "<leader>cj", '<cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', {silent = true})
map("n", "<leader>cs", ":Lspsaga signature_help<CR>", {silent = true})
map("n", "<leader>ci", ":Lspsaga show_line_diagnostics<CR>", {silent = true})
map("n", "<leader>cn", ":Lspsaga diagnostic_jump_next<CR>", {silent = true})
map("n", "<leader>cp", ":Lspsaga diagnostic_jump_prev<CR>", {silent = true})
map("n", "<leader>cr", ":Lspsaga rename<CR>", {silent = true})
map("n", "<leader>cd", ":Lspsaga preview_definition<CR>", {silent = true})


-- Setup treesitter
local ts = require "nvim-treesitter.configs"
ts.setup {ensure_installed = "maintained", highlight = {enable = true}}

cmd [[ autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline ]]

vim.g.Illuminate_delay = 500
-- cmd([[autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline]], true)


-- setup indent line
require("indent_blankline").setup {
    char = "|",
    buftype_exclude = {"terminal"},
    space_char_blankline = "|",
    use_treesitter = true,
    show_end_of_line = true
}

-- vim.g.indent_blankline_use_treesitter = true

cmd [[colorscheme ayu]] 

opt.backspace = {"indent", "eol", "start"}
opt.clipboard = "unnamedplus"
opt.completeopt = "menuone,noselect"
opt.cursorline = true
opt.encoding = "utf-8" -- Set default encoding to UTF-8
opt.expandtab = true -- Use spaces instead of tabs
opt.foldenable = false
opt.foldmethod = "indent"
opt.formatoptions = "l"
opt.hidden = true
opt.hidden = true -- Enable background buffers
opt.hlsearch = true -- Highlight found searches
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" -- Get a preview of replacements
opt.incsearch = true -- Shows the match while typing
opt.joinspaces = false -- No double spaces with join
opt.linebreak = true -- Stop words being broken on wrap
opt.list = false -- Show some invisible characters
opt.number = true -- Show line numbers
opt.numberwidth = 5 -- Make the gutter wider by default
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.showmode = false -- Don't display mode
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- always show signcolumns
opt.smartcase = true -- Do not ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = "en"
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- You will have bad experience for diagnostic messages when it's default 4000.
opt.updatetime = 250 -- don't give |ins-completion-menu| messages.
opt.wrap = true



require "lualine".setup {
  options = {
    icons_enabled = true,
    theme = "gruvbox",
    component_separators = {"∙", "∙"},
    section_separators = {"", "" },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {"mode", "paste"},
    lualine_b = {"branch", "diff"},
    lualine_c = {
      {"filename", file_status = true, full_path = true},
      {
        {"diagnostics", sources = "nvim_lsp"}
      }
    },
    lualine_x = {"filetype"},
    lualine_y = {
      {
        "progress"
      }
    },
    lualine_z = {
      {
        "location",
        icon = ""
      }
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

-- Compe setup start
require "compe".setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  resolve_timeout = 800,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {
    border = {"", "", "", " ", "", "", "", " "}, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1
  },
  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
    luasnip = true
  }
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm({ 'keys': '<CR>', 'select': v:true })", {expr = true})
vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- End Compe related setup

-- Open nvimrc file
map("n", "<Leader>v", "<cmd>e $MYVIMRC<CR>")

map("n", "<Leader>sv", ":luafile %<CR>")

-- Quick new file
map("n", "<Leader>n", "<cmd>enew<CR>")

-- Easy select all of file
map("n", "<Leader>sa", "ggVG<c-$>")
-- Source nvimrc file

-- Make visual yanks place the cursor back where started
map("v", "y", "ygv<Esc>")

-- Easier file save
map("n", "<Leader>w", "<cmd>:w<CR>")

-- Tab to switch buffers in Normal mode
-- map("n", "<Tab>", ":bnext<CR>")
-- map("n", "<S-Tab>", ":bprevious<CR>")

-- barbar buffer tab plugin config
map("n", "<S-Tab>", ":BufferPrevious<CR>", {silent = true})
map("n", "<Tab>", ":BufferNext<CR>", {silent = true})
map("n", "<Leader>t", ":BufferClose<CR>", {silent = true})


-- Line bubbling
-- Use these two if you don't have prettierc
--map('n'), '<c-j>', '<cmd>m .+1<CR>==')
--map('n,) <c-k>', '<cmd>m .-2<CR>==')
map("n", "<c-j>", "<cmd>m .+1<CR>", {silent = true})
map("n", "<c-k>", "<cmd>m .-2<CR>", {silent = true})
map("i", "<c-j> <Esc>", "<cmd>m .+1<CR>==gi", {silent = true})
map("i", "<c-k> <Esc>", "<cmd>m .-2<CR>==gi", {silent = true})
map("v", "<c-j>", "<cmd>m +1<CR>gv=gv", {silent = true})
map("v", "<c-k>", "<cmd>m -2<CR>gv=gv", {silent = true})


--Auto close tags
map("i", ",/", "</<C-X><C-O>")
--After searching, pressing escape stops the highlight
map("n", "<esc>", ":noh<cr><esc>", {silent = true})
-- Telescope Global remapping
local actions = require("telescope.actions")
require("telescope").setup {

  defaults = {
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    mappings = {
      i = {
        ["<esc>"] = actions.close
      }
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      mappings = {
        i = {
          ["<C-w>"] = "delete_buffer"
        },
        n = {
          ["<C-w>"] = "delete_buffer"
        }
      }
    }
  }
}

map(
  "n",
  "<leader>p",
  '<cmd>lua require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({}))<cr>'
)
map("n", "<leader>r", '<cmd>lua require("telescope.builtin").registers()<cr>')
map(
  "n",
  "<leader>g",
  '<cmd>lua require("telescope.builtin").live_grep(require("telescope.themes").get_dropdown({}))<cr>'
)
map("n", "<leader>b", '<cmd>lua require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({}))<cr>')
map("n", "<leader>h", '<cmd>lua require("telescope.builtin").help_tags()<cr>')
map(
  "n",
  "<leader>f",
  '<cmd>lua require("telescope.builtin").file_browser(require("telescope.themes").get_dropdown({}))<cr>'
)
map("n", "<leader>s", '<cmd>lua require("telescope.builtin").spell_suggest()<cr>')
map(
  "n",
  "<leader>i",
  '<cmd>lua require("telescope.builtin").git_status(require("telescope.themes").get_dropdown({}))<cr>'
)

-------------------- COMMANDS ------------------------------
cmd "au TextYankPost * lua vim.highlight.on_yank {on_visual = true}" -- disabled in visual mode

-- Prettier function for formatter
local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--double-quote"},
    stdin = true
  }
end

require("formatter").setup(
  {
    logging = false,
    filetype = {
      javascript = {prettier},
      typescript = {prettier},
      html = {prettier},
      css = {prettier},
      scss = {prettier},
      python = {prettier},
    }
  }
)

