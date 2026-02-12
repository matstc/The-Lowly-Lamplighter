-- The Lowly Lamplighter
-- by MXTXC
grid_x = 11
grid_y = 11
grid_size = 11
cursor_x = flr((grid_size + 1) / 2)
cursor_y = flr((grid_size + 1) / 2)
grid_start_x = 5
grid_start_y = 9
lvl = {}
remaining_pokes = 0
game_state = "title"
raindrops = {}
rain_speed = 1
rain_move_interval = 4
rain_frame_counter = 0
world_idx = 1
world_picker_sel = "world"
settings_sel = 1
particles_enabled = true
coordinates_enabled = false
music_enabled = true
lvls = {}
pokes = {}
fire = {x = nil, y = nil}
turn_time = false
turn_timer = 0
fire_dir = nil
lvl_timer = 0
lvl_idx = 1
success_sound_played = false
fail_sound_played = false
goal_lit = false
frames_in_step = 12
step_counter = 0
max_steps = 30
pre_turn_pokes = nil
fire_animation_timer = 0
fire_animation_sprites = {8,9,10}
blink_timer = 0
burst_radius = 0
fire_fail_animation_frame = 0
fire_fail_animation_sprites = {26, 27, 28}
fire_visible = true
burst_active = false
burst_speed = 3.5
current_text = ""
all_worlds_completed = false
step_sfx = 60
failure_sfx = 62
success_sfx = 63
menu_action_sfx = 57
nav_sfx = 59
cursor_colors = {5,6,7}
cursor_step = 1
cursor_steps_per_frame = 10
flash = nil
flash_frames = 0
help_text_colors = {5,6,7}
help_text_color_step = 1
help_text_color_steps = 10
nudges = {}
blinking_pokes = {}
blinking_step = 1
blinking_steps = 8
delete_save_data_button_label = "Delete save data"
toggle_music_button_label = "Disable music"
z_press_count = 0
z_press_timer = 0
large_alphabet = {
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

function parse_lvls(str)
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
        if (c >= "a" and c <= "z") or (c >= "A" and c <= "Z") or c == "_" or (c >= "0" and c <= "9") then
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

local tutorial_seq = parse_lvls([[{
  {
    id=1,
    goal={8,2},
    fire={6,7},
    pokes={{x=5,y=2,rot=2},{x=6, y=8, rot=1}},
    solution={},
    max=0,
    intro="Night has fallen in the neighborhood.\n\nLet there be light.",
    osd="Press Z to start the turn."
  },
  {
    id=0,
    goal={8,8},
    fire={4,8},
    pokes={{x=3,y=4,rot=2},{x=4,y=9,rot=1},{x=8,y=3,rot=3}},
    max=0,
    solution={},
    intro="Once the turn is started, you simply have to trust.",
    osd="Press Z to start the turn."
  },
  {
    id=2,
    goal={9,4},
    fire={4,6},
    pokes={{x=3,y=6,rot=2}},
    max=1,
    max_steps=15,
    solution={{x=9,y=7,rot=1}},
    intro="Place a poke in the right spot to push the flame towards the lamp.",
    osd="Navigate with arrow keys.\nX to place and rotate pokes.\nZ to start the turn."
  },
  {
    id=3,
    goal={4,7},
    fire={8,5},
    pokes={{x=9,y=5,rot=4}},
    max=1,
    max_steps=15,
    solution={{x=4,y=4,rot=3}},
    intro="A poke next to the flame will give it a push.\n\nRotate it to change the direction of that push.",
    osd="X to place and rotate pokes."
  },
  {
    id=56,
    goal={6,8},
    fire={6,3},
    max=1,
    solution={{x=6,y=2,rot=3}},
    intro="The flame will not move unless it is poked.",
    osd="Poke the flame\ntowards the lamp."
  },
  {
    id=27,
    goal={7,3},
    fire={6,3},
    pokes={{x=5,y=3,rot=4},{x=5,y=7,rot=2},{x=7,y=8,rot=1}},
    max=1,
    max_steps=15,
    solution={{x=6,y=2,rot=3}},
    intro="You can only rotate the\npokes you placed yourself.",
    osd="Take the long way around."
  },
  {
    id=4,
    goal={3,2},
    fire={6,8},
    obs={{6,5}},
    max=2,
    max_steps=15,
    solution={{x=7,y=8,rot=4},{x=3,y=9,rot=1}},
    intro="Boulders get in the way.",
    osd="Get around the boulder."
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
    intro="The flame and the pokes have a lot in common.",
    osd="Complete the path."
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
    intro="Pokes can also be poked.",
    osd="Push away one poke\nto clear a path."
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
    intro="The flame can stop moving and wait for the next poke.\n\nIt will only die out if there is no more progress to be made.",
    osd="Poke the flame towards the\nright so it can wait\nfor the next poke."
  },
  {
    id=7,
    goal={2,6},
    fire={10,6},
    pokes={{x=4,y=5,rot=1},{x=4,y=7,rot=2},{x=6,y=5,rot=1},{x=6,y=7,rot=1},{x=8,y=5,rot=4},{x=8,y=7,rot=3}},
    max=1,
    solution={{x=11,y=6,rot=4}},
    osd="The flame shimmies through."
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
    intro="Sometimes blocking the path is the only way.",
    osd="Block its path so the flame\ndoes not go astray."
  },
  {
    id=9,
    goal={9,7},
    fire={3,5},
    obs={{10,4}},
    pokes={{x=2,y=5,rot=2},{x=6, y=6, rot=1},{x=7, y=4, rot=3}},
    max=1,
    solution={{x=6,y=4,rot=2}},
    intro="A poke can block regardless of its orientation.",
    osd="Block and poke\nat the same time."
  },
  {
    id=52,
    goal={3,3},
    fire={6,7},
    obs={{6,2}},
    pokes={{x=5,y=7,rot=1},{x=5,y=3,rot=2},{x=7,y=3,rot=4},{x=10,y=8,rot=4}},
    max=1,
    solution={{x=9,y=8,rot=1}},
    intro="Pokes can serve again and again.",
    osd="Make your one poke count."
  },
  {
    id=10,
    goal={8,6},
    fire={5,6},
    pokes={{x=4,y=6,rot=2},{x=5,y=7,rot=1}},
    max=1,
    solution={{x=5,y=5,rot=3}},
    intro="Pokes should not be ambiguous.",
    osd="A fickle flame\nneeds clear directions."
  },
  {
    id=11,
    goal={10,9},
    fire={3,5},
    obs={{10,6}},
    pokes={{x=1,y=6,rot=2},{x=3,y=1,rot=3},{x=2,y=9,rot=2},{x=3,y=6,rot=1}},
    max=1,
    max_steps=20,
    intro="You can start the turn as a way to explore.",
    solution={{x=2,y=6,rot=2}},
    osd="Poke the poke\nthat pokes the poke."
  },
  {
    id=12,
    fire={2,6},
    goal={10,6},
    obs={{8,5}},
    pokes={{x=8,y=6,rot=2},{x=9,y=6,rot=1},{x=10,y=7,rot=4}},
    max=2,
    solution={{x=1,y=2,rot=2},{x=9,y=5,rot=3}},
    intro="You can always press D to reset the level.\n\n(And F to skip it.)",
    osd="Try to poke from above."
  },
  {
    id=58,
    fire={6,3},
    goal={6,9},
    pokes={{x=6,y=2,rot=3},{x=6,y=6,rot=1},{x=6,y=8,rot=1}},
    max=2,
    solution={{x=7,y=5,rot=3},{x=7,y=6,rot=4}},
    intro="No hints this time."
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
    outro="The neighborhood is lit up.\n\nYou are ready to wander off and spread the light."
  }
}]])

local clearing_seq = parse_lvls([[{
  {
    id=14,
    fire={2,6},
    goal={10,6},
    obs={{10,4},{10,8}},
    pokes={{x=6,y=6,rot=1},{x=7,y=6,rot=1},{x=8,y=6,rot=1},{x=9,y=6,rot=1}},
    max=3,
    solution={{x=1,y=6,rot=2},{x=4,y=7,rot=2},{x=5,y=7,rot=1}},
    intro="The park of a thousand benches.\n\nEvery one of them\nin perfect shade."
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
    intro="As a meeting point, the park works not at all."
  },
  {
    id=16,
    fire={6,10},
    goal={6,6},
    obs={{6,4},{6,11}},
    pokes={{x=5,y=6,rot=3},{x=6,y=5,rot=2},{x=6,y=7,rot=1},{x=7,y=6,rot=4},{x=10,y=11,rot=1}},
    max=2,
    solution={{x=5,y=7,rot=2},{x=11,y=4,rot=3}}
  },
  {
    id=59,
    fire={2,9},
    goal={10,6},
    obs={{2,2},{5,7},{5,8},{5,9},{5,10},{6,2},{6,3},{6,4},{6,5}},
    pokes={{x=1,y=6,rot=2},{x=2,y=10,rot=1},{x=5,y=6,rot=2},{x=6,y=6,rot=4},{x=8,y=6,rot=4}},
    max=4,
    solution={{x=3,y=4,rot=1},{x=3,y=7,rot=1},{x=8,y=3,rot=1},{x=8,y=7,rot=1}},
    intro="As one sits and enjoys perfect shade waiting for a long-lost friend..."
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
    intro="They might be sitting on another bench,\nunder another tree,\nat another end of the park,\nenjoying perfect shade.",
    outro="The neighbors find comfort in this thought."
  }
}]])

local reuse_seq = parse_lvls([[{
  {
    id=53,
    fire={3,5},
    goal={1,5},
    obs={{6,6}},
    pokes={{x=2,y=5,rot=2},{x=2,y=7,rot=1},{x=4,y=5,rot=2},{x=4,y=7,rot=1},{x=6,y=3,rot=3},{x=9,y=8,rot=1},{x=10,y=9,rot=1},{x=11,y=4,rot=4}},
    max=1,
    solution={{x=10,y=8,rot=4}},
    intro="There is no river or stream in this hollow. Just mud here and mud there."
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
    intro="A kid comes to fill up his bucket before a mud fight."
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
    fire={2,7},
    goal={5,10},
    obs={{3,7},{4,6},{5,5},{7,4},{7,8}},
    pokes={{x=1,y=4,rot=2},{x=2,y=8,rot=1},{x=3,y=3,rot=3},{x=6,y=4,rot=3},{x=6,y=6,rot=1},{x=7,y=7,rot=4},{x=10,y=6,rot=3},{x=11,y=10,rot=4}},
    max=2,
    solution={{x=2,y=3,rot=2},{x=11,y=11,rot=1}},
    intro="Two lovers find their way here to this hollow on the first snow of the year."
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
    intro="A colorful viper plays strike-and-release with anything smaller than a mouse."
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
    outro="The coldest place in town.\n\nWhere the mud takes over and lets go like a breath."
  }
}]])

local breakout_seq = parse_lvls([[{
  {
    id=30,
    fire={6,7},
    goal={6,8},
    obs={{5,7},{5,8},{6,4},{6,9},{7,7},{7,8}},
    pokes={{x=4,y=3,rot=3},{x=6,y=6,rot=1},{x=8,y=3,rot=3}},
    max=3,
    solution={{x=3,y=6,rot=2},{x=4,y=4,rot=3},{x=4,y=6,rot=2}},
    intro="The dry goods store opened back when it was just called \"the road\"."
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
    intro="Their door remains open to everybody even if they have no intention of buying anything."
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
    intro="The ice cream cart gets off the pavement and gets a storefront."
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
    intro="Someone pins the schedule of the sewing circle on the postmaster's notice board."
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
    outro="The campfire.\nThe crossroads.\nThe main street.\n\nWhere neighbors go to catch the light."
  }
}]])

local cannon_seq = parse_lvls([[{
  {
    id=43,
    fire={3,3},
    goal={8,3},
    obs={{1,8},{1,9},{5,7},{7,7},{11,8},{11,9}},
    pokes={{x=5,y=8,rot=2},{x=5,y=9,rot=1},{x=6,y=11,rot=1},{x=7,y=3,rot=3},{x=9,y=4,rot=1},{x=10,y=9,rot=1}},
    max=1,
    solution={{x=6,y=10,rot=4}},
    intro="The oldest court in town.\n\nNot a dead end but a cul-de-sac with a bulb."
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
    intro="As he bags groceries, the boy daydreams..."
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
    intro="He imagines crouching in the middle of the road and then jumping up.\n\nHe takes flight."
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
    intro="He flies up until the neighborhood becomes a daisy.\n\nEach house a petal for him to pick."
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
    outro="The last petal will decide whether he comes back down or not."
  }
}]])

local worlds = {
  {
    name = "Tutorial Town",
    lvls = tutorial_seq,
    rain_density = 0.04,
    rain_dir = "right",
    rain_color = 13,
    obs_sprite = 7,
    bg_color = 129,
    txt_color = 5
  },
  {
    name = "Winnow Park",
    lvls = clearing_seq,
    rain_density = 0.08,
    rain_dir = "left",
    rain_color = 4,
    obs_sprite = 25,
    bg_color = 131,
    txt_color = 6
  },
  {
    name = "Silver Hollow",
    lvls = reuse_seq,
    rain_density = 0.04,
    rain_dir = "right",
    rain_color = 6,
    obs_sprite = 7,
    bg_color = 0,
    txt_color = 5
  },
  {
    name = "Main Street",
    lvls = breakout_seq,
    rain_density = 0.04,
    rain_dir = "left",
    rain_color = 0,
    obs_sprite = 7,
    bg_color = 130,
    txt_color = 5
  },
  {
    name = "Cannonball Court",
    lvls = cannon_seq,
    rain_density = 0.03,
    rain_dir = "right",
    rain_color = 15,
    obs_sprite = 7,
    bg_color = 1,
    txt_color = 5
  }
}

function is_world_completed(world)
  local completed = true
  for _, lvl in ipairs(world.lvls) do
    if not lvl.completed then
      completed = false
      break
    end
  end

  return completed
end

function set_completed_from_lvl_data()
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

function contains(tab, val)
  for v in all(tab) do
    if v == val then return true end
  end
  return false
end

function draw_big(char, x, y, col)
  local glyph = large_alphabet[char]
  if not glyph then return end

  for row=1,16 do
    local line_data = glyph[row]
    for col_idx=0,7 do
      if (line_data & (0x80 >> col_idx)) ~= 0 then
        pset(x + col_idx, y + (row - 1), col)
      end
    end
  end
end

function print_big(str, x, y, color)
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

function is_valid_move(lvl, pokes, fire, entity_type, x, y)
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

function next_position(x, y, dir)
  if dir == 2 then return x + 1, y
  elseif dir == 4 then return x - 1, y
  elseif dir == 3 then return x, y + 1
  elseif dir == 1 then return x, y - 1
  end
  return x, y
end

function poke_redirects(pokes, entity_x, entity_y, skip_idx)
  local intents = {}
  for i, poke in pairs(pokes) do
    if i ~= skip_idx then
      if poke.x == entity_x - 1 and poke.y == entity_y and poke.rot == 2 then
        local tx, ty = next_position(entity_x, entity_y, 2)
        add(intents, {dir = 2, x = tx, y = ty, redir = true, poke = poke})
      elseif poke.x == entity_x + 1 and poke.y == entity_y and poke.rot == 4 then
        local tx, ty = next_position(entity_x, entity_y, 4)
        add(intents, {dir = 4, x = tx, y = ty, redir = true, poke = poke})
      elseif poke.x == entity_x and poke.y == entity_y - 1 and poke.rot == 3 then
        local tx, ty = next_position(entity_x, entity_y, 3)
        add(intents, {dir = 3, x = tx, y = ty, redir = true, poke = poke})
      elseif poke.x == entity_x and poke.y == entity_y + 1 and poke.rot == 1 then
        local tx, ty = next_position(entity_x, entity_y, 1)
        add(intents, {dir = 1, x = tx, y = ty, redir = true, poke = poke})
      end
    end
  end
  return intents
end

function calc_poke_intents(pokes, poke_idx, nudges)
  local poke = pokes[poke_idx]
  local intents = {}

  if nudges[poke_idx] then
    for _, nudger in ipairs(nudges[poke_idx]) do
      if nudger.rot then
        local tx, ty = next_position(poke.x, poke.y, nudger.rot)
        add(intents, {dir = nudger.rot, x = tx, y = ty, redir = true, is_nudge = true, poke = poke})
      end
    end
  end

  local redirects = poke_redirects(pokes, poke.x, poke.y, poke_idx)
  for _, redir in ipairs(redirects) do
    add(intents, redir)
  end

  if poke.dir then
    local tx, ty = next_position(poke.x, poke.y, poke.dir)
    add(intents, {dir = poke.dir, x = tx, y = ty, redir = false})
  end

  return intents
end

function calc_fire_intents(lvl, pokes, fire, fire_dir, nudges)
  local goal_reached = (fire.x == lvl.goal[1] and fire.y == lvl.goal[2])
  if goal_reached then return {{x = fire.x, y = fire.y, dir = nil, redir = false}} end

  local intents = {}

  if nudges.fire then
    for _, nudger in ipairs(nudges.fire) do
      if nudger.rot then
        local tx, ty = next_position(fire.x, fire.y, nudger.rot)
        add(intents, {x = tx, y = ty, dir = nudger.rot, redir = true, is_nudge = true, poke = nudger})
      end
    end
  end

  local redirects = poke_redirects(pokes, fire.x, fire.y, nil)
  for _, redir in ipairs(redirects) do
    add(intents, redir)
  end

  if fire_dir then
    local tx, ty = next_position(fire.x, fire.y, fire_dir)
    add(intents, {x = tx, y = ty, dir = fire_dir, redir = false})
  end

  return intents
end

function calc_valid_intents(lvl, pokes, fire, entity, entity_type, intents, include_momentum)
  local valid_intents = {}
  for _, intent in ipairs(intents) do
    if intent.redir == true or include_momentum then
      if (intent.x ~= entity.x or intent.y ~= entity.y)
        and is_valid_move(lvl, pokes, fire, entity_type, intent.x, intent.y) then
        add(valid_intents, intent)
      end
    end
  end
  return valid_intents
end

function towards_flame(fire, poke, intents)
  for _, intent in ipairs(intents) do
    if intent.redir == true then
      if (intent.x ~= poke.x or intent.y ~= poke.y)
        and intent.x == fire.x and intent.y == fire.y then
        return true
      end
    end
  end
  return false
end

function should_move(valid_intents)
  local nudge = nil
  for _, intent in ipairs(valid_intents) do
    if intent.is_nudge then
      if nudge then
        return false, nil
      end
      nudge = intent
    end
  end

  if nudge then
    return true, nudge
  end

  if #valid_intents == 1 then
    return true, valid_intents[1]
  elseif #valid_intents == 2 and valid_intents[1].redir == true and valid_intents[2].redir == false then
    return true, valid_intents[1]
  end

  return false, nil
end

function animate_entity(e)
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

function exec_move(e, intent)
  e.move_dx = (intent.x - e.x) / frames_in_step
  e.move_dy = (intent.y - e.y) / frames_in_step
  e.frames = frames_in_step
  e.draw_x = e.x
  e.draw_y = e.y
  e.x = intent.x
  e.y = intent.y
end

function set_flash(message)
  if flash then return end
  if message == lvl.osd then return end

  flash = message
  flash_frames = frames_in_step * 11
  help_text_color_step = 1
end

function detect_nudges(pokes, fire, original_positions, moved_entities)
  local nudges = {}
  local objs = {}

  if moved_entities.fire then
    add(objs, {id = "fire", old_x = original_positions.fire.x, old_y = original_positions.fire.y,
                   new_x = fire.x, new_y = fire.y})
  end
  for i, poke in pairs(pokes) do
    if moved_entities[i] then
      add(objs, {id = i, old_x = original_positions[i].x, old_y = original_positions[i].y,
                     new_x = poke.x, new_y = poke.y, rot = poke.rot})
    end
  end

  for i = 1, #objs do
    for j = i + 1, #objs do
      local e1, e2 = objs[i], objs[j]

      local dx1, dy1 = e1.new_x - e1.old_x, e1.new_y - e1.old_y
      local dx2, dy2 = e2.new_x - e2.old_x, e2.new_y - e2.old_y

      if dy1 == 0 and dy2 == 0 and (e1.old_y == e2.old_y - 1 or e1.old_y == e2.old_y + 1) then
        if e1.new_x == e2.old_x and e2.new_x == e1.old_x then
          local e1_toward_e2 = e1.rot and ((e2.new_y > e1.new_y and e1.rot == 3) or (e2.new_y < e1.new_y and e1.rot == 1))
          local e2_toward_e1 = e2.rot and ((e1.new_y > e2.new_y and e2.rot == 3) or (e1.new_y < e2.new_y and e2.rot == 1))
          if e1_toward_e2 then
            if not nudges[e2.id] then nudges[e2.id] = {} end
            add(nudges[e2.id], (e1.id == "fire") and fire or pokes[e1.id])
          end
          if e2_toward_e1 then
            if not nudges[e1.id] then nudges[e1.id] = {} end
            add(nudges[e1.id], (e2.id == "fire") and fire or pokes[e2.id])
          end
        end
      end

      if dx1 == 0 and dx2 == 0 and (e1.old_x == e2.old_x - 1 or e1.old_x == e2.old_x + 1) then
        if e1.new_y == e2.old_y and e2.new_y == e1.old_y then
          local e1_toward_e2 = e1.rot and ((e2.new_x > e1.new_x and e1.rot == 2) or (e2.new_x < e1.new_x and e1.rot == 4))
          local e2_toward_e1 = e2.rot and ((e1.new_x > e2.new_x and e2.rot == 2) or (e1.new_x < e2.new_x and e2.rot == 4))
          if e1_toward_e2 then
            if not nudges[e2.id] then nudges[e2.id] = {} end
            add(nudges[e2.id], (e1.id == "fire") and fire or pokes[e1.id])
          end
          if e2_toward_e1 then
            if not nudges[e1.id] then nudges[e1.id] = {} end
            add(nudges[e1.id], (e2.id == "fire") and fire or pokes[e2.id])
          end
        end
      end
    end
  end

  return nudges
end

function blink(intents)
  for _, intent in ipairs(intents) do
    if intent.poke then
      add(blinking_pokes, intent.poke)
    end
  end
end

function turn()
  local pokes_bak = {}
  for i, poke in pairs(pokes) do
    pokes_bak[i] = {
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
  local fire_bak = {
    x = fire.x,
    y = fire.y,
    draw_x = fire.draw_x,
    draw_y = fire.draw_y,
    move_dx = fire.move_dx,
    move_dy = fire.move_dy,
    frames = fire.frames
  }
  local fire_bak_dir = fire_dir

  local function rollback()
    for j, b in pairs(pokes_bak) do
      pokes[j].x = b.x
      pokes[j].y = b.y
      pokes[j].dir = b.dir
      pokes[j].moving = b.moving
      pokes[j].draw_x = b.draw_x
      pokes[j].draw_y = b.draw_y
      pokes[j].move_dx = b.move_dx
      pokes[j].move_dy = b.move_dy
      pokes[j].frames = b.frames
    end
    fire.x = fire_bak.x
    fire.y = fire_bak.y
    fire.draw_x = fire_bak.draw_x
    fire.draw_y = fire_bak.draw_y
    fire.move_dx = fire_bak.move_dx
    fire.move_dy = fire_bak.move_dy
    fire.frames = fire_bak.frames
    fire_dir = fire_bak_dir
  end

  local function maybe_rollback(valid_intents, prefix)
    if #valid_intents > 2 or (#valid_intents == 2 and valid_intents[1].redir == true and valid_intents[2].redir == true) then
      rollback()
      set_flash(prefix.."\nNEEDS CLEAR DIRECTIONS.")
      blink(valid_intents)
      return true
    end

    return false
  end

  -- Phase 1: Calc intents based on original state
  local intents_per_poke = {}
  local original_positions = {fire = {x = fire.x, y = fire.y}}

  for i, poke in pairs(pokes) do
    intents_per_poke[i] = calc_poke_intents(pokes, i, nudges)
    original_positions[i] = {x = poke.x, y = poke.y}
  end

  -- Stop two pokes from moving onto same cell
  local destinations_per_poke = {}

  for i, poke in pairs(pokes) do
    local valid_intents = calc_valid_intents(lvl, pokes, fire, poke, "poke", intents_per_poke[i], true)
    local can_move, intent = should_move(valid_intents)

    if can_move and intent then
      destinations_per_poke[i] = {x = intent.x, y = intent.y}
    end
  end

  for i, a in pairs(destinations_per_poke) do
    for j, b in pairs(destinations_per_poke) do
      if i ~= j and a.x == b.x and a.y == b.y then
        set_flash("A PRICKLY POKE\nNEEDS CLEAR DIRECTIONS.")
        blink({{poke = pokes[i]}, {poke = pokes[j]}})
        return false, false
      end
    end
  end

  local fire_intents = calc_fire_intents(lvl, pokes, fire, fire_dir, nudges)

  -- Phase 2
  local already_moved = {fire = false}
  for i in pairs(pokes) do already_moved[i] = false end

  local moved = true
  local priority_pass = false
  local momentum_pass = false

  while moved do
    moved = false

    for i, poke in pairs(pokes) do
      if not already_moved[i] then
        if not priority_pass or not towards_flame(fire, poke, intents_per_poke[i]) then
          local valid_intents = calc_valid_intents(lvl, pokes, fire, poke, "poke", intents_per_poke[i], priority_pass or momentum_pass)

          local can_move, intent = should_move(valid_intents)
          if can_move and intent then
            exec_move(poke, intent)
            poke.dir = intent.dir
            poke.moving = not not intent.dir
            already_moved[i] = true
            moved = true
            break
          else
            if maybe_rollback(valid_intents, "A PRICKLY POKE") then return false, false end
          end
        end
      end
    end

    if not moved and not priority_pass and not momentum_pass then
      priority_pass = true
      moved = true
    end

    if not moved and not already_moved.fire then
      local valid_intents = calc_valid_intents(lvl, pokes, fire, fire, "fire", fire_intents, true)

      local can_move, intent = should_move(valid_intents)
      if can_move and intent then
        exec_move(fire, intent)

        if intent.dir then
          fire_dir = intent.dir
        end
        already_moved.fire = true
        moved = true
      else
        if maybe_rollback(valid_intents, "A FICKLE FLAME") then return false, false end
      end
    end

    if not moved and not momentum_pass then
      priority_pass = false
      momentum_pass = true
      moved = true
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

  nudges = detect_nudges(pokes, fire, original_positions, already_moved)

  local any_poke_moved = false
  for i, _ in pairs(pokes) do
    if already_moved[i] then any_poke_moved = true break end
  end

  return already_moved.fire, any_poke_moved
end

function make_poke(a, ro)
  return {
    x = a.x, y = a.y,
    draw_x = a.x, draw_y = a.y,
    move_dx = 0, move_dy = 0, frames = 0,
    rot = a.rot, ro = ro
  }
end

function reset_lvl(next_lvl)
  lvl_timer = 0
  step_counter = 0
  turn_time = false
  fire_dir = nil
  success_sound_played = false
  fail_sound_played = false
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
    lvl_idx = lvl_idx + 1
    if lvl_idx > #lvls then
      set_completed_from_lvl_data()

      if all_worlds_completed then
        game_state = "title"
      else
        game_state = "world_picker"
      end

      return
    end

    if lvls[lvl_idx].intro then
      current_text = lvls[lvl_idx].intro
      game_state = "lvl_intro"
      return
    end
  end

  lvl = lvls[lvl_idx] or lvls[1]
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

function check_cheat_codes()
  if btnp(3, 1) then
    sfx(menu_action_sfx)
    reset_lvl(false)
    return true
  end

  if btnp(2, 1) then
    sfx(menu_action_sfx)
    if lvl_idx > 1 then
      lvl_idx = lvl_idx - 1
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

function handle_inputs()
  if (btnp(0)) then cursor_x = cursor_x - 1; sfx(nav_sfx) end
  if (btnp(1)) then cursor_x = cursor_x + 1; sfx(nav_sfx) end
  if (btnp(2)) then cursor_y = cursor_y - 1; sfx(nav_sfx) end
  if (btnp(3)) then cursor_y = cursor_y + 1; sfx(nav_sfx) end
  if (btnp(5)) then
    local exists = false
    for poke in all(pokes) do
      if poke.x == cursor_x and poke.y == cursor_y then
        exists = true
        if poke.ro then
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
      if not a.ro then
        pre_turn_pokes[#pre_turn_pokes+1] = {x=a.x, y=a.y, rot=a.rot}
      end
    end

    turn_time = true
    turn_timer = 0
  end
end

function draw_obs()
  local obs_sprite = worlds[world_idx].obs_sprite
  if lvl and lvl.obs then
    for _, obs in pairs(lvl.obs) do
      spr(obs_sprite, grid_start_x + grid_x*(obs[1]-1), grid_start_y + grid_y*(obs[2]-1))
    end
  end
end

function draw_fire()
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

function draw_pokes()
  if #blinking_pokes > 0 then
    blinking_step = blinking_step + 1
    if blinking_step > (blinking_steps * 12) then
      blinking_step = 1
      blinking_pokes = {}
    end
  end

  for poke in all(pokes) do
    local sprite = nil
    if poke.ro then
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

function word_width(word)
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

function draw_word(word, start_x, start_y, color, outline)
  if outline then
    draw_word(word, start_x - 1, start_y, worlds[world_idx].bg_color, false)
    draw_word(word, start_x + 1, start_y, worlds[world_idx].bg_color, false)
    draw_word(word, start_x, start_y - 1, worlds[world_idx].bg_color, false)
    draw_word(word, start_x, start_y + 1, worlds[world_idx].bg_color, false)
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

function draw_text(text, start_x, start_y, max_width, text_color, outline)
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
      -- Collect consecutive spaces as a word
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

  -- Draw words with wrapping
  local current_x = start_x
  local line_words = {}

  for word in all(words) do
    if word == "\n" then
      -- Draw current line
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
        -- Draw current line
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

  -- Draw any remaining words
  if #line_words > 0 then
    current_x = start_x
    for i = 1, #line_words do
      local line_word = line_words[i]
      current_x = draw_word(line_word, current_x, y, color, outline)
    end
  end
end

function draw_help_text(message)
  if message then
    -- Count newlines to calculate starting y position
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

function draw_dithering_night()
  local y = 0
  for _, sprite in ipairs({45, 44, 42, 43, 38, 39, 40, 41}) do
    for x=0,15 do
      spr(sprite, x*8, y)
    end
    y = y + 8
  end
end

function draw_title_screen()
  draw_dithering_night()

  -- The gaslight needs to be drawn in two passes.
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

  print_big("THE", 1, 72, 7)
  print_big(all_worlds_completed and "LOFTY" or "LOWLY", 2, 91, 7)
  print_big("LAMPLIGHTER", 2, 110, 7)

  local start_hint_x = 9
  local start_hint_y = 6
  if blink_timer % 60 > 30 then
    rectfill(start_hint_x - 1, start_hint_y - 1, 71, 10, 9)
    print("PRESS X TO START", start_hint_x, start_hint_y, 4)
  end
end

function draw_button(text, side_text, x, y, width, height, is_selected, sprite_id, text_x_offset)
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

function draw_world_picker()
  draw_text("CHOOSE A NEIGHBORHOOD", 23, 3, 110, 4)

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
    draw_button(world.name, completed_lvls.."/"..#world.lvls, x, y, rect_width, rect_height, world_idx == i, is_world_completed(world) and 15 or 3)
  end

  local controls_y = start_y + #worlds * spacing + 12
  draw_button("CONTROLS", nil, x, controls_y, rect_width, rect_height, world_picker_sel == "controls", 30, 38)

  local settings_y = controls_y + spacing
  draw_button("SETTINGS", nil, x, settings_y, rect_width, rect_height, world_picker_sel == "settings", 29, 38)

  draw_text("X TO SELECT", 43, 120, 110, 5)
end

function draw_settings_screen()
  draw_text("SETTINGS", 48, 3, 110, 4)

  local x = 10
  local y = 30
  local rect_width = 108
  local rect_height = 10
  local spacing = 14

  local particles_text = particles_enabled and "DISABLE PARTICLES" or "ENABLE PARTICLES"
  local toggle_coordinates_button_label = coordinates_enabled and "HIDE COORDINATES" or "SHOW COORDINATES"
  draw_button(toggle_music_button_label, nil, x, y, rect_width, rect_height, settings_sel == 1, nil, 20)
  draw_button(particles_text, nil, x, y + spacing, rect_width, rect_height, settings_sel == 2, nil, 20)
  draw_button(toggle_coordinates_button_label, nil, x, y + spacing + spacing, rect_width, rect_height, settings_sel == 3, nil, 20)
  draw_button(delete_save_data_button_label, nil, x, y + spacing + spacing + spacing, rect_width, rect_height, settings_sel == 4, nil, 20)

  draw_text("X TO SELECT    Z TO GO BACK", 10, 120, 110, 5)
end

function draw_controls_screen()
  draw_text("IN-GAME CONTROLS", 34, 3, 110, 4)

  local x = 13
  local y = 30
  local height = 8

  draw_text("ARROW KEYS", x, y, 110, 7)
  draw_text("NAVIGATE", x + 57, y, 110, 5)

  draw_text("X", x, y + height, 110, 7)
  draw_text("PLACE POKE", x + 57, y + height, 110, 5)

  draw_text("X", x, y + height * 2, 110, 7)
  draw_text("ROTATE POKE", x + 57, y + height * 2, 110, 5)

  draw_text("Z", x, y + height * 3, 110, 7)
  draw_text("START TURN", x + 57, y + height * 3, 110, 5)

  draw_text("D", x, y + height * 4, 110, 7)
  draw_text("RESET LEVEL", x + 57, y + height * 4, 110, 5)

  draw_text("F", x, y + height * 5, 110, 7)
  draw_text("SKIP LEVEL", x + 57, y + height * 5, 110, 5)

  draw_text("E", x, y + height * 6, 110, 7)
  draw_text("SKIP BACK", x + 57, y + height * 6, 110, 5)

  draw_text("Z TO GO BACK", 40, 120, 110, 5)
end

function spawn_raindrops()
  if not particles_enabled then return end

  local spawn_chance = world_idx <= #worlds and worlds[world_idx].rain_density or 0.1
  if rnd(1) < spawn_chance then
      local drop = {
          x = flr(rnd(128)),
          y = flr(rnd(128))
      }
      add(raindrops, drop)
  end
end

function draw_rain(rain_color)
  local color = rain_color or world_idx <= #worlds and worlds[world_idx].rain_color or worlds[1].rain_color

  if color > 15 and game_state == "game" then
    pal(color - 128, color, 1)
  end

  for drop in all(raindrops) do
    pset(drop.x, drop.y, color)
  end
end

function play_music(boolean)
  music_enabled = boolean
  dset(61, music_enabled and 0 or 1)

  if music_enabled then
    music(17, 0, 7) -- locking the 3 4most tracks
    toggle_music_button_label = "Disable music"
  else
    music(-1)
    toggle_music_button_label = "Enable music"
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
    local x_mult = 1
    local y_mult = 1
    local rain_dir = world_idx <= #worlds and worlds[world_idx].rain_dir or worlds[1].rain_dir

    if rain_dir == "left" then
      x_mult = -1
      y_mult = 1
    elseif rain_dir == "right" then
      x_mult = 1
      y_mult = 1
    end

    for drop in all(raindrops) do
      drop.x = drop.x + rain_speed * x_mult
      drop.y = drop.y + rain_speed * y_mult

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
        world_idx = world_idx - 1
        if world_idx < 1 then world_idx = #worlds end
      elseif world_picker_sel == "controls" then
        world_picker_sel = "world"
        world_idx = #worlds
      elseif world_picker_sel == "settings" then
        world_picker_sel = "controls"
      end
      sfx(nav_sfx)
    end

    if btnp(3) then
      if world_picker_sel == "world" then
        world_idx = world_idx + 1
        if world_idx > #worlds then
          world_picker_sel = "controls"
        end
      elseif world_picker_sel == "controls" then
        world_picker_sel = "settings"
      elseif world_picker_sel == "settings" then
        world_picker_sel = "world"
        world_idx = 1
      end
      sfx(nav_sfx)
    end

    if btnp(5) then
      sfx(menu_action_sfx)
      if world_picker_sel == "settings" then
        game_state = "settings_screen"
        delete_save_data_button_label = "Delete save data"
      elseif world_picker_sel == "controls" then
        game_state = "controls_screen"
      else
        lvls = worlds[world_idx].lvls
        lvl_idx = 1

        -- Check if first lvl has intro text
        if lvls[lvl_idx].intro then
          current_text = lvls[lvl_idx].intro
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
        delete_save_data_button_label = "Save data deleted"

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
      animate_entity(poke)
    end

    animate_entity(fire)

    if turn_timer >= frames_in_step then
      turn_timer = 0
      step_counter = step_counter + 1
      local goal_reached = (fire.x == lvl.goal[1] and fire.y == lvl.goal[2])
      local fire_moved = false
      local poke_moved = false

      if not goal_reached and lvl_timer == 0 then
        fire_moved, poke_moved = turn()
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
            set_flash("THE FICKLE FLAME DIED OUT...")
          end

          if not fail_sound_played then
            sfx(61)
            fail_sound_played = true
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
    local bg = worlds[world_idx] and worlds[world_idx].bg_color or 129
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
    local bg = worlds[world_idx].bg_color
    if bg > 15 then
      pal(bg - 128, bg, 1)
    end
    cls(bg - 128)
    draw_rain()
    draw_text(current_text, 9, 50, 110)
    return
  end

  -- In-game
  local bg = worlds[world_idx].bg_color
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

  print("LEVEL "..world_idx.."-"..lvl_idx, grid_start_x - 1, 1, worlds[world_idx].txt_color)
  if coordinates_enabled then
    print(cursor_x..","..cursor_y, 128/2 - 5, 1, worlds[world_idx].txt_color)
  end
  print("POKE", grid_start_x + 88, 1, worlds[world_idx].txt_color)
  print("S x"..remaining_pokes, grid_start_x + 104, 1, worlds[world_idx].txt_color)

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
