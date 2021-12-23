/*
 * Copyright 2016, Crank Software Inc. All Rights Reserved.
 * 
 * For more information email info@cranksoftware.com.
 */
/** \File: ccallbacks.h
 *
 */

#ifndef _CCALLBACK_H
#define _CCALLBACK_H

#include <gre/gre.h>

void cbResetSizes(gr_action_context_t *action_context);
void cbResetStart(gr_action_context_t *action_context);
void cbResetBrew(gr_action_context_t *action_context);
void cbResetBrewing(gr_action_context_t *action_context);

extern const sb_ccallback_t sb_ccallbacks[] ;

#endif // _CCALLBACK_H
