--[[
 _____                   _
/  ___|                 | |
\ `--.__      _____  ___| |_
 `--. \ \ /\ / / _ \/ _ \ __|
/\__/ /\ V  V /  __/  __/ |_
\____/  \_/\_/ \___|\___|\__|
]]

local sweet = {}

function sweet.drawBorder(startX, startY, width, height, Colour, BackgroundColour)
    term.setTextColour(Colour)

    height  = height - startY
    width   = width  - startX

    for drawheight = 0, height do
        for drawwidth = 0, width do

            term.setCursorPos(startX + drawwidth, startY + drawheight)

            if drawheight == 0 and drawwidth == 0 then
                -- Top Left Corner
                term.write("\156")
            elseif drawheight == height and drawwidth == 0 then
                -- Bottom Left Corner
                term.write("\141")
            elseif drawheight == 0 and drawwidth == width then
                -- Top Right Corner
                term.setBackgroundColour(Colour)
                term.setTextColour(BackgroundColour)
                term.write("\147")
                term.setBackgroundColour(BackgroundColour)
                term.setTextColour(Colour)
            elseif drawheight == height and drawwidth == width then
                -- Bottom Left Corner
                term.write("\142")
            elseif drawheight == 0 or drawheight == height then
                -- Horizontal Bar
                term.write("\140")
            elseif drawwidth == 0 then
                -- Left Vertical Bar
                term.write("\149")
            elseif drawwidth == width then
                -- Right Vertical Bar
                term.setBackgroundColour(Colour)
                term.setTextColour(BackgroundColour)
                term.write("\149")
                term.setBackgroundColour(BackgroundColour)
                term.setTextColour(Colour)
            else
                -- Sapce
                term.write(" ")
            end
        end
    end
end

function sweet.newApp()
    local app = {}

    app.BackgroundColour       = colors.white
    app.TextColour             = colors.gray
    app.Objects                = {}

    function app.newButton(startX, startY, endX, endY, text, Function)
        local Button    = {}
        Button.Type     = "Button"

        Button.Color                = colors.blue
        Button.ActivationColor      = colors.green

        Button.startX   = startX
        Button.startY   = startY
        Button.endX     = #text + 3
        Button.endY     = endY
        Button.text     = text
        Button.Function = Function

        function Button.draw(color)
            color = color or Button.Color

            sweet.drawBorder(Button.startX, Button.startY, Button.endX, Button.endY, color, app.BackgroundColour)
            --paintutils.drawBox(Button.startX, Button.startY, Button.endX, Button.endY,color)

            term.setCursorPos(startX + 1, startY + 1)
            term.setTextColour(app.TextColour)
            term.setBackgroundColour(app.BackgroundColour)
            print(Button.text)
        end

        table.insert(app.Objects, Button)
        return Button
    end

    function app.newToggelButton(startX, startY, endX, endY, text, EnableFunction, DisableFunction)
        local ToggelButton  = {}
        ToggelButton.Type   = "ToggelButton"

        ToggelButton.startX   = startX
        ToggelButton.startY   = startY
        ToggelButton.endX     = #text + 3
        ToggelButton.endY     = endY
        ToggelButton.text     = text

        ToggelButton.EnabledColor    = colors.green
        ToggelButton.DisableColor    = colors.red

        ToggelButton.Enabled         = false
        ToggelButton.EnableFunction  = EnableFunction
        ToggelButton.DisableFunction = DisableFunction

        function ToggelButton.draw()
            local color = ToggelButton.DisableColor

            if ToggelButton.Enabled == true then
                color = ToggelButton.EnabledColor
            end

            sweet.drawBorder(ToggelButton.startX, ToggelButton.startY, ToggelButton.endX, ToggelButton.endY, color, app.BackgroundColour)
            --paintutils.drawBox(ToggelButton.startX, ToggelButton.startY, ToggelButton.endX, ToggelButton.endY,color)

            term.setCursorPos(startX + 1, startY + 1)
            term.setTextColour(app.TextColour)
            term.setBackgroundColour(app.BackgroundColour)
            print(ToggelButton.text)
        end

        table.insert(app.Objects, ToggelButton)
        return ToggelButton
    end

    function app.newScrollBox(startX, startY, items)
        local ScrollBox     = {}
        ScrollBox.Type      = "ScrollBox"

        ScrollBox.startX        = startX
        ScrollBox.startY        = startY
        ScrollBox.items         = items
        ScrollBox.SelectedItem  = 0

        ScrollBox.SelectionColor = colors.lightBlue

        local space = 0

        for _,item in pairs(ScrollBox.items) do
            if #item > space then
                space = #item
            end
        end

        ScrollBox.VisableItems = 5

        if ScrollBox.VisableItems > #ScrollBox.items then
            ScrollBox.VisableItems = #ScrollBox.items
        end

        ScrollBox.UpButtonX = ScrollBox.startX + space
        ScrollBox.UpButtonY = ScrollBox.startY - 1

        ScrollBox.DownButtonX = ScrollBox.startX + space
        ScrollBox.DownButtonY = ScrollBox.startY + ScrollBox.VisableItems - 2

        ScrollBox.ScrollDiff = 0

        function ScrollBox.Scroll(distance)
            ScrollBox.SelectedItem = ScrollBox.SelectedItem + distance

            -- Remove Scroll Diff
            if ScrollBox.SelectedItem > ScrollBox.VisableItems - 1 or (ScrollBox.SelectedItem >= ScrollBox.VisableItems - 1 and distance < 0) then
                ScrollBox.ScrollDiff = ScrollBox.ScrollDiff + distance
            end

            -- Scroll Up Diff
            if ScrollBox.SelectedItem < 0 then
                ScrollBox.SelectedItem  = #ScrollBox.items - 1
                ScrollBox.ScrollDiff    = #ScrollBox.items - ScrollBox.VisableItems
            end

            -- Scroll Down Diff
            if ScrollBox.SelectedItem > #ScrollBox.items - 1 then
                ScrollBox.SelectedItem  = 0
                ScrollBox.ScrollDiff    = 0
            end

            ScrollBox.draw()
        end

        function ScrollBox.getSelectedItem()
            return ScrollBox.items[ScrollBox.SelectedItem + 1]
        end

        function ScrollBox.draw()
            term.setBackgroundColour(colours.lightGrey)

            local count = 0

            local vurrentdiff = 0

            for _,item in pairs(ScrollBox.items) do

                if ScrollBox.ScrollDiff ~= vurrentdiff then
                    vurrentdiff = vurrentdiff + 1
                else
                    term.setCursorPos(ScrollBox.startX, ScrollBox.startY - 1 + count)

                    if count + vurrentdiff == ScrollBox.SelectedItem then
                        term.setBackgroundColour(ScrollBox.SelectionColor)
                    else
                        term.setBackgroundColour(app.BackgroundColour)
                    end

                    term.write(item)

                    for i = 0, space - #item do
                        term.write(" ")
                    end

                    term.setBackgroundColour(app.BackgroundColour)
                    count = count + 1

                    if count == ScrollBox.VisableItems then
                        break
                    end
                end
            end

            for i = 0, ScrollBox.VisableItems - 1 do
                term.setBackgroundColour(colours.lightGrey)
                term.setCursorPos(ScrollBox.startX + space, ScrollBox.startY - 1 + i)

                if i == 0 then
                    print("\30")
                elseif i == ScrollBox.VisableItems - 1 then
                    print("\31")
                elseif i == ScrollBox.SelectedItem then
                    term.setBackgroundColour(colours.grey)
                    print(" ")
                else
                    print(" ")
                end
            end

            --[[Scroll Bar
            term.clear()
            term.setCursorPos(2,2)

            term.setBackgroundColour(colours.lightGrey)
            term.setTextColour(colours.grey)
            print("\131\140")

            term.setCursorPos(4,2)
            term.setBackgroundColour(colours.grey)
            term.setTextColour(colours.lightGrey)
            print("\143")

            term.setCursorPos(1, 4)
            ]]

            term.setBackgroundColour(app.BackgroundColour)
        end

        table.insert(app.Objects, ScrollBox)
        return ScrollBox
    end

    function app.exit()
        print("exit")
    end

    function app.draw()
        term.setBackgroundColour(app.BackgroundColour)
        term.setTextColour(app.TextColour)
        term.clear()

        for _,Object in pairs(app.Objects) do
            Object.draw()
        end

    end

    function app.exec()
        app.draw()

        while true do

            local event, arg1, arg2, arg3 = os.pullEvent()

            if event == "mouse_click" then
                local button    = arg1
                local x         = arg2
                local y         = arg3

                for _,Object in pairs(app.Objects) do

                    if Object.Type == "ScrollBox" then
                        if x == Object.UpButtonX and y == Object.UpButtonY then
                            Object.Scroll(-1)
                            break
                        end

                        if x == Object.DownButtonX and y == Object.DownButtonY then
                            Object.Scroll(1)
                            break
                        end

                    end

                    if (Object.Type == "Button" or Object.Type == "ToggelButton") and Object.startX <= x and Object.endX >= x and Object.startY <= y and Object.endY >= y then

                        if Object.Type == "Button" then

                            Object.draw(Object.ActivationColor)
                            sleep(.1)
                            if Object.Function then
                                Object.Function()
                            end
                            Object.draw(Object.Color)
                            sleep(.1)

                        elseif Object.Type == "ToggelButton" then

                            if Object.Enabled == false then

                                Object.Enabled = true

                                Object.draw()

                                if Object.EnableFunction then
                                    Object.EnableFunction()
                                end

                            elseif Object.Enabled == true then

                                Object.Enabled = false

                                Object.draw()

                                if Object.DisableFunction then
                                    Object.DisableFunction()
                                end

                            end

                        end

                        break
                    end
                end

            elseif event == "mouse_scroll" then
                local scrollDirection   = arg1
                local x                 = arg2
                local y                 = arg3

                for _,Object in pairs(app.Objects) do

                    if Object.Type == "ScrollBox" then
                        Object.Scroll(scrollDirection)
                        break
                    end

                end

            elseif event == "term_resize" then
                app.draw()
            end

        end

    end

    return app
end

return sweet
