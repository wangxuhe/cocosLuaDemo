local RubCardFunc = require("app.Demo_Cocos.rubCard.Shader_RubCard")

local RubCardTest = class("RubCardTest", function()
    return newLayerColor(cc.size(display.width, display.height), 255)
end)

function RubCardTest:ctor()
    -- 返回按钮
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(display.width - 30, 30))
    backBtn:setTitleFontSize(18)
    backBtn:setTitleColor(cc.c3b(0,0,0))
    backBtn:setTitleText("返 回")
    backBtn:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then 
            self:getEventDispatcher():removeEventListenersForTarget(self)
            self:removeFromParent()
        end 
    end)
    self:addChild(backBtn)

    --显示搓牌效果
    local plistName = nil
    local backName = "res/Default/card_bg.png"          -- 牌背面图片
    local frontName = "res/Default/card_1.png"          -- 牌正面图片
    local scale = 1.0
 	local layer = RubCardFunc(nil, backName, frontName, scale)
 	self:addChild(layer)
end

return RubCardTest