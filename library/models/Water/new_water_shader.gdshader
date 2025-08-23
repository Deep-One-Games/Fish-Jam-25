// NOTE: Shader automatically converted from Godot Engine 4.4.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_toon, unshaded;

uniform vec2 speed;

uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color, filter_nearest, repeat_enable;
uniform ivec2 albedo_texture_size;
uniform float point_size : hint_range(0.1, 128.0, 0.1);

uniform float roughness : hint_range(0.0, 1.0);
uniform sampler2D texture_metallic : hint_default_white, filter_nearest, repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r, filter_nearest, repeat_enable;

uniform float specular : hint_range(0.0, 1.0, 0.01);
uniform float metallic : hint_range(0.0, 1.0, 0.01);

uniform sampler2D texture_heightmap : hint_default_black, filter_linear, repeat_enable;
uniform float heightmap_scale : hint_range(-16.0, 16.0, 0.001);
uniform int heightmap_min_layers : hint_range(1, 64);
uniform int heightmap_max_layers : hint_range(1, 64);
uniform vec2 heightmap_flip;

uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

uniform float camera_near;
uniform float camera_far;

float linearize_depth(float depth) {
    return camera_near * camera_far / (camera_far - depth * (camera_far - camera_near));
}

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
	UV += speed * TIME;
}

void fragment() {
    vec2 base_uv = UV;

    // Heightmap offset
    vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT * heightmap_flip.x, -BINORMAL * heightmap_flip.y, NORMAL));
    float depth = 1.0 - texture(texture_heightmap, base_uv).r;
    vec2 ofs = base_uv - view_dir.xy * depth * heightmap_scale * 0.01;
    base_uv = ofs;

    // Depth test
    //texture(DEPTH_TEXTURE, SCREEN_UV).r;
    //float frag_depth_raw = FRAGCOORD.z;

    //float scene_depth = linearize_depth(scene_depth_raw);
    //float frag_depth  = linearize_depth(frag_depth_raw);

    //if (scene_depth < frag_depth - 0.001) {
        //vec4 albedo_tex = texture(texture_albedo, base_uv);
        //ALBEDO = albedo.rgb * albedo_tex.rgb;
//
        //float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
        //METALLIC = metallic_tex * metallic;
        //SPECULAR = specular;
//
        //float roughness_tex = dot(texture(texture_roughness, base_uv), vec4(1.0,0.0,0.0,0.0));
        //ROUGHNESS = roughness_tex * roughness;
    //} else {
        vec4 albedo_tex = texture(texture_albedo, base_uv);
        ALBEDO = albedo.rgb * albedo_tex.rgb;

        float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
        METALLIC = metallic_tex * metallic;
        SPECULAR = specular;

        float roughness_tex = dot(texture(texture_roughness, base_uv), vec4(1.0,0.0,0.0,0.0));
        ROUGHNESS = roughness_tex * roughness;
    //}
}
