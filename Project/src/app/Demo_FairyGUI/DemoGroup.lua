--[[
Desc:   高级组示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Group = class("Demo_Group", BaseLayer)

function Demo_Group:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Group")

    -- 方式1: 不推荐
    local group = view:getChild("group_2")
    local img = view:getChildInGroup(group, "img_3")

    -- 方式2: 推荐
    local img2 = view:getChild("img_3")

    img:setVisible(false)
end 

return Demo_Group