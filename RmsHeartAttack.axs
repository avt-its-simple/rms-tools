/**
 * This module enables the RMS client heartbeat to be sped up and exceed the
 * minimum interval safety threshold. It has be built to enable temporary
 * improved response times in a *small number* of demo systems. It should
 * probably never be used.
 *
 * Side affects include: irregular client heartbeats, excess server traffic,
 * rapidly filling logs, general disgust from SDK and server dev team.
 *
 * Use at your own risk. You have been warned.
 */
MODULE_NAME='RmsHeartAttack' (dev vdvRMS)


#DEFINE INCLUDE_RMS_EVENT_CUSTOM_COMMAND_CALLBACK


#INCLUDE 'RmsExtendedApi'
#INCLUDE 'RmsEventListener'


define_variable

constant char RMS_CUSTOM_COMMAND_HEARTATTACK[] = '@CONFIG.CLIENT.HEARTATTACK';

constant long FORCE_REFRESH = 1;

constant integer DEFAULT_INTERVAL = 5; // seconds


/**
 * Sets the RMS heart attach active state. When enabled the RMS client will hit
 * the server for any pending messages at the interval specified, allowing you
 * to make things happen a little quicker that the safety threshold will allow.
 */
define_function setHeartAttack(char isEnabled, integer interval) {
	// We need to kill the timeline regardless to refresh the interval so may
	// as well be efficient about it.
	if (timeline_active(FORCE_REFRESH)) {
		timeline_kill(FORCE_REFRESH);
	}

	if (isEnabled) {
		stack_var long times[1];

		if (interval < 1) {
			interval = DEFAULT_INTERVAL;
		}
		times[1] = interval * 1000;

		timeline_create(FORCE_REFRESH,
				times,
				1,
				TIMELINE_ABSOLUTE,
				TIMELINE_REPEAT);

		send_string 0, "'>>>> RMS HEARTATTACK :: starting myocardial infarction at ', itoa(interval), ' second intervals.'";
	} else {
		send_string 0, '>>>> RMS HEARTATTACK :: heart attack done. Lets not do that any time again soon.';
	}
}


// RMS callbacks

define_function RmsEventCustomCommand(char header[], char data[]) {
	if (header == RMS_CUSTOM_COMMAND_HEARTATTACK) {
		stack_var char rmsParam1[RMS_MAX_PARAM_LEN];
		stack_var char rmsParam2[RMS_MAX_PARAM_LEN];

		rmsParam1 = RmsParseCmdParam(data);
		rmsParam2 = RmsParseCmdParam(data);

		setHeartAttack(RmsBooleanValue(rmsParam1), atoi(rmsParam2));
	}
}


define_event

timeline_event[FORCE_REFRESH] {
	if ([vdvRMS, RMS_CHANNEL_CLIENT_ONLINE]) {
		RmsRetrieveClientMessages();
	}
}
