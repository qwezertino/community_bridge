BridgeClientConfig = {}
BridgeClientConfig.NotifySystem    = "ox"         -- Change this to your notification system (ox/qb/esx?)
BridgeClientConfig.ZoneSystem      = "ox"         -- Change this to your dialog system (ox/poly)
BridgeClientConfig.InputSystem     = "ox"         -- Change this to your Input system (ox/qb)
BridgeClientConfig.MenuSystem      = "ox"         -- Change this to your Menu system (ox/qb)
BridgeClientConfig.ProgressBar     = "ox"         -- Change this to your preferred progress bar (ox/qb)
BridgeClientConfig.DebugLevel      = 3            -- Change this to your Debug level, 1 for none, 2 for some, 3 for all data
BridgeClientConfig.ShowHelpText    = "ox"         --

Require("init.lua", "ox_lib")
return BridgeClientConfig