-- 萝莉跑酷登录页面
local lolitaLoginScene = class("lolitaLoginScene", function()
    return cc.Scene:create()
end)

function lolitaLoginScene:ctor()
    -- 背景
    local bgImg = ccui.ImageView:create("lolitaParkour/bg_0.png")
    bgImg:setContentSize(cc.size(display.width, display.height))
    bgImg:setPosition(display.center)
    self:addChild(bgImg, 0)

    -- 开始按钮
    local normal = "lolitaParkour/newgameA.png"
    local press = "lolitaParkour/newgameB.png"
    local startBtn = ccui.Button:create(normal, press, normal)
    startBtn:addTouchEventListener(handler(self, self._startEvent))
    startBtn:setPosition(cc.p(display.width/2, display.height/2))
    self:addChild(startBtn, 1)

    -- 退出按钮
    local exitBtn = ccui.Button:create(Res.CLOSE_IMG, Res.CLOSE_IMG, Res.CLOSE_IMG)
    exitBtn:setPosition(cc.p(display.width - 30, 30))
    exitBtn:setTitleFontSize(18)
    exitBtn:addTouchEventListener(function(sender, eventType)
        if eventType ~= ccui.TouchEventType.ended then 
            return 
        end 
        local scene = require("app.TestScene"):create()
        display.runScene(scene)
    end)
    self:addChild(exitBtn)

    -- 警告文本
    local warnText = ccui.Text:create()
    warnText:setPosition(cc.p(display.width/2, 20))
    warnText:setString("图片来源于网友提供，承诺仅用于学习使用!!!")
    warnText:setColor(cc.c3b(255,0,0))
    self:addChild(warnText, 2)
end 

-- 开始按钮事件
function lolitaLoginScene:_startEvent(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then 
        return 
    end 

    local scene = require("app.Demo_lolitaParkour.lolitaMainScene"):create()
    if scene ~= nil then 
        display.runScene(scene)
    end 
end 

return lolitaLoginScene