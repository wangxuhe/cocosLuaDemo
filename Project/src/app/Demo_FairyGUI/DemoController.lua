--[[
Desc:  控制器示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Controller = class("Demo_Controller", BaseLayer)

function Demo_Controller:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Controller")

    -- 标签控制器
    local tabCtrl = view:getController("tab")
    tabCtrl:setSelectedIndex(2)          --[0,3]

    -- 图标控制器
    local loaderCtrl = view:getController("loader")
    loaderCtrl:setSelectedIndex(2)       --[0,2]

    -- 按钮控制器
    local btnCtr = view:getController("btn")
    btnCtr:setSelectedIndex(1)          --[0,1]
end 

return Demo_Controller