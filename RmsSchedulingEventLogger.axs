MODULE_NAME='RmsSchedulingEventLogger'(dev vdvRMS)


#DEFINE INCLUDE_RMS_EVENT_CUSTOM_COMMAND_CALLBACK
#DEFINE INCLUDE_SCHEDULING_BOOKINGS_RECORD_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_BOOKING_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_ACTIVE_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_NEXT_ACTIVE_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_BOOKING_SUMMARIES_DAILY_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_BOOKING_SUMMARY_DAILY_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_CREATE_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_EXTEND_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_END_RESPONSE_CALLBACK
#DEFINE INCLUDE_SCHEDULING_ACTIVE_UPDATED_CALLBACK
#DEFINE INCLUDE_SCHEDULING_NEXT_ACTIVE_UPDATED_CALLBACK
#DEFINE INCLUDE_SCHEDULING_EVENT_ENDED_CALLBACK
#DEFINE INCLUDE_SCHEDULING_EVENT_STARTED_CALLBACK
#DEFINE INCLUDE_SCHEDULING_EVENT_UPDATED_CALLBACK
#DEFINE INCLUDE_SCHEDULING_MONTHLY_SUMMARY_UPDATED_CALLBACK
#DEFINE INCLUDE_SCHEDULING_DAILY_COUNT_CALLBACK


#INCLUDE 'RmsApi';
#INCLUDE 'RmsEventListener'
#INCLUDE 'RmsSchedulingApi';
#INCLUDE 'RmsSchedulingEventListener';


define_variable

constant char RMS_CUSTOM_COMMAND_EVENT_LOGGER[] = '@LOG.SCHEDULING.EVENTS';

volatile char loggerActive;


define_function setEventLoggerActive(char isActive) {
	loggerActive = isActive;
}

define_function log(char msg[]) {
	if (loggerActive) {
		send_string 0, "'>>>> ', msg";
	}
}

define_function printRmsEventBookingResponse(RmsEventBookingResponse booking) {
	log("'    bookingId: ', booking.bookingId");
	log("'    location: ', itoa(booking.location)");
	log("'    isPrivate: ', RmsBooleanString(booking.isPrivateEvent)");
	log("'    startDate: ', booking.startDate");
	log("'    startTime: ', booking.startTime");
	log("'    endDate: ', booking.endDate");
	log("'    endTime: ', booking.endTime");
	log("'    subject: ', booking.subject");
	log("'    details: ', booking.details");
	log("'    clientGatewayUid: ', booking.clientGatewayUid");
	log("'    isAllDayEvent: ', RmsBooleanString(booking.isAllDayEvent)");
	log("'    organizer: ', booking.organizer");
	log("'    elapsedMinutes: ', itoa(booking.elapsedMinutes)");
	log("'    minutesUntilStart: ', itoa(booking.minutesUntilStart)");
	log("'    remainingMinutes: ', itoa(booking.remainingMinutes)");
	log("'    onBehalfOf: ', booking.onBehalfOf");
	log("'    attendees: ', booking.attendees");
	log("'    isSuccessful: ', RmsBooleanString(booking.isSuccessful)");
	log("'    failureDescription: ', booking.failureDescription");
}

define_function printRmsEventBookingMonthlySummary(RmsEventBookingMonthlySummary summary) {
	log("'    location: ', itoa(summary.location)");
	log("'    startDate: ', summary.startDate");
	log("'    startTime: ', summary.startTime");
	log("'    endDate: ', summary.endDate");
	log("'    endTime: ', summary.endTime");
	log("'    dailyCountsTotal: ', itoa(summary.dailyCountsTotal)");
}

define_function printRmsEventBookingDailyCount(RmsEventBookingDailyCount dailyCount) {
	log("'    location: ', itoa(dailyCount.location)");
	log("'    dayOfMonth: ', itoa(dailyCount.dayOfMonth)");
	log("'    bookingCount: ', itoa(dailyCount.bookingCount)");
	log("'    recordCount: ', itoa(dailyCount.recordCount)");
	log("'    recordNumber: ', itoa(dailyCount.recordNumber)");
}


// RMS callbacks

define_function RmsEventCustomCommand(char header[], char data[]) {
	if (header == RMS_CUSTOM_COMMAND_EVENT_LOGGER) {
		stack_var char rmsParam1[RMS_MAX_PARAM_LEN];

		rmsParam1 = RmsParseCmdParam(data);

		setEventLoggerActive(RmsBooleanValue(rmsParam1));
	}
}

define_function RmsEventSchedulingBookingsRecordResponse(char isDefaultLocation,
		integer recordIndex,
		integer recordCount,
		char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingBookingsRecordResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'recordIndex: ', itoa(recordIndex)");
	log("'recordCount: ', itoa(recordCount)");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingBookingResponse(char isDefaultLocation,
		char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingBookingResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingActiveResponse(char isDefaultLocation,
		integer recordIndex,
		integer recordCount,
		char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingActiveResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'recordIndex: ', itoa(recordIndex)");
	log("'recordCount: ', itoa(recordCount)");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingNextActiveResponse(char isDefaultLocation,
		integer recordIndex,
		integer recordCount,
		char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingNextActiveResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'recordIndex: ', itoa(recordIndex)");
	log("'recordCount: ', itoa(recordCount)");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingSummariesDailyResponse(char isDefaultLocation,
		RmsEventBookingDailyCount dailyCount) {
	log("'RmsEventSchedulingSummariesDailyResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'dailyCount: '");
	printRmsEventBookingDailyCount(dailyCount);
}

define_function RmsEventSchedulingSummaryDailyResponse(char isDefaultLocation,
		RmsEventBookingDailyCount dailyCount) {
	log("'RmsEventSchedulingSummaryDailyResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'dailyCount: '");
	printRmsEventBookingDailyCount(dailyCount);
}

define_function RmsEventSchedulingCreateResponse(char isDefaultLocation,
		char responseText[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingCreateResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'responseText: ', responseText");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingExtendResponse(char isDefaultLocation,
		char responseText[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingExtendResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'responseText: ', responseText");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingEndResponse(char isDefaultLocation,
		char responseText[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingEndResponse(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'responseText: ', responseText");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingActiveUpdated(char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingActiveUpdated(..) called at ', TIME");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingNextActiveUpdated(char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingNextActiveUpdated(..) called at ', TIME");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingEventEnded(char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingEventEnded(..) called at ', TIME");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingEventStarted(char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingEventStarted(..) called at ', TIME");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingEventUpdated(char bookingId[],
		RmsEventBookingResponse eventBookingResponse) {
	log("'RmsEventSchedulingEventUpdated(..) called at ', TIME");
	log("'bookingId: ', bookingId");
	log("'eventBookingResponse:'");
	printRmsEventBookingResponse(eventBookingResponse);
}

define_function RmsEventSchedulingMonthlySummaryUpdated(integer dailyCountsTotal,
		RmsEventBookingMonthlySummary monthlySummary) {
	log("'RmsEventSchedulingMonthlySummaryUpdated(..) called at ', TIME");
	log("'dailyCountsTotal: ', itoa(dailyCountsTotal)");
	log("'monthlySumary: '");
	printRmsEventBookingMonthlySummary(monthlySummary);
}

define_function RmsEventSchedulingDailyCount(char isDefaultLocation,
		RmsEventBookingDailyCount dailyCount) {
	log("'RmsEventSchedulingDailyCount(..) called at ', TIME");
	log("'isDefaultLocation: ', RmsBooleanValue(isDefaultLocation)");
	log("'dailyCount: '");
	printRmsEventBookingDailyCount(dailyCount);
}
