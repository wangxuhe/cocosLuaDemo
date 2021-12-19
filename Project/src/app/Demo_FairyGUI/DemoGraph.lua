--[[
Desc:   图形示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Graph = class("Demo_Graph", BaseLayer)

function Demo_Graph:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Graph")

    -- 创建矩形
    local width = display.width             -- 宽度
    local height = display.height           -- 高度
    local lineSize = 1                      -- 线条粗细
    local lineColor = cc.c4f(1, 1, 1, 1)    -- 线条颜色
    local fillColor = cc.c4f(0, 0, 0, 0.6)  -- 填充颜色
    local graphRect = fairygui.UIObjectFactory:newObject(fairygui.ObjectType.GRAPH)
    graphRect:drawRect(width, height, lineSize, lineColor, fillColor)
    graphRect:setTouchable(false)
    graphRect:makeFullScreen()
    view:addChild(graphRect)

    -- 创建椭圆,如果width == height则为圆
    local width, height = 100, 100          -- 大小
    local lineSize = 1                      -- 线条粗细
    local lineColor = cc.c4f(1, 1, 1, 1)    -- 线条颜色
    local fillColor = cc.c4f(1, 0, 0, 1)    -- 填充颜色
    local graphEllipse = fairygui.UIObjectFactory:newObject(fairygui.ObjectType.GRAPH)
    graphEllipse:drawEllipse(width, height, lineSize, lineColor, fillColor)
    graphEllipse:addEventListener(fairygui.UIEventType.Click, function()
        print("点击圆")
    end)
    graphEllipse:setPosition(75, 400)
    view:addChild(graphEllipse)

    -- 创建多边形
    local lineSize = 10                                                 -- 线条粗细
    local lineColor = cc.c4f(1, 1, 1, 1)                                -- 线条颜色
    local fillColor = cc.c4f(1, 1, 1, 1)                                -- 填充颜色
    local points = {cc.p(200, 30), cc.p(250, 130), cc.p(200, 230)}      -- 点位置
    local polygon = fairygui.UIObjectFactory:newObject(fairygui.ObjectType.GRAPH)
    polygon:setSize(300, 300)
    polygon:drawPolygon(lineSize, lineColor, fillColor, points)
    view:addChild(polygon)

    -- 创建多边形
    local lineSize = 0                              -- 线条粗细
    local lineColor = cc.c4f(1, 1, 1, 1)            -- 线条颜色
    local fillColor = cc.c4f(0.5, 1, 0.2, 0.6)      -- 填充颜色
    local points = {0.5, 1, 0.6, 0.7, 0.8, 1}       -- 范围[0,1]
    local sides = 6                                 -- 面数
    local startAngle = 60                           -- 角度
    local component = view:getChild("compoent")     
    component:setSortingOrder(100)                  -- 设置层级
    local graph = component:getChild("graph")
    graph:drawRegularPolygon(lineSize, lineColor, fillColor, sides, startAngle, points)
end 

return Demo_Graph