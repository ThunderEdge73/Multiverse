extern float stage;
extern vec2 pos;
extern float time;

vec3 blend( vec3 c1, vec3 c2, float c1_bias) {
    float r = c1.r * c1_bias + c2.r * (1 - c1_bias);
    float g = c1.g * c1_bias + c2.g * (1 - c1_bias);
    float b = c1.b * c1_bias + c2.b * (1 - c1_bias);
    return vec3(r, g, b);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    //add coordinate-modifying effects here
    vec4 tex = Texel(texture, texture_coords);
    // add colour-modifying effects here
    
    float rays = ceil(min(stage, 3.0)) * 4;
    float angle = atan(screen_coords.y - pos.y, screen_coords.x - pos.x);

    float PI = 3.14159265359;
    float dist = distance(screen_coords, pos);
    for (int i = 0; i < rays; i++) {
        if (screen_coords.y - pos.y == 0 && screen_coords.x - pos.x == 0) {
            break;
        }
        float fac = 1.5 * cos(i * 2.1 - 0.2);
        float sign = (fac < 0 && mod(i, 2) == 0) ? -1.0 : 1.0;
        fac = (abs(fac) + 1.0) / 2.0 * sign;
        float ray_angle = mod((0.6 + i / 3.0) * time * fac, 2 * PI) - PI;
        
        if (abs(angle - ray_angle) <= (0.1 + floor(i / 4.0) / 18.0) || abs(angle - ray_angle) >= 2 * PI - (0.1 + floor(i / 4.0) / 18.0)) {
            if (dist < (stage - floor(i / 4.0)) * 1500.0) {
                tex.rgb = blend(vec3(1.0, 1.0, 1.0), tex.rgb, min(8.0 - 2.0 * stage, 1.0));
            }
        }
        
    }
    if (stage > 3 && dist < (stage - 3) * 2000.0) {
        tex.rgb = blend(vec3(1.0, 1.0, 1.0), tex.rgb, min(12.0 - 3.0 * stage, 1.0));
    }

    return tex;
}


//necessary to prevent crashes i believe
#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    return transform_projection * vertex_position;
}
#endif