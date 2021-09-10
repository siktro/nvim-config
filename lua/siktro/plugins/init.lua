local packer = Q.ensure_module("packer")

-- {{{ Installing "packer" if it's not found.
-- TODO: refactor out installation process
-- see: https://github.com/wbthomason/packer.nvim#bootstrapping
if not packer then
  local exec = vim.api.nvim_command
  local fn = vim.fn

  local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system { "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path }
    exec "packadd packer.nvim"
  end

  packer = Q.ensure_module("packer", true)
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
  -- plugin manager
  use "wbthomason/packer.nvim"

  -- widly used lib
  use "nvim-lua/plenary.nvim"

  -- useful plugins
  use "nvim-treesitter/nvim-treesitter"
  use "nvim-telescope/telescope.nvim"

  -- LSP
  use "neovim/nvim-lspconfig"
  use "kabouzeid/nvim-lspinstall"

  -- autocompletition & snippets
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"

  -- keybindings
  use "folke/which-key.nvim"

  -- git stuff
  use "TimUntersberger/neogit"

  -- misc plugins
  use "nvim-neorg/neorg"

  -- theme
  use "NTBBloodbath/doom-one.nvim"

  -- cool icons
  use "kyazdani42/nvim-web-devicons"
  use "onsails/lspkind-nvim"
end)

-- TODO: refactor out
require "lua.siktro.plugins.configs.cmp"
-- }}}
