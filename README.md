RemoteTransmission
==================

Remote client for Transmission

Set up:

1st step:
  - Run Transmission desktop client
  - Preferences -> Remote ->Enable remote access (uncheck authentication - its not supported yet)
  - add some test torrent to client
  

2nd step:
  - Run RemoteTransmission app
  - Settings -> URL: "http://[ipAddress]:[port]/transmission/rpc/"
  - Settings -> Set update interval (preferd 5-10s)
  - Settings -> tap to save button
  - Settings -> Connect (If connection has been created then the Status label has to be changed to CONNECTED)
  - Tap to Torrents on tab bar (Torrents should be appear on screen)
