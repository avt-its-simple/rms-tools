PROGRAM_NAME='RmsExtendedEventListener'


#IF_NOT_DEFINED __RMS_EXTENDED_EVENT_LISTENER__
#DEFINE __RMS_EXTENDED_EVENT_LISTENER__


#INCLUDE 'RmsEventListener';
#INCLUDE 'RmsExtendedApi';


/*

/**
 * Called in response to RmsAssetLocationRequest(..)
 */
// #DEFINE INCLUDE_RMS_EVENT_ASSET_LOCATION_CALLBACK
RmsEventAssetLocation(char assetClientKey[], RmsLocation location) {}

*/


define_event

data_event[vdvRMS] {

	command: {
		stack_var char rmsHeader[RMS_MAX_HDR_LEN];

		rmsHeader = RmsParseCmdHeader(data.text);
		rmsHeader = upper_string(rmsHeader);

		select {

			#IF_DEFINED INCLUDE_RMS_EVENT_ASSET_LOCATION_CALLBACK
			active (rmsHeader == RMS_EVENT_ASSET_LOCATION): {
				stack_var char assetClientKey[RMS_MAX_PARAM_LEN];
				stack_var RmsLocation location;

				#WARN 'The actual API deviates from the docs here as of v4.1.13'
				//assetClientKey = RmsParseCmdParam(data.text);

				location.id = atoi(RmsParseCmdParam(data.text));
				location.name = RmsParseCmdParam(data.text);
				location.owner = RmsParseCmdParam(data.text);
				location.phoneNumber = RmsParseCmdParam(data.text);
				location.occupancy = atoi(RmsParseCmdParam(data.text));
				location.prestigeName = RmsParseCmdParam(data.text);
				location.timezone = RmsParseCmdParam(data.text);
				location.assetLicensed = RmsBooleanValue(RmsParseCmdParam(data.text));

				RmsEventAssetLocation(assetClientKey, location);
			}
			#END_IF

		}

	}

}

#END_IF // __RMS_EXTENDED_EVENT_LISTENER__
