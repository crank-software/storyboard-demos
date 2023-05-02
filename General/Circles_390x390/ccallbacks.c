/**
 * Copyright 2016, Crank Software Inc.
 * All Rights Reserved.
 * For more information email info@cranksoftware.com
 * ** FOR DEMO PURPOSES ONLY **
 **/

#include <stdio.h>
#include <string.h>
#include <gre/gre.h>
#include "ccallbacks.h"

#define DEGREES_IN_CIRCLE 		(360) 
#define ANGLE_OFFSET 			(90) 
#define PERCENT_OFFSET			(0)
#define PERCENTAGE_MULTIPLIER 	        (100)
#define GUAGE_PERCENT_OFFSET	        (2)
#define GAUGE_ANGLE_OFFSET 		(225)
#define DEGREES_IN_GAUGE  		(135)

static void
update_circle_text(gr_action_context_t *context, const char *input_var, const char *output_var, int input_offset, int percent_offset, int range) {
	char text[4];
	float percent;
	gr_application_t *app;
	gr_wrapped_data_t input;
	gr_data_union_t output;

	app = gr_context_get_application(context);
	gr_application_get_data(app, input_var, GR_DATA_FORMAT_4f1, &input);

	percent = ((input.v.f32 + input_offset) / range) + percent_offset;
	percent *=  PERCENTAGE_MULTIPLIER;
	gr_application_release_data(app, &input);

	snprintf(text, sizeof(text), "%d", (int) (percent + 0.5));

	memset(&output, 0, sizeof(output));
	output.cptr = text;
	
	gr_application_set_data(app, output_var, GR_DATA_FORMAT_1s0, &output);
}

void 
CBUpdateIncrementCircleText(gr_action_context_t *context) { 
	update_circle_text(context, "circle1.blue_fill.var", "circ1_value", ANGLE_OFFSET, PERCENT_OFFSET, DEGREES_IN_CIRCLE);
}

void 
CBUpdateCircularFillText(gr_action_context_t *context) {
	update_circle_text(context, "circle2.orange_fill.var", "circ2_value", ANGLE_OFFSET, PERCENT_OFFSET, DEGREES_IN_CIRCLE);
}

void 
CBUpdateDashedLineText(gr_action_context_t *context) {
	update_circle_text(context, "circle3.circle3_fill.var", "circ_3_value", ANGLE_OFFSET, PERCENT_OFFSET, DEGREES_IN_CIRCLE);
}

void 
CBUpdateBlackFadeText(gr_action_context_t *context) {
	update_circle_text(context, "black_fade.circle_blue.var", "circ_6_value", ANGLE_OFFSET, PERCENT_OFFSET, DEGREES_IN_CIRCLE);
}

void 
CBUpdateGaugeText(gr_action_context_t *context) {
	update_circle_text(context, "circle7.circ7_fill.var", "circ_7_value", ANGLE_OFFSET, GUAGE_PERCENT_OFFSET, DEGREES_IN_CIRCLE);
}
