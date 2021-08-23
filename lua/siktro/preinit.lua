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

-- TODO: add check for file size;
-- when some limit is reached we need to cut/drop file
-- or backup it.
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

-- separate each new session
table.insert(logs, string.format("\n\n%s\n", string.rep("=", 80)))
create_log_entry("INFO", "New session")

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

  -- tries to require a module and returns it on successes.
  -- otherwise returs either 'nil' (throw == false) or 'error' (throw == true).
  ensure_module = function(mod_name, throw)
    local ok, out = pcall(require, mod_name)
    if not ok then
      create_log_entry("FAIL", Q.sf("Module %q is not found/loaded. Error: %s", out))
    end
    if throw then
      error()
    end
    return ok and out or nil
  end,

  -- fn for creating a new log entry
  log = create_log_entry,

  -- just in case
  logger = {
    -- TODO: add ability to dump/view current log in vim
    start = start_logger,
    stop = stop_logger
  }
}
