pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- the lowly lamplighter
-- by mxtxc
pico8_width = 128
pico8_height = 128
local grid_x = 11
local grid_y = 11
local grid_size = 11
local cursor_x = flr((grid_size + 1) / 2)
local cursor_y = flr((grid_size + 1) / 2)
local grid_start_x = 5
local grid_start_y = 9
local lvl = {}
local remaining_pokes = 0
local game_state = "title"
local raindrops = {}
local rain_speed = 1
local rain_move_interval = 4
local rain_frame_counter = 0
local world_index = 1
local world_picker_sel = "world"
local settings_sel = 1
local particles_enabled = true
local coordinates_enabled = false
local music_enabled = true
local lvls = {}
local pokes = {}
local fire = {x = nil, y = nil}
local turn_time = false
local turn_timer = 0
local fire_dir = nil
local lvl_timer = 0
local lvl_index = 1
local success_sound_played = false
local failure_sound_played = false
local goal_lit = false
local frames_in_step = 12
local step_counter = 0
local max_steps = 30
local pre_turn_pokes = nil
local fire_animation_timer = 0
local fire_animation_sprites = {8,9,10}
local blink_timer = 0
local burst_radius = 0
local fire_fail_animation_frame = 0
local fire_fail_animation_sprites = {26, 27, 28}
local fire_visible = true
local burst_active = false
local burst_speed = 3.5
local current_text = ""
local all_worlds_completed = false
local step_sfx = 60
local failure_sfx = 62
local success_sfx = 63
local menu_action_sfx = 57
local nav_sfx = 59
local cursor_colors = {5,6,7}
local cursor_step = 1
local cursor_steps_per_frame = 10
local flash = nil
local flash_frames = 0
local help_text_colors = {5,6,7}
local help_text_color_step = 1
local help_text_color_steps = 10
local nudges = {}
local blinking_pokes = {}
local blinking_step = 1
local blinking_steps = 8
local delete_save_data_button_label = "delete save data"
local toggle_music_button_label = "disable music"
local z_press_count = 0
local z_press_timer = 0
local large_alphabet = {
 ["a"]={0xff,0xff,0xc3,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3},
 ["b"]={0xfe,0xff,0xc3,0xc3,0xc3,0xfe,0xfe,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0xfe,0xfe},
 ["c"]={0xff,0xff,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xff,0xff},
 ["d"]={0xfc,0xfe,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xfe,0xfc,0xfc},
 ["e"]={0xff,0xff,0xc0,0xc0,0xc0,0xff,0xff,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xff,0xff},
 ["f"]={0xff,0xff,0xc0,0xc0,0xc0,0xff,0xff,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0},
 ["g"]={0xff,0xff,0xc0,0xc0,0xc0,0xcf,0xcf,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0xff},
 ["h"]={0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3},
 ["i"]={0xff,0xff,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0xff,0xff},
 ["j"]={0x3f,0x3f,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0x0c,0xcc,0xcc,0xff,0x7e},
 ["k"]={0xc3,0xc6,0xcc,0xd8,0xf0,0xf0,0xd8,0xcc,0xc6,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3},
 ["l"]={0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xff,0xff},
 ["m"]={0x81,0xc3,0xe7,0xff,0xdb,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3},
 ["n"]={0xc3,0xe3,0xf3,0xfb,0xdb,0xcf,0xc7,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3},
 ["o"]={0x7e,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7e},
 ["p"]={0xff,0xff,0xc3,0xc3,0xc3,0xff,0xff,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0},
 ["q"]={0x7e,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xcb,0xcf,0xff,0x7f,0x03,0x03,0x03},
 ["r"]={0xfe,0xff,0xc3,0xc3,0xc3,0xfe,0xfc,0xce,0xc7,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3},
 ["s"]={0x7f,0xff,0xc0,0xc0,0xc0,0xff,0x7f,0x03,0x03,0x03,0x03,0x03,0x03,0xff,0xfe,0xfe},
 ["t"]={0xff,0xff,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18},
 ["u"]={0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7e},
 ["v"]={0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0x66,0x66,0x66,0x3c,0x3c,0x18,0x18,0x18,0x18},
 ["w"]={0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xdb,0xff,0xe7,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3},
 ["x"]={0xc3,0xc3,0x66,0x66,0x3c,0x3c,0x18,0x18,0x18,0x18,0x3c,0x3c,0x66,0x66,0xc3,0xc3},
 ["y"]={0xc3,0xc3,0xc3,0xc3,0x66,0x66,0x3c,0x3c,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18},
 ["z"]={0xff,0xff,0x03,0x06,0x0c,0x18,0x30,0x60,0xc0,0x80,0x00,0x00,0x00,0x00,0xff,0xff}
}

local function parse_lvls(str)
  local pos = 1
  local len = #str

  local function skip_ws()
    while pos <= len do
      local c = sub(str, pos, pos)
      if c ~= " " and c ~= "\n" and c ~= "\t" and c ~= "\r" then
        break
      end
      pos = pos + 1
    end
  end

  local function peek()
    skip_ws()
    if pos <= len then
      return sub(str, pos, pos)
    end
  end

  local function consume(expected)
    skip_ws()
    if pos <= len and sub(str, pos, pos) == expected then
      pos = pos + 1
      return true
    end
    return false
  end

  local function parse_string()
    skip_ws()
    if sub(str, pos, pos) == '"' then
      pos = pos + 1
      local result = ""
      while pos <= len do
        local c = sub(str, pos, pos)
        if c == "\\" then
          pos = pos + 1
          if pos <= len then
            local next_char = sub(str, pos, pos)
            if next_char == "n" then
              result = result .. "\n"
            elseif next_char == "t" then
              result = result .. "\t"
            elseif next_char == "\\" then
              result = result .. "\\"
            elseif next_char == '"' then
              result = result .. '"'
            else
              result = result .. next_char
            end
            pos = pos + 1
          end
        elseif c == '"' then
          pos = pos + 1
          return result
        else
          result = result .. c
          pos = pos + 1
        end
      end
    end
  end

  local function parse_number()
    skip_ws()
    local start = pos
    local c = sub(str, pos, pos)
    if c == "-" then pos = pos + 1 end

    while pos <= len do
      c = sub(str, pos, pos)
      if c >= "0" and c <= "9" or c == "." then
        pos = pos + 1
      else
        break
      end
    end

    if pos > start then
      return tonum(sub(str, start, pos - 1))
    end
  end

  local function parse_bool()
    skip_ws()
    if sub(str, pos, pos + 3) == "true" then
      pos = pos + 4
      return true
    elseif sub(str, pos, pos + 4) == "false" then
      pos = pos + 5
      return false
    end
  end

  local function parse_value()
    skip_ws()
    local c = peek()

    if c == "{" then
      return parse_table()
    elseif c == '"' then
      return parse_string()
    elseif c == "t" or c == "f" then
      return parse_bool()
    elseif c == "-" or (c >= "0" and c <= "9") then
      return parse_number()
    end
  end

  function parse_table()
    local t = {}
    consume("{")
    local is_array = true
    local array_index = 1

    while not consume("}") do
      skip_ws()

      local before_key = pos
      local key_start = pos

      while pos <= len do
        local c = sub(str, pos, pos)
        if (c >= "a" and c <= "z") or (c >= "a" and c <= "z") or c == "_" or (c >= "0" and c <= "9") then
          pos = pos + 1
        else
          break
        end
      end

      local key = nil
      if pos > key_start then
        key = sub(str, key_start, pos - 1)
      end

      skip_ws()
      if key and sub(str, pos, pos) == "=" then
        is_array = false
        pos = pos + 1
        local value = parse_value()
        t[key] = value
      else
        pos = before_key
        local value = parse_value()
        t[array_index] = value
        array_index = array_index + 1
      end

      skip_ws()
      if not consume(",") then
        skip_ws()
        if peek() ~= "}" then
          break
        end
      end
    end

    return t
  end

  return parse_table()
end

local tutorial_sequence = parse_lvls([[{
  {
    id=1,
    goal={8,2},
    fire={6,7},
    pokes={{x=5,y=2,rot=2},{x=6, y=8, rot=1}},
    solution={},
    max=0,
    intro="night has fallen in the neighborhood.\n\nlet there be light.",
    osd="press z to start the turn."
  },
  {
    id=0,
    goal={8,8},
    fire={4,8},
    pokes={{x=3,y=4,rot=2},{x=4,y=9,rot=1},{x=8,y=3,rot=3}},
    max=0,
    solution={},
    intro="once the turn is started, you simply have to trust.",
    osd="press z to start the turn."
  },
  {
    id=2,
    goal={9,4},
    fire={4,6},
    pokes={{x=3,y=6,rot=2}},
    max=1,
    max_steps=15,
    solution={{x=9,y=7,rot=1}},
    intro="place a poke in the right spot to push the flame towards the lamp.",
    osd="navigate with arrow keys.\nx to place and rotate pokes.\nz to start the turn."
  },
  {
    id=3,
    goal={4,7},
    fire={8,5},
    pokes={{x=9,y=5,rot=4}},
    max=1,
    max_steps=15,
    solution={{x=4,y=4,rot=3}},
    intro="a poke next to the flame will give it a push.\n\nrotate it to change the direction of that push.",
    osd="x to place and rotate pokes."
  },
  {
    id=56,
    goal={6,8},
    fire={6,3},
    max=1,
    solution={{x=6,y=2,rot=3}},
    intro="the flame will not move unless it is poked.",
    osd="poke the flame\ntowards the lamp."
  },
  {
    id=27,
    goal={7,3},
    fire={6,3},
    pokes={{x=5,y=3,rot=4},{x=5,y=7,rot=2},{x=7,y=8,rot=1}},
    max=1,
    max_steps=15,
    solution={{x=6,y=2,rot=3}},
    intro="you can only rotate the\npokes you placed yourself.",
    osd="take the long way around."
  },
  {
    id=4,
    goal={3,2},
    fire={6,8},
    obs={{6,5}},
    max=2,
    max_steps=15,
    solution={{x=7,y=8,rot=4},{x=3,y=9,rot=1}},
    intro="boulders get in the way.",
    osd="get around the boulder."
  },
  {
    id=5,
    goal={11,6},
    fire={8,2},
    obs={{7,7},{8,7},{9,7},{10,7},{11,7}},
    pokes={{x=1,y=1,rot=2},{x=2,y=1,rot=3}},
    max=1,
    max_steps=15,
    solution={{x=7,y=6,rot=2}},
    intro="the flame and the pokes have a lot in common.",
    osd="complete the path."
  },
  {
    id=6,
    goal={9,3},
    fire={3,7},
    obs={{9,7}},
    pokes={{x=2,y=3,rot=2},{x=3,y=8,rot=1},{x=4,y=5,rot=4}},
    max=1,
    max_steps=15,
    solution={{x=4,y=6,rot=1}},
    intro="pokes can also be poked.",
    osd="push away one poke\nto clear a path."
  },
  {
    id=38,
    goal={9,8},
    fire={7,4},
    obs={{7,8},{10,4}},
    pokes={{x=1,y=3,rot=2},{x=2,y=3,rot=3}},
    max=1,
    max_steps=15,
    solution={{x=6,y=4,rot=2}},
    intro="the flame can stop moving and wait for the next poke.\n\nit will only die out if there is no more progress to be made.",
    osd="poke the flame towards the\nright so it can wait\nfor the next poke."
  },
  {
    id=7,
    goal={2,6},
    fire={10,6},
    pokes={{x=4,y=5,rot=1},{x=4,y=7,rot=2},{x=6,y=5,rot=1},{x=6,y=7,rot=1},{x=8,y=5,rot=4},{x=8,y=7,rot=3}},
    max=1,
    solution={{x=11,y=6,rot=4}},
    osd="the flame shimmies through."
  },
  {
    id=8,
    goal={6,2},
    fire={6,7},
    obs={{4,3},{5,2},{5,7},{7,7}},
    pokes={{x=5,y=3,rot=2}, {x=6,y=8,rot=1}},
    max=1,
    max_steps=20,
    solution={{x=7,y=3,rot=1}},
    intro="sometimes blocking the path is the only way.",
    osd="block its path so the flame\ndoes not go astray."
  },
  {
    id=9,
    goal={9,7},
    fire={3,5},
    obs={{10,4}},
    pokes={{x=2,y=5,rot=2},{x=6, y=6, rot=1},{x=7, y=4, rot=3}},
    max=1,
    solution={{x=6,y=4,rot=2}},
    intro="a poke can block regardless of its orientation.",
    osd="block and poke\nat the same time."
  },
  {
    id=52,
    goal={3,3},
    fire={6,7},
    obs={{6,2}},
    pokes={{x=5,y=7,rot=1},{x=5,y=3,rot=2},{x=7,y=3,rot=4},{x=10,y=8,rot=4}},
    max=1,
    solution={{x=9,y=8,rot=1}},
    intro="pokes can serve again and again.",
    osd="make your one poke count."
  },
  {
    id=10,
    goal={8,6},
    fire={5,6},
    pokes={{x=4,y=6,rot=2},{x=5,y=7,rot=1}},
    max=1,
    solution={{x=5,y=5,rot=3}},
    intro="pokes should not be ambiguous.",
    osd="a fickle flame\nneeds clear directions."
  },
  {
    id=11,
    goal={10,9},
    fire={3,5},
    obs={{10,6}},
    pokes={{x=1,y=6,rot=2},{x=3,y=1,rot=3},{x=2,y=9,rot=2},{x=3,y=6,rot=1}},
    max=1,
    max_steps=20,
    intro="you can start the turn as a way to explore.",
    solution={{x=2,y=6,rot=2}},
    osd="poke the poke\nthat pokes the poke."
  },
  {
    id=12,
    fire={2,6},
    goal={10,6},
    obs={{8,5}},
    pokes={{x=8,y=6,rot=2},{x=9,y=6,rot=1},{x=10,y=7,rot=4}},
    max=2,
    solution={{x=1,y=2,rot=2},{x=9,y=5,rot=3}},
    intro="you can always press d to reset the level.\n\n(and f to skip it.)",
    osd="try to poke from above."
  },
  {
    id=58,
    fire={6,3},
    goal={6,9},
    pokes={{x=6,y=2,rot=3},{x=6,y=6,rot=1},{x=6,y=8,rot=1}},
    max=2,
    solution={{x=7,y=5,rot=3},{x=7,y=6,rot=4}},
    intro="no hints this time."
  },
  {
    id=47,
    fire={10,10},
    goal={8,7},
    obs={{2,7},{6,8},{7,3},{8,5},{8,9},{9,7}},
    pokes={{x=2,y=10,rot=2},{x=3,y=3,rot=3},{x=6,y=5,rot=2},{x=7,y=5,rot=1},{x=10,y=11,rot=1},{x=11,y=4,rot=4}},
    max=1,
    solution={{x=10,y=4,rot=3}}
  },
  {
    id=13,
    goal={11,11},
    fire={2,2},
    obs={{1,8},{2,8},{10,7},{5,5},{11,7},{3,4},{4,4},{5,4}},
    pokes={{x=2,y=1,rot=3},{x=1,y=5,rot=2},{x=9,y=1,rot=3},{x=9,y=2,rot=3},{x=10,y=5,rot=4},{x=10,y=6,rot=4},{x=9,y=8,rot=1}},
    max=2,
    solution={{x=1,y=4,rot=3},{x=5,y=11,rot=2}},
    outro="the neighborhood is lit up.\n\nyou are ready to wander off and spread the light."
  }
}]])

local clearing_sequence = parse_lvls([[{
  {
    id=14,
    fire={2,6},
    goal={10,6},
    obs={{10,4},{10,8}},
    pokes={{x=6,y=6,rot=1},{x=7,y=6,rot=1},{x=8,y=6,rot=1},{x=9,y=6,rot=1}},
    max=3,
    solution={{x=1,y=6,rot=2},{x=4,y=7,rot=2},{x=5,y=7,rot=1}},
    intro="the park of a thousand benches.\n\nevery one of them\nin perfect shade."
  },
  {
    id=19,
    fire={2,6},
    goal={11,6},
    pokes={{x=1,y=6,rot=2},{x=3,y=7,rot=2},{x=5,y=6,rot=1},{x=6,y=6,rot=3},{x=7,y=6,rot=1},{x=8,y=6,rot=3}},
    max=2,
    solution={{x=4,y=7,rot=1},{x=6,y=7,rot=1}}
  },
  {
    id=17,
    fire={2,2},
    goal={10,8},
    obs={{3,2},{4,7},{10,6}},
    pokes={{x=2,y=1,rot=3},{x=2,y=7,rot=2}},
    max=2,
    solution={{x=1,y=7,rot=2},{x=1,y=8,rot=2}}
  },
  {
    id=18,
    fire={2,2},
    goal={11,1},
    obs={{3,1},{3,2},{10,3},{10,4}},
    pokes={{x=1,y=4,rot=3},{x=2,y=5,rot=1},{x=1,y=11,rot=2},{x=11,y=11,rot=1}},
    max=3,
    solution={{x=1,y=5,rot=2},{x=4,y=5,rot=1},{x=2,y=1,rot=3}}
  },
  {
    id=15,
    fire={4,7},
    goal={10,7},
    obs={{9,7}},
    pokes={{x=3,y=4,rot=2},{x=10,y=3,rot=3},{x=10,y=6,rot=3},{x=11,y=7,rot=4},{x=10,y=8,rot=1}},
    max=1,
    solution={{x=9,y=6,rot=2}},
    intro="as a meeting point, the park works not at all."
  },
  {
    id=16,
    fire={6,10},
    goal={6,6},
    obs={{6,4},{6,11}},
    pokes={{x=5,y=6,rot=3},{x=6,y=5,rot=2},{x=6,y=7,rot=1},{x=7,y=6,rot=4},{x=10,y=11,rot=1}},
    max=2,
    solution={{x=5,y=7,rot=2},{x=11,y=6,rot=4}}
  },
  {
    id=59,
    fire={2,9},
    goal={10,6},
    obs={{2,2},{5,7},{5,8},{5,9},{5,10},{6,2},{6,3},{6,4},{6,5}},
    pokes={{x=1,y=6,rot=2},{x=2,y=10,rot=1},{x=5,y=6,rot=2},{x=6,y=6,rot=4},{x=8,y=6,rot=4}},
    max=4,
    solution={{x=3,y=4,rot=1},{x=3,y=7,rot=1},{x=8,y=3,rot=1},{x=8,y=7,rot=1}},
    intro="as one sits and enjoys perfect shade waiting for a long-lost friend..."
  },
  {
    id=20,
    fire={9,8},
    goal={3,3},
    obs={{2,8},{6,7}},
    pokes={{x=3,y=4,rot=1},{x=6,y=9,rot=1},{x=7,y=7,rot=4},{x=9,y=6,rot=3},{x=11,y=4,rot=4}},
    max=2,
    solution={{x=10,y=8,rot=4},{x=10,y=9,rot=1}}
  },
  {
    id=21,
    fire={2,6},
    goal={10,6},
    obs={{2,5},{8,5},{10,3},{10,8}},
    pokes={{x=8,y=6,rot=2},{x=9,y=6,rot=1}},
    max=4,
    solution={{x=1,y=6,rot=2},{x=3,y=10,rot=2},{x=4,y=5,rot=3},{x=9,y=5,rot=3}}
  },
  {
    id=57,
    fire={10,10},
    goal={8,7},
    obs={{1,7},{3,4},{8,11},{11,7}},
    pokes={{x=2,y=11,rot=1},{x=3,y=2,rot=4},{x=5,y=9,rot=1},{x=6,y=4,rot=4},{x=7,y=6,rot=2},{x=8,y=3,rot=3},{x=9,y=8,rot=2},{x=10,y=1,rot=3},{x=9,y=9,rot=2}},
    max=2,
    max_steps=50,
    solution={{x=2,y=10,rot=2},{x=11,y=10,rot=4}},
    intro="they might be sitting on another bench,\nunder another tree,\nat another end of the park,\nenjoying perfect shade.",
    outro="the neighbors find comfort in this thought."
  }
}]])

local reuse_sequence = parse_lvls([[{
  {
    id=53,
    fire={3,5},
    goal={1,5},
    obs={{6,6}},
    pokes={{x=2,y=5,rot=2},{x=2,y=7,rot=1},{x=4,y=5,rot=2},{x=4,y=7,rot=1},{x=6,y=3,rot=3},{x=9,y=8,rot=1},{x=10,y=9,rot=1},{x=11,y=4,rot=4}},
    max=1,
    solution={{x=10,y=8,rot=4}},
    intro="there is no river or stream in this hollow. just mud here and mud there."
  },
  {
    id=22,
    fire={5,2},
    goal={1,6},
    obs={{5,7},{10,7}},
    pokes={{x=3,y=1,rot=3},{x=4,y=3,rot=3},{x=10,y=2,rot=4},{x=4,y=4,rot=2},{x=4,y=11,rot=1}},
    max=1,
    solution={{x=2,y=1,rot=2}}
  },
  {
    id=55,
    fire={10,3},
    goal={1,2},
    obs={{10,2}},
    pokes={{x=2,y=6,rot=1},{x=3,y=2,rot=4},{x=7,y=3,rot=1},{x=10,y=4,rot=1}},
    max=2,
    solution={{x=11,y=4,rot=4},{x=11,y=5,rot=1}}
  },
  {
    id=26,
    fire={2,2},
    goal={11,8},
    obs={{10,5},{5,8},{6,7},{7,4},{11,5},{11,11}},
    pokes={{x=1,y=2,rot=2},{x=2,y=4,rot=2},{x=3,y=1,rot=3},{x=3,y=11,rot=1},{x=4,y=6,rot=2},{x=6,y=10,rot=2},{x=7,y=5,rot=3},{x=10,y=8,rot=4},{x=10,y=10,rot=1}},
    max=2,
    solution={{x=10,y=3,rot=3},{x=11,y=3,rot=4}},
    intro="a kid comes to fill up his bucket before a mud fight."
  },
  {
    id=23,
    fire={7,8},
    goal={9,6},
    obs={{1,7},{8,6},{10,10},{11,9}},
    pokes={{x=2,y=1,rot=3},{x=2,y=9,rot=1},{x=8,y=2,rot=4},{x=8,y=8,rot=1},{x=11,y=6,rot=4}},
    max=2,
    max_steps=40,
    solution={{x=1,y=10,rot=1},{x=1,y=9,rot=2}}
  },
  {
    id=54,
    fire={2,6},
    goal={5,9},
    obs={{3,6},{4,5},{5,4},{7,3},{7,7}},
    pokes={{x=1,y=3,rot=2},{x=2,y=7,rot=1},{x=3,y=2,rot=3},{x=6,y=3,rot=3},{x=6,y=5,rot=1},{x=7,y=6,rot=4},{x=10,y=5,rot=3},{x=11,y=9,rot=4}},
    max=2,
    solution={{x=2,y=2,rot=2},{x=11,y=10,rot=1}},
    intro="two lovers find their way here to this hollow on the first snow of the year."
  },
  {
    id=28,
    fire={2,9},
    goal={4,6},
    obs={{2,1},{3,6},{4,5},{4,8},{4,9},{6,9},{8,5},{7,11}},
    pokes={{x=7,y=9,rot=3},{x=8,y=9,rot=4}},
    max=3,
    solution={{x=1,y=10,rot=2},{x=1,y=11,rot=1},{x=2,y=10,rot=1}}
  },
  {
    id=24,
    fire={4,3},
    goal={7,9},
    obs={{9,8}},
    pokes={{x=3,y=6,rot=2},{x=6,y=8,rot=2},{x=7,y=7,rot=1},{x=9,y=6,rot=3}},
    max=2,
    solution={{x=3,y=7,rot=1},{x=10,y=6,rot=4}},
    intro="a colorful viper plays strike-and-release with anything smaller than a mouse."
  },
  {
    id=25,
    goal={11,11},
    fire={3,2},
    obs={{2,6},{1,6},{3,3},{4,3},{5,3},{8,1},{9,1},{10,1},{11,1},{9,5}},
    pokes={{x=6,y=1,rot=2},{x=7,y=5,rot=3},{x=3,y=9,rot=2},{x=3,y=10,rot=1},{x=8,y=4,rot=3},{x=7,y=11,rot=2}},
    max=3,
    solution={{x=2,y=1,rot=3},{x=2,y=2,rot=2},{x=7,y=6,rot=1}}
  },
  {
    id=29,
    fire={2,3},
    goal={11,6},
    obs={{2,9},{4,2},{3,6},{4,5},{11,4},{11,8},{9,5},{9,10}},
    pokes={{x=1,y=10,rot=2},{x=2,y=4,rot=2},{x=4,y=8,rot=2},{x=5,y=4,rot=1},{x=7,y=6,rot=4},{x=9,y=2,rot=3},{x=9,y=7,rot=1},{x=9,y=9,rot=1}},
    max=3,
    solution={{x=10,y=10,rot=4},{x=10,y=11,rot=1},{x=11,y=11,rot=4}},
    outro="the coldest place in town.\n\nwhere the mud takes over and lets go like a breath."
  }
}]])

local breakout_sequence = parse_lvls([[{
  {
    id=30,
    fire={6,7},
    goal={6,8},
    obs={{5,7},{5,8},{6,4},{6,9},{7,7},{7,8}},
    pokes={{x=4,y=3,rot=3},{x=6,y=6,rot=1},{x=8,y=3,rot=3}},
    max=3,
    solution={{x=3,y=6,rot=2},{x=4,y=4,rot=3},{x=4,y=6,rot=2}},
    intro="the dry goods store opened back when it was just called \"the road\"."
  },
  {
    id=35,
    fire={6,6},
    goal={8,1},
    obs={{5,2},{6,1},{9,4},{9,2},{9,3},{9,5}},
    pokes={{x=4,y=6,rot=4},{x=6,y=4,rot=1},{x=6,y=8,rot=3},{x=8,y=6,rot=2}},
    max=3,
    solution={{x=5,y=5,rot=2},{x=5,y=6,rot=1},{x=6,y=7,rot=1}}
  },
  {
    id=36,
    fire={6,6},
    goal={11,4},
    pokes={{x=5,y=6,rot=1},{x=6,y=5,rot=1},{x=7,y=6,rot=1},{x=6,y=7,rot=1}},
    max=2,
    solution={{x=5,y=5,rot=2},{x=5,y=3,rot=1}},
    intro="their door remains open to everybody even if they have no intention of buying anything."
  },
  {
    id=39,
    fire={6,6},
    goal={11,2},
    obs={{6,3}},
    pokes={{x=5,y=6,rot=2},{x=6,y=4,rot=2},{x=6,y=5,rot=4},{x=6,y=7,rot=1},{x=7,y=6,rot=4},{x=8,y=8,rot=4}},
    max=2,
    solution={{x=5,y=7,rot=2},{x=8,y=3,rot=3}}
  },
  {
    id=37,
    fire={6,6},
    goal={6,1},
    obs={{6,3},{6,9}},
    pokes={{x=4,y=7,rot=2},{x=5,y=6,rot=4},{x=6,y=5,rot=3},{x=6,y=7,rot=3},{x=7,y=6,rot=4},{x=10,y=5,rot=4}},
    max=3,
    solution={{x=1, y=1, rot=2},{x=2, y=7, rot=1},{x=7, y=5, rot=4}},
    intro="the ice cream cart gets off the pavement and gets a storefront."
  },
  {
    id=31,
    fire={6,4},
    goal={6,9},
    obs={{4,8},{5,4},{7,4},{8,8}},
    pokes={{x=2,y=3,rot=2},{x=3,y=6,rot=1},{x=4,y=6,rot=2},{x=4,y=7,rot=2},{x=6,y=6,rot=1},{x=8,y=6,rot=4},{x=8,y=7,rot=4},{x=9,y=6,rot=1},{x=10,y=3,rot=4}},
    max=3,
    solution={{x=4,y=5,rot=2},{x=5,y=5,rot=3},{x=5,y=8,rot=2}}
  },
  {
    id=40,
    fire={6,6},
    goal={9,1},
    obs={{8,1},{10,1},{5,5},{7,5},{5,7},{7,7}},
    pokes={{x=1,y=6,rot=2},{x=2,y=3,rot=3},{x=6,y=3,rot=2},{x=6,y=11,rot=1},{x=7,y=4,rot=4},{x=9,y=2,rot=1},{x=9,y=7,rot=1}},
    max=2,
    solution={{x=6,y=10,rot=1},{x=7,y=2,rot=2}},
    intro="someone pins the schedule of the sewing circle on the postmaster's notice board."
  },
  {
    id=32,
    fire={6,6},
    goal={3,10},
    obs={{2,5},{5,10}},
    pokes={{x=3,y=9,rot=1},{x=4,y=5,rot=3},{x=5,y=7,rot=2},{x=6,y=3,rot=2},{x=6,y=9,rot=4},{x=7,y=5,rot=4},{x=8,y=7,rot=1}},
    max=2,
    solution={{x=5,y=5,rot=4},{x=7,y=4,rot=3}}
  },
  {
    id=33,
    fire={6,6},
    goal={6,11},
    obs={{2,9},{5,2},{5,8},{8,7}},
    pokes={{x=2,y=4,rot=2},{x=3,y=1,rot=3},{x=5,y=6,rot=2},{x=6,y=2,rot=3},{x=6,y=5,rot=1},{x=6,y=7,rot=1},{x=7,y=6,rot=4}},
    max=2,
    solution={{x=5,y=3,rot=3},{x=5,y=4,rot=3}}
  },
  {
    id=34,
    fire={6,6},
    goal={9,10},
    obs={{4,5},{5,4},{9,1},{10,6}},
    pokes={{x=5,y=8,rot=2},{x=6,y=7,rot=3},{x=7,y=6,rot=2},{x=7,y=8,rot=2},{x=8,y=5,rot=2},{x=10,y=4,rot=3},{x=11,y=10,rot=1}},
    max=4,
    solution={{x=6,y=10,rot=1},{x=6,y=11,rot=1},{x=7,y=7,rot=4},{x=9,y=5,rot=4}},
    outro="the campfire.\nthe crossroads.\nthe main street.\n\nwhere neighbors go to catch the light."
  }
}]])

local cannon_sequence = parse_lvls([[{
  {
    id=43,
    fire={3,3},
    goal={8,3},
    obs={{1,8},{1,9},{5,7},{7,7},{11,8},{11,9}},
    pokes={{x=5,y=8,rot=2},{x=5,y=9,rot=1},{x=6,y=11,rot=1},{x=7,y=3,rot=3},{x=9,y=4,rot=1},{x=10,y=9,rot=1}},
    max=1,
    solution={{x=6,y=10,rot=4}},
    intro="the oldest court in town.\n\nnot a dead end but a cul-de-sac with a bulb."
  },
  {
    id=41,
    fire={4,4},
    goal={1,8},
    obs={{6,9}},
    pokes={{x=3,y=4,rot=2},{x=3,y=5,rot=3},{x=4,y=1,rot=3},{x=4,y=6,rot=2},{x=4,y=7,rot=2},{x=4,y=11,rot=1},{x=5,y=3,rot=3},{x=5,y=8,rot=4},{x=5,y=10,rot=1},{x=6,y=5,rot=3},{x=10,y=6,rot=3},{x=11,y=8,rot=4}},
    max=1,
    solution={{x=4,y=2,rot=4}}
  },
  {
    id=48,
    fire={4,3},
    goal={11,1},
    pokes={{x=1,y=8,rot=2},{x=2,y=4,rot=3},{x=5,y=5,rot=4},{x=6,y=1,rot=2},{x=6,y=3,rot=3},{x=7,y=3,rot=3},{x=9,y=3,rot=4},{x=8,y=9,rot=1},{x=11,y=9,rot=3}},
    max=2,
    solution={{x=1,y=2,rot=2},{x=2,y=2,rot=3}}
  },
  {
    id=42,
    fire={2,10},
    goal={11,5},
    obs={{3,7},{4,6},{5,4},{6,8},{9,7},{10,8}},
    pokes={{x=1,y=10,rot=2},{x=4,y=1,rot=3},{x=5,y=3,rot=3},{x=5,y=6,rot=1},{x=6,y=6,rot=2},{x=7,y=2,rot=2},{x=7,y=7,rot=1},{x=8,y=6,rot=4},{x=10,y=2,rot=3},{x=11,y=10,rot=4}},
    max=2,
    solution={{x=2,y=5,rot=2},{x=3,y=5,rot=3}}
  },
  {
    id=44,
    fire={2,2},
    goal={3,10},
    obs={{4,3},{8,7},{8,9}},
    pokes={{x=1,y=2,rot=2},{x=3,y=8,rot=3},{x=5,y=7,rot=2},{x=5,y=9,rot=2},{x=6,y=2,rot=3},{x=7,y=10,rot=1},{x=9,y=2,rot=4}},
    max=2,
    solution={{x=6,y=3,rot=1},{x=8,y=2,rot=4}},
    intro="as he bags groceries, the boy daydreams..."
  },
  {
    id=49,
    fire={7,9},
    goal={1,8},
    obs={{1,6},{2,6},{3,6},{4,6},{1,10},{2,10},{3,10},{4,10},{7,10}},
    pokes={{x=2,y=7,rot=3},{x=5,y=8,rot=2},{x=10,y=10,rot=1},{x=6,y=1,rot=3}},
    max=2,
    solution={{x=6,y=2,rot=2},{x=6,y=8,rot=4}}
  },
  {
    id=45,
    fire={8,4},
    goal={4,11},
    obs={{1,10},{2,4},{4,1},{6,7},{6,9},{7,4},{8,2},{9,10},{9,11}},
    pokes={{x=1,y=5,rot=2},{x=2,y=10,rot=1},{x=3,y=9,rot=2},{x=4,y=4,rot=3},{x=6,y=4,rot=3},{x=9,y=4,rot=4}},
    max=3,
    solution={{x=2,y=5,rot=1},{x=2,y=8,rot=2},{x=2,y=9,rot=1}},
    intro="he imagines crouching in the middle of the road and then jumping up.\n\nhe takes flight."
  },
  {
    id=46,
    fire={2,5},
    goal={9,11},
    obs={{1,4},{1,5},{4,8},{4,7},{4,9},{5,2},{7,6},{7,11},{8,11},{10,2},{10,3},{10,10},{11,3}},
    pokes={{x=2,y=10,rot=2},{x=3,y=5,rot=4},{x=4,y=11,rot=2},{x=5,y=3,rot=2},{x=5,y=5,rot=1},{x=7,y=3,rot=2},{x=7,y=8,rot=4},{x=8,y=2,rot=3},{x=11,y=4,rot=4}},
    max=3,
    max_steps=40,
    solution={{x=10,y=4,rot=3},{x=10,y=5,rot=1},{x=10,y=6,rot=1}}
  },
  {
    id=50,
    fire={4,10},
    goal={11,1},
    obs={{4,4},{4,8},{6,1},{6,9},{8,4},{8,7},{11,3}},
    pokes={{x=1,y=6,rot=2},{x=2,y=3,rot=3},{x=2,y=11,rot=1},{x=4,y=5,rot=3},{x=5,y=10,rot=4},{x=6,y=7,rot=2},{x=7,y=7,rot=1},{x=9,y=9,rot=1},{x=10,y=7,rot=1},{x=10,y=4,rot=3}},
    max=3,
    solution={{x=2,y=4,rot=3},{x=2,y=6,rot=3},{x=2,y=10,rot=2}},
    intro="he flies up until the neighborhood becomes a daisy.\n\neach house a petal for him to pick."
  },
  {
    id=51,
    fire={9,6},
    goal={6,4},
    obs={{4,3},{4,10},{6,7},{8,3},{8,4},{9,1},{10,6},{10,1},{10,11}},
    pokes={{x=2,y=9,rot=3},{x=2,y=11,rot=1},{x=4,y=4,rot=2},{x=4,y=11,rot=2},{x=5,y=6,rot=1},{x=8,y=6,rot=2},{x=9,y=7,rot=2},{x=10,y=4,rot=4}},
    max_steps=40,
    max=3,
    solution={{x=1,y=5,rot=2},{x=2,y=5,rot=3},{x=2,y=10,rot=1}},
    outro="the last petal will decide whether he comes back down or not."
  }
}]])

local worlds = {
  {
    name = "tutorial town",
    lvls = tutorial_sequence,
    rain_density = 0.04,
    rain_dir = "right",
    rain_color = 13,
    obs_sprite = 7,
    bg_color = 129,
    txt_color = 5
  },
  {
    name = "winnow park",
    lvls = clearing_sequence,
    rain_density = 0.08,
    rain_dir = "left",
    rain_color = 4,
    obs_sprite = 25,
    bg_color = 131,
    txt_color = 6
  },
  {
    name = "silver hollow",
    lvls = reuse_sequence,
    rain_density = 0.04,
    rain_dir = "right",
    rain_color = 6,
    obs_sprite = 7,
    bg_color = 0,
    txt_color = 5
  },
  {
    name = "main street",
    lvls = breakout_sequence,
    rain_density = 0.04,
    rain_dir = "left",
    rain_color = 0,
    obs_sprite = 7,
    bg_color = 130,
    txt_color = 5
  },
  {
    name = "cannonball court",
    lvls = cannon_sequence,
    rain_density = 0.03,
    rain_dir = "right",
    rain_color = 15,
    obs_sprite = 7,
    bg_color = 1,
    txt_color = 5
  }
}

local function is_world_completed(world)
  local completed = true
  for _, lvl in ipairs(world.lvls) do
    if not lvl.completed then
      completed = false
      break
    end
  end

  return completed
end

local function set_completed_from_lvl_data()
  local completed = true

  for _, world in pairs(worlds) do
    for _, lvl in pairs(world.lvls) do
      if dget(lvl.id) == 1 then
        lvl.completed = true
      else
        lvl.completed = false
        completed = false
      end
    end
  end


  all_worlds_completed = completed
end

local function contains(tab, val)
  for v in all(tab) do
    if v == val then return true end
  end
  return false
end

local function draw_big(char, x, y, col)
  local glyph = large_alphabet[char]
  if not glyph then return end

  for row=1,16 do
    local line_data = glyph[row]
    for col_idx=0,7 do
      if (line_data & (0x80 >>> col_idx)) ~= 0 then
        pset(x + col_idx, y + (row - 1), col)
      end
    end
  end
end

local function print_big(str, x, y, color)
  local start_x = x

  for i=1, #str do
    local char = sub(str, i, i)

    if char == " " then
      x = x + 8
    else
      draw_big(char, x, y, color)
      x = x + 9
    end
  end
end

local function is_valid_move(lvl, pokes, fire, entity_type, x, y)
  local grid_size = 11
  if x < 1 or x > grid_size or y < 1 or y > grid_size then
    return false
  end

  if lvl.obs then
    for _, obs in pairs(lvl.obs) do
      if obs[1] == x and obs[2] == y then
        return false
      end
    end
  end

  for _, other in pairs(pokes) do
    if other.x == x and other.y == y then
      return false
    end
  end

  if entity_type == "poke" then
    if lvl.goal and x == lvl.goal[1] and y == lvl.goal[2] then
      return false
    end

    if x == fire.x and y == fire.y then
      return false
    end
  end

  return true
end

local function get_next_position(x, y, dir)
  if dir == 2 then return x + 1, y
  elseif dir == 4 then return x - 1, y
  elseif dir == 3 then return x, y + 1
  elseif dir == 1 then return x, y - 1
  end
  return x, y
end

local function collect_poke_redirections(pokes, entity_x, entity_y, skip_idx)
  local intents = {}
  for i, poke in pairs(pokes) do
    if i ~= skip_idx then
      if poke.x == entity_x - 1 and poke.y == entity_y and poke.rot == 2 then
        local tx, ty = get_next_position(entity_x, entity_y, 2)
        add(intents, {dir = 2, x = tx, y = ty, redirected = true, poke = poke})
      elseif poke.x == entity_x + 1 and poke.y == entity_y and poke.rot == 4 then
        local tx, ty = get_next_position(entity_x, entity_y, 4)
        add(intents, {dir = 4, x = tx, y = ty, redirected = true, poke = poke})
      elseif poke.x == entity_x and poke.y == entity_y - 1 and poke.rot == 3 then
        local tx, ty = get_next_position(entity_x, entity_y, 3)
        add(intents, {dir = 3, x = tx, y = ty, redirected = true, poke = poke})
      elseif poke.x == entity_x and poke.y == entity_y + 1 and poke.rot == 1 then
        local tx, ty = get_next_position(entity_x, entity_y, 1)
        add(intents, {dir = 1, x = tx, y = ty, redirected = true, poke = poke})
      end
    end
  end
  return intents
end

local function calc_poke_intents(pokes, poke_idx, nudges)
  local poke = pokes[poke_idx]
  local intents = {}

  -- check if this poke has a crossing nudge from previous turn
  if nudges[poke_idx] then
    local nudge_dir = nudges[poke_idx]
    local tx, ty = get_next_position(poke.x, poke.y, nudge_dir)
    add(intents, {dir = nudge_dir, x = tx, y = ty, redirected = true, is_nudge = true})
  end

  local redirections = collect_poke_redirections(pokes, poke.x, poke.y, poke_idx)
  for _, redir in ipairs(redirections) do
    add(intents, redir)
  end

  if poke.dir then
    local tx, ty = get_next_position(poke.x, poke.y, poke.dir)
    add(intents, {dir = poke.dir, x = tx, y = ty, redirected = false})
  end

  return intents
end

local function calc_fire_intents(lvl, pokes, fire, fire_dir, nudges)
  local goal_reached = (fire.x == lvl.goal[1] and fire.y == lvl.goal[2])
  if goal_reached then return {{x = fire.x, y = fire.y, dir = nil, redirected = false}} end

  local intents = {}

  -- check if fire has a crossing nudge from previous turn
  if nudges.fire then
    local nudge_dir = nudges.fire
    local tx, ty = get_next_position(fire.x, fire.y, nudge_dir)
    add(intents, {x = tx, y = ty, dir = nudge_dir, redirected = true, is_nudge = true})
  end

  local redirections = collect_poke_redirections(pokes, fire.x, fire.y, nil)
  for _, redir in ipairs(redirections) do
    add(intents, redir)
  end

  if fire_dir then
    local tx, ty = get_next_position(fire.x, fire.y, fire_dir)
    add(intents, {x = tx, y = ty, dir = fire_dir, redirected = false})
  end

  return intents
end

local function calc_valid_intents(lvl, pokes, fire, entity, entity_type, intents)
  local valid_intents = {}
  for _, intent in ipairs(intents) do
    if (intent.x ~= entity.x or intent.y ~= entity.y)
      and is_valid_move(lvl, pokes, fire, entity_type, intent.x, intent.y) then
      add(valid_intents, intent)
    end
  end
  return valid_intents
end

local function should_move(valid_intents)
  -- if there's a nudge from a crossing, it takes priority
  for _, intent in ipairs(valid_intents) do
    if intent.is_nudge then
      return true, intent
    end
  end

  if #valid_intents == 1 then
    return true, valid_intents[1]
  elseif #valid_intents == 2 and valid_intents[1].redirected == true and valid_intents[2].redirected == false then
    return true, valid_intents[1]
  end

  return false, nil
end

local function date_entity_animation(e)
  if e.frames > 0 then
    e.draw_x = e.draw_x + e.move_dx
    e.draw_y = e.draw_y + e.move_dy
    e.frames = e.frames - 1
    if e.frames <= 0 then
      e.draw_x = e.x
      e.draw_y = e.y
    end
  end
end

local function execute_move(e, intent)
  e.move_dx = (intent.x - e.x) / frames_in_step
  e.move_dy = (intent.y - e.y) / frames_in_step
  e.frames = frames_in_step
  e.draw_x = e.x
  e.draw_y = e.y
  e.x = intent.x
  e.y = intent.y
end

local function set_flash(message)
  if flash then return end
  if message == lvl.osd then return end

  flash = message
  flash_frames = frames_in_step * 11
  help_text_color_step = 1
end

local function detect_crossings(pokes, fire, original_positions, moved_entities)
  local next_nudges = {}
  local entities = {}

  if moved_entities.fire then
    add(entities, {id = "fire", old_x = original_positions.fire.x, old_y = original_positions.fire.y,
                   new_x = fire.x, new_y = fire.y})
  end
  for i, poke in pairs(pokes) do
    if moved_entities[i] then
      add(entities, {id = i, old_x = original_positions[i].x, old_y = original_positions[i].y,
                     new_x = poke.x, new_y = poke.y, rot = poke.rot})
    end
  end

  for i = 1, #entities do
    for j = i + 1, #entities do
      local e1, e2 = entities[i], entities[j]

      local dx1, dy1 = e1.new_x - e1.old_x, e1.new_y - e1.old_y
      local dx2, dy2 = e2.new_x - e2.old_x, e2.new_y - e2.old_y

      -- horizontal crossing: both moving horizontally on adjacent rows
      if dy1 == 0 and dy2 == 0 and (e1.old_y == e2.old_y - 1 or e1.old_y == e2.old_y + 1) then
        if e1.new_x == e2.old_x and e2.new_x == e1.old_x then
          local e1_points_toward_e2 = e1.rot and ((e2.new_y > e1.new_y and e1.rot == 3) or (e2.new_y < e1.new_y and e1.rot == 1))
          local e2_points_toward_e1 = e2.rot and ((e1.new_y > e2.new_y and e2.rot == 3) or (e1.new_y < e2.new_y and e2.rot == 1))
          if e1_points_toward_e2 then next_nudges[e2.id] = e1.rot end
          if e2_points_toward_e1 then next_nudges[e1.id] = e2.rot end
        end
      end

      -- vertical crossing: both moving vertically on adjacent columns
      if dx1 == 0 and dx2 == 0 and (e1.old_x == e2.old_x - 1 or e1.old_x == e2.old_x + 1) then
        if e1.new_y == e2.old_y and e2.new_y == e1.old_y then
          local e1_points_toward_e2 = e1.rot and ((e2.new_x > e1.new_x and e1.rot == 2) or (e2.new_x < e1.new_x and e1.rot == 4))
          local e2_points_toward_e1 = e2.rot and ((e1.new_x > e2.new_x and e2.rot == 2) or (e1.new_x < e2.new_x and e2.rot == 4))
          if e1_points_toward_e2 then next_nudges[e2.id] = e1.rot end
          if e2_points_toward_e1 then next_nudges[e1.id] = e2.rot end
        end
      end
    end
  end

  return next_nudges
end

local function blink(intents)
  for _, intent in ipairs(intents) do
    if intent.poke then
      add(blinking_pokes, intent.poke)
    end
  end
end

local function handle_turn()
  local snapshot_pokes = {}
  for i, poke in pairs(pokes) do
    snapshot_pokes[i] = {
      x = poke.x,
      y = poke.y,
      dir = poke.dir,
      moving = poke.moving,
      draw_x = poke.draw_x,
      draw_y = poke.draw_y,
      move_dx = poke.move_dx,
      move_dy = poke.move_dy,
      frames = poke.frames
    }
  end
  local snapshot_fire = {
    x = fire.x,
    y = fire.y,
    draw_x = fire.draw_x,
    draw_y = fire.draw_y,
    move_dx = fire.move_dx,
    move_dy = fire.move_dy,
    frames = fire.frames
  }
  local snapshot_fire_dir = fire_dir

  local function rollback()
    for j, snap in pairs(snapshot_pokes) do
      pokes[j].x = snap.x
      pokes[j].y = snap.y
      pokes[j].dir = snap.dir
      pokes[j].moving = snap.moving
      pokes[j].draw_x = snap.draw_x
      pokes[j].draw_y = snap.draw_y
      pokes[j].move_dx = snap.move_dx
      pokes[j].move_dy = snap.move_dy
      pokes[j].frames = snap.frames
    end
    fire.x = snapshot_fire.x
    fire.y = snapshot_fire.y
    fire.draw_x = snapshot_fire.draw_x
    fire.draw_y = snapshot_fire.draw_y
    fire.move_dx = snapshot_fire.move_dx
    fire.move_dy = snapshot_fire.move_dy
    fire.frames = snapshot_fire.frames
    fire_dir = snapshot_fire_dir
  end

  -- phase 1: calculate intents based on original state
  local intents_per_poke = {}
  local original_positions = {fire = {x = fire.x, y = fire.y}}

  for i, poke in pairs(pokes) do
    intents_per_poke[i] = calc_poke_intents(pokes, i, nudges)
    original_positions[i] = {x = poke.x, y = poke.y}
  end

  -- prevent two pokes from moving onto the same cell.
  local destinations_per_poke = {}

  for i, poke in pairs(pokes) do
    local valid_intents = calc_valid_intents(lvl, pokes, fire, poke, "poke", intents_per_poke[i])
    local can_move, intent = should_move(valid_intents)

    if can_move and intent then
      destinations_per_poke[i] = {x = intent.x, y = intent.y}
    end
  end

  for i, a in pairs(destinations_per_poke) do
    for j, b in pairs(destinations_per_poke) do
      if i ~= j and a.x == b.x and a.y == b.y then
        set_flash("a prickly poke\nneeds clear directions.")
        blink({{poke = pokes[i]}, {poke = pokes[j]}})
        return false, false
      end
    end
  end

  local fire_intents = calc_fire_intents(lvl, pokes, fire, fire_dir, nudges)

  -- phase 2: sequential processing with retries
  local already_moved = {fire = false}
  for i in pairs(pokes) do already_moved[i] = false end

  local moved = true
  while moved do
    moved = false

    for i, poke in pairs(pokes) do
      if not already_moved[i] then
        local valid_intents = calc_valid_intents(lvl, pokes, fire, poke, "poke", intents_per_poke[i])

        local can_move, intent = should_move(valid_intents)
        if can_move and intent then
          execute_move(poke, intent)
          poke.dir = intent.dir
          poke.moving = not not intent.dir
          already_moved[i] = true
          moved = true
          break
        else
          if #valid_intents > 1 then
            rollback()
            set_flash("a prickly poke\nneeds clear directions.")
            blink(valid_intents)
            return false, false
          end
        end
      end
    end

    if not moved and not already_moved.fire then
      local valid_intents = calc_valid_intents(lvl, pokes, fire, fire, "fire", fire_intents)

      local can_move, intent = should_move(valid_intents)
      if can_move and intent then
        execute_move(fire, intent)

        if intent.dir then
          fire_dir = intent.dir
        end
        already_moved.fire = true
        moved = true
      else
        if #valid_intents > 1 then
          rollback()
          set_flash("a fickle flame\nneeds clear directions.")
          blink(valid_intents)
          return false, false
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

  nudges = detect_crossings(pokes, fire, original_positions, already_moved)

  local any_poke_moved = false
  for i, _ in pairs(pokes) do
    if already_moved[i] then any_poke_moved = true break end
  end

  return already_moved.fire, any_poke_moved
end

local function make_poke(a, read_only)
  return {
    x = a.x, y = a.y,
    draw_x = a.x, draw_y = a.y,
    move_dx = 0, move_dy = 0, frames = 0,
    rot = a.rot, read_only = read_only
  }
end

local function reset_lvl(next_lvl)
  lvl_timer = 0
  step_counter = 0
  turn_time = false
  fire_dir = nil
  success_sound_played = false
  failure_sound_played = false
  goal_lit = false
  burst_active = false
  burst_radius = 0
  fire_fail_animation_frame = 0
  fire_visible = true
  cursor_step = 1
  nudges = {}
  if not flash then help_text_color_step = 1 end

  if next_lvl then
    pre_turn_pokes = nil
    lvl_index = lvl_index + 1
    if lvl_index > #lvls then
      set_completed_from_lvl_data()

      if all_worlds_completed then
        game_state = "title"
      else
        game_state = "world_picker"
      end

      return
    end

    -- check if next lvl has intro text
    if lvls[lvl_index].intro then
      current_text = lvls[lvl_index].intro
      game_state = "lvl_intro"
      return
    end
  end

  lvl = lvls[lvl_index] or lvls[1]
  fire = {
    x = lvl.fire[1],
    y = lvl.fire[2],
    draw_x = lvl.fire[1],
    draw_y = lvl.fire[2],
    move_dx = 0,
    move_dy = 0,
    frames = 0
  }
  pokes = {}
  cursor_x = flr((grid_size + 1) / 2)
  cursor_y = flr((grid_size + 1) / 2)

  if pre_turn_pokes then
    if lvl.pokes then
      for _, a in pairs(lvl.pokes) do
        pokes[#pokes+1] = make_poke(a, true)
      end
    end

    for _, a in pairs(pre_turn_pokes) do
      pokes[#pokes+1] = make_poke(a, false)
    end

    remaining_pokes = (lvl.max or 9) - #pre_turn_pokes
    pre_turn_pokes = nil
  else
    for i,a in pairs(lvl.pokes) do
      pokes[i] = make_poke(a, true)
    end
    remaining_pokes = lvl.max or 9
  end
end

local function check_cheat_codes()
  if btnp(3, 1) then
    sfx(menu_action_sfx)
    reset_lvl(false)
    return true
  end

  if btnp(2, 1) then
    sfx(menu_action_sfx)
    if lvl_index > 1 then
      lvl_index = lvl_index - 1
      reset_lvl(false)
    else
      game_state = "world_picker"
    end
  end

  if btnp(4, 0) then
    z_press_count = z_press_count + 1
  end

  if btnp(1, 1) or z_press_count >= 5 then
    z_press_count = 0
    sfx(menu_action_sfx)
    if lvl.outro then
      current_text = lvl.outro
      game_state = "lvl_outro"
    else
      reset_lvl(true)
    end

    return true
  end


  return false
end

local function handle_inputs()
  if (btnp(0)) then cursor_x = cursor_x - 1; sfx(nav_sfx) end
  if (btnp(1)) then cursor_x = cursor_x + 1; sfx(nav_sfx) end
  if (btnp(2)) then cursor_y = cursor_y - 1; sfx(nav_sfx) end
  if (btnp(3)) then cursor_y = cursor_y + 1; sfx(nav_sfx) end
  if (btnp(5)) then
    local exists = false
    for poke in all(pokes) do
      if poke.x == cursor_x and poke.y == cursor_y then
        exists = true
        if poke.read_only then
          sfx(failure_sfx)
          break
        end
        poke.rot = poke.rot + 1
        sfx(58)
        if poke.rot > 4 then
          del(pokes, poke)
          remaining_pokes = remaining_pokes + 1
        end
        break
      end
    end

    local is_obstacle = false
    if lvl and lvl.obs then
      for obstacle in all(lvl.obs) do
        if obstacle[1] == cursor_x and obstacle[2] == cursor_y then
          is_obstacle = true
          break
        end
      end
    end

    if not exists and not is_obstacle and not (cursor_x == fire.x and cursor_y == fire.y) and not (cursor_x == lvl.goal[1] and cursor_y == lvl.goal[2]) and remaining_pokes > 0 then
      add(pokes, make_poke({x=cursor_x, y=cursor_y, rot=1}, false))
      remaining_pokes = remaining_pokes - 1
      sfx(58)
    elseif not exists then
      sfx(failure_sfx)
    end
  end

  if (btnp(4)) then
    pre_turn_pokes = {}

    for i,a in pairs(pokes) do
      if not a.read_only then
        pre_turn_pokes[#pre_turn_pokes+1] = {x=a.x, y=a.y, rot=a.rot}
      end
    end

    turn_time = true
    turn_timer = 0
  end
end

local function draw_obs()
  local obs_sprite = worlds[world_index].obs_sprite
  if lvl and lvl.obs then
    for _, obs in pairs(lvl.obs) do
      spr(obs_sprite, grid_start_x + grid_x*(obs[1]-1), grid_start_y + grid_y*(obs[2]-1))
    end
  end
end

local function draw_fire()
  if fire_visible then
    local sprite

    if fire_fail_animation_frame > 0 and fire_fail_animation_frame <= #fire_fail_animation_sprites then
      sprite = fire_fail_animation_sprites[fire_fail_animation_frame]
    else
      fire_animation_timer = fire_animation_timer + 1
      if fire_animation_timer >= frames_in_step * #fire_animation_sprites then
        fire_animation_timer = 0
      end
      local fire_sprite_index = flr((fire_animation_timer / frames_in_step) % #fire_animation_sprites) + 1
      sprite = fire_animation_sprites[fire_sprite_index]
    end

    spr(sprite, grid_start_x + (fire.draw_x-1) * grid_x, grid_start_y + (fire.draw_y-1) * grid_y)
  end
end

local function draw_pokes()
  if #blinking_pokes > 0 then
    blinking_step = blinking_step + 1
    if blinking_step > (blinking_steps * 12) then
      blinking_step = 1
      blinking_pokes = {}
    end
  end

  for poke in all(pokes) do
    local sprite = nil
    if poke.read_only then
      if poke.rot == 1 then sprite = 32 end
      if poke.rot == 2 then sprite = 33 end
      if poke.rot == 3 then sprite = 34 end
      if poke.rot == 4 then sprite = 35 end
    else
      if poke.rot == 1 then sprite = 16 end
      if poke.rot == 2 then sprite = 17 end
      if poke.rot == 3 then sprite = 36 end
      if poke.rot == 4 then sprite = 37 end
    end


    if not contains(blinking_pokes, poke) or flr(blinking_step / blinking_steps) % 2 == 0 then
      spr(sprite, grid_start_x + (poke.draw_x-1) * grid_x, grid_start_y + (poke.draw_y-1) * grid_y)
    end
  end
end

local function word_width(word)
  local width = 0
  for j = 1, #word do
    local char = sub(word, j, j)
    if char == "w" or char == "m" then
      width = width + 6
    elseif char == "g" then
      width = width + 5
    else
      width = width + 4
    end
  end
  return width
end

local function draw_word(word, start_x, start_y, color, outline)
  if outline then
    draw_word(word, start_x - 1, start_y, worlds[world_index].bg_color, false)
    draw_word(word, start_x + 1, start_y, worlds[world_index].bg_color, false)
    draw_word(word, start_x, start_y - 1, worlds[world_index].bg_color, false)
    draw_word(word, start_x, start_y + 1, worlds[world_index].bg_color, false)
  end

  local current_x = start_x
  for j = 1, #word do
    local char = sub(word, j, j)
    if char == "w" then
      if color ~= 7 then
        pal(7, color)
      end
      spr(48, current_x, start_y)
      pal(7, 7)
      current_x = current_x + 6
    elseif char == "m" then
      if color ~= 7 then
        pal(7, color)
      end
      spr(49, current_x, start_y)
      pal(7, 7)
      current_x = current_x + 6
    elseif char == "g" then
      if color ~= 7 then
        pal(7, color)
      end
      spr(50, current_x, start_y)
      pal(7, 7)
      current_x = current_x + 5
    else
      print(char, current_x, start_y, color)
      current_x = current_x + 4
    end
  end
  return current_x
end

local function draw_text(text, start_x, start_y, max_width, text_color, outline)
  local words = {}
  local current_word = ""
  local y = start_y
  local color = text_color or 7

  local i = 1
  while i <= #text do
    local char = sub(text, i, i)
    if char == " " then
      if #current_word > 0 then
        add(words, current_word)
        current_word = ""
      end
      -- collect consecutive spaces as a word
      local spaces = ""
      while i <= #text and sub(text, i, i) == " " do
        spaces = spaces .. " "
        i = i + 1
      end
      add(words, spaces)
    elseif char == "\n" then
      if #current_word > 0 then
        add(words, current_word)
        current_word = ""
      end
      add(words, "\n")
      i = i + 1
    else
      current_word = current_word .. char
      i = i + 1
    end
  end

  if #current_word > 0 then
    add(words, current_word)
  end

  -- draw words with wrapping
  local current_x = start_x
  local line_words = {}

  for word in all(words) do
    if word == "\n" then
      -- draw current line
      current_x = start_x
      for i = 1, #line_words do
        local line_word = line_words[i]
        current_x = draw_word(line_word, current_x, y, color, outline)
      end
      y = y + 8
      line_words = {}
      current_x = start_x
    else
      local w_width = word_width(word)
      local space_width = 0

      if current_x + space_width + w_width > start_x + max_width and #line_words > 0 then
        -- draw current line
        current_x = start_x
        for i = 1, #line_words do
          local line_word = line_words[i]
          current_x = draw_word(line_word, current_x, y, color, outline)
        end
        y = y + 8
        line_words = {}
        current_x = start_x
      end

      if #line_words > 0 or word ~= " " then
        add(line_words, word)
      end
      current_x = current_x + space_width + w_width
    end
  end

  -- draw any remaining words
  if #line_words > 0 then
    current_x = start_x
    for i = 1, #line_words do
      local line_word = line_words[i]
      current_x = draw_word(line_word, current_x, y, color, outline)
    end
  end
end

local function draw_help_text(message)
  if message then
    -- count newlines to calculate starting y position
    local newline_count = 0
    for i = 1, #message do
      if sub(message, i, i) == "\n" then
        newline_count = newline_count + 1
      end
    end

    local osd_y = 121 - (newline_count * 8)
    draw_text(message, grid_start_x - 1, osd_y, 115, help_text_colors[flr(help_text_color_step / help_text_color_steps + 1)], true)
    if help_text_color_step < (help_text_color_steps * (#help_text_colors - 1)) then
      help_text_color_step = help_text_color_step + 1
    end
  end
end

local function draw_dithering_night()
  local y = 0
  for _, sprite in ipairs({45, 44, 42, 43, 38, 39, 40, 41}) do
    for x=0,15 do
      spr(sprite, x*8, y)
    end
    y = y + 8
  end
end

local function draw_title_screen()
  draw_dithering_night()

  -- the gaslight needs to be drawn in two passes.
  local sprite_start = 64
  local x = 44
  local y = 0
  while sprite_start < 256 do
    for i = sprite_start, sprite_start + 9 do
      spr(i, x + (i - sprite_start) * 8, y)
    end

    y = y + 8
    sprite_start = sprite_start + 16
  end

  sprite_start = 202
  x = 68
  while sprite_start < 256 do
    for i = sprite_start, sprite_start + 4 do
      spr(i, x + (i - sprite_start) * 8, y)
    end

    y = y + 8
    sprite_start = sprite_start + 16
  end

  print_big("the", 1, 72, 7)
  print_big(all_worlds_completed and "lofty" or "lowly", 2, 91, 7)
  print_big("lamplighter", 2, 110, 7)

  local start_hint_x = 9
  local start_hint_y = 6
  if blink_timer % 60 > 30 then
    rectfill(start_hint_x - 1, start_hint_y - 1, 71, 10, 9)
    print("press x to start", start_hint_x, start_hint_y, 4)
  end
end

local function draw_button(text, side_text, x, y, width, height, is_selected, sprite_id, text_x_offset)
  if is_selected then
    rectfill(x, y, x + width, y + height, 4)
  end

  local text_color = 7
  local text_x = x + (text_x_offset or 9)
  draw_text(text, text_x + (sprite_id and 8 or 0), y + 3, width - 8, text_color)

  if side_text then
    draw_text(side_text, x + width - (#side_text * 4 + 1), y + 3, width - 8, text_color)
  end

  if sprite_id then
    local sprite_offset = 0
    if text_x_offset then
      sprite_offset = text_x_offset - 8
    end
    spr(sprite_id, x + sprite_offset + 1, y + 2)
  end
end

local function draw_world_picker()
  draw_text("choose a neighborhood", 23, 3, 110, 4)

  local x = 9
  local start_y = 18
  local rect_width = 110
  local rect_height = 10
  local spacing = 12

  for i, world in ipairs(worlds) do
    local y = start_y + (i-1)*spacing
    local completed_lvls = 0
    for _, lvl in ipairs(world.lvls) do
      if lvl.completed then
        completed_lvls = completed_lvls + 1
      end
    end
    draw_button(world.name, completed_lvls.."/"..#world.lvls, x, y, rect_width, rect_height, world_index == i, is_world_completed(world) and 15 or 3)
  end

  local controls_y = start_y + #worlds * spacing + 12
  draw_button("controls", nil, x, controls_y, rect_width, rect_height, world_picker_sel == "controls", 30, 38)

  local settings_y = controls_y + spacing
  draw_button("settings", nil, x, settings_y, rect_width, rect_height, world_picker_sel == "settings", 29, 38)

  draw_text("x to select", 43, 120, 110, 5)
end

local function draw_settings_screen()
  draw_text("settings", 48, 3, 110, 4)

  local x = 10
  local y = 30
  local rect_width = 108
  local rect_height = 10
  local spacing = 14

  local particles_text = particles_enabled and "disable particles" or "enable particles"
  local toggle_coordinates_button_label = coordinates_enabled and "hide coordinates" or "show coordinates"
  draw_button(toggle_music_button_label, nil, x, y, rect_width, rect_height, settings_sel == 1, nil, 20)
  draw_button(particles_text, nil, x, y + spacing, rect_width, rect_height, settings_sel == 2, nil, 20)
  draw_button(toggle_coordinates_button_label, nil, x, y + spacing + spacing, rect_width, rect_height, settings_sel == 3, nil, 20)
  draw_button(delete_save_data_button_label, nil, x, y + spacing + spacing + spacing, rect_width, rect_height, settings_sel == 4, nil, 20)

  draw_text("x to select    z to go back", 10, 120, 110, 5)
end

local function draw_controls_screen()
  draw_text("in-game controls", 34, 3, 110, 4)

  local x = 13
  local y = 30
  local height = 8

  draw_text("arrow keys", x, y, 110, 7)
  draw_text("navigate", x + 57, y, 110, 5)

  draw_text("x", x, y + height, 110, 7)
  draw_text("place poke", x + 57, y + height, 110, 5)

  draw_text("x", x, y + height * 2, 110, 7)
  draw_text("rotate poke", x + 57, y + height * 2, 110, 5)

  draw_text("z", x, y + height * 3, 110, 7)
  draw_text("start turn", x + 57, y + height * 3, 110, 5)

  draw_text("d", x, y + height * 4, 110, 7)
  draw_text("reset level", x + 57, y + height * 4, 110, 5)

  draw_text("f", x, y + height * 5, 110, 7)
  draw_text("skip level", x + 57, y + height * 5, 110, 5)

  draw_text("e", x, y + height * 6, 110, 7)
  draw_text("skip back", x + 57, y + height * 6, 110, 5)

  draw_text("z to go back", 40, 120, 110, 5)
end

local function spawn_raindrops()
  if not particles_enabled then return end

  local spawn_chance = world_index <= #worlds and worlds[world_index].rain_density or 0.1
  if rnd(1) < spawn_chance then
      local drop = {
          x = flr(rnd(pico8_width)),
          y = flr(rnd(pico8_height))
      }
      add(raindrops, drop)
  end
end

local function draw_rain(rain_color)
  local color = rain_color or world_index <= #worlds and worlds[world_index].rain_color or worlds[1].rain_color

  if color > 15 and game_state == "game" then
    pal(color - 128, color, 1)
  end

  for drop in all(raindrops) do
    pset(drop.x, drop.y, color)
  end
end

local function play_music(boolean)
  music_enabled = boolean
  dset(61, music_enabled and 0 or 1)

  if music_enabled then
    music(17, 0, 7) -- locking the 3 4most tracks
    toggle_music_button_label = "disable music"
  else
    music(-1)
    toggle_music_button_label = "enable music"
  end
end

function _init()
  game_state = "title"
  cartdata("the_lowly_lamplighter_save_data")

  set_completed_from_lvl_data()

  if dget(62) == 1 then
    particles_enabled = false
  end

  if (dget(60) == 1) then
    coordinates_enabled = true
  end

  play_music(dget(61) ~= 1)
end

function _update()
  poke(0x5f30, 1) -- suppress menu
  spawn_raindrops()
  blink_timer = blink_timer + 1

  if z_press_count > 0 then
    z_press_timer = z_press_timer + 1
    if z_press_timer > 60 then
      z_press_count = 0
      z_press_timer = 0
    end
  end

  if burst_active then
    burst_radius = burst_radius + burst_speed
  end

  rain_frame_counter = rain_frame_counter + 1

  if rain_frame_counter >= rain_move_interval then
    local x_multiplier = 1
    local y_multiplier = 1
    local rain_dir = world_index <= #worlds and worlds[world_index].rain_dir or worlds[1].rain_dir

    if rain_dir == "left" then
      x_multiplier = -1
      y_multiplier = 1
    elseif rain_dir == "right" then
      x_multiplier = 1
      y_multiplier = 1
    end

    for drop in all(raindrops) do
      drop.x = drop.x + rain_speed * x_multiplier
      drop.y = drop.y + rain_speed * y_multiplier

      if rnd(1) < 0.02 then
        del(raindrops, drop)
      end
    end
    rain_frame_counter = 0
  end

  if game_state == "title" then
    for i=0,5 do
      if btnp(i, 0) or btnp(i, 1) then
        sfx(menu_action_sfx)
        game_state = "world_picker"
        return
      end
    end
    return
  end

  if game_state == "world_picker" then
    if btnp(2) then
      if world_picker_sel == "world" then
        world_index = world_index - 1
        if world_index < 1 then world_index = #worlds end
      elseif world_picker_sel == "controls" then
        world_picker_sel = "world"
        world_index = #worlds
      elseif world_picker_sel == "settings" then
        world_picker_sel = "controls"
      end
      sfx(nav_sfx)
    end

    if btnp(3) then
      if world_picker_sel == "world" then
        world_index = world_index + 1
        if world_index > #worlds then
          world_picker_sel = "controls"
        end
      elseif world_picker_sel == "controls" then
        world_picker_sel = "settings"
      elseif world_picker_sel == "settings" then
        world_picker_sel = "world"
        world_index = 1
      end
      sfx(nav_sfx)
    end

    if btnp(5) then
      sfx(menu_action_sfx)
      if world_picker_sel == "settings" then
        game_state = "settings_screen"
        delete_save_data_button_label = "delete save data"
      elseif world_picker_sel == "controls" then
        game_state = "controls_screen"
      else
        lvls = worlds[world_index].lvls
        lvl_index = 1

        -- check if first lvl has intro text
        if lvls[lvl_index].intro then
          current_text = lvls[lvl_index].intro
          game_state = "lvl_intro"
        else
          game_state = "game"
          reset_lvl(false)
        end
      end
      return
    end
    return
  end

  if game_state == "settings_screen" then
    if btnp(2) then
      settings_sel = settings_sel - 1
      if settings_sel < 1 then settings_sel = 4 end
      sfx(nav_sfx)
    end

    if btnp(3) then
      settings_sel = settings_sel + 1
      if settings_sel > 4 then settings_sel = 1 end
      sfx(nav_sfx)
    end

    if btnp(4) then
      game_state = "world_picker"
      sfx(nav_sfx)
      return
    end

    if btnp(5) then
      if settings_sel == 1 then
        play_music(not music_enabled)
        sfx(menu_action_sfx)
      elseif settings_sel == 2 then
        particles_enabled = not particles_enabled
        dset(62, particles_enabled and 0 or 1)
        if not particles_enabled then
          raindrops = {}
        end
        sfx(menu_action_sfx)
      elseif settings_sel == 3 then
        coordinates_enabled = not coordinates_enabled
        dset(60, coordinates_enabled and 1 or 0)
        sfx(menu_action_sfx)
      elseif settings_sel == 4 then
        for i = 0, 63 do
          dset(i, 0)
        end

        set_completed_from_lvl_data()

        particles_enabled = true
        delete_save_data_button_label = "save data deleted"

        sfx(menu_action_sfx)
      end
      return
    end
    return
  end

  if game_state == "controls_screen" then
    if btnp(4) then
      game_state = "world_picker"
      sfx(nav_sfx)
      return
    end
    return
  end

  if game_state == "lvl_intro" or game_state == "lvl_outro" then
    for i=0,5 do
      if btnp(i, 0) or btnp(i, 1) then
        local was_intro = (game_state == "lvl_intro")
        game_state = "game"

        if was_intro then
          reset_lvl(false)
        else
          reset_lvl(true)
        end
        return
      end
    end
    return
  end

  if game_state == "game" then
    local cancel_update = check_cheat_codes()
    if cancel_update then return end
  end

  if not turn_time then
    handle_inputs()
  end

  if turn_time then
    turn_timer = turn_timer + 1

    for _, poke in pairs(pokes) do
      date_entity_animation(poke)
    end

    date_entity_animation(fire)

    if turn_timer >= frames_in_step then
      turn_timer = 0
      step_counter = step_counter + 1
      local goal_reached = (fire.x == lvl.goal[1] and fire.y == lvl.goal[2])
      local fire_moved = false
      local poke_moved = false

      if not goal_reached and lvl_timer == 0 then
        fire_moved, poke_moved = handle_turn()
        if fire_moved or poke_moved then
          sfx(step_sfx)
        end
      end

      if (not fire_moved and not poke_moved) or goal_reached or step_counter > (lvl.max_steps or max_steps) then
        lvl_timer = lvl_timer + 1

        if goal_reached and fire.frames < frames_in_step then
          if not success_sound_played then
            sfx(success_sfx)
            success_sound_played = true
          end

          if goal_lit == false and fire.frames == 0 then
            goal_lit = true
            burst_active = true
            burst_radius = 0
          end
        end

        if not goal_reached then
          if (fire_moved or poke_moved) and step_counter == (lvl.max_steps or max_steps) + 1 then
            set_flash("the fickle flame died out...")
          end

          if not failure_sound_played then
            sfx(61)
            failure_sound_played = true
            fire_fail_animation_frame = 0
            fire_dir = nil
          end

          fire_fail_animation_frame = fire_fail_animation_frame + 1

          if fire_fail_animation_frame > #fire_fail_animation_sprites then
            fire_visible = false
          end

          if lvl_timer >= frames_in_step/2 and not flash then
            reset_lvl(false)
          else
            if lvl_timer >= frames_in_step then
              reset_lvl(false)
            end
          end
        end

        if goal_reached then
          lvl.completed = true
          dset(lvl.id, 1)

          if lvl_timer >= frames_in_step/2 then
            if lvl.outro then
              current_text = lvl.outro
              game_state = "lvl_outro"
            else
              reset_lvl(true)
            end
          end
        end
      end
    end
  end

  if (cursor_x > grid_size) then cursor_x = grid_size end
  if (cursor_x < 1) then cursor_x = 1 end
  if (cursor_y > grid_size) then cursor_y = grid_size end
  if (cursor_y < 1) then cursor_y = 1 end
end

function _draw()
  pal()

  if game_state == "title" then
    cls(4)
    draw_title_screen()
    draw_rain(9)
    return
  end

  if game_state == "world_picker" then
    local bg = worlds[world_index] and worlds[world_index].bg_color or 129
    if bg > 15 then
      pal(bg - 128, bg, 1)
    end

    cls(bg - 128)
    draw_rain()
    draw_world_picker()
    return
  end

  if game_state == "settings_screen" then
    pal(1, 129, 1)
    cls(1)
    draw_rain()
    draw_settings_screen()
    return
  end

  if game_state == "controls_screen" then
    pal(1, 129, 1)
    cls(1)
    draw_rain()
    draw_controls_screen()
    return
  end

  if game_state == "lvl_intro" or game_state == "lvl_outro" then
    local bg = worlds[world_index].bg_color
    if bg > 15 then
      pal(bg - 128, bg, 1)
    end
    cls(bg - 128)
    draw_rain()
    draw_text(current_text, 9, 50, 110)
    return
  end

  -- in-game
  local bg = worlds[world_index].bg_color
  if bg > 15 then
    pal(bg - 128, bg, 1)
  end
  cls(bg - 128)
  if flash then
    flash_frames = flash_frames - 1

    if flash_frames == 0 then
      flash = nil
      help_text_color_step = 1
    end
  end

  print("level "..world_index.."-"..lvl_index, grid_start_x - 1, 1, worlds[world_index].txt_color)
  if coordinates_enabled then
    print(cursor_x..","..cursor_y, pico8_width/2 - 5, 1, worlds[world_index].txt_color)
  end
  print("poke", grid_start_x + 88, 1, worlds[world_index].txt_color)
  print("s x"..remaining_pokes, grid_start_x + 104, 1, worlds[world_index].txt_color)

  draw_obs()
  draw_fire()
  draw_pokes()
  draw_rain()

  if not turn_time then
    local cx = grid_start_x + (cursor_x-1) * grid_x - 1
    local cy = grid_start_y + (cursor_y-1) * grid_y - 1
    rect(cx, cy, cx + 9, cy + 9, cursor_colors[flr(cursor_step / cursor_steps_per_frame + 1)])
    if cursor_step < (cursor_steps_per_frame * (#cursor_colors - 1)) then
      cursor_step = cursor_step + 1
    end
  end

  local goal_sprite = (goal_lit or lvl.completed) and 15 or 3
  spr(goal_sprite,grid_start_x + (lvl.goal[1]-1) * grid_x,grid_start_y + (lvl.goal[2]-1) * grid_y)

  draw_help_text(flash or lvl.osd)

  if burst_active then
    local goal_center_x = grid_start_x + (lvl.goal[1]-1) * grid_x + 4
    local goal_center_y = grid_start_y + (lvl.goal[2]-1) * grid_y + 4
    circfill(goal_center_x, goal_center_y, burst_radius, 7)

    -- redraw lamp on top
    local goal_sprite = (goal_lit or lvl.completed) and 15 or 3
    spr(goal_sprite,grid_start_x + (lvl.goal[1]-1) * grid_x,grid_start_y + (lvl.goal[2]-1) * grid_y)
  end
end

__gfx__
0000000000000000000000000000600000000000000000000000000007776660000000000000a000000060000000000000000000000000000000000000006000
0000000000000000000000000006dd000000000000000000000000007555555d000070000000000000000000000000000000000000000000000000000006dd00
000000000000000000000000005555500000000000000000000000007555555d000a90000000a0000000700000000000000000000000000000000000006aa950
000000000000000000000000066ddddd0000000000000000000000007555555d00099a0000009000000aa00000000000000000000000000000000000066ddddd
000000000000000000000000005000500000000000000000000000007555555d00a99900000a900000a99000000000000000000000000000000000000057aa50
00000000000000000000000000d000500000000000000000000000006555555d0099890000a99a0000999a000000000000000000000000000000000000da9a50
00000000000000000000000000d000500000000000000000000000006555555d0098890000989900009989000000000000000000000000000000000000d99a50
000000000000000000000000000d55000000000000000000000000000dddddd000088400000884000008840000000000000000000000000000000000000d5500
000770007777700000000000000000000000a0000000600007776660000000000000000007776660000000000000000000000000000770000007700000000000
00777700077777000000000000007000000000000000000074444445000000000000000074444445000000000000000000000000077556600007600000000000
077777700077777000000000000a90000000a0000000700074444445000000000000000074444445000000000000000000000000075555600006600000000000
77777777000777770000000000099a0000009000000aa000744444450000000000000000744444550000a0000000000000000000755005567766666600000000
77766777000777760000000000a99900000a900000a9900074444445000000000000000074444545000a9a00000060000000000075500556766666dd00000000
7760067700777760000000000099890000a99a0000999a006444444500000000000000006454545500a999000006d00000000000065555600006600000000000
7600006707777600000000000098890000989900009989006444444500000000000000006545454500989900006dd60000006000066556600006600000000000
6000000666666000000000000008840000088400000884000555555000000000000000000555555000088400000884000006d000000660000006d00000000000
0006d000666660006000000d0006dddd700000070007777790909090909090909090909000900090909090909090909090909090099909990000000000000000
006ddd000ddddd00d60000dd006dddd0770000770077777009090909090009000000000000000000099909990999099999999999999999990000000000000000
06ddddd000ddddd0dd600ddd06dddd00777007770777770090909090909090909090909090909090909090909090909090909090990999090000000000000000
6ddddddd000ddddddddddddd6dddd000777777777777700009090909000900090000000000000000990999090909090999999999999999990000000000000000
ddd55ddd000dddd5ddddddd5ddddd000777777767777700090909090909090909090909000900090909090909090909090909090099909990000000000000000
dd5005dd00dddd500ddddd500dddd500077777600777760009090909090009000000000000000000099909990999099999999999999999990000000000000000
d500005d0dddd50000ddd50000dddd50007776000077776090909090909090909090909090009000909090909090909090909090990999090000000000000000
5000000555555000000d5000000dddd5000760000007777609090909000900090000000000000000990909090909090999999999999999990000000000000000
70007000700070000777000050005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70007000770770007000000050005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70707000707070007077000050505000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77077000700070007007000055055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70007000700070007770000050005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000005115000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000d1111500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000d111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000005115000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000d115000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000d1111d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000005111111155000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000511111111111150000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000051511111151500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000001141111411000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000001111dd1111000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000d11111111d000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000555d1111d55500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000511111111111d50000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000001155d15ddd55115000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000551551111111111551550000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000511111111111111111111111150000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000051111151111111111111111511111150000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000511111515111151111111111151111115000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000001111115d11111d111111111111d5111111100000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001111115511111d111511111115114511111110000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000511111541111111111154111111511451111111000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000051111154111111151151154111d11111d5111111100000000000000000000000000000000000000000000000000000000000000000000
0000000000000000001111115411111d1d11d51115d111115511dd11111110000000000000000000000000000000000000000000000000000000000000000000
00000000000000000111111dd1111141511d51115115111115511111111111000000000000000000000000000000000000000000000000000000000000000000
00000000000000001111111111111511115111111111111111151111111111100000000000000000000000000000000000000000000000000000000000000000
00000000000000051111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
000000000000001111112111111155ddddd55dd55dddddd555111111121111115000000000000000000000000000000000000000000000000000000000000000
00000000000001112111145d5554aaaafafffffffffffffffaa55551412121111500000000000000000000000000000000000000000000000000000000000000
000051100000111212111555444111111111111111111111111a9a95521212111150000011500000000000000000000000000000000000000000000000000000
00051100000111212155441111111111155555555555511111111111445511211115000001150000000000000000000000000000000000000000000000000000
00511000001111115554111111111155555444444544555511111111114455511111100000115000000000000000000000000000000000000000000000000000
0051100011111114511111111155144aaaaaaaaaaaaaaaa441551111111111455111111000115000000000000000000000000000000000000000000000000000
005111111111142111155444115144fafafafafafafafafa44151114455111125411111111115000000000000000000000000000000000000000000000000000
000511111244411115444444115144afafafafafafafafafa4151114444451112141411111150000000000000000000000000000000000000000000000000000
000051111121111544444faf11514afafafafafafafafafaf415111af44444511112111111500000000000000000000000000000000000000000000000000000
0000000511111144444afafa11514fafafafafafafafafafa415111fafaf44441111115000000000000000000000000000000000000000000000000000000000
00000000141114444fafafaf11514afafafafafafafafafaf415111afafafa444111110000000000000000000000000000000000000000000000000000000000
0000000015514544fafafafa11514fafafafafafafafafafae15111fafafafa45411510000000000000000000000000000000000000000000000000000000000
000000000154441fafafafaf11214afafafaf7f7f7fafafaf412111afafafaf54444500000000000000000000000000000000000000000000000000000000000
000000000000541afafafafa41219fafaf7f7f7f7f7fafaf9412114fafafafa54500000000000000000000000000000000000000000000000000000000000000
000000000000141fafafafaf412199faf7f7f7f7f7f7fafa9e12114afafafaf54100000000000000000000000000000000000000000000000000000000000000
000000000000141afafafafaf121e9af7f7f7fffff7f7faf991211afafafafa54100000000000000000000000000000000000000000000000000000000000000
0000000000000141afafafafa11219faf7fffffffffffafa912111fafafafad41000000000000000000000000000000000000000000000000000000000000000
0000000000000141fafafafaf11419af7ffff7fffff7ffafa14111afffafafd41000000000000000000000000000000000000000000000000000000000000000
0000000000000141afafaffff11419fffffffff7f7ffffffa14111fffffafad41000000000000000000000000000000000000000000000000000000000000000
00000000000001145afffafff11a1afff7f7fff7ffffffffa1f111ffffafaf511000000000000000000000000000000000000000000000000000000000000000
00000000000000145fffffaff11f1affff7ffff7ffff7fffa1f111ffaffafa410000000000000000000000000000000000000000000000000000000000000000
00000000000000145faffffff11f1affffff7f77fffff7ffa1f111ffffafaf410000000000000000000000000000000000000000000000000000000000000000
000000000000001141fffffffa1f1affffffff777fffffffa1f11afffafff4410000000000000000000000000000000000000000000000000000000000000000
000000000000000141fffffaff1a1afff7fff7777fffff7ff1a11ffffffff4100000000000000000000000000000000000000000000000000000000000000000
000000000000000145ffffffff1a1affff7ff7777ffffffff1a11ffffafff4100000000000000000000000000000000000000000000000000000000000000000
000000000000000145ffffffff1a1affffff77aa77ffffffa1a11fffffaff4100000000000000000000000000000000000000000000000000000000000000000
0000000000000001141fafffff1a1fafffff77aa77ffffffa1f11ffffaff41100000000000000000000000000000000000000000000000000000000000000000
0000000000000001145fffffff11a1ffffff7a9aa77fffff1a511fffffaf41100000000000000000000000000000000000000000000000000000000000000000
0000000000000000145ffffaff11a1fff7ff7a99a77ff7ff1a151ffffaff41000000000000000000000051111510151551005111150000000000000000000000
0000000000000000141fffafaf11a1ffffff7a99a77fffff1a151fafafff11000000000000000000000005555000111111000555500000000000000000000000
00000000000000001415fafffa11f1ff7fff7a99a77f7fff1a111ffffaf411000000000000000000000000000000011110000000000000000000000000000000
00000000000000000145ffffff11f1ffffff7aaaa7fff7ff1a111ffffff410000000000000000000000000000000011110000000000000000000000000000000
00000000000000000145ffafff11a1ffffff77a47fffffff14111ffafaf410000000000000000000000000000000055551000000000000000000000000000000
00000000000000000141ffffff1191ffffffff74ffffffff14111fffaff410000000000000000000000000000000511115000000000000000000000000000000
00000000000000000151afffff11e1ffff7ffff4fff7ffff14111fffffa410000000000000000000000000000000115111000000000000000000000000000000
000000000000000000141fffff1121fffff7fff4ffffffff12111fffff5410000000000000000000000000000000015510000000000000000000000000000000
000000000000000000014ffafaf1141ffffffff4ffffffa14115affaf54100000000000000000000000000000000015510000000000000000000000000000000
000000000000000000014fffaff1121fff544ee4ee45fff12115fffff54100000000000000000000000000000000015110000000000000000000000000000000
0000000000000000000141fffff1121fff5444e44445fff12115afaff14100000000000000000000000000000000015110000000000000000000000000000000
0000000000000000000141fffff1151fff5444444445fff15111fafff14100000000000000000000000000000000015110000000000000000000000000000000
0000000000000000000011fffaf1151fff5544444455fff15111affff11000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000145ffff1111fff5555555555fff15111faaf141000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000145fa1111111faa55555555aff11111111ff151000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000115115551155111111111111115511155511511000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000115551122211155222121225111112221155111000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000111221111111111111111111111111111222111000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000111111111111111111111111111111111111111000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000011111111222511111111111155221111111110000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000005551115111111525244251111112111122500000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000011112015115151155555511515115100211110000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000510001200551051111111111510550002100015000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000001500000120000055111111115510000521000005100000000000000000000000000000000015110000000000000000000000000000000
00000000000000000001500000012000014111151114100005110000005100000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000100000011200012411151122100021100000001000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000055500001120012211151142100211000005550000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000000000000115015211151125105110000000000000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000000000000011515511151155151100000000000000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000000000000150111111111111111510000000000000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000000000001500111151111511110051000000000000000000000000000000000000000000015110000000000000000000000000000000
00000000000000000000000000001150151111111111510511000000000000000000000000000000000000000000015110000000000000000000000000000000
__label__
49994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
99499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
49994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999499949994999
99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999
99499949994999499949994999499949994999499949994999499949994999499949994999499949995599499949994999499949994999499949994999499949
99999999999999999999999999999999999999999999999999999999999999999999999999999999951159999999999999999999999999999999999999999999
94949494949494949494949494949494949494949494949494949494949494949494949494949494d11115949494949494949494949494949494949494949494
999999999999999999999999999999999999999999999999999999999999999999999999999999999d1119999999999999999999999999999999999999999999
94949494949494949494949494949494949494949494949494949494949494949494949494949494941194949494949494949494949494949494949494949494
99999999999999999999999999999999999999999999999999999999999999999999999999999999991199999999999999999999999999999999999999999999
94949494949494949494949494949494949494949494949494949494949494949494949494949494951154949494949494949494949494949494949494949494
999999999999999999999999999999999999999999999999999999999999999999999999999999999d1159999999999999999999999999999999999999999999
94949494949494949494949494949494949494949494949494949494949494949494949494949494d1111d949494949494949494949494949494949494949494
99999999999999999999999999999999999999999999999999999999999999999999999999999951111111559999999999999999999999999999999999999999
94949494949494949494949494949494949494949494949494949494949494949494949494945111111111111594949494949494949494949494949494949494
49994999499949994999499949994999499949994999499949994999499949994999499949994515111111515999499949994999499949994999499949994999
94949494949494949494949494949494949494949494949494949494949494949494949494949411411114119494949494949494949494949494949494949494
9949994999499949994999499949994999499949994999499949994999499949994999499949991111dd11119949994999499949994999499949994999499949
949494949494949494949494949494949494949494949494949494949494949494949494949494d11111111d9494949494949494949494949494949494949494
49994999499949994999499949994999499949994999499949994999499949994999499949994555d1111d555999499949994999499949994999499949994999
9494949494949494949494949494949494949494949494949494949494949494949494949494511111111111d594949494949494949494949494949494949494
99494949994949499949494999494949994949499949494999494949994949499949494999491155d15ddd551159494999494949994949499949494999494949
94949494949494949494949494949494949494949494949494949494949494949494949495515511111111115515549494949494949494949494949494949494
49994999499949994999499949994999499949994999499949994999499949994999495111111111111111111111111549994999499949994999499949994999
94949494949494949494949494949494949494949494949494949494949494949494511111511111111111111115111111549494949494949494949494949494
49494949494949494949494949494949494949494949494949494949494949494945111115151111511111111111511111154949494949494949494949494949
9494949494949494949494949494949494949494949494949494949494949494941111115d11111d111111111111d51111111494949494949494949494949494
499949994999499949994999499949994999499949994999499949994999499941111115511111d1115111111151145111111199499949994999499949994999
94949494949494949494949494949494949494949494949494949494949494945111115411111111111541111115114511111114949494949494949494949494
49494949494949494949494949494949494949494949494949494949494949451111154111111151151154111d11111d51111111494949494949494949494949
949494949494949494949494949494949494949494949494949494949494941111115411111d1d11d51115d111115511dd111111149494949494949494949494
4949494949494949494949494949494949494949494949494949494949494111111dd1111141511d511151151111155111111111114949494949494949494949
94949494949494949494949494949494949494949494949494949494949411111111111115111151111111111111111511111111111494949494949494949494
49494949494949494949494949494949494949494949494949494949494511111111111111111111111111111111111111111111111149494949494949494949
94949494949494949494949494949494949494949494949494949494941111112111111155ddddd55dd55dddddd5551111111211111154949494949494949494
4949494949494949494949494949494949494949494949494949494941112111145d5554aaaafafffffffffffffffaa555514121211115494949494949494949
94949494949494949494949494949494949494949494949451149494111212111555444111111111111111111111111a9a955212121111549494115494949494
49494949494949494949494949494949494949494949494511494941112121554411111111111555555555555111111111114455112111154949411549494949
94949494949494949494949494949494949494949494945114949411111155541111111111555554444445445555111111111144555111111494941154949494
494449444944494449444944494449444944494449444951194411111114511111111155144aaaaaaaaaaaaaaaa4415511111111114551111114491159444944
94949494949494949494949494949494949494949494945111111111142111155444115144fafafafafafafafafa441511144551111254111111111154949494
44494449444944494449444944494449444944494449444511111244411115444444115144afafafafafafafafafa41511144444511121414111111544494449
94949494949494949494949494949494949494949494949451111121111544444faf11514afafafafafafafafafaf415111af444445111121111115494949494
494449444944494449444944494449444944494449444944494511111144444afafa11514fafafafafafafafafafa415111fafaf444411111154494449444944
9494949494949494949494949494949494949494949494949494141114444fafafaf11514afafafafafafafafafaf415111afafafa4441111194949494949494
444944494449444944494449444944494449444944494449444915514544fafafafa11514fafafafafafafafafafae15111fafafafa454115149444944494449
94949494949494949494949494949494949494949494949494949154441fafafafaf11214afafafaf7f7f7fafafaf412111afafafaf544445494949494949494
44444444444444444444444444444444444444444444444444444444541afafafafa41219fafaf7f7f7f7f7fafaf9412114fafafafa545444444444444444444
94949494949494949494949494949494949494949494949494949494141fafafafaf412199faf7f7f7f7f7f7fafa9e12114afafafaf541949494949494949494
44444444444444444444444444444444444444444444444444444444141afafafafaf121e9af7f7f7fffff7f7faf991211afafafafa541444444444444444444
949494949494949494949494949494949494949494949494949494949141afafafafa11219faf7fffffffffffafa912111fafafafad414949494949494949494
444444444444444444444444444444444444444444444444444444444141fafafafaf11419af7ffff7fffff7ffafa14111afffafafd414444444444444444444
949494949494949494949494949494949494949494949494949494949141afafaffff11419fffffffff7f7ffffffa14111fffffafad414949494949494949494
4444444444444444444444444444444444444444444444444444444441145afffafff11a1afff7f7fff7ffffffffa1f111ffffafaf5114444444444444444444
4494449444944494449444944494449444944494449444944494449444145fffffaff11f1affff7ffff7ffff7fffa1f111ffaffafa4144944494449444944494
4444444444444444444444444444444444444444444444444444444444145faffffff11f1affffff7f77fffff7ffa1f111ffffafaf4144444444444444444444
94949494949494949494949494949494949494949494949494949494941141fffffffa1f1affffffff777fffffffa1f11afffafff44194949494949494949494
44444444444444444444444444444444444444444444444444444444444141fffffaff1a1afff7fff7777fffff7ff1a11ffffffff41444444444444444444444
44944494449444944494449444944494449444944494449444944494449145ffffffff1a1affff7ff7777ffffffff1a11ffffafff41444944494449444944494
44444444444444444444444444444444444444444444444444444444444145ffffffff1a1affffff77aa77ffffffa1a11fffffaff41444444444444444444444
944494449444944494449444944494449444944494449444944494449441141fafffff1a1fafffff77aa77ffffffa1f11ffffaff411494449444944494449444
444444444444444444444444444444444444444444444444444444444441145fffffff11a1ffffff7a9aa77fffff1a511fffffaf411444444444444444444444
444444444444444444444444444444444444444444444444444444444444145ffffaff11a1fff7ff7a99a77ff7ff1a151ffffaff414444444444444444444444
444444444444444444444444444444444444444444444444444444444444141fffafaf11a1ffffff7a99a77fffff1a151fafafff114444444444444444444444
4444444444444444444444444444444444444444444444444444444444441415fafffa11f1ff7fff7a99a77f7fff1a111ffffaf4114444444444444444444444
4444444444444444444444444444444444444444444444444444444444444145ffffff11f1ffffff7aaaa7fff7ff1a111ffffff4144444444444444444444444
4444444444444444444444444444444444444444444444444444444444444145ffafff11a1ffffff77a47fffffff14111ffafaf4144444444444444444444444
4444444444444444444444444444444444444444444444444444444444444141ffffff1191ffffffff74ffffffff14111fffaff4144444444444444444444444
4444444444444444444444444444444444444444444444444444444444444151afffff11e1ffff7ffff4fff7ffff14111fffffa4144444444444444444444444
44444444444444444444444444444444444444444444444444444444444444141fffff1121fffff7fff4ffffffff12111fffff54144444444444444444444444
47777777747744447747777777744444444444444444444444444444444444414ffafaf1141ffffffff4ffffffa14115affaf541444444444444444444444444
47777777747744447747777777744444444444444444444444444444444444414fffaff1121fff544ee4ee45fff12115fffff541444444444444444444444444
444477444477444477477444444444444444444444444444444444444444444141fffff1121fff5444e44445fff12115afaff141444444444444444444444444
444477444477444477477444444444444444444444444444444444444444444141fffff1151fff5444444445fff15111fafff141444444444444444444444444
444477444477444477477444444444444444444444444444444444444444444411fffaf1151fff5544444455fff15111affff114444444444444444444444444
4444774444777777774777777774444444444444444444444444444444444444145ffff1111fff5555555555fff15111faaf1414444444444444444444444444
4444774444777777774777777774444444444444444444444449444444444444145fa1111111faa55555555aff11111111ff1514444444444444444444444444
44447744447744447747744444444444444444444444444444444444444444441151155511551111111111111155111555115114444444444444444444444444
44447744447744447747744444444444444444444444444444444444444444441155511222111552221212251111122211551114444444444444444444444444
44447744447744447747744444444444444444444444444444444444444444441112211111111111111111111111111112221114444444444444444444444444
44447744447744447747744444444444444444444444444444444444444444441111111111111111111111111111111111111114444444444444444444444444
44447744447744447747744444444444444444444444444444444444444444444111111112225111111111111552211111111144444444444444444444444444
44447744447744447747744444444444444444444444444444444444444444444455511151111115252442511111121111225444444444444444444444444444
44447744447744447747744444444444444444444444444444444444444444444111124151151511555555115151151442111144444444444444444444444444
44447744447744447747777777744444444444444444444444444444444444445144412445514511111111115145544421444154444444444444444444444444
44447744447744447747777777744444444444444444444444444444444444415444441244444551111111155144445214444451444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444415444444124444141111511141444451144444451444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444441444444112444124111511221444211444444414444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444555444411244122111511421442114444455544444444444444444444444444
44774444444477777744774444774774444444774444774444444444444444444444444441154152111511251451144444444444444444444444444444444444
44774444444777777774774444774774444444774444774444444444444444444444444444115155111511551511444444444444444444444444444444444444
44774444444774444774774444774774444444774444774444444444444444444444444441541111111111111115144444444444444444444444444444444444
44774444444774444774774444774774444444774444774444444444444444444444444415441111511115111144514444444444444444444444444444444444
44774444444774444774774444774774444444477447744444444444444444444444444411541511111111115145114444444444444444444444444444444444
44774444444774444774774444774774444444477447744444444444444444444444444451111514151551445111154444444444444444444444444444444444
44774444444774444774774444774774444444447777444444444444444444444444444445555444111111444555544444444444444444444444444444444444
44774444444774444774774774774774444444447777444444444444444444444444444444444444411114444444444444444444444444444444444444444444
44774444444774444774777777774774444444444774444444444444444444444444444444444444411114444444444444444444444444444444444444444444
44774444444774444774777447774774444444444774444444444444444444444444444444444444455551444444444444444444444444444444444444444444
44774444444774444774774444774774444444444774444444444444444444444444444444444444511115444444444444444444444444444444444444444444
44774444444774444774774444774774444444444774444444444444444444444444444444444444115111444444444444444444444444444444444444444444
44774444444774444774774444774774444444444774444444444444444444444444444444444444415514444444444444444444444444444444444444444444
44774444444774444774774444774774444444444774444444444444444444444444444444444444415514444444444444444444444444444444444444444444
44777777774777777774774444774777777774444774444444444444444444444444444444444444415114444444444444444444444444444444444444444444
44777777774477777744774444774777777774444774444444444444444444444444444444444444415114444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444415114444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444415114444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444415114444444444444444444444444444444444444444444
44774444444777777774744444474777777774774444444777777774777777774774444774777777775777777774777777744444444444444444444444444444
44774444444777777774774444774777777774774444444777777774777777774774444774777777775777777774777777774444444444444444444444444444
44774444444774444774777447774774444774774444444444774444774444444774444774444774415774444444774444774444444444444444444444444444
44774444444774444774777777774774444774774444444444774444774444444774444774444774415774444444774444774444444444444444444444444444
44774444444774444774774774774774444774774444444444774444774444444774444774444774415774444444774444774444444444444444444444444444
44774444444774444774774444774777777774774444444444774444774477774777777774444774415777777774777777744444444444444444444444444944
44774444444777777774774444774777777774774444444444774444774477774777777774444774415777777774777777444444444444444444444444444444
44774444444777777774774444774774444444774444444444774444774444774774444774444774415774444444774477744444444444444444444444444444
44774444444774444774774444774774444444774444444444774444774444774774444774444774415774444444774447774444444444444444444444444444
44774444444774444774774444774774444444774444444444774444774444774774444774444774415774444444774444774444444444444444444444444444
44774444444774444774774444774774444444774444444444774444774444774774444774444774415774444444774444774444444444444444444444444444
44774444444774444774774444774774444444774444444444774444774444774774444774444774415774444444774444774444444444444444444444444444
44774444444774444774774444774774444444774444444444774444774444774774444774444774415774444444774444774444444444444444444444444444
44774444444774444774774444774774444444774444444444774444774444774779444774444774415774444444774444774444444444444444444444444444
44777777774774444774774444774774444444777777774777777774777777774774444774444774415777777774774444774444444444444444444444444444
44777777774774444774774444774774444444777777774777777774777777774774444774444774415777777774774444774444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444415114444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444415114444444444444444444444444444444444444444444

__map__
0000000000000000000000aa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
893900000005000050000500005000050000500005000050000500005000050000500005000050000500005000000000000000000000000000000000000000000000000000000000000000000000000000000000
333900201361013610136101361013610136101361013610136101361013610136101361013610136101361013610136101361013610136101361013610136101361013610136101361013610136101361013610
9101000016050100500c050070500205000050000551e1002210024100271002a1002e1003010000000000000000027100271002410023100221001f1001d1001a1001710014100121000f1000b1000510000100
4b020000376503365030650396503865036650356503565035650356503565035650356503565004500045000050003500035000650008500095000a5000850005500095000e5001250010500105001000010000
030305003862038610386103861000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
050100001a0500d0500b0501800018000180000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49ff03002b6502b6502b6500050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000000000000000000000000000
015a10000e5340e5300e5300e5300e5350e5000d5340d5350e5340e5300e5300e5300e5350e5050d5340d5350b5340b5300b5300b5300b5350b5050b5340b5350953409530095300953009530095300952509500
313e00001f8541f8501f8501f8501f8501f8501f8501f8501f8501f8401f8301f8201a8541a8501a8501a8501f8541f8501f8501f8501f8501f8501f8501f8501f8501f8401f8301f8201a8541a8501a8501a850
613e0000137441274013745197200070019710007001971000700197100070000700007000070000700007001374412740137451b720007001b710007001b710007001b710007000070000700007000070000700
7d4600200c0440d0520e0520f052100420f0520e0520d0520e0420f05210052110521204211052100520f04210042110321203213032140221303212032110321202213032140321503216042150521404213052
613e00001374412740137451972000700197100070019710007001971000700007000070000700007000070013744127401374518720007001871000700187100070018710007000070000700007000070000700
613e0000137441274013745167200c700167100c700167100c7001671500700007000070000700007000070013700127001370018700007001870000700187000070000700007000070000700007000070000000
d73e00001f8441f8401f8401f8401f8401f8401f8401f8401f8401f8401f8401f8401a8541a8501a8501a8501883218832188321883218832188321883218832188321883218832188321b8541b8501b8501b850
793e00201390013900229242292022920229251f9001f9002292422920229202292022920229251f9001f9001f9001f9001f900229242292022920229251f9002293422930229302293022930229351390013900
313e00002085420850208502085020850208502085020850208502084020830208201b8541b8501b8501b8502085420850208502085020850208502085020850208502084020830208201b8541b8501b8501b850
613e00001474413740147451b720007001b710007001b710007001b7100070000700007000070000700007001474413740147451c720007001c710007001c710007001c710007000070000700007000070000700
d73e00002084420840208402084020840208402084020840208402084020840208401b8541b8501b8501b8501983219832198321983219832198321983219832198321983219832198321a8001a8001a8001a800
613e00001474413740147451a720007001a710007001a710007001a7100070000700007000070000700007001474413740147451c720007001c710007001c710007001c710007000070000700007000070000700
613e00001474413740147451a720007001a710007001a710007001a71000700007000070000700007000070014744137401474519720007001971000700197100070019710007000070000700007000070000700
613e0000147441374014745177200c700177100c700177100c7001771500700007000070000700007000070013700127001370018700007001870000700187000070000700007000070000700007000070000000
55460020000000000000000000000000000000000000000013000130001300013000130001300013000130002b0142b0102b0102b015280142801028015240142401024010240102401224015180001800018000
4f3e000013a50000002f6053b6053a9553b6050700313a5513a50000002f6053b60507000000000700313a0313a50000002f6053b6053a9553b6050700313a5513a50000002f6053b60507000000000700313a03
4f3e000014a53000002f6053b6053b9553b6050700314a5514a50000002f6053b60507000000000700313a0314a50000002f6053b6053b9553b6050700314a5514a50000002f6053b60507000000000700313a03
4d4600000c000130420e0001303210000130220e00013012000001301200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
a14600000574005740057400574005740057400574005740057400574005740057400574005740057400474104740047400474004740047400474002741027400274002740027400274002740027400274002740
914600001572015720157201572015720157201572015720157201572015720157201572015720157201572015720157201572015720157201572015720157201572015720157201572015720157201572015720
55460020000000000000000000000000000000000000000013000130001300013000130001300013000130002b0142b0102b0102b015280142801028015240142401024010240102401224012240122401224013
072d00201ee2521e0535d0017a4017a5032d0037c0036c00376003760033c050cd000cd0015d503ad0015d501fe2521e0506d0017a4017a5006d0037c0019c401ac5029c0011c0005c001dc0515d403cd0015d40
072d00001ee2521e0535d0017a4017a5032d0037c0036c00376003760033c050cd000cd0015d503ad0015d501fe2521e0506d0017a0017a0006d0037c0019c001ac0029c0011c0005c001dc0515d003cd0015d00
914600001572015720157201572015720177201772017720167201672016720167201672016720167201672015720157201572015720157201572015720157201572015720157201572015720157201572015723
a14600000574005740057400574005740087400874008740077400774007740077400774006740067400674205740057400574005740057400574005740057400574005740057400574005740057400574005743
515a10000e5340e5300e5300e5320e5300e5300e5300e535105341053010530105321053010530105301052212534125301253012532125301253012530125301252012520125201252212520125201252012512
555a18001252412520125201252012520125201252012520135201352013520135201352013520135201352504500045000450013500105001450010500145001050014500105001450010500005000050000500
795a10000653406530065300653006530065220453104530065310653006530065300653006522045310453002531025300253002530025350250002534025350153401530015300153001530015350550000500
a14600000574405740057400574005740087400874008740077400774007740077400774006740067400674205740057400574005740057400574005740057400574005740057400574005740057400574005740
914600001572415720157201572015720177201772017720167201672016720167201672016720167201672015720157201572015720157201572015720157201572015720157201572015720157201572015720
c1c800000972009720097200972009720097200972007721077200772007720077200772007720077100771007710077120772207722077220772207712077120771207712077220772207722077220772007720
55460020000000000000000000000000000000000000000013000130001300013000130001300013000130002b0142b0102b0102b0152801428010280152401424010240102401024012240150c0000c00018000
7d4600200c0350d0450e0550f0551c022030501a0220d0450e0450f05510055110551e022050501c0220f0351003511035120351304514045130451203511035120351304514045150452202209055200221f013
79ff00000c5140c5100b5100b5100b5100b5100a5100a5100a5100a5100a51009510095100951009510095150a5140a5100a5100a5100a5100951009510095100851008510085100851008510075100751007510
79ff00000452004520045200452004520035200352003520035200352002520025200252002520025200152001520015200152001520005200052000520015200152001520015220052000520005200052000520
79ff00000751007510075100751006510065100651006512075100751007510075100751006510065120651006510065100551005510055100551204510045100451004510035100351003510035120451004512
79ff00001390016924169201692216925139001390016914169101691216910169121691513900139001390013900139001692416920169251690516914169101691216915169141691016912169101691500000
79ff00000751007510085100851008510085100851209510095100951009510095120a5100a5100a5100a5100a5100951009510095100951009510095120a5100a5100a5100a5100a5120b5100b5100b5100b515
79ff00000052000520005200052201520015200152001520015220052000520005200052001520015200152001520015200152202520025200252002520025200352003520035200352003520045200452004520
79ff00000351003510035100351003510045100451004510045100451005510055100551005510055120651006510065100651006510065100751007510075100751007510065100651006510065100751007510
79ff000000000229142291022910229102291222910229150c0000c0002290022924229202292022922229251f9001f9002290022924229202292022920229252290022914229102291022910229102291500000
915a00000775407750077500775007750077550775407750067540675006750067500675006755067540675007754077500775007750077500775507754077500875408750087500875008750087550875408750
4d5a00000975409750097500975009750097550875408755097540975009750097500975009755087540875006754067500675006750067500675506754067550475404750047500475004750047500475004755
5d5a00000975409750097500975009750097550875408755097540975009750097500975009755087540875506754067500675006750067500675506754067550475404750047500475004750047500475004755
915a00000775407750077500775007750077550775407750067540675006750067500675006755067540675007754077500775007750077500775507754077500875408750087500875008750087550875408750
495a18000775407750077500775007750077500775407750087540875008750087500875008750087500875008750087500875008750087500875508700087000870008700007000070000700007000000000000
315a10000e5340e5300e5300e5300e5350e5050d5340d5350e5340e5300e5300e5300e5350e5050d5340d5350b5340b5300b5300b5300b5350b5050b5340b5350953409530095300953009525095000750007500
315a1000105350b525105350b525105350b525105350b5250d535095250d535095250d535095250d535095250e5350b5250e5350b5250e5350b5250e5350b5250f5350b5250f5350b5250f5350b5250f5350b525
315a1800105350b525105350b525105350b525105350b5250c545075050c535075000c5250b505105050b50513500105001350010500135001050013500105001450010500145001050014500105001450010500
495a10000655506545065350652506500065000455404555065550654506535065250650006500045540455502555025450253502525025000250002554025550155501545015350152501500015000150005500
913c02000753501000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4904020018d5018d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000d0000000
01010200056500b6001e6002260000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
9310010030c5000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c00
4b16030037e2037e2537e002be002be0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000000
951002000655500500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
8d220a000854408550085500854008530085200851008510085150750005500055001c5001c5001c5001c5001c5001e5001f5002250026500295002d50032500395003f500000000000000000000000000000000
__music__
03 55424344
01 585b5d5d
02 5a5b5f5e
00 60424344
00 4a424344
01 08091657
00 0809164e
00 080b0e16
00 0d0c0e44
00 0f101757
00 0f121757
00 0f130e17
02 11140e44
00 23240a26
00 191a180e
00 23242715
04 1f1e271b
01 28292a2b
02 2c2d2e2f
00 41424344
01 32073859
00 31352259
00 3336201c
00 3036201c
02 3437211d

