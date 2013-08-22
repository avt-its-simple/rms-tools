PROGRAM_NAME='RmsAssetLocationTracker'


#IF_DEFINED __RMS_ASSET_LOCATION_TRACKER__
#WARN 'RmsAssetLocationTracker already in use for this scope'
#ELSE
#DEFINE __RMS_ASSET_LOCATION_TRACKER__


#DEFINE INCLUDE_RMS_EVENT_ASSET_REGISTERED_CALLBACK
#DEFINE INCLUDE_RMS_EVENT_ASSET_RELOCATED_CALLBACK
#DEFINE INCLUDE_RMS_EVENT_ASSET_LOCATION_CALLBACK


#INCLUDE 'RmsExtendedApi'
#INCLUDE 'RmsExtendedEventListener'


define_type

structure assetLocationnTracker {
	char assetClientKey[50];
	RmsLocation location;
}

define_variable

volatile assetLocationnTracker locationTracker;


/**
 * Sets the client key to track.
 *
 * @param	assetClientKey	a string continating the asset client key of the
 *							asset to track
 */
define_function setLocationTrackerAsset(char assetClientKey[]) {
	locationTracker.assetClientKey = assetClientKey;
	RmsAssetLocationRequest(locationTracker.assetClientKey)
}


// RMS callbacks

define_function RmsEventAssetRegistered(char registeredAssetClientKey[],
		long assetId,
		char newAssetRegistration) {
	if (registeredAssetClientKey == locationTracker.assetClientKey) {
		RmsAssetLocationRequest(locationTracker.assetClientKey)
	}
}

define_function RmsEventAssetRelocated(char assetClientKey[],
		long assetId,
		integer newLocationId) {
	if (assetClientKey == locationTracker.assetClientKey) {
		RmsAssetLocationRequest(locationTracker.assetClientKey)
	}
}

define_function RmsEventAssetLocation(char assetClientKey[], RmsLocation location) {
	/*if (assetClientKey == locatioTracker.assetClientKey) {
		locationTracker.location = location;
	}*/
	#WARN 'As we cannot currently associate an ?ASSET.LOCATION response with a device this is a hard coded hack'
	locationTracker.location.id = tempLocationId;
	locationTracker.location.name = tempLocationName
}


#END_IF // __RMS_ASSET_LOCATION_TRACKER__
