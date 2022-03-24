local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
function get_config(name)
	return string.format("require(\"config/%s\")", name)
end

-- bootstrap packer if not installed
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        "git", "clone", "https://github.com/wbthomason/packer.nvim",
        install_path
    })
    execute "packadd packer.nvim"
end

-- initialize and configure packer
local packer = require("packer")
packer.init {
    enable = true, -- enable profiling via :PackerCompile profile=true
    threshold = 0 -- the amount in ms tha a plugins load time must be over for it to be included in the profile
}
local use = packer.use
packer.reset()

-- actual plugins list
use "wbthomason/packer.nvim"

use {'kevinhwang91/nvim-hlslens',
    config = get_config("hlslens")
}

use "folke/tokyonight.nvim"
use {
    "nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}},
    config = get_config("telescope")
}

use {"jvgrootveld/telescope-zoxide"}
use {"crispgm/telescope-heading.nvim"}
use {"nvim-telescope/telescope-symbols.nvim"}
use {"nvim-telescope/telescope-file-browser.nvim"}

use {"kyazdani42/nvim-tree.lua", config = get_config("nvim-tree")}

use {"numToStr/Navigator.nvim", config = get_config("navigator")}

use {
    "nvim-lualine/lualine.nvim",
    config = get_config("lualine"),
    event = "VimEnter",
    requires = {"kyazdani42/nvim-web-devicons", opt = true}
}

use {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = get_config("colorizer")
}

use {"folke/which-key.nvim", event = "VimEnter", config = get_config("which")}
use {"ahmedkhalf/project.nvim", config = get_config("project")}

use {"windwp/nvim-autopairs", config = get_config("autopairs")}
use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}

use {
    "nvim-treesitter/nvim-treesitter",
    config = get_config("treesitter"),
    run = ":TSUpdate"
}

use "nvim-treesitter/nvim-treesitter-textobjects"
use "p00f/nvim-ts-rainbow"

use {
    "hrsh7th/nvim-cmp",
    requires = {
        {"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-buffer"}, {"hrsh7th/cmp-path"},
        {"hrsh7th/cmp-cmdline"}, {"hrsh7th/cmp-vsnip"},
        {"f3fora/cmp-spell", {"hrsh7th/cmp-calc"}}
    },
    config = get_config("cmp")
}

use {"hrsh7th/vim-vsnip", config = get_config("vsnip")}
use {"RRethy/vim-illuminate", event = "CursorHold"}

use {"neovim/nvim-lspconfig", config = get_config("lsp")}
use {"ray-x/lsp_signature.nvim", requires = {{"neovim/nvim-lspconfig"}}}
use {"onsails/lspkind-nvim", requires = {{"famiu/bufdelete.nvim"}}}

use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    cmd = {"TroubleToggle", "Trouble"},
    config = get_config("trouble")
}
