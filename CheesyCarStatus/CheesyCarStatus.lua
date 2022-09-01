local wiperModes = ac.getCar().wiperModes
local WiperSpeed, ABS, Gear = 0, 0, 0

--function ui.progressBar(fraction, size, overlay) end

local function changeWiper()
    ui.setColumnWidth(3, 70)
    ui.text('   Wipers')
    if ui.arrowButton('increaseWiper', ui.Direction.Up, vec2(64,16)) then
        if WiperSpeed < wiperModes then
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
    ui.text('   ABS')
    if ui.arrowButton('increaseABS', ui.Direction.Up, vec2(64,16)) then
        if ABS < 12 then
            ABS = ABS + 1
            ac.setABS(ABS)
        end
    end

    ui.button(ABS,vec2(64,24),ui.ButtonFlags.Disabled)

    if ui.arrowButton('decreaseABS', ui.Direction.Down, vec2(64,16)) then
        if ABS > 0 then
            ABS = ABS - 1
            ac.setABS(ABS)
        end
    end
end

local function rpmBar()

end

--[[
local function selectGear()
    ui.text('   Gear')
    if ui.arrowButton('increaseGear', ui.Direction.Up, vec2(64,16)) then
        if Gear < 12 then
            Gear = Gear + 1

        end
    end

    ui.button(Gear,vec2(64,24))

    if ui.arrowButton('decreaseGear', ui.Direction.Down, vec2(64,16)) then
        if Gear > -1 then
            Gear = Gear - 1
        end
    end
end
]]


local squareOffset = 10
local function drawWaterTemp()
    local waterTemp = math.round(ac.getCar().waterTemperature/10, 0)
    ac.debug('waterTemp', waterTemp)
    local top_left, top_right, bottom_left, bottom_right = vec2(50,50)
    for i = 1, waterTemp do
      ui.drawQuadFilled(vec2(0+(i*50+squareOffset),0),vec2(50+(i*50),0),vec2(50+(i*50),100),vec2(0+(i*50+squareOffset),100), rgbm.colors.blue)
    end
end

local barRotaion = 90
function script.carStatus(dt)

    local currentRPM = ac.getCar().rpm
    local maxRPM = ac.getCar().rpmLimiter
    local rpmFraction = (currentRPM / maxRPM)

    ui.progressBar(rpmFraction, vec2(ui.windowWidth(),20))

   --ui.childWindow('##waterTemp', vec2(100, 100), drawWaterTemp())


   -- barRotaion = ui.slider('##barRotaion', barRotaion, -360,360,'%.f')

    --[[for i = 1, rpmFraction*10 do
        ui.drawQuadFilled(vec2(0+(i*50+squareOffset),0),vec2(50+(i*50),0),vec2(50+(i*50),50),vec2(0+(i*50+squareOffset),50), rgbm.colors.red)
    end]]
    --ui.beginRotation()
   -- drawWaterTemp()
    --ui.endRotation(barRotaion)
--[[
    ui.columns(5,true, 'mainColumn')
    changeABS()
    ui.nextColumn()
    ui.nextColumn()
    ui.nextColumn()
    ui.nextColumn()
        changeWiper()


    ui.colorPicker('##licenselight',plateColour)
    plateMult = ui.slider('##plateMult', plateMult, 0, 1000,'%.3f',1.5)
    valueSave = math.round(plateColour.r,2)..','..math.round(plateColour.g,2)..','..math.round(plateColour.b,2)..','..math.round(plateMult,2)
    ac.INIConfig.load('content/cars/acura_nsx_s1/extension/ext_config.ini'):setAndSave('LIGHT_LICENSEPLATE','COLOR',valueSave)

    --[[ac.debug('plateColour', plateColour)
    ac.debug('1r', math.round(plateColour.r,2))
    ac.debug('2g', math.round(plateColour.g,2))
    ac.debug('3b', math.round(plateColour.b,2))
    ac.debug('4mult', math.round(plateColour.mult,2))]]
end



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