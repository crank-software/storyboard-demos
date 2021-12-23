#ifdef GL_ES
precision highp float;
#endif

varying vec2 vtex; 
uniform sampler2D sampler2d;

uniform float grd_c_r;
uniform float grd_c_g;
uniform float grd_c_b;

void main()
{
	vec4 col = texture2D(sampler2d, vtex);
	col.rgb = vec3(grd_c_r,grd_c_g,grd_c_b);
	gl_FragColor = col;
}
