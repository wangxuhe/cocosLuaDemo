--[[
Desc:   图片示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Image = class("Demo_Image", BaseLayer)

function Demo_Image:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Image")

    -- 设置颜色
    local colorImg =  view:getChild("img_color")
    colorImg:setColor(cc.c3b(255, 0, 0))

    -- 设置翻转
    local flipImg = view:getChild("img_flip")
    flipImg:setFlip(fairygui.FlipType.VERTICAL)
end 

return Demo_Image