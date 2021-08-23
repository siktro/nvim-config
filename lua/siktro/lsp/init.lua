local ok, lspinstall = pcall(require, "lspinstall")

if not ok then
  error(string.format("'lspinstall' is not found/installed\nerr: %s", lspinstall))
  return
end

local lspconfig = require "lspconfig"
local configs = {
  lua = require "siktro.lsp.configs.lua",
}

local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()
  -- lspconfig[lang].setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  -- }
  for _, serv in pairs(servers) do
    local conf = configs[serv]
    if conf and not conf.root_dir then
      conf.root_dir = vim.loop.cwd
    end
    lspconfig[serv].setup(conf or {})
  end
end

setup_servers()

-- {{{ LSP handlers
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = { prefix = "", spacing = 0 },
  signs = true,
  underline = true,
  update_in_insert = false,
})
-- }}}

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function()
  setup_servers() -- reload installed servers
  vim.cmd "bufdo e"
end
