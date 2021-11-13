-- 橡皮擦效果
local RubberTest = class("RubberTest", function()
    return cc.LayerColor:create(cc.c4b(0,0,0,255), display.width, display.height)
end)

local CARD_COUNT = 13               -- 牌张数目 
local CARD_SPACE = 40               -- 牌张之间间隔
local STARTPOS = cc.p(100, 100)      -- 首张牌的起始位置

function RubberTest:ctor()
    self._textureCanvas = nil   -- 画布
    self._wipeImg = nil         -- 被擦除的图片
    self._showImg = nil         -- 要显示的图片
    self._rubberImg = nil       -- 橡皮擦
    self:_initUI()
end 

function RubberTest:_initUI()
    -- 背景相关
    local bgImg = ccui.ImageView:create(Res.BTN_D)
    bgImg:setContentSize(cc.size(display.width, display.height))
    bgImg:setPosition(display.center)
    bgImg:setScale9Enabled(true)
    --bgImg:setTouchEnabled(true)
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

    -- 要显示的图片
    self._showImg = cc.Sprite:create("res/Default/card_1.png")
    self._showImg:setPosition(display.center)
    self:addChild(self._showImg)

    -- 创建画布
    local size = self._showImg:getContentSize()
    self._textureCanvas = cc.RenderTexture:create(display.width, display.height)
    self._textureCanvas:setPosition(display.center)
    self:addChild(self._textureCanvas)

    -- 创建被擦除图片，并渲染放置到画布中
    self._wipeImg = cc.Sprite:create("res/Default/card_bg.png")
    self._wipeImg:setPosition(display.center)
    self._textureCanvas:addChild(self._wipeImg)

    self._textureCanvas:begin()
    self._wipeImg:visit()
    self._textureCanvas:endToLua()

    -- 创建橡皮擦
    self._rubberImg = cc.Sprite:create("res/Default/r2.png")
    self:addChild(self._rubberImg)

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self, self._onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self, self._onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(handler(self, self._onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
	listener:setSwallowTouches(true)

	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end 

function RubberTest:_onTouchBegan(sender, event)
    local location = sender:getLocation()
    self._rubberImg:setPosition(cc.p(location.x, location.y))
    self._rubberImg:setVisible(true)
    return true 
end 

function RubberTest:_onTouchMoved(sender, event)
    local location = sender:getLocation()
    self._rubberImg:setPosition(cc.p(location.x, location.y))
    self._rubberImg:setBlendFunc(cc.blendFunc(gl.ZERO, gl.ZERO))
    self._textureCanvas:begin()
    self._rubberImg:visit()
    self._textureCanvas:endToLua()

end 

function RubberTest:_onTouchEnded(sender, event)
    self._rubberImg:setVisible(false)
end 

return RubberTest