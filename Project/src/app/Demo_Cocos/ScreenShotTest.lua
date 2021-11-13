
-- 截图功能

local ScreenShotTest = class("ScreenShotTest", function()
    return newLayerColor(cc.size(display.width, display.height), 255)
end)

function ScreenShotTest:ctor()
    -- 背景相关
    self._bgImg = ccui.ImageView:create(Res.BTN_D)
    self._bgImg:setContentSize(cc.size(display.width, display.height))
    self._bgImg:setPosition(display.center)
    self._bgImg:setScale9Enabled(true)
    self:addChild(self._bgImg)

    -- logo相关
    self._logoImg = ccui.ImageView:create(Res.LOGO)
    self._logoImg:setPosition(display.center)
    self._logoImg:setScale9Enabled(true)
    self:addChild(self._logoImg)

    -- 截图按钮
    self._shotBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    self._shotBtn:addTouchEventListener(handler(self, self._onClickShotEvent))
    self._shotBtn:setPosition(cc.p(display.width/2, 30))
    self._shotBtn:setTitleFontSize(18)
    self._shotBtn:setTitleColor(cc.c3b(0,0,0))
    self._shotBtn:setTitleText("截 图")
    self:addChild(self._shotBtn)

    -- 返回按钮
    self._backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    self._backBtn:addTouchEventListener(handler(self, self._onClickBackEvent))
    self._backBtn:setPosition(cc.p(display.width - 30, 30))
    self._backBtn:setTitleFontSize(18)
    self._backBtn:setTitleColor(cc.c3b(0,0,0))
    self._backBtn:setTitleText("返 回")
    self:addChild(self._backBtn)
end 

-- 截图按钮事件
function ScreenShotTest:_onClickShotEvent(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then 
        return 
    end 
    self:_saveScreenShot(self._logoImg)
end 

-- 返回按钮事件
function ScreenShotTest:_onClickBackEvent(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then 
        return 
    end 
    self:removeFromParent()
end 

--[[
@function: 截图的实现
    @param: node - 截取的节点
    @prame: saveName - 保存的文件，默认为screenShot.png
    @return: 返回文件路径
]]
function ScreenShotTest:_saveScreenShot(node, saveName)
    if not node or tolua.isnull(node) then 
        return 
    end

    local size = node:getContentSize()
    local posx, posy = node:getPosition()
    
    -- 存储名字
    saveName = saveName or "screenshot.png"

    -- 判定文件是否存在
    local writepath = cc.FileUtils:getInstance():getWritablePath()
    local filepath = writepath .. saveName
    local isExist = cc.FileUtils:getInstance():isFileExist(filepath)
    if isExist then 
        cc.FileUtils:getInstance():removeFile(filepath)
    end 

    -- 绘制截图，其锚点默认为(0,0),位置默认为(0,0),故此要设置下绘制节点的位置，避免绘制无法出现图片的问题
    -- 不可改变render的位置，否则依然无法绘制
    local render = cc.RenderTexture:create(size.width, size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    node:setPosition(cc.p(size.width/2, size.height/2))
    render:begin()
    node:visit()
    render:endToLua()

    -- 将node恢复到原位置
    node:setPosition(cc.p(posx, posy))

    --[[将纹理保存到文件中，操作成功后，将返回true。其参数有：
    1. 保存的文件名
    2. 保存的格式，有两种： cc.IMAGE_FORMAT_JPEG  cc.IMAGE_FORMAT_PNG
    3. 是否为RGBA,默认为true
    ]]
    local isSave = render:saveToFile(saveName, cc.IMAGE_FORMAT_PNG)

    -- 图片的获取要再下一帧
    local timeScheduler = nil 
    timeScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
        if cc.FileUtils:getInstance():isFileExist(filepath) then 
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(timeScheduler)
            print("文件保存成功")
        else 
            print("文件保存失败")
        end 
    end, 0.3, false)
    
    return filepath 
end 

return ScreenShotTest