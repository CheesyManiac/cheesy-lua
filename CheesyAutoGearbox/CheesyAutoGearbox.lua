local changeUp, changeDown = 0, 0
local car0 = ac.getCar(0)
local carCar = ac.INIConfig.carData(0,'car.ini')
local carEngine = ac.INIConfig.carData(0,'engine.ini')
--extconfig = ac.INIConfig.load('extension/config/cars/kunos/ks_audi_a1s1.ini'):get('LIGHT_HEADLIGHTS','BOUND_EXP',0)
extconfig2 = ac.INIConfig.load('extension/config/cars/kunos/ks_audi_a1s1.ini'):setAndSave('LIGHT_HEADLIGHTS','BOUND_EXP',0)

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


function script.windowMain(dt)
    --ac.debug('test',extconfig)
    local gasUse = math.round((car0.gas*10)+1,0)
    local rpmFrac = math.round(((car0.rpm / car0.rpmLimiter)*10)+1,0)

    ui.pushDWriteFont('Speed Racing:fonts/SpeedRacing.ttf')
    ui.dwriteText('MINIMUM:  '..carEngine:get('ENGINE_DATA','MINIMUM')[1],24)
    ui.dwriteText('LIMITER:  '..carEngine:get('ENGINE_DATA','LIMITER')[1])
    ui.dwriteText('gearCount:  '..car0.gearCount)
    ui.popDWriteFont()

    ui.separator()
    changeGear()
    ui.separator()

    ui.dwriteText('rpm:   '..car0.rpm)
    ui.dwriteText('rpm %:   '..rpmFrac)
    ui.dwriteText('gas:   '..gasUse)
    ui.dwriteText('gear:  '..car0.gear)

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