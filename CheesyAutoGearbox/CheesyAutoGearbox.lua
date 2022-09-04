local changeUp, changeDown = 0, 0
local car0 = ac.getCar(0)
local carCar = ac.INIConfig.carData(0,'car.ini')
local carEngine = ac.INIConfig.carData(0,'engine.ini')

local shiftUpLUT = {['rpm']={-1.0,-0.8,-0.0,0.0,0.0,0.0,0.0,0.0,0.8,0.9,1.0}, ['throttle']={0.0,1.0,0.8,0.6,0.4,0.0,0.0,-0.4,-0.4,-0.3,-0.2}}

--function ac.readDataFile(value) end
--function ac.INIConfig.carData(carIndex, fileName) end

local function changeGear()
    if ui.button('change up') then
        ac.store("changeUp", 1)
    else
        ac.store("changeUp", 0)
    end
    if ui.button('change down') then
        ac.store("changeDown", 1)
    else
        ac.store("changeDown", 0)
    end
end
    local changeGearUp = 0
    local susFront = 0.1
    local susRear = 0.1
    local forceUp = 0


    local carPos = ac.getCar(0).position
function script.windowMain(dt)

    local gasUse = math.round((car0.gas*10)+1,0)
    local rpmFrac = math.round(((car0.rpm / car0.rpmLimiter)*10)+1,0)


    ui.text('MINIMUM:  '..carEngine:get('ENGINE_DATA','MINIMUM')[1],24)
    ui.text('LIMITER:  '..carEngine:get('ENGINE_DATA','LIMITER')[1])
    ui.text('gearCount:  '..car0.gearCount)


    ui.separator()
    changeGear()
    ui.separator()

    ui.text('rpm:   '..car0.rpm)
    ui.text('rpm %:   '..rpmFrac)
    ui.text('gas:   '..gasUse)
    ui.text('gear:  '..car0.gear)

    ui.text(shiftUpLUT['rpm'][rpmFrac])
    ui.text(shiftUpLUT['throttle'][gasUse])
    ui.text(shiftUpLUT['rpm'][rpmFrac]+shiftUpLUT['throttle'][gasUse])

    local shiftUpProb = shiftUpLUT['rpm'][rpmFrac]+shiftUpLUT['throttle'][gasUse]

    if shiftUpProb >= 0.8 then
        ac.store("changeUp", 1)
    else
        ac.store("changeUp", 0)
    end

    if shiftUpProb >= -0.9 and car0.gear <= 0 then
        ac.store("changeDown", 1)
    else
        ac.store("changeDown", 0)
    end
end