shader_type sky;

uniform vec4 sky_top_color : hint_color = vec4(0.35, 0.46, 0.71, 1.0);
uniform vec4 sky_horizon_color : hint_color = vec4(0.55, 0.69, 0.81, 1.0);
uniform float sky_curve : hint_range(0, 1) = 0.09;
uniform float sky_energy = 1.0;

uniform vec4 ground_bottom_color : hint_color = vec4(0.12, 0.12, 0.13, 1.0);
uniform vec4 ground_horizon_color : hint_color = vec4(0.37, 0.33, 0.31, 1.0);
uniform float ground_curve : hint_range(0, 1) = 0.02;
uniform float ground_energy = 1.0;

uniform float sun_angle_max = 1.74;
uniform float sun_curve : hint_range(0, 1) = 0.05;

//uniform mat4 projection_matrix = mat4(0.0);
uniform vec2 resolution = vec2(1, 1);
uniform vec2 tan_fov = vec2(1, 1);

const float PI = 3.1415926535897932384626433833;

void fragment() {
	COLOR = vec3(0, 0, 0);

	bool draw_overlays = !AT_HALF_RES_PASS && !AT_QUARTER_RES_PASS && !AT_CUBEMAP_PASS;
	if (draw_overlays)
	{
		int div = 36;
		vec2 vdiv = vec2(float(div), float(div >> 1));
		
		vec2 cellsize = vec2(2.0*PI, PI) / vdiv;
		vec2 cell = SKY_COORDS * vdiv;
		vec2 celldist = fract(cell + vec2(0.5, 0.5)) - vec2(0.5, 0.5);

		vec2 angle = celldist * cellsize;
//		float min_angle = min(abs(angle.y), abs(angle.x));
		
		vec2 pixeldist = tan(angle) / tan_fov;

		float min_dist = min(abs(pixeldist.y), abs(pixeldist.x));
		float value = smoothstep(0.01, 0.0, min_dist);
		
		COLOR.rg = vec2(1, 1) * value;
		
		vec2 offset = atan((SCREEN_UV.xy * 2.0 - vec2(1.0, 1.0)) * tan_fov);
		COLOR = vec3(offset.xy, 0);
//		COLOR = vec3(resolution, 0);
//		COLOR = projection_matrix[3].xyz;
	}

//	float v_angle = acos(clamp(EYEDIR.y, -1.0, 1.0));
//	float c = (1.0 - v_angle / (PI * 0.5));
//	vec3 sky = mix(sky_horizon_color.rgb, sky_top_color.rgb, clamp(1.0 - pow(1.0 - c, 1.0 / sky_curve), 0.0, 1.0));
//	sky *= sky_energy;
//	if (LIGHT0_ENABLED) {
//		float sun_angle = acos(dot(LIGHT0_DIRECTION, EYEDIR));
//		if (sun_angle < LIGHT0_SIZE) {
//			sky = LIGHT0_COLOR * LIGHT0_ENERGY;
//		} else if (sun_angle < sun_angle_max) {
//			float c2 = (sun_angle - LIGHT0_SIZE) / (sun_angle_max - LIGHT0_SIZE);
//			sky = mix(LIGHT0_COLOR * LIGHT0_ENERGY, sky, clamp(1.0 - pow(1.0 - c2, 1.0 / sun_curve), 0.0, 1.0));
//		}
//	}
//	if (LIGHT1_ENABLED) {
//		float sun_angle = acos(dot(LIGHT1_DIRECTION, EYEDIR));
//		if (sun_angle < LIGHT1_SIZE) {
//			sky = LIGHT1_COLOR * LIGHT1_ENERGY;
//		} else if (sun_angle < sun_angle_max) {
//			float c2 = (sun_angle - LIGHT1_SIZE) / (sun_angle_max - LIGHT1_SIZE);
//			sky = mix(LIGHT1_COLOR * LIGHT1_ENERGY, sky, clamp(1.0 - pow(1.0 - c2, 1.0 / sun_curve), 0.0, 1.0));
//		}
//	}
//	if (LIGHT2_ENABLED) {
//		float sun_angle = acos(dot(LIGHT2_DIRECTION, EYEDIR));
//		if (sun_angle < LIGHT2_SIZE) {
//			sky = LIGHT2_COLOR * LIGHT2_ENERGY;
//		} else if (sun_angle < sun_angle_max) {
//			float c2 = (sun_angle - LIGHT2_SIZE) / (sun_angle_max - LIGHT2_SIZE);
//			sky = mix(LIGHT2_COLOR * LIGHT2_ENERGY, sky, clamp(1.0 - pow(1.0 - c2, 1.0 / sun_curve), 0.0, 1.0));
//		}
//	}
//	if (LIGHT3_ENABLED) {
//		float sun_angle = acos(dot(LIGHT3_DIRECTION, EYEDIR));
//		if (sun_angle < LIGHT3_SIZE) {
//			sky = LIGHT3_COLOR * LIGHT3_ENERGY;
//		} else if (sun_angle < sun_angle_max) {
//			float c2 = (sun_angle - LIGHT3_SIZE) / (sun_angle_max - LIGHT3_SIZE);
//			sky = mix(LIGHT3_COLOR * LIGHT3_ENERGY, sky, clamp(1.0 - pow(1.0 - c2, 1.0 / sun_curve), 0.0, 1.0));
//		}
//	}
//	c = (v_angle - (PI * 0.5)) / (PI * 0.5);
//	vec3 ground = mix(ground_horizon_color.rgb, ground_bottom_color.rgb, clamp(1.0 - pow(1.0 - c, 1.0 / ground_curve), 0.0, 1.0));
//	ground *= ground_energy;
//	COLOR = mix(ground, sky, step(0.0, EYEDIR.y));
}
