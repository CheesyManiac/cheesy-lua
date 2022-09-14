local car = ac.getCar(0)
local getControls = ac.getFolder(ac.FolderID.Cfg)..'/controls.ini'
local bindForHighbeam =ac.INIConfig.load(getControls):get('__EXT_LOW_BEAM','KEY')[1]
local toggleHighBeam = true 
local lastKeyState = false

local carModes = {
    ['Wipers'] = car.wiperModes,
    ['ABS'] = car.absModes,
    ['TC'] = car.tractionControlModes,
    ['gearCount'] = car.gearCount
}

local Icons = {
    ['EML'] = 'Icons/EML_ON.png',
    ['ABS'] = 'Icons/ABS_ON.png',
    ['ESC'] = 'Icons/ESC_ON.png',
    ['T_COLD'] = 'Icons/TEMP_COLD.png',
    ['T_HOT'] = 'Icons/TEMP_HOT.png',
    ['INDICATORS'] = 'Icons/INDICATORS.png',
    ['LIGHT_HIGHBEAM'] = 'Icons/LIGHT_HIGHBEAM.png',
    ['LIGHT_PARKING'] = 'Icons/LIGHT_PARKINGpng.png'
}

--ac.INIConfig.(ac.INIFormat.Default, )

local columnWidths = {
    160,
    150,
    115,
    160,
    250
}

local function changeWiper()
    local WiperSpeed = car.wiperMode
    ui.text('   Wipers')
    if ui.arrowButton('increaseWiper', ui.Direction.Up, vec2(64,16)) then
        if WiperSpeed < carModes.Wipers then
            WiperSpeed = WiperSpeed + 1
            ac.setWiperSpeed(0, WiperSpeed)
        end
    end

    ui.button(WiperSpeed,vec2(64,24),ui.ButtonFlags.Disabled)

    if ui.arrowButton('decreaseWiper', ui.Direction.Down, vec2(64,16)) then
        if WiperSpeed > 0 then
            WiperSpeed = WiperSpeed - 1
            ac.setWiperSpeed(0, WiperSpeed)
        end
    end
    
end

local function changeABS()
    local absCurrent = car.absMode
    ac.debug('absCurrent', absCurrent)
    ui.text('   ABS')
    if ui.arrowButton('increaseABS', ui.Direction.Up, vec2(64,16)) then
        if absCurrent < carModes.ABS then
            absCurrent = absCurrent + 1
            ac.setABS(absCurrent)
        end
    end
    ui.button(absCurrent,vec2(64,24),ui.ButtonFlags.Disabled)
    if ui.arrowButton('decreaseABS', ui.Direction.Down, vec2(64,16)) then
        if absCurrent > 0 then
            absCurrent = absCurrent - 1
            ac.setABS(absCurrent)
        end
    end

    ui.offsetCursor(vec2(75,-68))

    if car.absInAction then    
        ui.image(Icons.ABS, vec2(64,64), rgbm(1,1,1,1), nil)
    else
        ui.image(Icons.ABS, vec2(64,64), rgbm(0,0,0,0.2), nil)
        --ui.dummy(vec2(64,64))
    end
end

local function changeTC()
    local tcCurrent = car.tractionControlMode    
    ac.debug('tcCurrent', tcCurrent)
    ui.text('   TC')
    if ui.arrowButton('increaseTC', ui.Direction.Up, vec2(64,16)) then
        if tcCurrent < carModes.TC then
            tcCurrent = tcCurrent + 1
            ac.setTC(tcCurrent)
        end
    end
    ui.button(tcCurrent,vec2(64,24),ui.ButtonFlags.Disabled)
    if ui.arrowButton('decreaseTC', ui.Direction.Down, vec2(64,16)) then
        if tcCurrent > 0 then
            tcCurrent = tcCurrent - 1
            ac.setTC(tcCurrent)
        end
    end
    ui.offsetCursor(vec2(75,-68))
    if car.tractionControlInAction then
        ui.image(Icons.ESC, vec2(64,64), rgbm(1,1,1,1), nil)
    else
        ui.image(Icons.ESC, vec2(64,64), rgbm(0,0,0,0.2), nil)
    end
end

local function rpmBar()
    local rpmCurrent = ac.getCar().rpm
    local maxRPM = ac.getCar().rpmLimiter
    local rpmFraction = (rpmCurrent / maxRPM)
    ac.debug('currentRPM', rpmCurrent)

    ui.progressBar(rpmFraction, vec2(ui.windowWidth(),20))
end

local function selectGear()
    gearCurrent = car.gear
    ui.text('         Gear')
    if ui.arrowButton('increaseGear', ui.Direction.Up, vec2(100,16)) then
        if gearCurrent < carModes.gearCount then
            gearCurrent = gearCurrent + 1

        end
    end
    ui.pushFont((bit.bor(ui.Font.Huge,ui.Font.Monospace)))
    ui.button(gearCurrent,vec2(100,70))
    ui.popFont()

    if ui.arrowButton('decreaseGear', ui.Direction.Down, vec2(100,16)) then
        if gearCurrent > -1 then
            gearCurrent = gearCurrent - 1
        end
    end
end

local function drawWaterTemp()
    ac.debug('water temp',car.waterTemperature)

    --Everything related to the initial dial state
    local markColor = rgbm(1, 1, 1, 0.3)
    local markColorGreen = rgbm(0.5, 1, 0.5, 0.7)
    local markColorAmber = rgbm(1, 0.7, 0, 0.7)
    local markColorRed = rgbm(1, 0, 0, 0.7)
    local needleColor = rgbm(1, 1, 1, 1)
    local dialStart, dialEnd = -0.5, 0.5

    local lineCountLong = 6
    local dialStartGreen = lineCountLong/3
    local dialStartAmber = lineCountLong*2/3
    local dialStartRed = lineCountLong/1


    local dialRadius = 70
    local offsetX = (table.sum(columnWidths) - columnWidths[5])+ dialRadius/2
    local offsetY = dialRadius + 70
    local dialCenter = vec2(offsetX+dialRadius,offsetY)

    ui.drawCircleFilled(dialCenter, dialRadius, rgbm(0, 0, 0, 0.3), 50)

        -- draws the larger indents on temp 

    for i = 0, lineCountLong do 
        local s = math.sin(math.lerp(dialStart, dialEnd, i / lineCountLong) * math.pi)
        local c = -math.cos(math.lerp(dialStart, dialEnd, i / lineCountLong) * math.pi)
        ui.drawLine(dialCenter + vec2(s, c) * (dialRadius-(dialRadius/3.5)), dialCenter + vec2(s, c) * (dialRadius), ((i >= dialStartGreen and i <= dialStartAmber) and markColorGreen) or ((i >= dialStartAmber and i < dialStartRed) and markColorAmber) or ((i >= dialStartRed) and markColorRed)or markColor, 1)
    end

    -- draws the small indents on temp 
    local lineCountShort = lineCountLong*3
    for i = 0, lineCountShort do 
        if i % 3 ~= 0 then 
            local s = math.sin(math.lerp(dialStart, dialEnd, i / lineCountShort) * math.pi)
            local c = -math.cos(math.lerp(dialStart, dialEnd, i / lineCountShort) * math.pi)
            ui.drawLine(dialCenter + vec2(s, c) * (dialRadius-(dialRadius/6)), dialCenter + vec2(s, c) * (dialRadius), ((i > dialStartGreen*3 and i < dialStartAmber*3) and markColorGreen) or ((i >= dialStartAmber*3 and i < dialStartRed*3-3) and markColorAmber) or ((i >= dialStartRed*3-3) and markColorRed)or markColor, 1)--((i > dialStartGreen*3 and i < 21) and markColorGreen) or ((i > 19 and i < 27) and markColorAmber) or ((i > 21) and markColorRed)or markColor, 1)
        end
    end

    -- draws the needle
    local angle = math.lerp(dialStart, dialEnd, math.lerpInvSat(car.waterTemperature, 60,90)) * math.pi
    local s = math.sin(angle)
    local c = -math.cos(angle)
    ui.drawLine(dialCenter - vec2(s, c) * 0, dialCenter + vec2(s, c) * 70, needleColor, 1.5)

    --now to draw the temp icons
    ui.offsetCursor(vec2(dialRadius,dialRadius+25))
    if car.waterTemperature < 65 then
    ui.image(Icons.T_COLD, vec2(32,32), rgbm(1,1,1,1), nil)
    elseif car.waterTemperature > 85 then
    ui.image(Icons.T_HOT, vec2(32,32), rgbm(1,1,1,1), nil)
    else
    ui.image(Icons.T_COLD, vec2(32,32), rgbm(0,0,0,0.3), nil)
    end

end

local indicatorActive = false
local function drawLightState()

    if car.turningLeftLights or car.turningRightLights then
        setInterval(function() indicatorActive = not indicatorActive end, 0.35, 'indicatorActive')
    else
        clearInterval(1)
        indicatorActive = false
    end

    if car.turningLeftLights and indicatorActive then
        ui.image(Icons.INDICATORS, vec2(64,64), rgbm(1,1,1,1), nil, vec2(0,0), vec2(0.5,1), true)
    else
        ui.image(Icons.INDICATORS, vec2(64,64), rgbm(0,0,0,0.3), nil, vec2(0,0), vec2(0.5,1), true)
    end
    ui.sameLine()
    if car.turningRightLights and indicatorActive then
        ui.image(Icons.INDICATORS, vec2(64,64), rgbm(1,1,1,1), nil, vec2(0.5,0), vec2(1,1), true)
    else
        ui.image(Icons.INDICATORS, vec2(64,64), rgbm(0,0,0,0.3), nil, vec2(0.5,0), vec2(1,1), true)
    end

    if car.headlightsActive then
        ui.image(Icons.LIGHT_PARKING, vec2(64,64), rgbm(1,1,1,1), nil, vec2(0,0), vec2(1,1), true)
    else
        ui.image(Icons.LIGHT_PARKING, vec2(64,64), rgbm(0,0,0,0.3), nil, vec2(0,0), vec2(1,1), true)
    end
    ui.sameLine()
    if not car.lowBeams then
        ui.image(Icons.LIGHT_HIGHBEAM, vec2(64,64), rgbm(1,1,1,1), nil, vec2(0,0), vec2(1,1), true)
    else
        ui.image(Icons.LIGHT_HIGHBEAM, vec2(64,64), rgbm(0,0,0,0.3), nil, vec2(0,0), vec2(1,1), true)
    end
end
local wah = false
local susHeight = 0.5
function script.carStatus(dt)

    rpmBar()

    ui.separator()
    -------------------------------------------------------
    ui.columns(5,true, 'mainColumn')
    ui.setColumnWidth(0, columnWidths[1])
        changeABS()
        changeTC()    
    -------------------------------------------------------
    ui.nextColumn()
    ui.setColumnWidth(1, columnWidths[2])

        drawLightState()
    -------------------------------------------------------
    ui.nextColumn()
    ui.setColumnWidth(2, columnWidths[3])
        selectGear()
    -------------------------------------------------------
    ui.nextColumn()
    ui.setColumnWidth(3, columnWidths[4])
        changeWiper()
    -------------------------------------------------------
    ui.nextColumn()
    ui.setColumnWidth(4, columnWidths[5])
        drawWaterTemp()
    -------------------------------------------------------
    ui.nextColumn()
    ui.columns(1, false, 'none')
    ui.separator()

    --susHeight = ui.slider('##susHeight', susHeight, 0,1,'%.2f')
    --ac.store('susHeight', susHeight)

    --[[
    local keyState = ac.isKeyDown(bindForHighbeam)
    if keyState and lastKeyState ~= keyState then
        toggleHighBeam = not toggleHighBeam
        lastKeyState = keyState
    elseif not keyState then
        lastKeyState = false
    end
    ]]

    --[[
    if toggleHighBeam then
        ac.setHighBeams(true)
    else
        ac.setHighBeams(false)
    end
    ]]

    --[[
    if car.lowBeams == false and toggleHighBeam == true then
        ac.setHighBeams(true)
    else
        ac.setHighBeams(false)
    end

    ac.debug('1lowbeam',car.lowBeams)
    ac.debug('1toggleHighBeam',toggleHighBeam)
    ac.debug('wah',wah)
    ]]
ac.debug('1lowbeam',car.lowBeams)
end





--    ui.colorPicker('##licenselight',plateColour)
--    plateMult = ui.slider('##plateMult', plateMult, 0, 1000,'%.3f',1.5)
--    valueSave = math.round(plateColour.r,2)..','..math.round(plateColour.g,2)..','..math.round(plateColour.b,2)..','..math.round(plateMult,2)
--    ac.INIConfig.load('content/cars/acura_nsx_s1/extension/ext_config.ini'):setAndSave('LIGHT_LICENSEPLATE','COLOR',valueSave)

    --susRear = ui.slider('##susRear', susRear, 0,1,'%.3f')
    --ac.store('susRear', susRear)

    --forceUp = ui.slider('##forceUp', forceUp, 0,20000,'%.3f')
    --ac.store('forceUp', forceUp)

    --ui.childWindow('##waterTemp', vec2(100, 100), drawWaterTemp())


    -- barRotaion = ui.slider('##barRotaion', barRotaion, -360,360,'%.f')

    --[[for i = 1, rpmFraction*10 do
        ui.drawQuadFilled(vec2(0+(i*50+squareOffset),0),vec2(50+(i*50),0),vec2(50+(i*50),50),vec2(0+(i*50+squareOffset),50), rgbm.colors.red)
    end
    --ui.beginRotation()
   -- drawWaterTemp()
    --ui.endRotation(barRotaion)]]



    --[[ac.debug('plateColour', plateColour)
    ac.debug('1r', math.round(plateColour.r,2))
    ac.debug('2g', math.round(plateColour.g,2))
    ac.debug('3b', math.round(plateColour.b,2))
    ac.debug('4mult', math.round(plateColour.mult,2))]]

--[[
local plateColour = rgbm(10,10,10,10)
local carName = ac.getCarID(0)
local plateMult = 10
function script.carStatus(dt)
    ui.colorPicker('##licenselight',plateColour)
    plateMult = ui.slider('##plateMult', plateMult, 0, 1000,'%.0f')
    valueSave = math.round(plateColour.r,2)..','..math.round(plateColour.g,2)..','..math.round(plateColour.b,2)..','..math.round(plateMult,2)
    ac.INIConfig.load('content/cars/'..carName..'/extension/ext_config.ini'):setAndSave('LIGHT_LICENSEPLATE','COLOR',valueSave)
end]]