-- {{{ Setup logging functions.
local cache = vim.fn.stdpath "cache"
local logpath = cache .. "/session.log"

local logs = {}

local function create_log_entry(level, msg)
  if msg == nil then
    -- then only one param is received,
    -- so msg == level
    msg = level
    level = "DEBUG"
  end

  local log = string.format("[ %s | %5s ] :: %s\n", os.date "%X", level, msg)
  table.insert(logs, log)
end

-- TODO: if errors were found then we need to backup a session.log file
local function save_log()
  if not #logs then
    -- no new logs
    return
  end

  local f = io.open(logpath, "a")
  for _, log in ipairs(logs) do
    f:write(log)
  end
  f:close()
  logs = {} -- clear logs
end

local logger = nil

local function stop_logger()
  if not logger:is_active() then
    return
  end
  logger:stop()
end

local function start_logger(interval)
  logger = vim.loop.new_timer()
  logger:start(interval, 0, save_log)
end

-- dump logs into file each minute
start_logger(60 * 1000)
-- }}}

-- Basic global functions for simplicity sake.
-- Hope no other modules won't pollute '_G' with this name.
Q = {
  -- pretty-prints some value.
  q = function(val)
    print(vim.inspect(val))
  end,

  -- returns fomatted string.
  -- type less.
  f = function(...)
    return string.format(...)
  end,

  -- tries to require a module and returns it on successes,
  -- or raise an error.
  ensure_module = function(mod_name)
    local ok, out = pcall(require, mod_name)
    if not ok then
      create_log_entry("FAIL", Q.f("Module %q is not found/loaded. Error: %s", mod_name, out))
      save_log()
      error(Q.f("unable to load module %q; see log.", mod_name))
    end
    return ok and out or nil
  end,

  -- fn for creating a new log entry
  log = create_log_entry,

  logger = {
    -- TODO: add ability to dump/view current log in vim
    start = start_logger,
    stop = stop_logger,
    save = save_log,
  }
}
