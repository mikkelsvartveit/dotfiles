#!/usr/bin/osascript

# @raycast.schemaVersion 1
# @raycast.title Switch to AirPods
# @raycast.mode silent

# @raycast.packageName Audio
# @raycast.icon 🎧

# https://gist.github.com/ieatfood/814b065964492f71f728da59a47413bc?permalink_comment_id=3895031#gistcomment-3895031

use framework "IOBluetooth"
use scripting additions

set AirPodsName to "AirPods"

on getFirstMatchingDevice(deviceName)
	repeat with device in (current application's IOBluetoothDevice's pairedDevices() as list)
		if (device's nameOrAddress as string) contains deviceName then return device
	end repeat
end getFirstMatchingDevice

on toggleDevice(device)
	set quotedDeviceName to quoted form of (device's nameOrAddress as string)
	
	if not (device's isConnected as boolean) then
		device's openConnection()
	end if
	
	do shell script "/opt/homebrew/bin/SwitchAudioSource -s " & quotedDeviceName
	return "Connecting " & (device's nameOrAddress as string)
end toggleDevice

return toggleDevice(getFirstMatchingDevice(AirPodsName))
