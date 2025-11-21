local Util = {}
Util.CACHE_BUST = true

function Util.log(...)
    print("[alura]", ...)
end

function Util.http_get(url)
    local function bust(u)
        if not Util.CACHE_BUST then return u end
        return u .. ((u:find("%?") and "&" or "?") .. "t=" .. os.time())
    end
    local u = bust(url)
    if syn and syn.request then
        local r = syn.request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "syn.request "..tostring(r and r.StatusCode).." for "..u)
        Util.log("syn.request OK", u)
        return r.Body
    end
    if http and http.request then
        local r = http.request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "http.request "..tostring(r and r.StatusCode).." for "..u)
        Util.log("http.request OK", u)
        return r.Body
    end
    if request then
        local r = request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "request "..tostring(r and r.StatusCode).." for "..u)
        Util.log("request OK", u)
        return r.Body
    end
    local body = game:HttpGet(u)
    assert(type(body) == "string" and #body > 0, "HttpGet empty body for "..u)
    Util.log("HttpGet OK", u)
    return body
end

local function make_smart_require(modules, loaded)
    local original_require = require
    return function(id)
        if type(id) ~= "string" then
            return original_require(id)
        end
        local fn = modules[id]
        if not fn then
            return original_require(id)
        end
        if loaded[id] ~= nil then
            return loaded[id]
        end
        local ok, ret = pcall(fn)
        if not ok then error(("error running %s: %s"):format(id, ret), 0) end
        loaded[id] = (ret == nil) and true or ret
        return loaded[id]
    end
end

local function define(modules, loaded, name, src)
    assert(type(src) == "string" and #src > 0, "empty source for "..name)
    local chunk, err = loadstring(src, name)
    assert(chunk, ("loadstring failed for %s: %s"):format(name, tostring(err)))
    local env = setmetatable({ require = make_smart_require(modules, loaded) }, { __index = getfenv(0) })
    setfenv(chunk, env)
    modules[name] = chunk
end

function Util.bootstrap(url_map, entry_name)
    assert(type(url_map) == "table", "url_map must be a table")
    assert(type(entry_name) == "string", "entry_name must be a string")
    local modules, loaded = {}, {}
    for name, url in pairs(url_map) do
        local src = Util.http_get(url)
        Util.log(("fetched %-22s %6d bytes"):format(name, #src))
        define(modules, loaded, name, src)
    end
    local entry = modules[entry_name]
    assert(entry, "missing entry: "..entry_name)
    Util.log("launching", entry_name, "…")
    local ok, ret = pcall(entry)
    if not ok then
        Util.log("runtime error:", ret)
        error(ret)
    end
    Util.log(entry_name, "returned:", tostring(ret))
    return ret
end

return Util
