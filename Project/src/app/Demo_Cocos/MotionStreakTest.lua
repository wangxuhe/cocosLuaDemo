-- 拖尾效果
local MotionStreakTest = class("MotionStreakTest", function()
    return cc.LayerColor:create(cc.c4b(0,0,0,255), display.width, display.height)
end)

function MotionStreakTest:ctor()
    -- 背景相关
    local bgImg = ccui.ImageView:create(Res.BTN_D)
    bgImg:setContentSize(cc.size(display.width, display.height))
    bgImg:setPosition(display.center)
    bgImg:setScale9Enabled(true)
    self:addChild(bgImg)

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

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self, self._onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self, self._onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(handler(self, self._onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
	listener:setSwallowTouches(true)

	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

    self:_initUI()
end 

function MotionStreakTest:_initUI()
    -- 拖尾渐隐效果相关
    self._starSpr = cc.Sprite:create(Res.STAR)
    self:addChild(self._starSpr)

    local timeToFade = 1                        -- 拖尾渐隐时间(秒)
    local minSeg = 0                            -- 渐隐片段长度
    local strokeWidth = 10                      -- 渐隐条的宽度
    local strokeColor = cc.c3b(0, 255, 0)       -- 片段颜色值
    local imagePath = Res.STEAK                 -- 纹理图片
    self._steakNode = cc.MotionStreak:create(timeToFade, minSeg, strokeWidth, strokeColor, imagePath)
    -- 启用快速模式，添加新的顶点更快，但精度却会更低
    self._steakNode:setFastMode(true)
    self:addChild(self._steakNode)    
end 

function MotionStreakTest:_onTouchBegan(sender, event)
    -- 重置条带
    self._steakNode:reset()
    -- 设置星星图片显示
    self._starSpr:setVisible(true)
    return true 
end 

function MotionStreakTest:_onTouchMoved(sender, event)
    local location = sender:getLocation()
    self._steakNode:setPosition(cc.p(location.x, location.y))
    self._starSpr:setPosition(cc.p(location.x, location.y))
end 

function MotionStreakTest:_onTouchEnded(sender, event)
    self._starSpr:setVisible(false)
end 

return MotionStreakTest