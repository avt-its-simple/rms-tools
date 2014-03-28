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


/*

Callback signitures below. To subscribe to a callback ensure that the associated
compiler directive is declared prior to the inclusion of this axi.


/**
 * Called when an update occurs to the location tracker's location.
 */
#DEFINE LOCATION_TRACKER_UPDATE_CALLBACK
define_function locationTrackerUpdated(integer trackerId, RmsLocation location) {}

*/

define_type

structure assetLocationTracker {
	char assetClientKey[50];
	RmsLocation location;
}

define_variable

constant integer MAX_RMS_ASSET_LOCATION_TRACKERS = 8;

volatile assetLocationTracker locationTracker[MAX_RMS_ASSET_LOCATION_TRACKERS];


/**
 * Sets the client key to track.
 *
 * @param	assetClientKey	a string continating the asset client key of the
 *							asset to track
 */
define_function setLocationTrackerAsset(integer trackerId, char assetClientKey[]) {
	locationTracker[trackerId].assetClientKey = assetClientKey;
	RmsAssetLocationRequest(locationTracker.assetClientKey)
}


// RMS callbacks

define_function RmsEventAssetRegistered(char registeredAssetClientKey[],
		long assetId,
		char newAssetRegistration) {
	stack_var integer i;
	for (i = MAX_RMS_ASSET_LOCATION_TRACKERS; i; i--) {
		if (registeredAssetClientKey == locationTracker[i].assetClientKey) {
			RmsAssetLocationRequest(locationTracker[i].assetClientKey)
		}
	}
}

define_function RmsEventAssetRelocated(char assetClientKey[],
		long assetId,
		integer newLocationId) {
	stack_var integer i;
	for (i = MAX_RMS_ASSET_LOCATION_TRACKERS; i; i--) {
		if (assetClientKey == locationTracker[i].assetClientKey) {
			RmsAssetLocationRequest(locationTracker[i].assetClientKey)
		}
	}
}

define_function RmsEventAssetLocation(char assetClientKey[], RmsLocation location) {
	stack_var integer i;
	for (i = MAX_RMS_ASSET_LOCATION_TRACKERS; i; i--) {
		if (assetClientKey == locationTracker[i].assetClientKey) {
			locationTracker[i].location = location;
			#IF_DEFINED LOCATION_TRACKER_UPDATE_CALLBACK
			locationTrackerUpdated(i, location);
			#END_IF
		}
	}
}


#END_IF // __RMS_ASSET_LOCATION_TRACKER__
