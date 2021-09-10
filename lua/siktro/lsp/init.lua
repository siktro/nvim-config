local lspinstall = Q.ensure_module("lspinstall")
local nvim_lsp_cmp = Q.ensure_module("cmp_nvim_lsp")

local lspconfig = require "lspconfig"
local configs = {
  lua = require "siktro.lsp.configs.lua",
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = nvim_lsp_cmp.update_capabilities(capabilities)

local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()

  for _, serv in pairs(servers) do
    local conf = configs[serv] or {}

    if not conf.root_dir then
      conf.root_dir = vim.loop.cwd
    end

    if not conf.capabilities then
      conf.capabilities = capabilities
    end

    lspconfig[serv].setup(conf)
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
