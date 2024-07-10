local function makeEnvURL(env)
    local url = {} -- table that contains all of the environment credentials

    if (env == "DEV") then
        table.insert(url, "https://gatherer.d.helixworlds.io/") -- Dev environment
    elseif (env == "PROD") then
        table.insert(url, "https://gatherer.helixworlds.io/") -- Prod environment
    else
        table.insert(url, "http://localhost:4001/")       -- Dev environment (default)
    end

    table.insert(url, "auth/login")          -- FOR AUTHENTICATION...
    table.insert(url, "v3/user/user")        -- FOR CREATING USERS...
    table.insert(url, "v3/user/{USERID}/track") -- FOR TRACKING USERS...

    return url
end

return makeEnvURL
