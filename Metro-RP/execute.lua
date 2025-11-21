local RAW = "https://raw.githubusercontent.com/alura-sys/Lua-Scripts/main/Metro-RP"

local function quick_get(u)
    if syn and syn.request then
        local r = syn.request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "syn.request "..tostring(r and r.StatusCode))
        return r.Body
    elseif http and http.request then
        local r = http.request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "http.request "..tostring(r and r.StatusCode))
        return r.Body
    elseif request then
        local r = request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "request "..tostring(r and r.StatusCode))
        return r.Body
    end
    return game:HttpGet(u)
end

local util_src = quick_get(RAW .. "/util.lua")
local Util = assert(loadstring(util_src, "Metro-RP/util"))()

local urls = {
    ["Metro-RP/config"] = RAW .. "/config.lua",
    ["Metro-RP/functions"] = RAW .. "/functions.lua",
    ["Metro-RP/gui"] = RAW .. "/gui.lua",
    ["Metro-RP/main"] = RAW .. "/main.lua"
}

return Util.bootstrap(urls, "Metro-RP/main")
