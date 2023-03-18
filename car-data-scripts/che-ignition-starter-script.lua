--CheesyManiac#0001
--Car ignition and starter script
--CSP ExtraA for ignition, CSP ExtraB to engage the starter motor

--Do not use on encrypted mods (that goes for data encrypted models!)

local carState = {
  ignition = false,
  cranking = false,
  crankAllowed = true
}

local carInfo = {
  0.6, --starter overrun time in seconds
  ac.INIConfig.carData(0, 'engine.ini'):get('ENGINE_DATA', 'MINIMUM', 900) --engine idle value
}

ac.setEngineStalling(true)
local engineStartRPM = 1300
local crankTime = 0
local cd = 0
local CARPM = 0
local tmp = 0
local carRPM = 0

function script.update(dt)
  CAR = ac.accessCarPhysics()
  carInputs = {
    ignition = car.extraA,
    cranking = car.extraB, 
    clutch = CAR.clutch
  }

  --local dt because csp aint got nothing
  cd = cd + 0.003
  ----------------------------

  if carInputs.cranking and carState.crankAllowed and CAR.rpm < carInfo[2] then
    crankTime = cd + carInfo[1]
  end

  --engage the starter, allow a small overrun
  if cd <= crankTime and carInputs.ignition then
    carState.cranking = true
  else
    carState.cranking = false
  end

  --stop the engine
  if not carInputs.ignition then
    carState.crankAllowed = true
    carRPM = math.applyLag(carRPM, 0, 0.97, 0.003)
    if carRPM < 10 then
      carRPM = 0 --otherwise it will slowly drop to 0 forever
    end
    ac.setEngineRPM(carRPM)
  else
    carRPM = CAR.rpm
  end

  --engage the starter motor
  if carState.cranking then
    carRPM = math.applyLag(carRPM, engineStartRPM, 0.92, 0.003)
    ac.setEngineRPM(carRPM)
  else
    carRPM = CAR.rpm
  end
end
