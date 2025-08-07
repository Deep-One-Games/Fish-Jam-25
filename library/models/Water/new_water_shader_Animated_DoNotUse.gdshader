// NOTE: Shader automatically converted from Godot Engine 4.4.1.stable's StandardMaterial3D.
// Modified: added time-based UV motion for water.

shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_burley, specular_toon, unshaded;

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

// --- NEW: UV motion controls ---
uniform vec2 uv_scroll_speed = vec2(0.03, 0.015);         // linear scroll (uv units / second)
uniform float uv_wave_amplitude = 0.6;                    // how strong the sin/cos perturbation is (tweak)
uniform float uv_wave_frequency = 1.5;                    // spatial frequency of the waves
uniform float uv_wave_speed = 0.7;                        // speed multiplier for the sin/cos waves

void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	// start from base UV (already scaled/offset in vertex)
	vec2 base_uv = UV;

	// apply small time-based motion before sampling heightmap/textures
	// linear scroll
	vec2 scroll_offset = uv_scroll_speed * TIME;

	// subtle wave perturbation (adds non-linear movement)
	vec2 wave_offset = vec2(
		sin((base_uv.y + TIME * uv_wave_speed) * uv_wave_frequency),
		cos((base_uv.x - TIME * uv_wave_speed) * uv_wave_frequency)
	) * uv_wave_amplitude * 0.01; // scale down to keep effect subtle

	base_uv += scroll_offset + wave_offset;

	{
		// Height: Enabled (parallax using moving base_uv)
		vec3 view_dir = normalize(normalize(-VERTEX + EYE_OFFSET) * mat3(TANGENT * heightmap_flip.x, -BINORMAL * heightmap_flip.y, NORMAL));
		float depth = 1.0 - texture(texture_heightmap, base_uv).r;
		vec2 ofs = base_uv - view_dir.xy * depth * heightmap_scale * 0.01;
		base_uv = ofs;
	}

	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;

	float metallic_tex = dot(texture(texture_metallic, base_uv), metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	SPECULAR = specular;

	vec4 roughness_texture_channel = vec4(1.0, 0.0, 0.0, 0.0);
	float roughness_tex = dot(texture(texture_roughness, base_uv), roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
}
