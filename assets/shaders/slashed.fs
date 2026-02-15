extern vec4 slashes[10];
extern float blue_phases[10];

extern vec2 bottom_right;
extern vec2 card_pos;
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

    vec2 temp_coords = texture_coords;
    float PI = 3.14159265359;

    for (int i = 0; i < 10; i++) {
        vec4 current_slash = slashes[i];

        vec2 p1 = weighted_midpoint(current_slash.xy * min(bottom_right.x, bottom_right.y), card_pos, 0.04);
        vec2 p2 = weighted_midpoint(current_slash.zw * min(bottom_right.x, bottom_right.y), card_pos, 0.04);

        float min_dist = clamp((progress - i) * 2.0, 0.0, 2.0);
        if (get_dist_from_line(p1, p2, screen_coords) >= min_dist && p2 != screen_coords) {
            vec2 line = p2 - p1;
            vec2 perp = normalize(vec2(line.y, -line.x)) * min_dist / length(bottom_right) * 5.5;
            float sign = -sign(acos(dot(perp, p2 - screen_coords) / (min_dist * length(p2 - screen_coords))) - PI/2);
            temp_coords += perp * sign * clamp(11.0 - progress, 0.0, 1.0);
        }
    }

    vec4 tex = Texel(texture, temp_coords);
    // add colour-modifying effects here
    
    for (int i = 0; i < 10; i++) {
        vec4 current_slash = slashes[i];

        vec2 p1 = weighted_midpoint(current_slash.xy * min(bottom_right.x, bottom_right.y), card_pos, 0.04);
        vec2 p2 = weighted_midpoint(current_slash.zw * min(bottom_right.x, bottom_right.y), card_pos, 0.04);

        float min_dist = clamp((progress - i) * 2.0, 0.0, 2.0);
        float blue_fac = clamp(sqrt(blue_phases[i]), 0.5, 1.0);
        if (get_dist_from_line(p1, p2, screen_coords) < min_dist) {
            tex.rgb = blend(vec3(blue_fac, blue_fac, 1.0), tex.rgb, min(11.0 - progress, 1.0));
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