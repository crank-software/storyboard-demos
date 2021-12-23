/**
 * This is the callback interface file for the Storyboard Engine.
 *
 * The C callbacks in this file will be invoked by Storyboard in response to the 
 * C API callbacks.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <gre/gre.h>
#include <gre/iodefs.h>

#define TEMP_ANGLE_OFFSET 53
#define TEMP_MAX_ANGLE 287
#define TEMP_OUTBOUND_ANGLE_MEDIAN 323.5

#define TEMP_MIN_VALUE 14
#define TEMP_MAX_VALUE 26 

#define DIMMER_MIN_LEVEL 0
#define DIMMER_MAX_LEVEL 35

#define MAX_LIGHTS 4

typedef struct light_dimmer {
	int 	id;
	int		value;
} light_dimmer_t;

int selected_light_index = 0;

light_dimmer_t light_list[] = {
	{ 1, DIMMER_MIN_LEVEL },
	{ 2, DIMMER_MIN_LEVEL },
	{ 3, DIMMER_MIN_LEVEL },
	{ 4, DIMMER_MIN_LEVEL },	
};

/*
 * Utility Functions
 */
#define MAX_NAME_LEN 50

typedef struct dim {
  int   x;
  int   y;
  int   width;
  int   height;
} dim_t;

char * alloc_sprintf(const char *fmt, ...) {
    va_list ap, ap1;
    size_t size;
    char *buffer;
    int ret;
   
    va_start(ap, fmt);
    
    va_copy(ap1, ap);
    size = vsnprintf(NULL, 0, fmt, ap1) + 1;
    va_end(ap1);
    
    buffer = calloc(1, size); //Safety, could just nul the end
    if (!buffer) {
        return NULL;
    }

    ret = vsnprintf(buffer, size, fmt, ap);
    va_end(ap);

    if(ret <= 0) {
      free(buffer);
      return NULL;
    }

    return buffer;
}

//TODO: Change this API to return success/failure and fill a ptr instead
int get_data_int(gr_application_t *app, const char *cname, const char *attr) {
  char *key;
  int  *pvalue;
	char *pformat = NULL;
  int  ret, value;

  if(attr) {
    key = alloc_sprintf("%s.%s", cname, attr);
  } else {
    key = cname;
  }
  if(!key) {
    return 0;
  }
	
	ret = gr_application_get_data(app, key, &pvalue, &pformat);

  if(key != cname) {
    free(key);
  }

	if(ret == -1 || !pvalue) {
		return 0;
	}
	
	value = *pvalue;
	
  return value;
}

int get_control_attr_int(gr_application_t *app, const char *cname, const char *attr) {
	char fq_attr[MAX_NAME_LEN];	
	
	snprintf(fq_attr, MAX_NAME_LEN, "%s.grd_%s", cname, attr);

  return get_data_int(app, fq_attr, NULL);
}

int get_control_dim(gr_application_t *app, const char *cname, dim_t *dim) {
  dim->x = get_control_attr_int(app, cname, "x");
  dim->y = get_control_attr_int(app, cname, "y");
  dim->width = get_control_attr_int(app, cname, "width");
  dim->height = get_control_attr_int(app, cname, "height");

  return 0;
}

int set_data_int(gr_application_t *app, const char *stem, const char *var, int value) {
  char *key;
	int  ret, *pvalue = NULL;

  pvalue = malloc(sizeof(*pvalue));
  if(!pvalue) {
    return -1;
  }
  *pvalue = value;

  if(var) {
    key = alloc_sprintf("%s.%s", stem, var);
  } else {
    key = stem;
  }
  if(!key) {
    free(pvalue);
    return -1;
  }
	
	ret = gr_application_set_data(app, key, "4s1", pvalue);

  if(key != stem) {
    free(key);
  }

	if(ret == -1) {
    free(pvalue);
		return -1;
	}

	return 0;
}

int set_control_attr_int(gr_application_t *app, const char *cname, const char *attr, int value) {
	char fq_attr[MAX_NAME_LEN];	
	char *pformat = NULL;
	
	snprintf(fq_attr, MAX_NAME_LEN, "%s.grd_%s", cname, attr);

  return set_data_int(app, fq_attr, NULL, value);  
}

//-- This function centers a control on the specified X/Y position
static void center(gr_application_t *app, const char * cname, int x, int y) {
  dim_t dim;
  int nv;
 
  get_control_dim(app, cname, &dim);

  if(x >= 0) {
    nv = x - (dim.width / 2);
    set_control_attr_int(app, cname, "x", nv);
  }

  if(y >= 0) {
    nv = y - (dim.height / 2);
    set_control_attr_int(app, cname, "y", nv);
  }
 }

//-- This function extends the controls height, width to a specified Y/Y position
static void extend(gr_application_t *app, const char *cname, int x, int y) {
  dim_t dim;
  int nv;
 
  get_control_dim(app, cname, &dim);
  //--Normalize since we can only extend, not move
  if(x >= 0 && x < dim.x) {
    x = dim.x;
  }
  if(y >= 0 && y < dim.y) {
    y = dim.y;
  }

  if(x) {
    nv = x - dim.x;
    set_control_attr_int(app, cname, "width", nv);
  }
  if(y) {
    nv = y - dim.y;
    set_control_attr_int(app, cname, "height", nv);
  }
}

// Convert a y position to the dimmer value based on a reference control
int ypos_to_dimmer_value(gr_application_t *app, int ypos) {
  dim_t dim;

  //--Offset in the touch area, convert to a dimmer value
  get_control_dim(app, "light_dimmer_layer.dimmer_ref_area", &dim);

  //-- Normalize the value relative to the reference control
  if(ypos > (dim.y + dim.height)) {
    ypos = dim.y + dim.height;
  } else if(ypos < dim.y) {
    ypos = dim.y;
  }

  //-- Calculate the percent complete running from bottom (0) to top (100)
  float percent = 1 - ((float)(ypos - dim.y) / (float)dim.height);
  
  //-- Apply the percent as a value
  return (int)(DIMMER_MIN_LEVEL + ((DIMMER_MAX_LEVEL - DIMMER_MIN_LEVEL) * percent));
}

void sync_dimmer_ui_to_value(gr_application_t *app, light_dimmer_t *dimmer) {
  int ypos = dimmer_value_to_ypos(app, dimmer->value);
  
  center(app, "light_dimmer_layer.slider", -1, ypos);
  center(app, "light_dimmer_layer.current_level", -1, ypos);
  extend(app, "light_dimmer_layer.slider_top", -1, ypos);
  
  //-- Display the minimum and maximum values as a string instead of as a number
  char * label;
  if (dimmer->value <= DIMMER_MIN_LEVEL) {
    label = alloc_sprintf("%s", "MIN");
  } else if(dimmer->value >= DIMMER_MAX_LEVEL) {
    label = alloc_sprintf("%s", "MAX");
  } else {
    label = alloc_sprintf("%d", dimmer->value);
  }
  gr_application_set_data(app, "light_dimmer_layer.current_level.text", "1s0", label);

  label = alloc_sprintf("LIGHT %d", dimmer->id);
  gr_application_set_data(app, "light_dimmer_layer.current_light_title.text", "1s0", label);
}

void update_selected_light_index(gr_application_t *app, int direction) {
  int selected_light_index = selected_light_index + direction;
  
  //-- If the direction exceeds the bounds of the light_list, wrap the index appropriately
  if (selected_light_index < 0) {
    selected_light_index = MAX_LIGHTS;
  } else if(selected_light_index >= MAX_LIGHTS) {
    selected_light_index = 0;
  }
  
  //-- Update dimmer values since the light in context has changed
  sync_dimmer_ui_to_value(app, &light_list[selected_light_index]);
}

/*
 * Callbacks
 */

//C Callback Generic Prototype:
//void function_name(gr_action_context_t *context)

void cb_light_dimmer_touch(gr_action_context_t *context) {
  gr_application_t *app = gr_context_get_application(context);
  void *ev_data = gr_context_get_event_data(context);
  gr_ptr_event_t *ptr = (gr_ptr_event_t *)ev_data;

  int dimmer_value = ypos_to_dimmer_value(app, ptr->y);
  light_list[selected_light_index].value = dimmer_value;

  sync_dimmer_ui_to_value(app, &light_list[selected_light_index]);
}

void cb_previous_light(gr_action_context_t *context) {
  gr_application_t *app = gr_context_get_application(context);
	update_selected_light_index(app, -1);
}

void cb_next_light(gr_action_context_t *context) {
  gr_application_t *app = gr_context_get_application(context);
	update_selected_light_index(app, 1);
}

//---toggle the selected light switch on and off
void cb_light_toggle_touch(gr_action_context_t *context) {
  gr_application_t *app = gr_context_get_application(context);
  char cname[MAX_NAME_LEN];
  char gname[MAX_NAME_LEN];
  dim_t dim;

  gr_context_get_control(context, cname, MAX_NAME_LEN);
  gr_context_get_group(context, gname, MAX_NAME_LEN);

  int status = get_data_int(app, gname, "status");
  
  //--check for the current status and then set it to the opposite value, then play the animation
  if (status == 0) {
    status = 1;
    gr_application_send_event(app, cname, "turn_light_on_event", NULL, NULL, 0);
  } else {
    status = 0;
    gr_application_send_event(app, cname, "turn_light_off_event", NULL, NULL, 0);
  }
  
  set_data_int(app, gname, "status", status);
}

//---Convert the angle generated from the context event into a value between 14 and 26 and then set the text of the control
void set_temperature_dial_value(gr_application_t *app, int angle) {
  double angle_perc = (double)angle / ceil(TEMP_MAX_ANGLE / (TEMP_MAX_VALUE - TEMP_MIN_VALUE));
  
  //-- Pad the calculation
  double value = TEMP_MIN_VALUE + round(angle_perc);
 
  //-- Show one decimal place of formatting
  char * label = alloc_sprintf("%2.1f°C", value);
  
  //--add a celcius symbol to the end of the value
  gr_application_set_data(app, "temperature_dial_layer.temperature_value.text", "1s0", label);
}

void cb_temperature_dial_touch(gr_action_context_t *context) {
  gr_application_t *app = gr_context_get_application(context);
  void *ev_data = gr_context_get_event_data(context);
  gr_ptr_event_t *ptr = (gr_ptr_event_t *)ev_data;
  char cname[MAX_NAME_LEN];
  dim_t dim;

  gr_context_get_control(context, cname, MAX_NAME_LEN);

  get_control_dim(app, cname, &dim);

  int touch_x = ptr->x;
  int touch_y = ptr->y;
  int control_cx = dim.x + (dim.width / 2);
  int control_cy = dim.y + (dim.height / 2);
    
  double angle_from_center = deg(atan2(control_cy - touch_y, control_cx - touch_x));
  
  int angle = (int)(angle_from_center + TEMP_ANGLE_OFFSET);
  if (angle < 0) {
    angle = angle + 360;
  }
  
  //--clamp the angle to either the maximum or minimum possible value, using the halfway point/median of the unselectable area
  if (angle > TEMP_MAX_ANGLE && angle < TEMP_OUTBOUND_ANGLE_MEDIAN) {
    angle = TEMP_MAX_ANGLE;
  } else if(angle > TEMP_OUTBOUND_ANGLE_MEDIAN) {
    angle = 0;
  }
  
  set_data_int(app, "temperature_dial_layer.temperature_dial.angle", NULL, angle);  

  set_temperature_dial_value(app, angle);
}

void cb_init(gr_action_context_t *context) {
}

