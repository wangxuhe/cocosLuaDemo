--[[
Desc: FairyGUI 示例主页面
]]

local config = {
    {strTitile = "图片", layer = require("app.Demo_FairyGUI.DemoImage")},
    {strTitile = "装载器", layer = require("app.Demo_FairyGUI.DemoLoader")},
    {strTitile = "图形", layer = require("app.Demo_FairyGUI.DemoGraph")},
    {strTitile = "动画", layer = require("app.Demo_FairyGUI.DemoAnimation")},
    {strTitile = "条", layer = require("app.Demo_FairyGUI.DemoBar")},
    {strTitile = "组", layer = require("app.Demo_FairyGUI.DemoGroup")},
    {strTitile = "列表", layer = require("app.Demo_FairyGUI.DemoList")},
    {strTitile = "树", layer = require("app.Demo_FairyGUI.DemoTree")},
    {strTitile = "下拉框", layer = require("app.Demo_FairyGUI.DemoCombox")},
    {strTitile = "控制器", layer = require("app.Demo_FairyGUI.DemoController")},
}

local FguiMainTest = class("FguiMainTest", function()
    return newLayerColor(cc.size(display.width, display.height), 0)
end)

function FguiMainTest:ctor()
    -- 添加包
    fairygui.UIPackage:addPackage("fgui/Common")
    fairygui.UIPackage:addPackage("fgui/Basic")

    -- view相关
    local view = fairygui.UIPackage:createObject("Basic", "MainView")
    local gRoot = fairygui.GRoot:create(display.getRunningScene())
    gRoot:retain()
    gRoot:addChild(view)

    -- 列表
    local list = view:getChild("list")
    list.itemRenderer = function(index, item)
        local titleText = item:getChild("title")
        local strTitle = config[index + 1].strTitile 
        titleText:setText(strTitle) 
    end 
    list:setVirtual()
    list:setNumItems(#config)
    list:addEventListener(fairygui.UIEventType.ClickItem, function(context)
        local selectIndex = list:getSelectedIndex() + 1
        local layer = config[selectIndex].layer
        if layer then 
            layer:Show()
        end 
    end)
end 

return FguiMainTest
