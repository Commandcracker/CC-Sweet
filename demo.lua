local sweet = require("sweet")
local app   = sweet.newApp()

local function lenTable(Table)
    local count = 0

    for _,_ in pairs(Table) do
        count = count + 1
    end

    return count
end

local function getTable(Table, index)
    local count = 0

    for k,v in pairs(Table) do
        count = count + 1
        if count == index then
            return v
        end
    end
end

local c = {
    black     = colors.black,
    blue      = colors.blue,
    brown     = colors.brown,
    cyan      = colors.cyan,
    gray      = colors.gray,
    green     = colors.green,
    lightBlue = colors.lightBlue,
    lightGray = colors.lightGray,
    lime      = colors.lime,
    magenta   = colors.magenta,
    orange    = colors.orange,
    pink      = colors.pink,
    purple    = colors.purple,
    red       = colors.red,
    --white     = colors.white,
    yellow    = colors.yellow
}

app.newButton(2,2,5,5, "Random Text Color", function ()
    app.TextColour = getTable(c, math.random(1, lenTable(c)))
    app.draw()
end)

local LightButton = app.newToggelButton(
    2,6,2,8,"Light",
    function ()
        rs.setAnalogOutput("top", 15)
    end,
    function ()
        rs.setAnalogOutput("top", 0)
    end
)

app.newScrollBox(2,10)

app.exec()
