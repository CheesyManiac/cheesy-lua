
--[[local extra_cfg_main = {
    --['param'] =  {default, input type, min, max, steps},
    [1] = {'PlayerRadiusMeters',200},
    [2] = {'PlayerPositionOffsetMeters',100},
    [3] = {'PlayerAfkTimeoutSeconds',10},
    [4] = {'MaxPlayerDistanceToAiSplineMeters',7},
    [5] = {'MinSpawnDistancePoints',100},
    [6] = {'MaxSpawnDistancePoints',400},
    [7] = {'MinAiSafetyDistanceMeters',20},
    [8] = {'MaxAiSafetyDistanceMeters',70},
    [9] = {'StateSpawnDistanceMeters',1000},
    [10] = {'MinStateDistanceMeters',200},
    [11] = {'SpawnSafetyDistanceToPlayerMeters',150},
    [12] = {'MinSpawnProtectionTimeSeconds',4},
    [13] = {'MaxSpawnProtectionTimeSeconds',8},
    [14] = {'MinCollisionStopTimeSeconds',1},
    [15] = {'MaxCollisionStopTimeSeconds',3},
    [16] = {'MaxSpeedKph',80},
    [17] = {'RightLaneOffsetKph',10},
    [18] = {'MaxSpeedVariationPercent',0.15},
    [19] = {'DefaultDeceleration',8.5},
    [20] = {'DefaultAcceleration',2.5},
    [21] = {'MaxAiTargetCount',300},
    [22] = {'AiPerPlayerTargetCount',10},
    [23] = {'MaxPlayerCount',0},
    [24] = {'HideAiCars',false},
    [25] = {'SplineHeightOffsetMeters',0},
    [26] = {'LaneWidthMeters',3},
    [27] = {'TwoWayTraffic',false},
    [28] = {'CorneringSpeedFactor',1},
    [29] = {'CorneringBrakeDistanceFactor',1},
    [30] = {'CorneringBrakeForceFactor',1},
    [31] = {'NamePrefix','traffic'},
    [32] = {'IgnoreObstaclesAfterSeconds',10},
    [33] = {'TrafficDensity',1},
    [34] = {'HourlyTrafficDensity',nil},
    [35] = {'TyreDiameterMeters',0.64999997615814209},
    [36] = {'SmoothCamber',false}
}]]

local extra_cfg_main = {
    --['param'] =  {default, input type, min, max, steps},
    [1] = {"EnableAntiAfk","checkbox","true","","","", "Enable AFK autokick"},
    [2] = {"MaxAfkTimeMinutes","slider",10,0,180,5,"Maximum allowed AFK time before kick"},
    [3] = {"AfkKickBehavior_NOTWORKINGYET","list","","","","","Players might try to get around the AFK kick by doing inputs once in a while without actually driving. Set this to MinimumSpeed to autokick players idling"},
    [4] = {"MaxPing","slider",500,50,1000,50,"Maximum ping before autokick"},
    [5] = {"MaxPingSeconds","slider",10,5,120,5,"Maximum ping duration before autokick"},
    [6] = {"ForceLights","checkbox","false","","","","Force headlights on for all cars"},
    [7] = {"EnableServerDetails","checkbox","true","","","","Enable server details in CM. Required for server description"},
    [8] = {"ServerDescription","text","","","","","Server description shown in Content Manager. EnableServerDetails must be on"},
    [9] = {"EnableRealTime","checkbox","false","","","","Link server time to real map time. For correct timezones there must be an entry for the map here: https://github.com/ac-custom-shaders-patch/acc-extension-config/blob/master/config/data_track_params.ini"},
    [10] = {"RainTrackGripReductionPercent","slider",0,0,1,0.05,"Reduce track grip when the track is wet. This is much worse than proper CSP rain physics but allows you to run clients with public/Patreon CSP at the same time"},
    [11] = {"EnableCustomUpdate","checkbox","false","","","","Enable CSP custom position updates. This is an improved version of batched position updates, reducing network traffic even further. CSP 0.1.77+ required"},
    [12] = {"PlayerLoadingTimeoutMinutes","slider",10,5,60,5,"Maximum time a player can spend on the loading screen before being disconnected"}
}

local extra_cfg_ai = {
        --['param'] =  {Name, type, default, min, max, steps, desc},
    [1] = {"PlayerRadiusMeters","slider",200,0,1000,10,"Radius around a player in which AI cars won't despawn"},
    [2] = {"PlayerPositionOffsetMeters","slider",100,0,1000,10,"Offset the player radius in direction of the velocity of the player so AI cars will despawn earlier behind a player"},
    [3] = {"MaxPlayerDistanceToAiSplineMeters","slider",7,0,50,1,"Maximum distance to the AI spline for a player to spawn AI cars. This helps with parts of the map without traffic so AI cars won't spawn far away from players"},
    [4] = {"MinSpawnDistancePoints","slider",100,0,500,10,"Minimum amount of spline points in front of a player where AI cars will spawn"},
    [5] = {"MaxSpawnDistancePoints","slider",400,0,1000,10,"Maximum amount of spline points in front of a player where AI cars will spawn"},
    [6] = {"MinAiSafetyDistanceMeters","slider",20,0,100,2,"Minimum distance between AI cars"},
    [7] = {"MaxAiSafetyDistanceMeters","slider",70,0,100,2,"Maximum distance between AI cars"},
    [8] = {"StateSpawnDistanceMeters","slider",1000,0,2000,50,"Minimum spawn distance for AI states of the same car slot. If you set this too low you risk AI states despawning or AI states becoming invisible for some players when multiple states are close together"},
    [9] = {"MinStateDistanceMeters","slider",200,0,500,50,"Minimum distance between AI states of the same car slot. If states get closer than this one of them will be forced to despawn"},
    [10] = {"SpawnSafetyDistanceToPlayerMeters","slider",150,0,500,10,"Minimum spawn distance to players"},
    [11] = {"MinSpawnProtectionTimeSeconds","slider",4,0,18,1,"Minimum time in which a newly spawned AI car cannot despawn"},
    [12] = {"MaxSpawnProtectionTimeSeconds","slider",8,0,20,1,"Maximum time in which a newly spawned AI car cannot despawn"},
    [13] = {"MinCollisionStopTimeSeconds","slider",1,0,18,1,"Minimum time an AI car will stop/slow down after a collision"},
    [14] = {"MaxCollisionStopTimeSeconds","slider",3,0,20,1,"Maximum time an AI car will stop/slow down after a collision"},
    [15] = {"IgnoreObstaclesAfterSeconds","slider",10,0,30,1,"Ignore obstacles for some time if the AI car is stopped for longer than x seconds"},
    [16] = {"PlayerAfkTimeoutSeconds","slider",10,0,60,1,"AFK timeout for players. Players who are AFK longer than this won't spawn AI cars"},
    [17] = {"MaxPlayerCount","slider",0,0,ac.getSim().carsCount,1,"Soft player limit, the server will stop accepting new players when this many players are reached. Use this to ensure a minimum amount of AI cars. 0 to disable."},
    [18] = {"MaxAiTargetCount","slider",300,0,5000,10,"Maximum AI car target count for AI slot overbooking. This is not an absolute maximum and might be slightly higher"},
    [19] = {"AiPerPlayerTargetCount","slider",10,0,100,1,"Number of AI cars per player the server will try to keep"},
    [20] = {"HideAiCars","checkbox","false","false","true","","Hide AI car nametags and make them invisible on the minimap. Broken on CSP versions < 0.1.78"},
    [21] = {"TwoWayTraffic","checkbox","false","false","true","","Enable two way traffic. This will allow AI cars to spawn in lanes with the opposite direction of travel to the player."},
    [22] = {"SplineHeightOffsetMeters","slider",0,0,2,0.01,"AI spline height offset. Use this if the AI spline is too close to the ground"},
    [23] = {"TyreDiameterMeters","slider",0.65,0,2,0.01,"Tyre diameter of AI cars in meters, shouldn't have to be changed unless some cars are creating lots of smoke."},
    [24] = {"TrafficDensity","slider",1,0,5,0.5,"Apply scale to some traffic density related settings. Increasing this DOES NOT magically increase your traffic density, it is dependent on your other settings. Values higher than 1 not recommended."},
    [25] = {"HourlyTrafficDensity",0,0,0,0,0,"Dynamic hourly traffic density. List must have exactly 24 entries in the format 0.2, 0.5, 1, 0.7, ..."},
    [26] = {"MaxSpeedKph","slider",80,0,500,5,"Default maximum AI speed. This is not an absolute maximum and can be overridden with RightLaneOffsetKph and MaxSpeedVariationPercent"},
    [27] = {"RightLaneOffsetKph","slider",10,0,100,1,"Speed offset for right lanes. Will be added to MaxSpeedKph"},
    [28] = {"MaxSpeedVariationPercent","slider",0.15,0,1,0.01,"Maximum speed variation"},
    [29] = {"DefaultDeceleration","slider",8.5,0,20,0.1,"Default AI car deceleration for obstacle/collision detection m/s^2"},
    [30] = {"DefaultAcceleration","slider",2.5,0,20,0.1,"Default AI car acceleration for obstacle/collision detection m/s^2"},
    [31] = {"CorneringSpeedFactor","slider",1,0.1,5,0.1,"AI cornering speed factor. Lower = AI cars will drive slower around corners."},
    [32] = {"CorneringBrakeDistanceFactor","slider",1,0.2,6,0.1,"AI cornering brake distance factor. Lower = AI cars will brake later for corners."},
    [33] = {"CorneringBrakeForceFactor","slider",1,0.3,7,0.1,"AI cornering brake force factor. This is multiplied with DefaultDeceleration. Lower = AI cars will brake less hard for corners."},
    [34] = {"Debug","checkbox","false","false","true","","Show debug overlay for AI cars"}
}


local server_cfg_params = {
    ['Name'] = ac.getServerName(),
    ['Password'] = nil,
    ['AdminPassword'] = nil,
    ['TimeOfDayMultiplier'] = ac.getSim().timeMultiplier,
    ['UdpPluginAddress'] = nil,
    ['UdpPluginLocalPort'] = nil
}

local server_commands = {
    
}

local function uiInput(type, value, min, max)
    if type == "checkbox" then
        if ui.checkbox("##checkbox") then
            value = not value
            result = value
        end
    end
    if type == "slider" then
        if ui.slider("##slider", value, min, max) then
            value = not value
            result = value
        end
    end
    if type == "text" then
        value = ui.inputText("##text", value)
    end
    return result
end     


--[[local serverINFO = ac.getServerIP()..ac.getServerPortHTTP().."/INFO"
local serverVersion = web.get(serverINFO, function (err, response)
    ac.debug("response.headers.string", response.headers.string)
    ac.debug("response.status", response.status)
    ac.debug("response.body", response.body)
    ac.debug("err", err)
end)]]






local selectedParam, setParam, defaultParam, selectedDesc = "",nil, "", nil
local selectedParamAI, setParamAI, defaultParamAI, selectedDescAI = "",nil, "", nil

local function extra_cfg_tab()
    ac.debug('1selectedParam', selectedParam)
    ac.debug('1setParam', setParam)
    ac.debug('1defaultParam', defaultParam)

    ac.debug('2selectedParamAI', selectedParamAI)
    ac.debug('2setParamAI', setParamAI)
    ac.debug('2defaultParamAI', defaultParamAI)


    ac.debug('isAdmin', ac.getSim().isAdmin)
    ui.pushFont(ui.Font.Title)
    ui.text('extra_cfg Main settings')
    ui.popFont()
    ui.newLine(0)
    ui.combo('##ExtraMain', string.format('Set: %s', selectedParam), selectedParam, function ()
        for i = 1, table.nkeys(extra_cfg_main) do
            if ui.selectable(extra_cfg_main[i][1], extra_cfg_main[i][1] == selectedParam) then
                selectedParam = extra_cfg_main[i][1]
                setParam = nil
                defaultParam = extra_cfg_main[i][3]
                selectedDesc = extra_cfg_main[i][7]
            end
        end
    end)
    setParam = ui.inputText("Default:  "..defaultParam.."##main", setParam)
    if setParam ~= nil and ui.button('Confirm Change##main') then
        ui.modalPopup("Set Value",'Extra.'..selectedParam..' '..setParam,function ()
            ac.sendChatMessage('/set '..'Extra.'..selectedParam..' '..setParam)
            ac.log('/set '..'Extra.'..selectedParam..' '..setParam)
        end)        
    elseif setParam == nil and ui.button('Confirm Change##main',ui.ButtonFlags.Disabled) then
    end
    ui.newLine(0)
    if selectedDesc ~= nil then
        ui.textWrapped(selectedDesc)
    else
        ui.text("Select a value for the description")
    end






    ui.separator()
    ui.pushFont(ui.Font.Title)
    ui.text('extra_cfg AI Paramaters')
    ui.popFont()
    ui.newLine(0)
    ui.combo('##ExtraAI', string.format('Set: %s', selectedParamAI), selectedParamAI, function ()
    for i = 1, table.nkeys(extra_cfg_ai) do
        if ui.selectable(extra_cfg_ai[i][1], extra_cfg_ai[i][1] == selectedParamAI) then
            selectedParamAI = extra_cfg_ai[i][1]
            defaultParamAI = extra_cfg_ai[i][3]
            setParamAI = nil
            selectedDescAI = extra_cfg_ai[i][7]
        end
    end
    end)
    setParamAI = ui.inputText('Default: ##AI'..defaultParamAI, setParamAI)
    if setParamAI ~= nil and ui.button('Confirm Change##AI') then
        ac.sendChatMessage('/set '..'Extra.AiParams.'..selectedParamAI..' '..setParamAI)
        ac.log('/set '..'Extra.AiParams.'..selectedParamAI..' '..setParamAI)
    elseif setParamAI == nil and ui.button('Confirm Change##AI', ui.ButtonFlags.Disabled) then 
    end
    ui.newLine(0)
    if selectedDescAI ~= nil then
        ui.textWrapped(selectedDescAI)
    else
        ui.text("Select a value for the description")
    end

end

local function server_cfg_tab()
    for h = 1, table.nkeys(server_cfg_params) do
        
    end
end

local TimeOfDay, changeHour, changeMinute, timeChanged = string.format("%02d",ac.getSim().timeHours)..":"..string.format("%02d",ac.getSim().timeMinutes), ac.getSim().timeHours, ac.getSim().timeMinutes, false
setInterval(function ()
    TimeOfDay = string.format("%02d",ac.getSim().timeHours)..":"..string.format("%02d",ac.getSim().timeMinutes)
    if not timeChanged then
        changeHour = ac.getSim().timeHours
        changeMinute = ac.getSim().timeMinutes
    end

end,1)

local function drawClock()
    local clockCenter = vec2(80,80)
    local clockRadius = 60
    local fontSize = vec2(-0.05,-0.06)
    ui.childWindow("##drawClock", vec2((clockCenter.x)*2, (clockCenter.y)*2),false, ui.WindowFlags.NoBackground, function ()

        ui.drawCircleFilled(clockCenter,clockRadius,rgbm(1,1,1,0.1),52)
        ui.drawCircle(clockCenter,clockRadius+3,rgbm(1,1,1,1),50,2)

        -- draws the hours on the clock 
        for i = 0, 11 do 
            local s = -math.sin(math.lerp(2,-2, i / 24) * math.pi)
            local c = -math.cos(math.lerp(2,-2, i / 24) * math.pi)

            ac.debug("s"..i,s)
            ac.debug("c"..i,c)
            ui.pushFont(ui.Font.Monospace)
            ui.drawText(i, clockCenter + vec2(s, c):add(fontSize) * clockRadius*0.9, rgbm.colors.white)
            ui.popFont()
        end

        -- draws the minutes needle
        local angle = (math.lerp(0, 2, math.lerpInvSat(changeMinute, 0,60)) * math.pi)
        local s = math.sin(angle)
        local c = -math.cos(angle)
        ui.drawLine(clockCenter - vec2(s, c) * 1, clockCenter + vec2(s, c) * (clockRadius *0.80), rgbm(0.9,0.9,0.9,1), 3)

        -- draws the hours needle
        local angle = (math.lerp(-2, 2, math.lerpInvSat(changeHour, 0,24)) * math.pi)
        local s = math.sin(angle)
        local c = -math.cos(angle)
        ui.drawLine(clockCenter - vec2(s, c) * 1, clockCenter + vec2(s, c) *(clockRadius *0.50), rgbm(0.2,0.2,0.2,1), 5)

        -- draws the seconds needle
        local angle = (math.lerp(-2, 2, math.lerpInvSat(ac.getSim().timeSeconds, 0,60)) * math.pi)
        local s = math.sin(angle)
        local c = -math.cos(angle)
        ui.drawLine(clockCenter - vec2(s, c) * 1, clockCenter + vec2(s, c) *(clockRadius *1), rgbm(1,0,0,1), 1)
    end)
end   

local function changeServerTime()
    ui.pushFont(ui.Font.Title)
    ui.text("Change Server Time")
    ui.newLine(-10)
    ui.popFont()

    ac.debug("TimeOfDay", TimeOfDay)
    ac.debug("changeHour", changeHour)
    ac.debug("changeMinute", changeMinute)
    ac.debug("timeChanged", timeChanged)


    if ui.arrowButton("##IncreaseHour", ui.Direction.Up, vec2(50,20)) then
        if changeHour >= 0 and changeHour <= 22 then
            changeHour = changeHour + 1
            timeChanged = true            
        elseif changeHour == 23 then
            changeHour = 0
            timeChanged = true 
        end
    end
    ui.sameLine(50, 25) 
    if ui.arrowButton("##IncreaseMinute", ui.Direction.Up, vec2(50,20)) then
        if changeMinute >= 0 and changeMinute <= 58 then
            changeMinute = changeMinute + 1
            timeChanged = true            
        elseif changeMinute == 59 then
            changeMinute = 0
            timeChanged = true 
        end
    end


    ui.pushFont(ui.Font.Huge)
    ui.textAligned(string.format("%02d",changeHour), vec2(0.5,0.5), vec2(50,70))
    ui.sameLine(50,25)
    ui.textAligned(string.format("%02d",changeMinute), vec2(0.5,0.5), vec2(50,70))
    ui.popFont()
    ui.sameLine(100,50)
    if timeChanged and ui.button("SET##time", vec2(70,70)) then
        ac.sendChatMessage("/settime "..string.format("%02d",changeHour)..":"..string.format("%02d",changeMinute))
        ac.log(("/settime "..string.format("%02d",changeHour)..":"..string.format("%02d",changeMinute)))
        timeChanged = false
    elseif timeChanged == false and ui.button('SET##time', vec2(70,70), ui.ButtonFlags.Disabled) then 
    end


    if ui.arrowButton("##DecreaseHour", ui.Direction.Down, vec2(50,20)) then
        if changeHour >= 1 and changeHour <= 23 then
            changeHour = changeHour - 1
            timeChanged = true            
        elseif changeHour == 0 then
            changeHour = 23
            timeChanged = true 
        end
    end
    ui.sameLine(50,25)
    if ui.arrowButton("##DecreaseMinute", ui.Direction.Down, vec2(50,20)) then
        if changeMinute >= 1 and changeMinute <= 59 then
            changeMinute = changeMinute - 1
            timeChanged = true            
        elseif changeMinute == 0 then
            changeMinute = 59
            timeChanged = true 
        end
    end
    ui.newLine(0)

end

local playerINFO = {
    ["IP"] = "",
    ["GUID"] = "",
    ["PING"] = "",
    ["POS"] = "",
    ["VELO"] = ""
}

local selectedCar, selectedName = ac.getCar(0), ""
local function playerList()
    ui.combo('##playerList', string.format('Select: %s', selectedName), selectedCar, function ()
        for g = 1, ac.getSim().carsCount do
            local car = ac.getCar(g-1)
            if car.isConnected  and not car.isHidingLabels then
                if ui.selectable(g..'  '..ac.getDriverName(g-1), selectedCar == car) then
                    selectedName = ac.getDriverName(g-1)
                    selectedCar = car
                    ac.sendChatMessage("/whois "..selectedName)
                end
            elseif not car.isHidingLabels then
                ui.pushFont(ui.Font.Italic)
                ui.text('not connected')
                ui.popFont()
            end
        end
    end)
    if ui.button("/whois") then
        ac.sendChatMessage("/whois "..selectedName)
        ac.log("asda")
    end
    ui.columns(2, true, "##playerINFO")
    ui.text("IP: ") ui.nextColumn() ui.text(playerINFO.IP) ui.nextColumn()
    ui.text("GUID: ") ui.nextColumn() ui.text(playerINFO.GUID) ui.nextColumn()
end

local function debug_items()

    ui.text('Copy server CSP Extra Options to Clipboard')
    if ui.button('Copy') then
        ui.setClipboardText(ac.INIConfig.onlineExtras())
    end
    ui.separator()
    ui.pushFont(ui.Font.Title)
    ui.text("Session Info")
    ui.popFont()
    ui.separator()
    ui.columns(2, true, "##sessionStates")
    ui.setColumnWidth(0, 180) ui.setColumnWidth(1, 500)

    ui.text("Current time: ") ui.nextColumn() ui.text(TimeOfDay)
    ui.nextColumn() ui.text("Current Time Multiplier: ") ui.nextColumn() ui.text(ac.getTimeMultiplier())
    ui.nextColumn() ui.text("Current Timezone Offset: ") ui.nextColumn() ui.text(math.round(ac.getTrackTimezoneBaseDst().x,1).." seconds")


    ui.separator()
    ui.nextColumn() ui.text("Current Sun Angle: ") ui.nextColumn() ui.text(math.round(ac.getSunAngle(),1))
    ui.nextColumn() ui.text("Current Sun Pitch: ") ui.nextColumn() ui.text(math.round(ac.getSunPitchAngle(),1))
    ui.nextColumn() ui.text("Current Sun Heading: ") ui.nextColumn() ui.text(math.round(ac.getSunHeadingAngle(),1))

    ui.separator()
    ui.nextColumn() ui.text("Track ID: ") ui.nextColumn() ui.text(ac.getTrackID())
    ui.nextColumn() ui.text("Track Layout: ") ui.nextColumn() ui.text(ac.getTrackLayout())
    ui.nextColumn() ui.text("Track Full Name: ") ui.nextColumn() ui.text(ac.getTrackName())    


end


--[[local function playerList()
    ui.combo('##playerList', string.format('Select: %s', selectedName), selectedCar, function ()
        for g = 1, ac.getSim().carsCount do
            local car = ac.getCar(g-1)
            if car.isConnected  and not car.isHidingLabels then
                if ui.selectable(g..'  '..ac.getDriverName(g-1), selectedCar == car) then
                    selectedName = ac.getDriverName(g-1)
                    selectedCar = car
                    ac.sendChatMessage("/whois "..selectedName)
                end
            elseif not car.isHidingLabels then
                ui.pushFont(ui.Font.Italic)
                ui.text('not connected')
                ui.popFont()
            end
        end
    end)
    if ui.button("/whois") then
        local teststring="IP: 192.168.1.62\nProfile: https://steamcommunity.com/profiles/76561198116748843\nPing: 0ms\nPosition: <5888.7393, 24.476053, -4650.8423>\nVelocity: 0kmh\n"
           
           stringtable = string.split(teststring, '\n', 100, false, true)
           
           for throwmeaway, line in pairs(stringtable) do
                --separate string by line
                --[[ from "key: value"
                line content returns
                "1"->"key"
                "2"->" value"
                ]]
                --[[local linecontent = string.split(line, ": ", 100, false, true)
                local key=linecontent[1]
                local value=linecontent[2]
                
                if(key==nil or value==nil) then
                    ac.log("Nul value in line '"..line.."'")
                else
                    if key=="IP" then
                        --xxx.xxx.xxx.xxx
                        --%d = digits
                        local ip = string.match(value, "%d+%.%d+%.%d+%.%d+")
                        if (ip == nil) then
                            ac.log("Wrong IP format: "..value)
                        else
                            playerINFO[key]=ip
                        end
                    elseif key=="Profile" then
                        --https://steamcommunity.com/profiles/76561198116748843
                        --using parenthesis specifies a match that you want to extract
                        local profile=string.match(value, "^.*/(%d+)")
                        if(profile == nil) then
                            ac.log("Profile format is wrong: "..value)
                        else
                            playerINFO[key]=profile
                        end
                    else
                        playerINFO[key]=value
                    end
                end
           end
        end
    ui.columns(2, true, "##playerINFO")
    --ui.text("IP: ") ui.nextColumn() ui.text(playerINFO.IP) ui.nextColumn()
    for key, value in pairs(playerINFO) do
        ui.text(key) ui.nextColumn() ui.text(value) ui.nextColumn()
    end
end]]






ac.onChatMessage(
    function (message, senderCarIndex, senderSessionID)
        ac.log(message)
        --if senderCarIndex == -1 then
            for a in string.gmatch(message,"IP:%s*(.-)\n") do
                playerINFO.IP = a
            end
            for b in string.gmatch(message,"profiles/*(%d+)") do
                playerINFO.GUID = b
            end
        --end
    end
)

-------------------------------------------------------

function script.windowMain()

    ui.text('Built for use with') ui.sameLine() ui.textHyperlink('https://assettoserver.org/')
    --ui.text('Version 0.0.50+2248415198')
    ui.newLine(0)
    --if ac.getSim().isOnlineRace and ac.getSim().isAdmin then
        ui.tabBar('##mainTabs',function()
                ui.tabItem('extra_cfg',function ()
                        extra_cfg_tab()
                end)
        
        
                ui.tabItem('server_cfg', function ()
                    server_cfg_tab()

                    local temp = {
                    "slider", "checkbox", "text"
                    }
                    result2 = uiInput(temp[1], extra_cfg_main[1][3])

                    ac.debug("result2", result2)
                end)


                ui.tabItem("Player Moderation", function ()
                    playerList()
                end)

        
                ui.tabItem('misc', function ()
                    changeServerTime()
                    ui.setCursor(vec2(250,100))
                    drawClock()
                    ui.separator()
                    
                end)
            end)
        --Other states
    --[[elseif ac.getSim().isOnlineRace and not ac.getSim().isAdmin then
        ui.separator()
        ui.newLine(0)
        ui.text('Sign in as Admin using the CSP Chat app to use this app')
    else
        ui.separator()
        ui.newLine(0)
        ui.text("This app only works with Servers. Please connect to an online server")
    end]]
end

function script.debugTrigger()
    debug_items()
end

ac.log("App Ready")