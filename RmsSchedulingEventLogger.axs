MODULE_NAME='RmsSchedulingEventLogger'(dev vdvRMS)


#DEFINE INCLUDE_RMS_EVENT_CUSTOM_COMMAND_CALLBACK


#INCLUDE 'io';
#INCLUDE 'RmsApi';
#INCLUDE 'RmsSchedulingApi';
#INCLUDE 'RmsSchedulingEventListener';


define_variable

constant char RMS_CUSTOM_COMMAND_EVENT_LOGGER[] = '@LOG.EVENTS'

volatile char loggerActive;


define_function setEventLoggerActive(char isActive) {
	loggerActive = isActive;
}

define_function log(char msg[]) {
	println("DATE, ' ', TIME, ' | ', msg");
}

define_function char[1024] rmsEventToString(RmsEventBookingResponse booking) {
	stack_var char ret[1024];



	return ret;
}

define_function RmsEventCustomCommand(char header[], char data[]) {
	if (header == RMS_CUSTOM_COMMAND_EVENT_LOGGER) {
		stack_var char rmsParam1[RMS_MAX_PARAM_LEN];

		rmsParam1 = RmsParseCmdParam(data);

		setEventLoggerActive(RmsBooleanValue(rmsParam1));
	}
}