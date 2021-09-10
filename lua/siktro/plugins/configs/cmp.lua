local cmp = Q.ensure_module("cmp")
local luasnip = Q.ensure_module("luasnip")
local icons = Q.ensure_module("lspkind").presets.default

local sources = {
    nvim_lsp = "⌈LSP⌋",
    buffer   = "⌈BUF⌋"
}

cmp.setup {
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm()
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },

    formatting = {
        format = function(entry, item)
            item.kind = icons[item.kind] .. " " .. item.kind
            item.menu = sources[entry.source.name] or entry.source.name
            return item
        end
    }
}
