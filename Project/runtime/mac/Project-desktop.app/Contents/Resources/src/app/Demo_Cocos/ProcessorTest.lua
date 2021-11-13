-- 进度条动画
require "cocos.spine.SpineConstants"

local ProcessorTest = class("ProcessorTest",function()
    return newLayerColor(cc.size(display.width, display.height), 255)
end)

function ProcessorTest:ctor()
    local title =  ccui.Text:create("进度条动画", "Arial", 25)
    title:setPosition(cc.p(display.width/2, display.height-100))
    self:addChild(title)

    --self:playProcessBarDemo()
    self:playLoadBarDemo()
end

-- process动画
function ProcessorTest:playProcessBarDemo()
    local barBgSpr = cc.Sprite:create("res/bar1.png")
    barBgSpr:setPosition(cc.p(display.width/2, display.height*5/6))
    self:addChild(barBgSpr,1)

    local barSpr = cc.Sprite:create("res/bar2.png")
    local processTimer = cc.ProgressTimer:create(barSpr)
    processTimer:setPosition(cc.p(display.width/2, display.height*5/6))
    processTimer:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    processTimer:setBarChangeRate(cc.p(1, 0))
    processTimer:setMidpoint(cc.p(0, 0))
    processTimer:setPercentage(0) 
    self:addChild(processTimer,2)

    --local action1 = cc.ProgressTo:create(5,100)
    local action1 = cc.ProgressFromTo:create(5,0,100)
    local action = cc.RepeatForever:create(action1)
    processTimer:runAction(action)
end 

-- loadBar动画
function ProcessorTest:playLoadBarDemo()
    -- 返回按钮相关
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(display.width - 30, 30))
    backBtn:setTitleFontSize(18)
    backBtn:setTitleColor(cc.c3b(0,0,0))
    backBtn:setTitleText("返 回")
    backBtn:addTouchEventListener(function(sender, eventType)
        if eventType ~= ccui.TouchEventType.ended then 
            return 
        end 
        self:removeFromParent()
    end)
    self:addChild(backBtn)

    -- 按钮相关
    for i = 1, 2 do 
        local index = i == 1 and 1 or -1
        local btn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
        btn:setPosition(cc.p(display.width/2 - 100 * index, display.height/6))
        btn:addTouchEventListener(handler(self, self._addReduceEvt))
        btn:setTitleText(i == 1 and "加" or "减")
        btn:setTitleColor(cc.c3b(0,0,0))
        btn:setTag(i)
        self:addChild(btn)
    end 

    -- 进度条
    local loadingBar = ccui.LoadingBar:create()
    loadingBar:loadTexture("effect/thunder/thunder_4.png")
    loadingBar:setPosition(display.center)
    loadingBar:setDirection(ccui.LoadingBarDirection.LEFT)
    loadingBar:setScale(0.6)
    loadingBar:setPercent(0)
    self:addChild(loadingBar)
    self._loadingBar = loadingBar
end 

function ProcessorTest:_addReduceEvt(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then 
        return 
    end 
    local tag = sender:getTag()
    local dir = tag == 1 and 1 or -1

    local curpercent = self._loadingBar:getPercent()
    curpercent = curpercent + dir * 2
    self._loadingBar:setPercent(curpercent)
end 

return ProcessorTest
