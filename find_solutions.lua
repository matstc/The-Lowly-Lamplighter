#!/usr/bin/env lua

-- Most of this file is AI-generated

-- PICO-8 constants
local UP = 1
local RIGHT = 2
local DOWN = 3
local LEFT = 4

-- Load game logic from main.lua (similar to test_solutions.lua)
local function load_functions_from_main()
  local file = io.open("main.lua", "r")
  if not file then
    error("Could not open main.lua")
  end
  local content = file:read("*all")
  file:close()

  local function extract_simple_function(func_name)
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

  local chunk = "local UP, RIGHT, DOWN, LEFT = " .. UP .. "," .. RIGHT .. "," .. DOWN .. "," .. LEFT .. "\n"

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

  chunk = chunk .. extract_simple_function("next_position") .. "\n"
  chunk = chunk .. extract_simple_function("is_valid_move") .. "\n"
  chunk = chunk .. extract_simple_function("should_move") .. "\n"
  chunk = chunk .. extract_simple_function("poke_redirects") .. "\n"
  chunk = chunk .. extract_simple_function("calc_poke_intents") .. "\n"
  chunk = chunk .. extract_simple_function("calc_fire_intents") .. "\n"
  chunk = chunk .. extract_simple_function("calc_valid_intents") .. "\n"
  chunk = chunk .. extract_simple_function("detect_nudges") .. "\n"
  chunk = chunk .. extract_complex_function("parse_lvls") .. "\n"

  chunk = chunk .. "return next_position, is_valid_move, should_move, poke_redirects, calc_poke_intents, calc_fire_intents, calc_valid_intents, detect_nudges, parse_lvls"

  local loader, err = load(chunk, "main.lua functions")
  if not loader then
    error("Could not load functions from main.lua: " .. tostring(err))
  end

  local success, result1, result2, result3, result4, result5, result6, result7, result8, result9 = pcall(loader)
  if not success then
    error("Error executing loaded functions: " .. tostring(result1))
  end

  return result1, result2, result3, result4, result5, result6, result7, result8, result9
end

print("Loading game logic from main.lua...")
local next_position, is_valid_move, should_move, poke_redirects, calc_poke_intents, calc_fire_intents, calc_valid_intents, detect_nudges, parse_lvls = load_functions_from_main()

-- Helper to add items to table
local function add(t, v)
  table.insert(t, v)
end

-- Simulate a complete game from initial poke placement
local function simulate_lvl(lvl, initial_pokes, max_steps)
  -- Deep copy pokes
  local pokes = {}
  for i, a in ipairs(initial_pokes) do
    pokes[i] = {x = a.x, y = a.y, rot = a.rot}
  end

  -- Initialize fire
  local fire = {x = lvl.fire[1], y = lvl.fire[2]}
  local fire_dir = nil
  local crossing_nudges = {}

  local steps = 0
  local max_allowed_steps = max_steps or lvl.max_steps or 30

  while steps < max_allowed_steps do
    -- Check if goal reached
    if fire.x == lvl.goal[1] and fire.y == lvl.goal[2] then
      return true, steps
    end

    -- Simulate one turn (same logic as handle_turn in main.lua)
    local intentions_per_poke = {}
    local original_positions = {fire = {x = fire.x, y = fire.y}}

    for i, poke in pairs(pokes) do
      intentions_per_poke[i] = calc_poke_intents(pokes, i, crossing_nudges)
      original_positions[i] = {x = poke.x, y = poke.y}
    end

    -- Prevent two pokes from moving onto the same cell (Phase 1.5)
    local destinations_per_poke = {}
    for i, poke in pairs(pokes) do
      local valid_intents = calc_valid_intents(lvl, pokes, fire, poke, "poke", intentions_per_poke[i], true)
      local can_move, intent = should_move(valid_intents)
      if can_move and intent then
        destinations_per_poke[i] = {x = intent.x, y = intent.y}
      end
    end
    for i, a in pairs(destinations_per_poke) do
      for j, b in pairs(destinations_per_poke) do
        if i ~= j and a.x == b.x and a.y == b.y then
          return false, "two pokes same cell"
        end
      end
    end

    local fire_intentions = calc_fire_intents(lvl, pokes, fire, fire_dir, crossing_nudges)

    local already_moved = {fire = false}
    for i in pairs(pokes) do already_moved[i] = false end

    local momentum_included = false
    local moved = true
    while moved do
      moved = false

      for i, poke in pairs(pokes) do
        if not already_moved[i] then
          local valid_intentions = calc_valid_intents(lvl, pokes, fire, poke, "poke", intentions_per_poke[i], momentum_included)
          local can_move, intent = should_move(valid_intentions)

          if can_move and intent then
            poke.x = intent.x
            poke.y = intent.y
            poke.dir = intent.dir
            already_moved[i] = true
            moved = true
            break
          else
            if #valid_intentions > 2 or (#valid_intentions == 2 and valid_intentions[1].redirected == true and valid_intentions[2].redirected == true) then
              return false, "ambiguous poke"
            end
          end
        end
      end

      if not moved and not momentum_included then
        momentum_included = true
        moved = true
      end

      if not moved and not already_moved.fire then
        local valid_intentions = calc_valid_intents(lvl, pokes, fire, fire, "fire", fire_intentions, true)
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
          if #valid_intentions > 2 or (#valid_intentions == 2 and valid_intentions[1].redirected == true and valid_intentions[2].redirected == true) then
            return false, "ambiguous fire"
          end
        end
      end
    end

    -- Update crossing nudges
    crossing_nudges = detect_nudges(pokes, fire, original_positions, already_moved)

    -- Check if anything moved
    local something_moved = already_moved.fire
    for i in pairs(pokes) do
      if already_moved[i] then
        something_moved = true
        break
      end
    end

    if not something_moved then
      return false, "stuck"
    end

    if not already_moved.fire then
      fire_dir = nil
    end

    if fire.x == lvl.goal[1] and fire.y == lvl.goal[2] then
      fire_dir = nil
    end

    steps = steps + 1
  end

  return false, "timeout"
end

-- Get all valid cells where pokes could be placed
local function get_candidate_cells(lvl)
  local candidates = {}
  local grid_size = 11
  local fire_x, fire_y = lvl.fire[1], lvl.fire[2]
  local goal_x, goal_y = lvl.goal[1], lvl.goal[2]

  for x = 1, grid_size do
    for y = 1, grid_size do
      local valid = true

      -- Skip fire position
      if x == fire_x and y == fire_y then
        valid = false
      end

      -- Skip goal position
      if x == goal_x and y == goal_y then
        valid = false
      end

      if lvl.obs then
        for _, obs in pairs(lvl.obs) do
          if obs[1] == x and obs[2] == y then
            valid = false
            break
          end
        end
      end

      -- Skip pre-placed pokes
      if lvl.pokes then
        for _, poke in ipairs(lvl.pokes) do
          if poke.x == x and poke.y == y then
            valid = false
            break
          end
        end
      end

      if valid then
        table.insert(candidates, {
          x = x,
          y = y,
          rotations = {UP, RIGHT, DOWN, LEFT}
        })
      end
    end
  end

  return candidates
end

-- Encode poke placement as a string for deduplication
local function encode_pokes(pokes)
  local parts = {}
  -- Sort pokes by position for consistent encoding
  local sorted = {}
  for _, a in ipairs(pokes) do
    table.insert(sorted, a)
  end
  table.sort(sorted, function(a, b)
    if a.x ~= b.x then return a.x < b.x end
    if a.y ~= b.y then return a.y < b.y end
    return a.rot < b.rot
  end)

  for _, a in ipairs(sorted) do
    table.insert(parts, string.format("%d,%d,%d", a.x, a.y, a.rot))
  end
  return table.concat(parts, "|")
end

-- Check if two poke sets are equivalent
local function pokes_match(pokes1, pokes2)
  if #pokes1 ~= #pokes2 then
    return false
  end

  -- Sort both for comparison
  local sorted1 = {}
  for _, a in ipairs(pokes1) do
    table.insert(sorted1, {x = a.x, y = a.y, rot = a.rot})
  end
  table.sort(sorted1, function(a, b)
    if a.x ~= b.x then return a.x < b.x end
    if a.y ~= b.y then return a.y < b.y end
    return a.rot < b.rot
  end)

  local sorted2 = {}
  for _, a in ipairs(pokes2) do
    table.insert(sorted2, {x = a.x, y = a.y, rot = a.rot})
  end
  table.sort(sorted2, function(a, b)
    if a.x ~= b.x then return a.x < b.x end
    if a.y ~= b.y then return a.y < b.y end
    return a.rot < b.rot
  end)

  for i = 1, #sorted1 do
    if sorted1[i].x ~= sorted2[i].x or
       sorted1[i].y ~= sorted2[i].y or
       sorted1[i].rot ~= sorted2[i].rot then
      return false
    end
  end

  return true
end

-- Find all solutions using iterative search
local function find_all_solutions(lvl, options)
  options = options or {}
  local max_steps = options.max_steps or (lvl.max_steps or 30)
  local max_solutions = options.max_solutions or 1000
  local verbose = options.verbose or false
  local max = lvl.max or 9
  local candidates = get_candidate_cells(lvl)

  if verbose then
    print(string.format("Searching for solutions with %d pokes on %d candidate cells...",
      max, #candidates))
  end

  if #candidates < max then
    print("Error: Not enough valid cells for poke placement")
    return {}, false
  end

  local solutions = {}
  local seen_configs = {}
  local attempts = 0
  local found_expected = false

  -- Recursive function to try all combinations
  local function try_placement(current_pokes, start_idx)
    if #solutions >= max_solutions then
      return
    end

    if #current_pokes == max then
      attempts = attempts + 1

      -- Check if we've seen this configuration
      local config_key = encode_pokes(current_pokes)
      if seen_configs[config_key] then
        return
      end
      seen_configs[config_key] = true

      if verbose and attempts % 5000 == 0 and attempts > 0 then
        print(string.format("Tested %d configurations, found %d solutions...", attempts, #solutions))
      end

      -- Create full poke list (pre-placed + user pokes)
      local all_pokes = {}
      if lvl.pokes then
        for _, a in ipairs(lvl.pokes) do
          table.insert(all_pokes, {x = a.x, y = a.y, rot = a.rot})
        end
      end
      for _, a in ipairs(current_pokes) do
        table.insert(all_pokes, {x = a.x, y = a.y, rot = a.rot})
      end

      -- Test this configuration
      local success, steps_or_reason = simulate_lvl(lvl, all_pokes, max_steps)
      if success then
        -- Check if this matches the expected solution
        local is_expected = false
        if lvl.solution and pokes_match(current_pokes, lvl.solution) then
          is_expected = true
          found_expected = true
        end

        table.insert(solutions, {
          pokes = current_pokes,
          steps = steps_or_reason,
          is_expected = is_expected
        })

        if verbose then
          local marker = is_expected and " (EXPECTED)" or ""
          print(string.format("Solution #%d found! (%d steps)%s", #solutions, steps_or_reason, marker))
          for _, a in ipairs(current_pokes) do
            print(string.format("  {x=%d, y=%d, rot=%d}", a.x, a.y, a.rot))
          end
        end
      end

      return
    end

    -- Try each remaining candidate cell
    for i = start_idx, #candidates do
      local cell = candidates[i]

      -- Try the useful rotations for this cell
      for _, rot in ipairs(cell.rotations) do
        local new_pokes = {}
        for _, a in ipairs(current_pokes) do
          table.insert(new_pokes, a)
        end
        table.insert(new_pokes, {x = cell.x, y = cell.y, rot = rot})

        try_placement(new_pokes, i + 1)

        if #solutions >= max_solutions then
          return
        end
      end
    end
  end

  try_placement({}, 1)

  if verbose then
    print(string.format("\nSearch complete: tested %d configurations, found %d solutions", attempts, #solutions))
  end

  return solutions, found_expected
end

-- Main execution
local args = arg or {}
local world_name = args[1]
local lvl_num = tonumber(args[2])
local max_solutions = tonumber(args[3]) or 10
local verbose = false

for _, a in ipairs(args) do
  if a == "-v" or a == "--verbose" then
    verbose = true
  end
end

if not world_name then
  print("Usage: lua find_solutions.lua <world_name> [lvl_num] [max_solutions] [options]")
  print("")
  print("Examples:")
  print("  lua find_solutions.lua \"Tutorial Town\" 1")
  print("  lua find_solutions.lua \"Tutorial Town\"              # Run all lvls")
  print("")
  print("Options:")
  print("  -v, --verbose              Show detailed progress")
  print("  --no-early-stop            Don't terminate simulations early")
  print("")
  print("Available worlds:")
  print("  - Tutorial Town")
  print("  - Winnow Park")
  print("  - Silver Hollow")
  print("  - Cannonball Court")
  print("  - Main Street")
  os.exit(1)
end

-- Load lvl data
print("Loading lvls from main.lua...")
local main_file = io.open("main.lua", "r")
local main_content = main_file:read("*all")
main_file:close()

-- Extract lvl data for the specific world
local world_map = {
  ["Tutorial Town"] = "tutorial_sequence",
  ["Silver Hollow"] = "reuse_sequence",
  ["Winnow Park"] = "clearing_sequence",
  ["Cannonball Court"] = "cannon_sequence",
  ["Main Street"] = "breakout_sequence"
}

local var_name = world_map[world_name]
if not var_name then
  print("Error: Unknown world '" .. world_name .. "'")
  os.exit(1)
end

local pattern = "local " .. var_name .. " = parse_lvls%(%[%[(.-)%]%]%)"
local lvl_data = main_content:match(pattern)
if not lvl_data then
  print("Error: Could not extract lvl data for " .. world_name)
  os.exit(1)
end

local lvls = parse_lvls(lvl_data)

-- Function to process a single lvl
local function process_lvl(lvl, lvl_idx, world_display_name, search_options)
  print(string.rep("=", 70))
  print(string.format("%s Level %d", world_display_name, lvl_idx))
  print(string.rep("=", 70))
  print(string.format("Fire: (%d,%d), Goal: (%d,%d), Max pokes: %d",
    lvl.fire[1], lvl.fire[2], lvl.goal[1], lvl.goal[2], lvl.max or 9))

  if lvl.solution then
    print("Expected solution:")
    for _, a in ipairs(lvl.solution) do
      print(string.format("  {x=%d, y=%d, rot=%d}", a.x, a.y, a.rot))
    end
  else
    print("No expected solution defined")
  end

  print()

  local solutions, found_expected = find_all_solutions(lvl, search_options)

  -- Print results
  print(string.format("\nResults: Found %d solution(s)", #solutions))

  if lvl.solution then
    if found_expected then
      print("✓ Expected solution FOUND")
    else
      print("✗ Expected solution NOT FOUND")
    end
  end

  if #solutions > 0 then
    print("\nAll solutions:")
    for i, sol in ipairs(solutions) do
      local marker = sol.is_expected and " (EXPECTED)" or ""
      print(string.format("\n  Solution #%d (%d steps)%s:", i, sol.steps, marker))
      for _, a in ipairs(sol.pokes) do
        print(string.format("    {x=%d, y=%d, rot=%d}", a.x, a.y, a.rot))
      end
    end
  end

  print()
  return found_expected
end

-- Determine which lvls to run
local lvls_to_run = {}
if lvl_num then
  if not lvls[lvl_num] then
    print("Error: Level " .. lvl_num .. " not found in " .. world_name)
    os.exit(1)
  end
  if lvls[lvl_num].max > 3 then
    lvls[lvl_num].max = 3
    print("Level "..lvl_num.." requires more than 3 pokes... will solve as if it required 3")
  end

  table.insert(lvls_to_run, {idx = lvl_num, lvl = lvls[lvl_num]})
else
  -- Run all lvls
  for i, lvl in ipairs(lvls) do
    if lvl.max > 3 then
      lvl.max = 3
      print("Level "..i.." requires more than 3 pokes... will solve as if it required 3")
    end

    table.insert(lvls_to_run, {idx = i, lvl = lvl})
  end
end

print(string.format("Running %d lvl(s) from %s\n", #lvls_to_run, world_name))

-- Build search options
local search_options = {
  max_solutions = max_solutions,
  verbose = verbose,
}

-- Process each lvl
local total_expected_found = 0
local total_with_expected = 0

for _, entry in ipairs(lvls_to_run) do
  local found_expected = process_lvl(entry.lvl, entry.idx, world_name, search_options)
  if entry.lvl.solution then
    total_with_expected = total_with_expected + 1
    if found_expected then
      total_expected_found = total_expected_found + 1
    end
  end
end

-- Print summary if running multiple lvls
if #lvls_to_run > 1 then
  print(string.rep("=", 70))
  print("SUMMARY")
  print(string.rep("=", 70))
  print(string.format("Processed %d lvl(s)", #lvls_to_run))
  if total_with_expected > 0 then
    print(string.format("Expected solutions found: %d/%d", total_expected_found, total_with_expected))
  end
end
