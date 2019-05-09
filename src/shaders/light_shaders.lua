
return {


  point_light = function ()
    local light = love.graphics.newShader[[


struct Light {
  vec2 position;
  float range ;
  vec3 diffuse;
  float pow;

};

const float constant = 1.0;
const float linear = 0.09;
const float quadratic = 0.032;



extern Light light;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
  
  
  
    vec2 delta = vec2(screen_coords- light.position);
    float distance = length(delta);

  if (distance <= light.range) {
  float attenuation = 1.0-length(delta/light.range) ;
    vec4 diffuse = vec4(light.diffuse*light.pow,attenuation);
    return pixel*diffuse;
  
  
  }


    return vec4(vec3(0),0);
}
]]
    return light
  end,


  shadow_light = function ()
    local light = love.graphics.newShader[[


struct Light {
  vec2 position;
  float range ;
  vec3 diffuse;
  float pow;

};

const float constant = 1.0;
const float linear = 0.09;
const float quadratic = 0.032;



extern Light light;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
  
  
  
    vec2 delta = vec2(screen_coords- light.position);
    float distance = length(delta);

  if (distance <= light.range) {
  float attenuation = 1.0-length(delta/light.range) ;
    vec4 diffuse = vec4(light.diffuse,attenuation*light.pow);
    return pixel*diffuse;
  
  
  }


    return vec4(vec3(0),0);
}
]]
    return light
  end,


  world_light = function ()
    local light = love.graphics.newShader[[


struct Light {
  vec3 diffuse;
  float pow;

};

const float constant = 1.0;
const float linear = 0.09;
const float quadratic = 0.032;



extern Light light;

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
  vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
  


    //vec4 diffuse = vec4(light.diffuse*light.pow,light.pow);
    vec4 diffuse = vec4(light.diffuse,light.pow);
    return pixel*diffuse;
  
}
]]

    return light
  end
}