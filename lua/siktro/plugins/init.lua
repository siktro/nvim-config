local ok, packer = pcall(require, "packer")

-- {{{ Installing "packer" if it's not found.
-- see: https://github.com/wbthomason/packer.nvim#bootstrapping
if not ok then
  local exec = vim.api.nvim_command
  local fn = vim.fn

  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
    exec "packadd packer.nvim"
  end

  ok, packer = pcall(require, "packer")
  if not ok then
    error(string.format("unable to find/install packer\nerr: %s", packer))
    return
  end
end
-- }}}

-- {{{ "packer" options
-- see: https://github.com/wbthomason/packer.nvim#custom-initialization
local util = require "packer.util"
packer.init {
  git = { clone_timeout = 300 },
  display = {
    open_fn = function()
      return util.float { border = "single" }
    end,
  },
}
-- }}}

-- {{{ Plugins
packer.startup(function(use)
  -- "packer" itself
  use "wbthomason/packer.nvim"

  -- utility lib; thing that most plugins wants
  use "nvim-lua/plenary.nvim"

  -- treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require "siktro.plugins.treesitter"
    end,
  }

  --- LSP
  use "neovim/nvim-lspconfig"
  use {
    "kabouzeid/nvim-lspinstall",
    requires = "neovim/nvim-lspconfig",
  }

  use "nvim-telescope/telescope.nvim"

  -- autocompletion
  use {
    "hrsh7th/nvim-compe",
    config = function()
      require("compe").setup {
        source = {
          path = true,
          buffer = true,
          nvim_lsp = true,
          nvim_lua = true,
          calc = false,
          vsnip = false,
          luasnip = false,
          ultisnips = false,
        },
      }
    end,
  }

  -- Keybindings
  use "folke/which-key.nvim"

  --- Misc
  -- cool icons
  use "kyazdani42/nvim-web-devicons"

  -- Color theme
  use "rafamadriz/neon"

  -- bufferline
  use {
    "romgrk/barbar.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }
end)
-- }}}
