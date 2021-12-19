--[[
Desc:   进度条，拖动条相关
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Bar = class("Demo_Bar", BaseLayer)

function Demo_Bar:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Bar")

    ----------------------- 进度条 -----------------------
    -- 
    local imgBar = view:getChild("imgbar")
    imgBar:setMin(100)                    -- 设置进度条最小值
    imgBar:setValue(200)                  -- 设置进度条当前值
    imgBar:setMax(300)                    -- 设置进度条最大值

    --[[
    设置标题类型，公有：
    PERCENT :  当前进度的百分比
    VALUE_MAX : 当前/最大
    VALUE : 当前
    MAX :  最大
    ]]
    local titleType = fairygui.ProgressTitleType.PERCENT
    imgBar:setTitleType(titleType)      

    -- 
    local aniBar = view:getChild("aniBar")
    aniBar:setValue(50)
    -- 设置动态改变进度值
    local maxValue = 80            -- 最终值
    local duration = 0.5           -- 持续秒数
    aniBar:tweenValue(maxValue, 5)

    ----------------------- 拖动条 -----------------------
    local sliderText = view:getChild("sliderText")
    local slider = view:getChild("slider")
    slider:addEventListener(fairygui.UIEventType.Changed, function(context)
        sliderText:setText("当前进度:" .. slider:getValue())
    end)
end 

return Demo_Bar