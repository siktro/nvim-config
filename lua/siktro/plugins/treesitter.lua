local ts = require "nvim-treesitter.configs"

ts.setup {
    ensure_installed = { "lua" },
    highlight = { enable = true }
}