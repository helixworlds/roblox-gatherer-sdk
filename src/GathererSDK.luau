-- GATHERER SDK v0.1.23
--[[
    This package was developed by MetaverseGroup and should be used
    to track events and logs inside your Roblox games. It was created
    to integrate with the Helixworlds System, so you can visit `app.helixworlds.io`
    to see the gathered analytics.

    Visit the website, create an account, an organization, your game, and get the
    credentials to start tracking your users and getting knowledge to improve and
    make your app more successful.

    You can also create custom events and track them using this package, being able to measure
    different kinds of actions and get good insights about your games and items!
]] --

----------- Main Initialization of global variable from the Module scripts
local module = {}
local envConfig = nil
coroutine.wrap(function()
    envConfig = require(script.EnvironmentConfig)
end)()

----------- Initialization of the Gatherer API services and URL environments
local function initializeSDK(credentials)
    print("GathererSDK: SDK Initialized")
    -- Getting env from credentials
    local env = credentials.env
    -- initialization of the variables
    local PROD = "PROD"   -- PROD ENVIRONMENT
    local DEV = "DEV"     -- DEV ENVIRONMENT
    local LOCAL = "LOCAL" -- LOCAL ENVIRONMENT

    -- Validations
    if not env then
        env = PROD
    end

    if not credentials.clientId then
        warn("GATHERER INITIALIZATION ERROR: The credentials object must contain the clientId");
        return
    end

    if not credentials.secret then
        warn("GATHERER INITIALIZATION ERROR: The credentials object must contain the secret");
        return
    end


    local envURL = envConfig(env)

    -- initialization of the Service for API requests
    local HttpService = game:GetService("HttpService")

    local baseurl = envURL[1]

    local requestBody = credentials

    local accessToken = ""

    -- Function to Authenticate credentials and get an access token
    local function aunthenticateLoginAPI(userID)
        local authURL = envURL[2]
        local url = baseurl .. authURL
        local success, response = pcall(function()
            return HttpService:PostAsync(url, HttpService:JSONEncode(requestBody), Enum.HttpContentType.ApplicationJson,
                false)
        end)
        if success then
            local responseData = HttpService:JSONDecode(response)
            accessToken = responseData and responseData.access_token

            if accessToken then
                return accessToken
            else
                warn("Invalid or missing 'access_token' field in authentication response:", response)
            end
        else
            warn("Authentication request failed: " .. response)
        end

        return nil
    end

    -- Creating user
    local function createUserAPI(userID)
        local createUserURL = envURL[3]
        local url = baseurl .. createUserURL
        local responseData = nil

        if not accessToken then
            warn("Access token is nil. Please provide a valid access token.")
            return
        end

        local headers = {
            ["Authorization"] = "Bearer " .. accessToken
        }

        local requestBody = {
            extId = userID
        }

        local success, response = pcall(function()
            return HttpService:PostAsync(url, HttpService:JSONEncode(requestBody), Enum.HttpContentType.ApplicationJson,
                false, headers)
        end)

        if success then
            responseData = HttpService:JSONDecode(response)
            if responseData then
                return responseData
            else
                warn("Invalid authentication response:", response)
            end
        else
            warn("Authentication request failed: " .. response)
        end

        return nil
    end


    -- Function to track session start
    local function trackSessionStart(userID, localId)
        local createUserURL = envURL[4]
        local url = baseurl .. createUserURL
        url = url:gsub("{USERID}", userID)
        local responseData = nil

        if not accessToken then
            warn("Access token is nil. Please provide a valid access token.")
            return
        end

        local headers = {
            ["Authorization"] = "Bearer " .. accessToken
        }

        local requestBody = {
            name = "session_start",
            parameters = '{"user_id":"' .. localId .. '"}'
        }

        local success, response = pcall(function()
            return HttpService:PostAsync(url, HttpService:JSONEncode(requestBody), Enum.HttpContentType.ApplicationJson,
                false, headers)
        end)
        if success then
            responseData = HttpService:JSONDecode(response)
            if responseData then
                return true
            else
                warn("Invalid authentication response:", response)
            end
        else
            warn("Authentication request failed: " .. response)
        end

        return responseData
    end

    -- Tracking Session end
    local function trackSessionEnd(userId, extId, sessionTime)
        local url = baseurl .. "v3/user/" .. userId .. "/track"
        local headers = {
            ["Authorization"] = "Bearer " .. accessToken
        }
        local requestBody = {
            name = "session_end",
            parameters = '{"session_time": ' .. sessionTime .. '}',
            inventoryId = ""
        }

        local success, response = pcall(function()
            return HttpService:PostAsync(url, HttpService:JSONEncode(requestBody), Enum.HttpContentType.ApplicationJson,
                false, headers)
        end)
        local responseData = HttpService:JSONDecode(response)
        if success then
            return true
        else
            warn("Session end event failed for user: " .. userId .. " - " .. response)
            return false
        end
    end

    -- Function to track a custom event
    local function trackCustomEvent(extId, eventId)
        if not (type(extId) == "string") then
            extId = tostring(extId)
        end

        if not (type(eventId) == "string") then
            warn("Invalid eventId: It should be a string")
            return
        end

        local accessToken = aunthenticateLoginAPI(extId)
        local user = createUserAPI(extId)
        local userId = user.id

        local url = baseurl .. "v3/user/" .. userId .. "/track"
        local headers = {
            ["Authorization"] = "Bearer " .. accessToken
        }
        print("Tracking custom event", eventId, extId)
        local requestBody = {
            name = "custom_event",
            parameters = '{"event_id":"' .. eventId .. '"}'
        }

        local success, response = pcall(function()
            return HttpService:PostAsync(url, HttpService:JSONEncode(requestBody), Enum.HttpContentType.ApplicationJson,
                false, headers)
        end)

        if success then
            return true
        else
            warn("Custom event failed for user: " .. userId .. " - " .. response)
            return false
        end
    end

    -- -----------------------------
    -- Table to store player join times
    local playerJoinTimes = {}

    -- Getting the Players object to add listeners
    local Players = game:GetService("Players")

    --
    local function onPlayerAdded(player)
        local userId = tostring(player.UserId)
        aunthenticateLoginAPI(userId)

        local user = createUserAPI(userId)
        -- Record the time when the player joins
        playerJoinTimes[userId] = os.time()
        trackSessionStart(user.id, userId)
    end
    --
    Players.PlayerAdded:Connect(onPlayerAdded)

    --
    local function onPlayerDisconnect(player)
        local userId = tostring(player.UserId)
        local joinTime = playerJoinTimes[userId]
        local accessToken = aunthenticateLoginAPI(userId)
        local user = createUserAPI(userId)
        if joinTime then
            local sessionTime = (os.time() - joinTime) * 1000
            trackSessionEnd(user.id, userId, sessionTime)
            playerJoinTimes[player.UserId] = nil
        end
    end
    --
    Players.PlayerRemoving:Connect(onPlayerDisconnect)

    local functions = {}
    functions.trackCustomEvent = trackCustomEvent
    return functions
end


module.initializeSDK = initializeSDK
return module
