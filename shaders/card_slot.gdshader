shader_type canvas_item;

// Outline width in pixels.
uniform float outline_px : hint_range(0.0, 8.0) = 2.0;
// Outline color (slot color).
uniform vec4 outline_color : source_color = vec4(1.0);

// If true, hide the original fill and show only the outline (slot look).
uniform bool outline_only = true;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    float a = tex.a;

    // Compute neighbor alpha to detect the edge.
    vec2 ts = vec2(textureSize(TEXTURE, 0));
    vec2 px = 1.0 / ts;

    float max_neighbor = 0.0;
    // 8-neighborhood (you can add more samples for a thicker/smoother outline)
    vec2 offs[8] = vec2[](
        vec2(-1,  0), vec2(1,  0),
        vec2( 0, -1), vec2(0,  1),
        vec2(-1, -1), vec2(1, -1),
        vec2(-1,  1), vec2(1,  1)
    );

    for (int i = 0; i < 8; i++) {
        float na = texture(TEXTURE, UV + offs[i] * px * outline_px).a;
        max_neighbor = max(max_neighbor, na);
    }

    // Edge pixel if current is transparent but a neighbor is opaque.
    bool is_outline = (a == 0.0 && max_neighbor > 0.0);

    if (outline_only) {
        COLOR = is_outline ? outline_color : vec4(0.0);
    } else {
        // Show the original sprite plus the outline “behind” it.
        vec4 base = tex;
        vec4 outc = is_outline ? outline_color : vec4(0.0);
        // If you want the outline to sit behind the sprite, choose the max alpha.
        COLOR = (outc.a > base.a) ? outc : base;
    }
}
