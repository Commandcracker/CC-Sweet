-- BetterTable API
local BetterTable = {}

function BetterTable.lenTable(Table)
    local count = 0

    for _,_ in pairs(Table) do
        count = count + 1
    end

    return count
end

function BetterTable.getTable(Table, index)
    local count = 0

    for k,v in pairs(Table) do
        count = count + 1
        if count == index then
            return v
        end
    end
end

-- FakeColors
local FakeColors = {
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

-- Main Demo
local sweet = require("sweet")
local app   = sweet.newApp()

local ScrollBox = app.newScrollBox(2,10,{
    -- Random Names
    "Abhinav Boyan",
    "China Adam",
    "Alinafe Ines",
    "Foma Siemen",
    "Karl Asaf",
    "Ankita Aravind",
    "Otso Radoslava",
    "Lia Hillevi",
    "Vilmantė Tobia",
    "Cupido Amethyst",
    "Oghenekevwe Aarón",
    "Jacqueline Marek",
    "Conall Kia",
    "Elena Tara",
    "Delfina Bogdan"
})

local SetRandomTextColorButton = app.newButton(2,2,5,5, "Set Random Text Color", function ()
    app.TextColour = BetterTable.getTable(FakeColors, math.random(1, BetterTable.lenTable(FakeColors)))
    app.draw()
end)

local LightButton = app.newToggelButton(
    2,6,2,8,"Toggle Light",
    function ()
        rs.setAnalogOutput("top", 15)
    end,
    function ()
        rs.setAnalogOutput("top", 0)
    end
)

app.exec()
