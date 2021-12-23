
#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D sampler2d;
uniform float grd_a_cw;
uniform float grd_a_ch;

uniform float grd_a_gr;
uniform float grd_a_gg;
uniform float grd_a_gb;
uniform float grd_a_ga;

varying vec2 myTexCoord;

void main (void)
{
    vec4 texcol = texture2D(sampler2d, myTexCoord);
	float u_xstep=2.0/grd_a_cw;
	float u_ystep=2.0/grd_a_ch;

	if (u_xstep == 0.0) {
		vec4 col = texture2D(sampler2d, myTexCoord);
		gl_FragColor = col;
	} else {

	    //row 1
	    vec4 sample11 = texture2D(sampler2d, myTexCoord + vec2(-2.0*u_xstep, -2.0*u_ystep));
	    vec4 sample12 = texture2D(sampler2d, myTexCoord + vec2(-u_xstep, -2.0*u_ystep));  
	    vec4 sample13 = texture2D(sampler2d, myTexCoord + vec2(0.0, -2.0*u_ystep));
	    vec4 sample14 = texture2D(sampler2d, myTexCoord + vec2(u_xstep, -2.0*u_ystep));  
	    vec4 sample15 = texture2D(sampler2d, myTexCoord + vec2(2.0*u_xstep, -2.0*u_ystep));
	
	    //row 2
	    vec4 sample21 = texture2D(sampler2d, myTexCoord + vec2(-2.0*u_xstep, -u_ystep));
	    vec4 sample22 = texture2D(sampler2d, myTexCoord + vec2(-u_xstep, -u_ystep));  
	    vec4 sample23 = texture2D(sampler2d, myTexCoord + vec2(0.0, -u_ystep));
	    vec4 sample24 = texture2D(sampler2d, myTexCoord + vec2(u_xstep, -u_ystep));  
	    vec4 sample25 = texture2D(sampler2d, myTexCoord + vec2(2.0*u_xstep, -u_ystep));
	
	    //row 3 
	    vec4 sample31 = texture2D(sampler2d, myTexCoord + vec2(-2.0*u_xstep, 0.0));
	    vec4 sample32 = texture2D(sampler2d, myTexCoord + vec2(-u_xstep, 0.0));  
	    vec4 sample33 = texture2D(sampler2d, myTexCoord + vec2(0.0, 0.0));
	    vec4 sample34 = texture2D(sampler2d, myTexCoord + vec2(u_xstep, 0.0));  
	    vec4 sample35 = texture2D(sampler2d, myTexCoord + vec2(2.0*u_xstep, 0.0));
	
	    //row 4 
	    vec4 sample41 = texture2D(sampler2d, myTexCoord + vec2(-2.0*u_xstep, u_ystep));
	    vec4 sample42 = texture2D(sampler2d, myTexCoord + vec2(-u_xstep, u_ystep));  
	    vec4 sample43 = texture2D(sampler2d, myTexCoord + vec2(0.0, u_ystep));
	    vec4 sample44 = texture2D(sampler2d, myTexCoord + vec2(u_xstep, u_ystep));  
	    vec4 sample45 = texture2D(sampler2d, myTexCoord + vec2(2.0*u_xstep, u_ystep));
	
	    //row 5 
	    vec4 sample51 = texture2D(sampler2d, myTexCoord + vec2(-2.0*u_xstep, 2.0*u_ystep));
	    vec4 sample52 = texture2D(sampler2d, myTexCoord + vec2(-u_xstep, 2.0*u_ystep));  
	    vec4 sample53 = texture2D(sampler2d, myTexCoord + vec2(0.0, 2.0*u_ystep));
	    vec4 sample54 = texture2D(sampler2d, myTexCoord + vec2(u_xstep, 2.0*u_ystep));  
	    vec4 sample55 = texture2D(sampler2d, myTexCoord + vec2(2.0*u_xstep, 2.0*u_ystep));
	
	    vec4 row1 = 0.00366*sample11 + 0.01465*sample12 + 0.02564*sample13 + 0.01465*sample14 + 0.00366*sample15;
	    vec4 row2 = 0.01465*sample21 + 0.05861*sample22 + 0.09523*sample23 + 0.05861*sample24 + 0.01465*sample25;
	    vec4 row3 = 0.02564*sample31 + 0.09523*sample32 + 0.15018*sample33 + 0.09523*sample34 + 0.02564*sample35;
	    vec4 row4 = 0.01465*sample41 + 0.05861*sample42 + 0.09523*sample43 + 0.05861*sample44 + 0.01465*sample45;
	    vec4 row5 = 0.00366*sample51 + 0.01465*sample52 + 0.02564*sample53 + 0.01465*sample54 + 0.00366*sample55;
	
	    vec4 colour = row1 + row2 + row3 + row4 + row5;
	    
	    float grey = sqrt(length(colour.rgb));
	    vec4 new_col = vec4(grey*grd_a_gr, grey*grd_a_gg, grey*grd_a_gb, grey*grd_a_ga);
	    vec4 w;
	    if (sample33.r == sample33.g && sample33.g == sample33.b) {
			w = vec4(texcol.a, texcol.a,texcol.a,texcol.a);
		} else {
			w = sample33;
		}	    
		gl_FragColor = clamp(new_col*(1.0-w.a)+w, 0.0, 1.0);
	}
}
                         
