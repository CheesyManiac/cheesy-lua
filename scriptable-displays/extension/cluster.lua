--because this is specific to this car, I"m going to make a table that draws the gears quickly. This can be edited for future cars.
local gearT = {
    [-1] = "R",
    [0] = "N",
    [1] = "1",
    [2] = "2",
    [3] = "3",
    [4] = "4",
    [5] = "5",
    [6] = "6",
    [7] = "7",
    [8] = "8"
    
}

local Icons = {
    ["EML"] = "assets/icons/EML_ON.png",
    ["ABS"] = "assets/icons/ABS_ON.png",
    ["ESC"] = "assets/icons/ESC.png",
    ["ILEFT"] = "assets/icons/INDICATOR_LEFT.png",
    ["IRIGHT"] = "assets/icons/INDICATOR_RIGHT.png",
    ["LIGHT_HIGHBEAM"] = "assets/icons/LIGHT_HIGHBEAM.png",
    ["LIGHT_PARKING"] = "assets/icons/LIGHT_PARKING.png",
    ["SPEEDLIMIT"] = "assets/icons/speedlimit2.png"
}
local indicatorActive
setInterval(function() indicatorActive = not indicatorActive end, 1/2.6)


--load the cluster video LUTs into memory so we can refer to them later. Interestingly they are very non-linear, but this fixes that.
if ac.getPatchVersionCode() > 2080 then
    rpmLUT = ac.DataLUT11.load("assets/cluster/rpm_frames_2/rpm-frame.lut")
    speedLUT = ac.DataLUT11.load("assets/cluster/speed_frames_2/speed-frame.lut")
    ac.log("LUT Files loaded")
end
local carRPM = 0
local carSpeed = 0

local rpmframe
local rpmmaxframe = 300
local rpmposition = vec2(2300,600)
local rpmsize = vec2(580,540):scale(2.1)

--load speed video and set it"s settings accordingly.
local speedframe
local speedmaxframe = 300
local speedsize  = vec2(580,540):scale(2.1)
local speedposition = vec2(500,600)

--speedlimit target location vec2(1320, 1480)
local speedLimPosVert = 2000
local speedLimPosAnim = false
 
local rpmStartUp = 0
local SpeedStartUp = 0
local dashReady = false

function update(dt)
    ui.setAsynchronousImagesLoading(false)
    if rpmStartUp < rpmmaxframe then
        rpmStartUp = rpmStartUp + 1
        ui.drawImage("./assets/frames_rpm/rpm".. rpmStartUp ..".jpg", rpmposition, vec2(rpmposition.x+rpmsize.x, rpmposition.y+rpmsize.y))
    end
    if SpeedStartUp < speedmaxframe then 
        SpeedStartUp = SpeedStartUp + 1
        ui.drawImage("./assets/frames_speed/speed".. SpeedStartUp ..".jpg", speedposition, vec2(speedposition.x+speedsize.x, speedposition.y+speedsize.y)) 
    end

    local time = string.format("%02d:%02d",sim.timeHours,sim.timeMinutes)
    local temp = "+" .. sim.ambientTemperature .. "C"
    local distance = (car.fuel * sim.trackLengthM ) / car.fuelPerLap .. "km"

    if ac.getPatchVersionCode() < 2080 and rpmStartUp == 300 and SpeedStartUp == 300 then
        ui.setAsynchronousImagesLoading(false)
        ac.debug("Render method", "Old")
        carRPM = math.applyLag(carRPM, car.rpm, 0.8, dt)

        rpmframe = math.min(rpmmaxframe, (rpmmaxframe/7400)*carRPM+10)
        rpmframe = math.floor(rpmframe)
        ui.drawImage("./assets/frames_rpm/rpm"..rpmframe..".jpg", rpmposition, vec2(rpmposition.x+rpmsize.x, rpmposition.y+rpmsize.y))

        if car.speedKmh >= 0 and car.speedKmh <= 20 then
            speedframe = (53/20)*car.speedKmh
        elseif car.speedKmh > 20 and car.speedKmh <= 60 then
            speedframe = ((103-53)/(60-20))*car.speedKmh+(53-(((103-53)/(60-20))*20))
        elseif car.speedKmh > 60 and car.speedKmh <= 100 then
            speedframe = ((150-103)/(100-60))*car.speedKmh+(103-(((150-103)/(100-60))*60))
        elseif car.speedKmh > 100 and car.speedKmh <= 140 then
            speedframe = ((182-150)/(140-100))*car.speedKmh+(150-(((182-150)/(140-100))*100))
        elseif car.speedKmh > 140 and car.speedKmh <= 200 then
            speedframe = ((219-182)/(200-140))*car.speedKmh+(182-(((219-182)/(200-140))*140))
        elseif car.speedKmh > 200 and car.speedKmh <= 260 then
            speedframe = ((256-219)/(260-200))*car.speedKmh+(219-(((256-219)/(260-200))*200))
        elseif car.speedKmh > 260 then
            speedframe = ((299-256)/(320-260))*car.speedKmh+(256-(((299-256)/(320-260))*260))
        end
        ui.drawImage("./assets/frames_speed/speed" .. math.min(speedmaxframe, math.floor(speedframe)) .. ".jpg", speedposition, vec2(speedposition.x+speedsize.x, speedposition.y+speedsize.y))

    elseif ac.getPatchVersionCode() > 2080 and rpmStartUp == 300 and SpeedStartUp == 300 then
        ac.debug("Render method", "New")
        carRPM = math.applyLag(carRPM, car.rpm, 0.5, dt)
        rpmframe = math.applyLag(rpmframe, rpmLUT:get(carRPM),0.5,dt)
        rpmframe = math.round(rpmframe,0)
        ui.drawImage("./assets/frames_rpm/rpm"..rpmframe..".jpg", rpmposition, vec2(rpmposition.x+rpmsize.x, rpmposition.y+rpmsize.y))

        carSpeed = math.applyLag(carSpeed, car.speedKmh, 0.5, dt)
        speedframe = math.applyLag(speedframe, speedLUT:get(carSpeed), 0.5, dt)
        speedframe = math.round(speedframe,0)
        ui.drawImage("./assets/frames_speed/speed" .. math.min(speedmaxframe, math.floor(speedframe)) .. ".jpg", speedposition, vec2(speedposition.x+speedsize.x, speedposition.y+speedsize.y))
    end

    ----- Dash loading thing -----
    if dashReady == false then
        if rpmStartUp == rpmmaxframe and SpeedStartUp == speedmaxframe then   
            display.text{
            text = "DASH READY",
            pos = vec2(1820,1190),
            letter = vec2(20, 40):scale(2),
            font = "fonts/340i",
            color = rgbm.colors.green,
            alignment = 0,
            width = 1000,
            spacing = 0
            }
            setTimeout(function () dashReady = true end, 2.5)            
        else
            display.text{
                text = "    DASH \nINITIALISING",
                pos = vec2(1660,1190),
                letter = vec2(20, 40):scale(2),
                font = "fonts/340i",
                color = rgbm.colors.white,
                alignment = 1,
                width = 1000,
                spacing = 0
            }
        end
    end

    ----- Current Music that"s playing -----
    if dashReady then
        local music = ac.currentlyPlaying()
        if music.hasCover then
            display.image{
            image = music,
            pos = vec2(1840,1100),
            size = vec2(100,100):scale(3),
            color = rgbm.colors.white,
            uvStart = vec2(0, 0),
            uvEnd = vec2(1, 1)
            }
        end
        display.text{
          text = music.title,
          pos = vec2(1600,1450),
          letter = vec2(20, 40):scale(1.8),
          font = "e92_big",
          color = rgbm.colors.white,
          alignment = 0.5,
          width = 800,
          spacing = 0
        }
        display.text{
            text = music.artist,
            pos = vec2(1600,1520),
            letter = vec2(20, 40):scale(1.2),
            font = "e92_big",
            color = rgbm.colors.red,
            alignment = 0.5,
            width = 800,
            spacing = 0
          }
        display.horizontalBar({
          text = "",
          pos = vec2(1700,1580),
          size = vec2(600, 10),
          delta = 0,
          activeColor = rgbm(0.5,0.2,0, 1),
          inactiveColor = rgbm.colors.transparent,
          total = 100,
          active = math.floor(math.lerpInvSat(music.trackPosition,0,music.trackDuration)*100)
        })
    end
    ----- speed -----
    display.text {
        text = math.round(car.speedKmh, 0),
        pos = vec2(1060,1190),
        color = rgbm(1,1,1,1),
        letter = vec2(95, 100),
        font = "e92_big",
        width = 200,
        alignment = 1
    }
    ----- S next to gear -----
    display.text {
        text = "S",
        pos = vec2(2575,1190),
        color = rgbm(1,1,1,1),
        letter = vec2(95, 100),
        font = "fonts/340i",
        width = 200,
        alignment = 1
    }

    ----- draw the current gear but looking in the table created at the start. Much faster than before -----
    display.text {
        text = gearT[car.gear],
        pos = vec2(2665,1190),
        color = rgbm(1,1,1,1),
        letter = vec2(95, 100),
        font = "fonts/340i",
        width = 200,
        alignment = 1
    }

    ui.drawImage("./assets/icons/gaz_icon.png", vec2(745, 1625) ,vec2(745+38, 1625+38) , rgbm(1,1,1,1))
    
    if car.fuelPerLap ~= 0 then
        display.text {
            text = distance,
            pos = vec2(786, 1622),
            color = rgbm(1,1,1,1),
            letter = vec2(45, 55),
            font = "fonts/m4_font",
            width = 100,
            alignment = 1
        }
    else
        display.text {
            text = "500",
            pos = vec2(786, 1622),
            color = rgbm(1,1,1,1),
            letter = vec2(45, 55),
            font = "fonts/m4_font",
            width = 100,
            alignment = 1
        }

        display.text {
            text = "km",
            pos = vec2(900, 1618),
            color = rgbm(1,1,1,1),
            letter = vec2(45, 200),
            font = "fonts/arial_hd",
            width = 100,
            alignment = 1
        }
    end

    --clock?
    display.text {
        text = time,
        pos = vec2(1070, 1622),
        color = rgbm(1,1,1,1),
        letter = vec2(45, 55),
        font = "fonts/m4_font",
        width = 100,
        alignment = 1
    }

    display.rect {
      pos = vec2(2870, 1635),
      size = vec2(250, 60),
      color = rgbm(0, 0, 0, 1)
  }

    ----- outside temp ------
    local temp = "+" .. sim.ambientTemperature
    ui.drawRectFilled(vec2(2900, 1630),vec2(3130, 1695),rgbm(0,0,0,0.5), 20)
    display.text {
        text = temp,
        pos = vec2(2920, 1610),
        color = rgbm(1,1,1,1),
        letter = vec2(35, 70):scale(1.5),
        font = "bmw",
        width = 100,
        alignment = 1
    }
    display.text {
        text = " @",
        pos = vec2(3040, 1630),
        color = rgbm(0.9,0.9,0.9,1),
        letter = vec2(20, 60):scale(1.4),
        font = "e92_big",
        width = 100,
        alignment = 1
    }

    ----- speedlimit -----
    local speedLimPos = vec2(1320, speedLimPosVert)
    if car.isInPitlane and speedLimPosVert > 1480 and not speedLimPosAnim then
        speedLimPosVert = speedLimPosVert - 10

        ui.drawImage(Icons.SPEEDLIMIT, speedLimPos, vec2(speedLimPos.x+125,speedLimPos.y+125),rgbm.colors.white,vec2(0,0), vec2(1,1),true)
        display.text{
            text = car.speedLimiter,
            pos = vec2(speedLimPos.x+15, speedLimPos.y+25),
            color = rgbm(0,0,0,1),
            letter = vec2(20, 50):scale(1.6),
            font = "bmw",
            width = 100,
            alignment = 0.5
        }
        if speedLimPosVert == 1480 then
            speedLimPosAnim = true
        end
    elseif car.isInPitlane and speedLimPosVert == 1480 then
        ui.drawImage(Icons.SPEEDLIMIT, vec2(1320, 1480), vec2(speedLimPos.x+125,speedLimPos.y+125),rgbm.colors.white,vec2(0,0), vec2(1,1),true)
        display.text{
            text = car.speedLimiter,
            pos = vec2(speedLimPos.x+15, speedLimPos.y+25),
            color = rgbm(0,0,0,1),
            letter = vec2(20, 50):scale(1.6),
            font = "bmw",
            width = 100,
            alignment = 0.5
        }
    elseif not car.isInPitlane and speedLimPosVert < 2000 and speedLimPosAnim then
        speedLimPosVert = speedLimPosVert + 10

        ui.drawImage(Icons.SPEEDLIMIT, speedLimPos, vec2(speedLimPos.x+125,speedLimPos.y+125),rgbm.colors.white,vec2(0,0), vec2(1,1),true)
        display.text{
            text = car.speedLimiter,
            pos = vec2(speedLimPos.x+15, speedLimPos.y+25),
            color = rgbm(0,0,0,1),
            letter = vec2(20, 50):scale(1.6),
            font = "bmw",
            width = 100,
            alignment = 0.5
        }
        if speedLimPosVert == 2000 then
            speedLimPosAnim = false
        end
    end

    ----- other icons -----
    if not car.lowBeams and car.headlightsActive then
        ui.drawImage(Icons.LIGHT_HIGHBEAM, vec2(510, 1218),vec2(510+80, 1218+80) , rgbm(0,0,255,1))
    end
    if car.headlightsActive then
        ui.drawImage(Icons.LIGHT_PARKING, vec2(510, 1418),vec2(510+80, 1418+80) , rgbm(0.1,1,0.1,1))
    end 
	 
	if car.tractionControlInAction then
        setInterval(function() tractionControlInAction = not tractionControlInAction end, 0.15, "tractionControlInAction")
        lasttrue = os.clock()
	elseif (os.clock() - lasttrue > 0.5) then
        clearInterval("tractionControlInAction")
		tractionControlInAction = false
        
    end
    
    if car.tractionControlMode == 0 or tractionControlInAction then
        ui.drawImage(Icons.ESC, vec2(3445, 1423),vec2(3445+80, 1423+80) , rgbm(25,2,0,1))
    end
        
    if not lasttrueTC then
        lasttrueTC = 0
    end
    if car.tractionControlInAction then
        setInterval(function() tractionControlInAction = not tractionControlInAction end, 0.15, "tractionControlInAction")
        lasttrueTC = os.clock()
	elseif (os.clock() - lasttrueTC > 0.5) then 
        clearInterval("tractionControlInAction")
		tractionControlInAction = false
        
    end
    if car.tractionControlMode == 0 or tractionControlInAction then
        ui.drawImage(Icons.ESC, vec2(3445, 1423),vec2(3445+80, 1423+80) , rgbm(25,2,0,1))
    end
end