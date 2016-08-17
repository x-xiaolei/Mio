local string_find = string.find
local lor = require("lor.index")
local app = lor()
local router = require("dashboard.router")


app:conf("view enable", true)
app:conf("view engine",  "tmpl")
app:conf("view ext", "html")
app:conf("views", "./dashboard/views")


-- routes
app:use(router())

-- 404 error
app:use(function(req, res, next)
    if req:is_found() ~= true then
        if req.headers["Accept"] and string_find(req.headers["Accept"], "application/json") then
            res:status(404):json({
                success = false,
                msg = "404! sorry, not found."
            })
        else
            res:status(404):send("404! sorry, not found. " .. req.path or "")
        end
    end
end)

-- error handle middleware
app:erroruse(function(err, req, res, next)
    ngx.log(ngx.ERR, err)

    if req.headers["Accept"] and string_find(req.headers["Accept"], "application/json") then
        res:status(500):json({
            success = false,
            msg = "500! unknown error."
        })
    else
        res:status(500):send("unknown error")
    end
end)

app:run()

