--CheesyManiac Server Icon Script v2.0
--Original Source: https://github.com/CheesyManiac/cheesy-lua/
--Distributed under the GNU GPL v3.0 License
--More info: https://choosealicense.com/licenses/gpl-3.0/

-------------------------------------------------------------------

--x is horizontal
--y is vertical
--(0,0) is the top left corner

local scriptVersion = "2.0"
ac.debug("1. Cheesy Icon Script", 'v'..scriptVersion)
ac.debug("2. Original Source: ", "https://github.com/CheesyManiac/")

local screensize = vec2(ac.getSim().windowWidth,ac.getSim().windowHeight)
local debugFlash, debugImage, debugLines,imageMetaLoaded = false, false, false, 0
setInterval(function ()debugFlash = not debugFlash end, 0.5)
ui.setAsynchronousImagesLoading(true)


--Image Config table that is used by the script. 
--Duplicate the entire table and increment the numbers by 1.
--Follow the example from image_0 and image_1 to get an understanding of how it works.
local image_0_source = 'https://raw.githubusercontent.com/CheesyManiac/cheesy-lua/main/server-scripts/iconScript/rocketIcon.gif'
local image_1_source = ''

-------------------------------------------------------------------
local function loadImageMeta()
    if imageMetaLoaded <  3 then
-------------------------------------------------------------------

        image_0 = {
        ['src'] = ui.GIFPlayer(image_0_source),
        ['sizeX'] = ui.imageSize(image_0_source).x,
        ['sizeY'] = ui.imageSize(image_0_source).y,
        ['paddingX'] = 10,
        ['paddingY'] = 10,
        ['scale'] = 0.5}


        image_1 = {
        ['src'] = ui.GIFPlayer(image_1_source),
        ['sizeX'] = ui.imageSize(image_1_source).x,
        ['sizeY'] = ui.imageSize(image_1_source).y,
        ['paddingX'] = 0,
        ['paddingY'] = 0,
        ['scale'] = 1}


-------------------------------------------------------------------
--------------DO NOT EDIT ANYTHING BELOW THIS LINE-----------------
---------------UNLESS YOU KNOW WHAT YOU ARE DOING------------------
-------------------------------------------------------------------
        imageMetaLoaded = imageMetaLoaded + 1
    end
end

local function drawdebugLines()
    --horizontal
    ui.drawLine(vec2(0, screensize.y/2), vec2(screensize.x, screensize.y/2), rgbm.colors.red,2)
    ui.drawText(" X-axis", vec2(0, screensize.y/2),rgbm.colors.red)
    --vertical
    ui.drawLine(vec2(screensize.x/2, 0), vec2(screensize.x/2, screensize.y),rgbm.colors.blue,2)
    ui.drawText(" Y-axis", vec2(screensize.x/2, 0),rgbm.colors.blue)
end

---@alias screenPosition
---| 'top_left' @!Top Left
---| 'top_center' @!Top Center
---| 'top_right' @!Top Right
---| 'center_left' @!Center Left
---| 'center_center' @!Center Center
---| 'center_right' @!Center Right
---| 'bottom_left' @!Bottom Left
---| 'bottom_center' @!Bottom Center
---| 'bottom_right' @!Bottom Right

---Draws an image on the screen based on a table of locations, a source image table.
---@param image T @Tmage config table from above that holds the information about an image.
---@param position screenPosition @Choose the initial location on the screen of the image, then use the padding in the image config to move it.
---@param debug boolean? @Enable the debug box around the image to check boundaries
---@param scaleOverride integer? @Override the scale of the image in the image config
local function positionImage(image, position, debug, scaleOverride)
        if scaleOverride ~= nil then
            pos = {
                ['top_left'] =      vec2(image.paddingX,image.paddingY),
                ['top_center'] =    vec2((screensize.x/2)-(image.sizeX/2*scaleOverride),image.paddingY),
                ['top_right'] =     vec2((screensize.x)-(image.sizeX*scaleOverride)-image.paddingX,image.paddingY),
                ['center_left'] =   vec2(image.paddingX, (screensize.y/2)-(image.sizeY/2*scaleOverride)),
                ['center_center'] = vec2(screensize.x/2-(image.sizeX/2*scaleOverride)+image.paddingX,        screensize.y/2-(image.sizeY/2*scaleOverride)+image.paddingY),
                ['center_right'] =  vec2(screensize.x-(image.sizeX*scaleOverride)-image.paddingX, screensize.y/2-(image.sizeY/2*scaleOverride)),
                ['bottom_left'] =   vec2(image.paddingX, screensize.y-(image.sizeY*scaleOverride)-image.paddingY),
                ['bottom_center'] = vec2(screensize.x/2-(image.sizeX/2*scaleOverride), screensize.y-(image.sizeY*scaleOverride)-image.paddingY),
                ['bottom_right'] =  vec2((screensize.x)-(image.sizeX*scaleOverride)-image.paddingX, screensize.y-(image.sizeY*scaleOverride)-image.paddingY)
            }
            if debug then
                display.rect({ pos = pos[position]-vec2(image.paddingX, image.paddingY),size = vec2(ui.imageSize(image.src)*scaleOverride+vec2(image.paddingX, image.paddingY):scale(2)),color = rgbm(0,0,0,0.5)})
                if debugFlash then
                    display.rect({pos = pos[position]-vec2(1,1),size = vec2(ui.imageSize(image.src)*scaleOverride)+vec2(2,2),color = rgbm(1,0,0,0.5)})
                end
            end
        
            display.image({
                image = image.src,
                pos = pos[position],
                size = vec2(ui.imageSize(image.src)*scaleOverride),
                color = rgbm.colors.white, uvStart = vec2(0, 0),uvEnd = vec2(1, 1)
            })
        elseif scaleOverride == nil or scaleOverride == 0 then
            pos = {
                ['top_left'] =      vec2(image.paddingX,image.paddingY),
                ['top_center'] =    vec2((screensize.x/2)-(image.sizeX/2*image.scale),image.paddingY),
                --['top_center'] =    vec2((screensize.x/2)-(ui.imageSize(image.src).x/2*image.scale),image.paddingY),
                ['top_right'] =     vec2((screensize.x)-(image.sizeX*image.scale)-image.paddingX,image.paddingY),

                ['center_left'] =   vec2(image.paddingX, (screensize.y/2)-(image.sizeY/2*image.scale)),
                ['center_center'] = vec2(screensize.x/2-(image.sizeX/2*image.scale)+image.paddingX,        screensize.y/2-(image.sizeY/2*image.scale)+image.paddingY),
                ['center_right'] =  vec2(screensize.x-(image.sizeX*image.scale)-image.paddingX, screensize.y/2-(image.sizeY/2*image.scale)),
                
                ['bottom_left'] =   vec2(image.paddingX, screensize.y-(image.sizeY*image.scale)-image.paddingY),
                ['bottom_center'] = vec2(screensize.x/2-(image.sizeX/2*image.scale), screensize.y-(image.sizeY*image.scale)-image.paddingY),
                ['bottom_right'] =  vec2((screensize.x)-(image.sizeX*image.scale)-image.paddingX, screensize.y-(image.sizeY*image.scale)-image.paddingY)
            }
            if debug then
                display.rect({ pos = pos[position]-vec2(image.paddingX, image.paddingY),size = vec2(ui.imageSize(image.src)*image.scale+vec2(image.paddingX, image.paddingY):scale(2)),color = rgbm(0,0,0,0.5)})
                if debugFlash then
                    display.rect({pos = pos[position]-vec2(1,1),size = vec2(ui.imageSize(image.src)*image.scale)+vec2(2,2),color = rgbm(1,0,0,0.5)})
                end
            end
        
            display.image({
                image = image.src,
                pos = pos[position],
                size = vec2(ui.imageSize(image.src)*image.scale),
                color = rgbm.colors.white, uvStart = vec2(0, 0),uvEnd = vec2(1, 1)
            })
        end

end

local creditTimer = 10
local creditPos = 0
function script.update(dt)
    ac.debug('Driver In Setup Menu', ac.getSim().isInMainMenu)
    if not ac.getSim().isInMainMenu then
        local a = 2
        local b = 10
        if creditTimer >= 0 then
            creditTimer = creditTimer - (dt)
        end
        creditPos = (-0.01*b^(-a*creditTimer+math.log(500)/math.log(b)) + 2)*20
    end
    ac.debug('creditPos', creditPos)
    ac.debug('timer', creditTimer)
    ac.debug("image_0_source", image_0_source)
    ac.debug("image_1_source", image_1_source)
    ac.debug('imageMetaLoaded', imageMetaLoaded)
    ac.debug("imageready",ui.isImageReady(image_0_source))
    loadImageMeta() 
end

ui.registerOnlineExtra(ui.Icons.Bug, "Server Icon Debug", function () return true end, function () 
        if ui.checkbox("Draw Image Boundary Boxes", debugImage) then debugImage = not debugImage end
        if ui.checkbox("Draw Screen Center Lines", debugLines) then debugLines = not debugLines end
    end, function (okClicked) end,ui.OnlineExtraFlags.Admin)


function script.drawUI()
    if creditTimer > 0 then
        display.rect({ pos = vec2(screensize.x/2-120, creditPos-5), size = vec2(240,40), color = rgbm(0,0,0,0.5)})
        display.text({
            text = 'Server Icon Script v'..scriptVersion..'\n    by CheesyManiac',
            pos = vec2((screensize.x/2)-92, creditPos),
            letter = vec2(8, 16),
            font = 'aria',
            color = rgbm.colors.white
          })
    end
    if debugLines then
        drawdebugLines()
    end

-------------------------------------------------------------------
-------------ADD YOUR ADDITIONAL IMAGES UNDER HERE,----------------
----------------SO THAT THEY ARE DRAWN ON SCREEN-------------------
-------------------------------------------------------------------


    positionImage(image_0, 'center_left', debugImage)
    positionImage(image_0, 'center_center', debugImage)


--DO NOT forget the final "end" over here, otherwise it will not work.
end