local sweet = {}

function sweet.drawBorder(startX, startY, width, height, Colour, BackgroundColour)
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

        Button.startX   = startX
        Button.startY   = startY
        Button.endX     = #text + 3
        Button.endY     = endY
        Button.text     = text
        Button.Function = Function

        function Button.draw(color)
            color = color or colors.blue

            term.setTextColour(color)
            sweet.drawBorder(Button.startX, Button.startY, Button.endX, Button.endY, color, app.BackgroundColour)

            --paintutils.drawBox(Button.startX, Button.startY, Button.endX, Button.endY,color)

            term.setCursorPos(startX+1, startY+1)
            term.setTextColour(app.TextColour)
            term.setBackgroundColour(app.BackgroundColour)
            print(Button.text)
        end

        table.insert(app.Objects, Button)
        return Button
    end

    function app.newToggelButton(startX, startY, endX, endY, text, EnableFunction, DisableFunction)
        local ToggelButton  = app.newButton(startX,startY,endX,endY,text)
        ToggelButton.Type   = "ToggelButton"

        ToggelButton.Enabled         = false
        ToggelButton.EnableFunction  = EnableFunction
        ToggelButton.DisableFunction = DisableFunction

        return ToggelButton
    end

    function app.newScrollBox(startX, startY)
        local ScrollBox     = {}
        ScrollBox.Type      = "ScrollBox"

        ScrollBox.startX   = startX
        ScrollBox.startY   = startY

        function ScrollBox.draw()
            term.setCursorPos(ScrollBox.startX,ScrollBox.startY)
            print("\30")
            term.setCursorPos(ScrollBox.startX,ScrollBox.startY-1)
            print("\31")
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
                    if (Object.Type == "Button" or Object.Type == "ToggelButton") and Object.startX <= x and Object.endX >= x and Object.startY <= y and Object.endY >= y then

                        if Object.Type == "Button" then

                            Object.draw(colors.green)
                            sleep(.1)
                            if Object.Function then
                                Object.Function()
                            end
                            Object.draw(colors.blue)
                            sleep(.1)

                        elseif Object.Type == "ToggelButton" then

                            if Object.Enabled == false then

                                Object.Enabled = true
                                if Object.EnableFunction then
                                    Object.EnableFunction()
                                end

                                Object.draw(colors.green)

                            elseif Object.Enabled == true then

                                Object.Enabled = false
                                if Object.DisableFunction then
                                    Object.DisableFunction()
                                end

                                Object.draw(colors.red)

                            end

                        end

                        break
                    end
                end

            elseif event == "mouse_scroll" then
                local scrollDirection   = arg1
                local x                 = arg2
                local y                 = arg3

                if scrollDirection == -1 then
                    --print("UP")
                elseif scrollDirection == 1 then
                    --print("Down")
                end

            elseif event == "term_resize" then
                app.draw()
            end

        end

    end

    return app
end

return sweet
