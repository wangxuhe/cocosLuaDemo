--[[
Desc:   下拉框示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Combox = class("Demo_Combox", BaseLayer)

function Demo_Combox:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Combox")

    -- 
local titles = {"全部", "世界", "系统", "跨服", "个人"}
local values = {0, 10, 20, 30, 40}
local combox = view:getChild("combox")
-- 设置标题
combox:setItems(titles)
-- 设置数值
combox:setValues(values)
-- 点击item回调
combox:addEventListener(fairygui.UIEventType.Changed, function(context)
    local selectIndex = combox:getSelectedIndex()
    print("选择的标签索引", selectIndex)
    
    local value = combox:getValue()
    print("value:", value)
end)

-- 设置默认索引
combox:setSelectedIndex(4)
end 

return Demo_Combox