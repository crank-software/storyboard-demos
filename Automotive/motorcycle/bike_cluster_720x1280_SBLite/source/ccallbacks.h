#include <gre/gre.h>

void CBUpdateRPM(gr_action_context_t *action_context);
void CBUpdateSpeed(gr_action_context_t *action_context);

DLLExport const sb_ccallback_t sb_ccallback_list[] = {
	{ "CBUpdateRPM",   &CBUpdateRPM },
	{ "CBUpdateSpeed", &CBUpdateSpeed },
	{ NULL, NULL },
};

