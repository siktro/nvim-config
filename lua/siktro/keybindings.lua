local ok, wk = pcall(require, "which-key")
if not ok then
  error(string.format("'which-key' is not found/installed\nerr: %s", wk))
  return
end

local ok, telescope = pcall(require, "telescope.builtin")
if not ok then
  error(string.format("'telescope' is not found/installed\nerr: %s", wk))
  return
end

vim.g.mapleader = " "

-- {{{ Normal Mode Maps
do
  local function map(key, action)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", key, action, opts)
  end

  -- turn off highlights
  map("<Esc>", ":noh<CR>")

  -- cycling windows
  map("<C-j>", "<C-w>w") -- next (down/right) window
  map("<C-k>", "<C-w>W") -- prev (up/left) window

  -- tab controls
  map("<A-\\>", ":tabnew<cr>")
  map("<A-|>", ":BufferClose<cr>")

  -- cycling tabs
  map("<A-[>", ":BufferPrevious<cr>")
  map("<A-]>", ":BufferNext<cr>")

  -- move tabs
  map("<A-{>", ":BufferMovePrevious<cr>")
  map("<A-}>", ":BufferMoveNext<cr>")
end
-- }}}

-- [[ which-key area ]]
-- {{{ Normal Mode Maps with <leader>
do
  local maps = {}
  -- TODO:
  -- 1. u - UI opts
  -- 2. q - exit opts
  -- 3. b - buf opts *
  -- 4. w - win opts
  -- 5. F - file(s)
  -- 6. t - tabs
  -- 7. g - git
  -- 8. z - activate zen?

  -- TODO: refactor all explicit function into 'action' table
  -- such no 'function() ... end' were here, only references to them

  -- finding things
  maps["<leader>"] = { telescope.find_files, "find files" }

  -- finding things more precisely
  maps.f = {
    name = "find",

    --- Telescope binds
    f = { telescope.find_files, "find (no hid)" },
    F = {
      function()
        telescope.find_files { hidden = true, no_ignore = true }
      end,
      "find (all)",
    },
    -- find from 'home', for now with cwd files in list, need to exclude them
    h = {
      function()
        telescope.find_files { hidden = true, no_ignore = true }
      end,
      "find from home",
    },
    -- TODO: add hidden and no-ignore opts
    g = { telescope.live_grep, "grep string" },
    b = { telescope.file_browser, "browser" },
  }

  -- buffer(s) actions
  maps.b = {
    name = "buffer",

    c = { ":bw<cr>", "close" },
    b = { telescope.buffers, "list" },
  }

  wk.register(maps, { prefix = "<leader>", mode = "n" })
end
-- }}}
