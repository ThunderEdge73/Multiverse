extern vec4 slash1;
extern vec4 slash2;
extern vec4 slash3;
extern vec4 slash4;
extern vec4 slash5;
extern vec4 slash6;
extern vec4 slash7;
extern vec4 slash8;

extern vec2 bottom_right;
extern float progress;

vec3 blend( vec3 c1, vec3 c2, float c1_bias) {
    return c1 * c1_bias + c2 * (1 - c1_bias);
}

float weighted_average(float v1, float v2, float v1_bias) {
    return v1 * v1_bias + v2 * (1 - v1_bias);
}

vec2 weighted_midpoint( vec2 p1, vec2 p2, float p1_bias) {
    return p1 * p1_bias + p2 * (1 - p1_bias);
}

float get_dist_from_line( vec2 p1, vec2 p2, vec2 target) {
    vec3 cross_prod = cross(vec3(p2.x - p1.x, p2.y - p1.y, 0), vec3(p2.x - target.x, p2.y - target.y, 0));
    return length(cross_prod) / distance(p1, p2);
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    //add coordinate-modifying effects here
    vec4 tex = Texel(texture, texture_coords);
    // add colour-modifying effects here
    
    for (int i = 0; i < 8; i++) {
        vec4 current_slash;
        if (i == 0) {
            current_slash = slash1;
        } else if (i == 1) {
            current_slash = slash2;
        } else if (i == 2) {
            current_slash = slash3;
        } else if (i == 3) {
            current_slash = slash4;
        } else if (i == 4) {
            current_slash = slash5;
        } else if (i == 5) {
            current_slash = slash6;
        } else if (i == 6) {
            current_slash = slash7;
        } else {
            current_slash = slash8;
        }

        vec2 p1 = weighted_midpoint(current_slash.xy * bottom_right, bottom_right / 2.0, 0.8);
        vec2 p2 = weighted_midpoint(current_slash.zw * bottom_right, bottom_right / 2.0, 0.8);

        float min_dist = clamp((progress - i) * 10.0, 0.0, 10.0);
        if (get_dist_from_line(p1, p2, screen_coords) < min_dist) {
            tex.rgb = blend(vec3(1.0), tex.rgb, min(9.0 - progress, 1.0));
        }
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