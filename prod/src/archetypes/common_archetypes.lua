


return {
 
 



world_light = {
  light = {type = "world_light", pow = 0.1 , diffuse = {1,1,1}}
  

  
},

timer  = {
  timer = {}
  
  
},

monster = {
  body = {},
  sound_emitter = {},
    rigid_body = { body_type = "dynamic", cast_shadows =false, gravity = false, collider = { type = "rectangle_collider", args = {material = {name = "standard_material"},size = {25,25}} } },
  sprite_renderer = { layer_order = 1 ,color = {1,0,0,1}, rectangle = true, size = { 25, 25}},
   field_of_view = { radius = 250},
   ia_cavern = {},
   state = {},
  light = { pow = 0.8 , pow_max = 0.8 , range = 250, type = "shadow_light", diffuse = {1,1,1}},
},

map = {
  sprite_renderer = {}
  
  
  },

wall = {
 body = {},
 sprite_renderer = { rectangle = true, size = { 75, 75}},
--rigid_body = {body_type = "static", collider = {type = "rectangle_collider", args = {size = {5,5}} }},
},

wall10 = {
 body = {},
 sprite_renderer = {color = {25/255,25/255,200/225,1},  rectangle = true, size = { 75, 75}},
rigid_body = {body_type = "static", collider = {type = "rectangle_collider", args = {size = {75,75}} }},
},



ground = {
  body = { position = {400 , 600}, rot = 0},
  rigid_body = {body_type = "static", collider = {type = "rectangle_collider", args = {size = {800,100}} }},
  sprite_renderer = { rectangle = true, size = { 200, 100}}
},

wall1 ={
  body = { position = { 50, 400}, rot = 0},
  rigid_body = {body_type = "static", collider = {type = names.rectangle_collider, args = {size = {20,800}} }},
  sprite_renderer = { rectangle = true, size = {w = 20, h = 800}}
},

wall2 ={
  body = { position = { 800, 400}, rot = 0},
  rigid_body = {body_type = "static", collider = {type = names.rectangle_collider, args = {size = {10,800}} }},
  sprite_renderer = { rectangle = true, size = {w = 10, h = 800}}
},

obs1 ={
  body = { position = { 250, 200}, rot = math.pi/4},
  rigid_body = {body_type = "static", collider = {type = names.rectangle_collider, args = {size = {200,10}} }},
  sprite_renderer = { color = {0,0,1,1} ,rectangle = true, size = {w = 200, h = 10}}
},

obs2 ={
  body = { position = { 150, 400}, rot = -math.pi/4},
  rigid_body = {body_type = "static", collider = {type = names.rectangle_collider, args = {size = {200,10}} }},
  sprite_renderer = { color = {0,0,1,1},rectangle = true, size = {w = 200, h = 10}}
},


world_camera = {
  body = { position = { 0, 0}},
  size = { 800, 600},
  --camera_follow = {},
  --follow_mod = {mod = "old"},
  camera_renderer = {size = { 800, 600}, shaders = {{name ="black_white"}}},
  --camera_controller = {},
  --renderer = { shaders = {}}
},


jhonny = {
  body = { position ={300,200}, rot = math.pi/2},
  sound_receiver = {},
  camera_controller = {},
  --lighter ={light = { pow = 1  , type = "shadow_light", diffuse = {1,0,0,1}}},
  --tag = { tag = "player" },
  --jump = {{name = "basic_jump"}},
  --velocity = { x = 0, y = 0 },
 -- keyboard_controller = {},
  --box_collider = { size = { w = 25, h = 25}, material = {name = "standard_material", args = {bouciness = 0.5}}},
  rigid_body = { cast_shadows =false,  body_type = "dynamic", gravity = false, collider = { type = "rectangle_collider", args = {material = {name = "standard_material"},size = {25,25}} } },
  sprite_renderer = { layer_order = 1 ,color = {0,0,1,1}, rectangle = true, size = { 25, 25}},
  --light = { pow = 1  , range = 300, type = "shadow_light", diffuse = { 244/255,102/255,27/255,1}},
  --field_of_view = { radius = 600}
},

lighter = {
  body = {},
  light = { pow = 1  , range = 300, type = "shadow_light", diffuse = {244/255,102/255,27/255,1}},
  field_of_view = { radius = 300},
  lighter = {},
  target = {}
},

ligther_gui = {
 body = {400,400},
 gui_renderer = {}
  
  
},
treasure = {
  body = {},
  light = { pow = 1  ,range =150, sparkling = 0.1,  type = "shadow_light", diffuse = {252/255,209/255,4/255,1}},
  sprite_renderer = { layer_order = 1 ,color = {252/255,209/255,4/255,1}, rectangle = true, size = { 25, 25}},
   field_of_view = { radius = 150},
}



  
}