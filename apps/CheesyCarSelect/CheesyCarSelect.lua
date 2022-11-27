local settings = ac.storage
{
  autoFocus = true;
  playerPosition = false;
  supportACSM = false;
  listDetailed = true;
  listPreview = true;
  mapScale = 300;
  mapLocal = false;
  mapColourA = rgbm(0.6,0.6,0.6,1);
  mapColourB = rgbm(0,0.8,0,1);
  mapColourC = rgbm(1,1,0,1);
}

local sim = ac.getSim()
local selectedCar = ac.getCar(0)
local displayMapToggle = false
local listHovered = false
local hoveredItem = 0
local carHoverImage = nil

--=======================================================

function script.carList(dt)
ac.debug('carsCount', sim.carsCount)
ac.debug('listHovered', listHovered)
  if ac.getSim().isOnlineRace == true then
      ac.setWindowTitle('carList', "Car List".." - Online Session")
      ui.textWrapped(ac.getServerName())
      ui.separator()
  else    
    ac.setWindowTitle('carList', "Car List".." - Offline Session")
  end

  if (ui.windowHovered(ui.HoveredFlags.ChildWindows) ) then
    listHovered = true
  else
    listHovered = false
  end


  ui.childWindow('##drivers', vec2(ui.availableSpaceX(), (ui.availableSpaceY()-50)), true, function ()
    for i = 1, (sim.carsCount) do
      ui.pushFont(ui.Font.Monospace)
      local car = ac.getCar(i - 1)
        if ui.itemHovered() then
          hoveredItem = (i-2)
        end
        if car.isConnected then
          if settings.playerPosition == true then
            if ui.selectable(string.pad(ac.getCarLeaderboardPosition(i-1),2,0,-1).." | "..ac.getDriverName(i - 1), selectedCar) then
              selectedCar = car
              if settings.autoFocus == true then
                ac.focusCar(selectedCar.index)
              end
            end
          elseif
            ui.selectable(i..'  '..tostring(car.index+1)..'  '..ac.getDriverName(i - 1), selectedCar == car) then
            selectedCar = car
            if settings.autoFocus == true then
              ac.focusCar(selectedCar.index)
            end
          end
        else
          ui.pushFont(ui.Font.Italic)
          ui.text('not connected')
          ui.popFont()
        end
      ui.popFont()
      ac.debug('i',i)
      ac.debug('car.index', car.index)
      ac.debug('hoveredItem', hoveredItem)
    end
  end)

  ui.separator()

  ui.columns(3,true,nil)
  if ui.button("Reset Camera") then
    ac.focusCar(0)
  end
  ui.nextColumn()
  if settings.supportACSM == true then
    if ui.button("ACSM Spec") then
      ac.sendChatMessage("/spectate "..selectedCar.index)
    end
  end
  ui.nextColumn()
    if ui.button("Open Map") then
      displayMapToggle = not displayMapToggle
      ac.setWindowOpen('displayMap', displayMapToggle)
    end



    local function drawPreviewWindow()
      ui.image(carHoverImage,vec2(1022*0.5,575*0.5),true)
      carHoverImage = ac.getFolder(ac.FolderID.ContentCars)..'/'..ac.getCarID(hoveredItem)..'/skins/'..ac.getCarSkinID(hoveredItem)..'/preview.png'
    end
    if listHovered then
      ui.toolWindow('###carPreview',ui.mousePos(),vec2(1022*0.5,575*0.5), true, drawPreviewWindow)
      ac.debug('carPreviewImage',carHoverImage)
    end
end

--=======================================================

function script.settingsWindow()
  if ui.checkbox('Detailed List View', settings.listDetailed) then
    settings.listDetailed = not settings.listDetailed
  end
  if ui.checkbox("Auto Focus Car", settings.autoFocus) then
    settings.autoFocus = not settings.autoFocus
  end
  if ui.checkbox("Show Preview on list", settings.listPreview) then
    settings.listPreview = not settings.listPreview
  end
  if ui.checkbox("Show Player Position", settings.playerPosition) then
    settings.playerPosition = not settings.playerPosition
  end
  if ui.checkbox("ACSM Spectator Support", settings.supportACSM) then
    settings.supportACSM = not settings.supportACSM
  end
end

--=======================================================

local controlisAI = false
function script.detailedInfo(dt)


  if ac.getCar(selectedCar.index).isRemote == true then
    controlisAI = not controlisAI
    ui.textWrapped("Current Car is Remote controlled. Limited information is available")
    ui.separator()
  end
  --ui.radioButton('drs available',selectedCar.drsAvailable)
  --ui.radioButton('drs active',selectedCar.drsActive)


  

  ui.tabBar('detailedInfoTab', ui.TabBarFlags.Reorderable,function ()
    ui.tabItem('Car info', function()
      ui.text("Position: "..selectedCar.racePosition)
      ui.text("Leaderboard: "..ac.getCarLeaderboardPosition(selectedCar.index))
      ui.text("Relative: "..ac.getCarRealTimeLeaderboardPosition(selectedCar.index))
     ui.text("Name: "..ac.getDriverName(selectedCar.index))
     ui.text("Code: "..ac.getDriverNationCode(selectedCar.index))
     ui.text("Nation: "..ac.getDriverNationality(selectedCar.index))
     ui.text("Number: "..ac.getDriverNumber(selectedCar.index))
     ui.text("Team: "..ac.getDriverTeam(selectedCar.index) or nil)
    end)
    ui.tabItem('Car Location', function()
      ui.pushFont(ui.Font.Monospace)
      ui.text(('car position:    '..tostring(selectedCar.position)))
      ui.text('track progress:  '..tostring(ac.worldCoordinateToTrackProgress(selectedCar.position)))
      ui.text('Upcoming Turn Distance:  '..tostring(ac.getTrackUpcomingTurn(selectedCar.index).x))
      ui.text('Upcoming Turn Angle:  '..tostring(ac.getTrackUpcomingTurn(selectedCar.index).y))
      ui.text('Steering Angle:  '..tostring(selectedCar.steer))
      ui.popFont()
    end)
    ui.tabItem('Car Preview', function()
      local carPreviewImage = ac.getFolder(ac.FolderID.ContentCars)..'/'..ac.getCarID(selectedCar.index)..'/skins/'..ac.getCarSkinID(selectedCar.index)..'/preview.png'
      ui.textWrapped(carPreviewImage)
      ui.image(carPreviewImage,vec2(1022*0.5,575*0.5),true)

    end)
  end)
end

--=======================================================

local mapFile = ac.getFolder(ac.FolderID.ContentTracks)..'/'..ac.getTrackFullID('/')..'/map.png'
--create a table containing information about the track map image size and offset values
local mapParams = ac.INIConfig.load(ac.getFolder(ac.FolderID.ContentTracks)..'/'..ac.getTrackFullID('/')..'/data/map.ini'):mapSection('PARAMETERS', {
  X_OFFSET = 0,
  Z_OFFSET = 0,
  SCALE_FACTOR = 0,
  WIDTH = 600,
  HEIGHT = 600
})
  local childWindowFlags = bit.bor(0)
-- local mapSize = vec2(mapParams.WIDTH / mapParams.HEIGHT * settings.mapScale, settings.mapScale)
  local windowSize = 0
  local mapBackground = true

--=======================================================

function script.displayMap(dt)

  local mapSize = vec2(1,mapParams.HEIGHT / mapParams.WIDTH ) * windowSize
  local drawFrom = ui.getCursor()

  if ((ui.windowContentSize().x)) > ui.windowContentSize().y then
    windowSize = (ui.windowContentSize().y)-50
  else
    windowSize = (ui.windowContentSize().x)-50
  end

  if mapBackground == true then
    childWindowFlags = bit.bor(0)
  else
    childWindowFlags = bit.bor(ui.WindowFlags.NoBackground)
  end

  ui.childWindow('mapArea', vec2(ui.availableSpaceX(), ui.availableSpaceY()),false, childWindowFlags, function()
  ui.drawImage(mapFile, drawFrom, drawFrom+mapSize)

  for i = 1, sim.carsCount do
    local car = ac.getCar(i - 1)
    if car.isConnected then
      local posX = (car.position.x + mapParams.X_OFFSET) / mapParams.WIDTH
      local posY = (car.position.z + mapParams.Z_OFFSET) / mapParams.HEIGHT
      if car.wheelsOutside < 2 then
        ui.drawCircleFilled(drawFrom + vec2(posX, posY) * mapSize/mapParams.SCALE_FACTOR, 5, car == selectedCar and settings.mapColourB or settings.mapColourA)
        ui.dwriteDrawText(math.round(car.speedKmh, 0), 20,drawFrom + vec2(posX, posY) * mapSize/mapParams.SCALE_FACTOR, rgbm.colors.black)
      else
        ui.drawCircleFilled(drawFrom + vec2(posX, posY) * mapSize/mapParams.SCALE_FACTOR, 5, car == selectedCar and settings.mapColourC or settings.mapColourC)
      end
    end
  end
  end)
--[[
  if ac.windowFading() <= 0.8 then
    ui.separator()
    ui.columns(3,false,'mapScaler')
      if ui.button('Reset Size') then
        settings.mapScale = 300
      end
    ui.nextColumn()
      if ui.button('Increase Size') then
        settings.mapScale = settings.mapScale + 10
      end
    ui.nextColumn()
      if ui.button('Decrease Size') then
        settings.mapScale = settings.mapScale - 10
      end
    ui.columns(1, false, nil)
  end]]

  --[[
  ac.debug('window size', tostring(ui.windowSize()))
  ac.debug('window content', tostring(ui.windowContentSize()))
  ac.debug('2.1 maps size', mapSize)
  ac.debug('2.2 maps ratio', mapSize.x / mapSize.y)
  ac.debug('mapwindow', mapWindow)
  ac.debug('mapwindow', windowSize)
  ac.debug('1.1 mapres', vec2(mapParams.WIDTH, mapParams.HEIGHT))
  ac.debug('1.2 map ratio', mapParams.WIDTH / mapParams.HEIGHT)
  ac.debug('window size', tostring(ui.windowSize()))
  ac.debug('window content', tostring(ui.windowContentSize()))
  ac.debug('2.1 maps size', mapSize)
  ac.debug('2.2 maps ratio', mapSize.x / mapSize.y)
  ac.debug('mapwindow', mapWindow)
  ac.debug('mapwindow', windowSize)
  ac.debug('1.1 mapres', vec2(mapParams.WIDTH, mapParams.HEIGHT))
  ac.debug('1.2 map ratio', mapParams.WIDTH / mapParams.HEIGHT)
]]
end
--=======================================================

function script.settingsMap(dt)
  --if ui.checkbox('Local Mode   ', settings.mapLocal) then
    --settings.mapLocal = not settings.mapLocal
  --end
  if ui.checkbox('Map Background', mapBackground) then
    mapBackground = not mapBackground
  end
  if ui.button('Reset Colours') then
    settings.mapColourA = rgbm(0.6,0.6,0.6,1)
    settings.mapColourB = rgbm(0,0.8,0,1)
    settings.mapColourC = rgbm(1,1,0,1)
  end
  ui.combo('##otherCar', 'Selected Car Colour', ui.ComboFlags.HeightLargest, function ()
      ui.colorPicker('Other Cars', settings.mapColourB)
    settings.mapColourB = settings.mapColourB
  end)
  ui.combo('##currentCar', 'Other Car Colour', ui.ComboFlags.HeightLargest, function ()
    ui.colorPicker('Other Cars', settings.mapColourA)
    settings.mapColourA = settings.mapColourA
  end)
  ui.combo('##offtrackCar', 'Offtrack Car Colour', ui.ComboFlags.HeightLargest, function ()
    ui.colorPicker('Other Cars', settings.mapColourC)
    settings.mapColourC = settings.mapColourC
  end)
end