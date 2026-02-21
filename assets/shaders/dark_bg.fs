extern float radius;
extern vec2 center;

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    //add coordinate-modifying effects here
    vec4 tex = Texel(texture, texture_coords);
    // add colour-modifying effects here
    
    if (distance(center, screen_coords) >= radius) {
        tex.rgb = tex.rgb / 4;
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