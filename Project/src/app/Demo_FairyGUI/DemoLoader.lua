--[[
Desc:   装载器示例
]]
local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Loader = class("Demo_Loader", BaseLayer)

function Demo_Loader:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Loader")
    self._view = view 

    self:initDynamic()
    self:initLoaderImg()
    self:initLoaderComponent()
end 

-- 动态创建
function Demo_Loader:initDynamic()
    local loader = fairygui.UIObjectFactory:newObject(fairygui.ObjectType.LOADER)
    if not loader then 
        return 
    end 
 
    local url = "ui://Common/22"    -- 图片

    loader:setSize(100, 100)                                    -- 设置初始化大小
    loader:setAutoSize(true)                                    -- 设置自动大小
    loader:setAlign(fairygui.TextHAlignment.CENTER)             -- 设置水平对齐方式
    loader:setVerticalAlign(fairygui.TextVAlignment.CENTER)     -- 设置垂直对齐方式
    loader:setURL(url)                                          -- 设置URL
    loader:addEventListener(fairygui.UIEventType.Click, function(context)
        print("您点击了loader")
    end)

    loader:setPosition(153, 214)
    self._view:addChild(loader) 
end 

-- 加载图片
function Demo_Loader:initLoaderImg() 
    local loader = self._view:getChild("loader_1")

    -- 使用UI编译器内url编码更换
    local url = "ui://a0imyaf1vx0u33"
    loader:setURL(url)

    -- 使用UI编译器内资源名更换
    local url = "ui://Common/r4"
    loader:setURL(url)

    -- 使用外部资源更换
    local url = "res/Default/r1.png"
    loader:setURL(url)
end 

-- 加载组件
function Demo_Loader:initLoaderComponent()
    local loader = self._view:getChild("loader_2")
    -- 该url为按钮
    local url = "ui://Common/normal_btn1"
    loader:setURL(url)

    -- 获取按钮组件
    local component = loader:getComponent()
    print("loader component:")
    local titleText = component:getChild("title")
    titleText:setText("loader内标题")
end 

return Demo_Loader