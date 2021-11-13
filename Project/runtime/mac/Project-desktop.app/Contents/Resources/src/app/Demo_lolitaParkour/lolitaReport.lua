-- 结算页面
local lolitaReport = class("lolitaReport", function()
    return newLayerColor(cc.size(display.width, display.height), 200)
end)

function lolitaReport:ctor()
    local overImg = cc.Sprite:create("lolitaParkour/gameover.png")
    overImg:setPosition(display.center)
    self:addChild(overImg, 1)

    local src = "lolitaParkour/back.png"
    local backBtn = ccui.Button:create(src, src, src)
    backBtn:addTouchEventListener(handler(self, self._backEvent))
    backBtn:setPosition(cc.p(display.width/2, display.height/4))
    self:addChild(backBtn, 1)
end 

function lolitaReport:_backEvent(sender, event)
    if event ~= ccui.TouchEventType.ended then 
        return 
    end 

    -- 切换场景
    local scene = require("app.Demo_lolitaParkour.lolitaLoginScene"):create()
    if scene ~= nil then 
        display.runScene(scene)
    end 
end 

return lolitaReport