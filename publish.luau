local ASSET_ID = "18858426780"

print("Reading place file...")
local place = remodel.readPlaceFile("roblox-gatherer-sdk.rbxl")
local sdk = place.ServerScriptService.GathererSDK

print("Writing Model to file...")
remodel.writeModelFile("GathererSDK.rbxm", sdk)

print("Uploading Model to Roblox...")
print("ASSET_ID: " .. ASSET_ID)
remodel.writeExistingModelAsset(sdk, ASSET_ID)
print("Model uploaded!")
