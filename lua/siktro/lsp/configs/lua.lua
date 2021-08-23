local lua_path = vim.split(package.path, ";")
table.insert(lua_path, "lua/?.lua")
table.insert(lua_path, "lua/?/init.lua")

return {
    root_dir = vim.loop.cwd,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = lua_path,
            },

            diagnostics = { globals = { "vim" } },

            workspace = {
                library = {},
                maxPreload = 100000,
                preloadFileSize = 10000,
            },

            telemetry = {
                enable = false,
            },
        },
    },
}
