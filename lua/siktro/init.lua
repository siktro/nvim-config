local modules = {
  "options",
  "plugins",
  "lsp",
  "keybindings"
}

local prefix = "siktro"
for _, mod in ipairs(modules) do
  require(Q.f("%s.%s", prefix, mod))
end

vim.cmd [[colorscheme doom-one]]
