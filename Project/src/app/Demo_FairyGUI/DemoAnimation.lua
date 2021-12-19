--[[
Desc:   帧动画，动效示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Ani = class("Demo_Ani", BaseLayer)

function Demo_Ani:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Ani")

    ----------------------- 数字帧动画 -----------------------
    local numClip = view:getChild("ani_num")
    -- 设置颜色
    numClip:setColor(cc.c3b(255, 0, 0))     
    -- 设置翻转
    numClip:setFlip(fairygui.FlipType.NONE)     
    -- 设置播放相关
    local startFrame = 0                    -- 开始帧数
    local endFrame = -1                     -- 结束帧数, -1表示结束帧数
    local endAt = endFrame                  -- 同结束帧数
    local times = 1                         -- 重复次数, 0表示循环
    local comleteCallBack = function()      -- 结束回调
        print("帧动画播放结束")
    end 
    numClip:setPlaySettings(startFrame, endFrame, times, endAt, comleteCallBack)
    -- 设置播放
    numClip:setPlaying(true)

    ----------------------- 动效 -----------------------
    -- 重置下位置相关，动效的播放会修改节点的属性
    local bagGroup = view:getChild("bagGroup")
    bagGroup:setX(1000)

    local trans = view:getTransition("bagEffect")
    -- 检测是否播放
    if trans:isPlaying() then 
        trans:stop()
    end 
    -- 设置持续时间, 要在开始标签前设定
    trans:setDuration("start", 0.2)
    -- 设置标签位置
    trans:setValue("start", {600, 0})
    -- 设置播放
    local times = 1                 -- 播放次数
    local delay = 4                 -- 延迟秒数
    local completeCallBack = function() 
        print("动效播放结束, bgGroup的位置:", bagGroup:getY())
    end 
    trans:play(times, delay, completeCallBack)
end 

return Demo_Ani