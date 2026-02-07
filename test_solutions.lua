#!/usr/bin/env lua

-- Most of this file is AI-generated

-- PICO-8 function mocks
local function add(t, v)
  table.insert(t, v)
end

local function del(t, v)
  for i, item in ipairs(t) do
    if item == v then
      table.remove(t, i)
      return
    end
  end
end

local function all(t)
  local i = 0
  return function()
    i = i + 1
    if i <= #t then
      return t[i]
    end
  end
end

local function flr(x)
  return math.floor(x)
end

local function sub(s, i, j)
  return string.sub(s, i, j)
end

local function tonum(s)
  return tonumber(s)
end

-- Direction constants
local UP = 1
local RIGHT = 2
local DOWN = 3
local LEFT = 4

-- Load duplicate functions from main.lua
local function load_functions_from_main()
  local file = io.open("main.lua", "r")
  if not file then
    error("Could not open main.lua")
  end
  local content = file:read("*all")
  file:close()

  -- Simple extraction for functions without nested function definitions
  local function extract_simple_function(func_name)
    -- Match: "local function name(...) ... end" where there are no nested functions
    local pattern = "(local function " .. func_name .. "%b().-\nend)\n"
    local match = content:match(pattern)
    if match then
      return match
    end
    error("Could not extract function: " .. func_name)
  end

  -- Extract function with nested functions by finding matching end at same indentation
  local function extract_complex_function(func_name)
    local start_pattern = "local function " .. func_name .. "("
    local start_pos = content:find(start_pattern, 1, true)
    if not start_pos then
      error("Could not find function: " .. func_name)
    end

    -- Find the start of the line to measure indentation
    local line_start = start_pos
    while line_start > 1 and content:sub(line_start - 1, line_start - 1) ~= "\n" do
      line_start = line_start - 1
    end

    -- Measure indentation (spaces before "local")
    local indent = ""
    local pos = line_start
    while pos < start_pos do
      local char = content:sub(pos, pos)
      if char == " " or char == "\t" then
        indent = indent .. char
        pos = pos + 1
      else
        break
      end
    end

    -- Find the matching "end" at the same indentation lvl
    pos = start_pos
    while pos <= #content do
      local next_newline = content:find("\n", pos)
      if not next_newline then break end

      local line_begin = next_newline + 1
      local line_indent = ""
      local scan = line_begin
      while scan <= #content do
        local char = content:sub(scan, scan)
        if char == " " or char == "\t" then
          line_indent = line_indent .. char
          scan = scan + 1
        else
          break
        end
      end

      -- Check if this line has "end" at the same indentation
      if line_indent == indent and content:sub(scan, scan + 2) == "end" then
        -- Make sure it's the keyword "end" (followed by whitespace or end of file)
        local after_end = content:sub(scan + 3, scan + 3)
        if after_end == "" or after_end == "\n" or after_end == " " or after_end == "\t" then
          local end_of_line = content:find("\n", scan) or #content
          return content:sub(line_start, end_of_line)
        end
      end

      pos = next_newline + 1
    end

    error("Could not find matching 'end' for " .. func_name)
  end

  -- Build a chunk with the functions we want to load
  local chunk = "local UP, RIGHT, DOWN, LEFT = " .. UP .. "," .. RIGHT .. "," .. DOWN .. "," .. LEFT .. "\n"

  -- Add helper functions needed by extracted code
  chunk = chunk .. [[
local function ipairs(t)
  local i = 0
  return function()
    i = i + 1
    if i <= #t then return i, t[i] end
  end
end

local function add(t, v)
  table.insert(t, v)
end

local function sub(s, i, j)
  return string.sub(s, i, j)
end

local function tonum(s)
  return tonumber(s)
end
]]

  -- Extract and add the duplicate functions
  chunk = chunk .. extract_simple_function("get_next_position") .. "\n"
  chunk = chunk .. extract_simple_function("should_move") .. "\n"
  chunk = chunk .. extract_simple_function("is_valid_move") .. "\n"
  chunk = chunk .. extract_simple_function("collect_poke_redirections") .. "\n"
  chunk = chunk .. extract_simple_function("calculate_poke_intentions") .. "\n"
  chunk = chunk .. extract_simple_function("calculate_fire_intentions") .. "\n"
  chunk = chunk .. extract_simple_function("calculate_valid_intentions") .. "\n"
  chunk = chunk .. extract_simple_function("detect_crossings") .. "\n"
  chunk = chunk .. extract_complex_function("parse_lvls") .. "\n"

  -- Return the functions
  chunk = chunk .. "return get_next_position, should_move, is_valid_move, collect_poke_redirections, calculate_poke_intentions, calculate_fire_intentions, calculate_valid_intentions, detect_crossings, parse_lvls"

  -- Load and execute the chunk
  local loader, err = load(chunk, "main.lua functions")
  if not loader then
    error("Failed to load functions from main.lua: " .. (err or "unknown error"))
  end

  return loader()
end

local get_next_position, should_move, is_valid_move, collect_poke_redirections, calculate_poke_intentions, calculate_fire_intentions, calculate_valid_intentions, detect_crossings, parse_lvls = load_functions_from_main()

-- parse_lvls loaded from main.lua

-- Read lvl data from main.lua
local function load_lvls()
  local file = io.open("main.lua", "r")
  if not file then
    error("Could not open main.lua")
  end

  local content = file:read("*all")
  file:close()

  local all_lvls = {}

  -- Extract each lvl set
  local lvl_sets = {
    {name = "Tutorial Village", pattern = "tutorial_sequence = parse_lvls%(%[%[(.-)%]%]%)"},
    {name = "Winnow Park", pattern = "clearing_sequence = parse_lvls%(%[%[(.-)%]%]%)"},
    {name = "Silver Hollow", pattern = "reuse_sequence = parse_lvls%(%[%[(.-)%]%]%)"},
    {name = "Cannonball Court", pattern = "cannon_sequence = parse_lvls%(%[%[(.-)%]%]%)"},
    {name = "Main Street", pattern = "breakout_sequence = parse_lvls%(%[%[(.-)%]%]%)"},
  }

  for _, set in ipairs(lvl_sets) do
    local data = content:match(set.pattern)
    if data then
      local lvls = parse_lvls(data)
      for _, lvl in ipairs(lvls) do
        table.insert(all_lvls, {world = set.name, lvl = lvl})
      end
    end
  end

  return all_lvls
end

-- Game logic functions loaded from main.lua
-- get_next_position, should_move, is_valid_move, collect_poke_redirections,
-- calculate_poke_intentions, calculate_fire_intentions, calculate_valid_intentions,
-- detect_crossings

local function simulate_turn(lvl, pokes, fire, fire_dir, crossing_nudges)
  local intentions_per_poke = {}
  local original_positions = {fire = {x = fire.x, y = fire.y}}
  for i, poke in pairs(pokes) do
    intentions_per_poke[i] = calculate_poke_intentions(pokes, i, crossing_nudges)
    original_positions[i] = {x = poke.x, y = poke.y}
  end

  local fire_intentions = calculate_fire_intentions(lvl, pokes, fire, fire_dir, crossing_nudges)

  local already_moved = {fire = false}
  for i in pairs(pokes) do already_moved[i] = false end

  local moved = true
  while moved do
    moved = false

    for i, poke in pairs(pokes) do
      if not already_moved[i] then
        local valid_intentions = calculate_valid_intentions(lvl, pokes, fire, poke, "poke", intentions_per_poke[i])

        local can_move, intent = should_move(valid_intentions)
        if can_move and intent then
          poke.x = intent.x
          poke.y = intent.y
          poke.dir = intent.dir
          poke.moving = not not intent.dir
          already_moved[i] = true
          moved = true
          break
        else
          if #valid_intentions > 1 then
            return false, "Arrow ambiguous direction"
          end
        end
      end
    end

    if not moved and not already_moved.fire then
      local valid_intentions = calculate_valid_intentions(lvl, pokes, fire, fire, "fire", fire_intentions)

      local can_move, intent = should_move(valid_intentions)
      if can_move and intent then
        fire.x = intent.x
        fire.y = intent.y

        if intent.dir then
          fire_dir = intent.dir
        end
        already_moved.fire = true
        moved = true
      else
        if #valid_intentions > 1 then
          return false, "Fire ambiguous direction"
        end
      end
    end
  end

  for i, poke in pairs(pokes) do
    if not already_moved[i] then
      poke.moving = false
      poke.dir = nil
    end
  end

  if not already_moved.fire then
    fire_dir = nil
  end

  if fire.x == lvl.goal[1] and fire.y == lvl.goal[2] then
    fire_dir = nil
  end

  crossing_nudges = detect_crossings(pokes, fire, original_positions, already_moved)

  local any_poke_moved = false
  for i, poke in pairs(pokes) do
    if already_moved[i] then any_poke_moved = true break end
  end

  return already_moved.fire or any_poke_moved, nil, fire_dir, crossing_nudges
end

-- Test a lvl solution
local function test_lvl(world_name, lvl_idx, lvl)
  if not lvl.solution then
    return true, "No solution specified"
  end

  -- Check that solution has correct number of pokes
  local max = lvl.max or 9
  if #lvl.solution ~= max then
    return false, string.format("Solution has %d pokes but lvl expects %d", #lvl.solution, max)
  end

  -- Setup lvl
  local pokes = {}
  if lvl.pokes then
    for i, a in ipairs(lvl.pokes) do
      pokes[i] = {x = a.x, y = a.y, rot = a.rot}
    end
  end

  -- Place solution pokes
  for _, sol in ipairs(lvl.solution) do
    table.insert(pokes, {x = sol.x, y = sol.y, rot = sol.rot})
  end

  local fire = {x = lvl.fire[1], y = lvl.fire[2]}
  local fire_dir = nil
  local crossing_nudges = {}
  local max_steps = lvl.max_steps or 30

  -- Simulate turns
  for step = 1, max_steps do
    if fire.x == lvl.goal[1] and fire.y == lvl.goal[2] then
      return true, string.format("Success in %d steps", step - 1)
    end

    local moved, error, new_fire_dir, new_nudges = simulate_turn(lvl, pokes, fire, fire_dir, crossing_nudges)
    if error then
      return false, string.format("Error at step %d: %s", step, error)
    end

    fire_dir = new_fire_dir
    crossing_nudges = new_nudges

    if not moved then
      return false, string.format("Stuck at step %d (fire at %d,%d, goal at %d,%d)", step, fire.x, fire.y, lvl.goal[1], lvl.goal[2])
    end

    -- Check goal after turn as well
    if fire.x == lvl.goal[1] and fire.y == lvl.goal[2] then
      return true, string.format("Success in %d steps", step)
    end
  end

  return false, string.format("Timeout after %d steps (fire at %d,%d, goal at %d,%d)", max_steps, fire.x, fire.y, lvl.goal[1], lvl.goal[2])
end

-- Main test runner
local function main()
  print("Loading lvls from main.lua...")
  local all_lvls = load_lvls()
  print(string.format("Loaded %d lvls\n", #all_lvls))

  local passed = 0
  local failed = 0
  local world_counts = {}

  for idx, entry in ipairs(all_lvls) do
    world_counts[entry.world] = (world_counts[entry.world] or 0) + 1
    local lvl_num = world_counts[entry.world]

    local success, message = test_lvl(entry.world, lvl_num, entry.lvl)

    if success then
      print(string.format("✓ %s %d: %s", entry.world, lvl_num, message))
      passed = passed + 1
    else
      print(string.format("✗ %s %d: %s", entry.world, lvl_num, message))
      failed = failed + 1
    end
  end

  print(string.format("\n%d/%d tests passed", passed, passed + failed))

  if failed > 0 then
    os.exit(1)
  end
end

main()
