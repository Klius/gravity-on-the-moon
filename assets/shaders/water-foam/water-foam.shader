shader_type spatial;
render_mode unshaded, cull_disabled;
 
uniform sampler2D dissolve_tex : hint_white;
uniform vec4 front_color : hint_color;
uniform vec4 back_color : hint_color;
 
void fragment()
{
	
	float a = COLOR.r - texture(dissolve_tex, UV).x;
	ALPHA = step(0.0, a);
	ALPHA_SCISSOR = 0.01;
	ALBEDO = front_color.rgb;
	//ALBEDO = mix(back_color,front_color,a).rgb;
//	ALBEDO = mix(back_color, front_color, FRONT_FACING).rgb;
}