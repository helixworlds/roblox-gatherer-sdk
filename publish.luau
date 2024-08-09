local ASSET_ID = "18858426780"
local place = remodel.readPlaceFile("roblox-gatherer-sdk.rbxl")
local sdk = place.ServerScriptService.GathererSDK
remodel.writeModelFile("GathererSDK.rbxm", sdk)
-- remodel.writeExistingModelAsset(sdk, ASSET_ID)
