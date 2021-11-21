
local IMG_NAME = "res/Default/elephant.png"

local BaseLayer = class("ShaderBaseLayer",function()
   return newLayerColor(cc.size(display.width, display.height), {r = 255, g = 255, b = 255, a = 255})
end)

function BaseLayer:ctor() 
    self:initData() 
    self:initNode()
    self:show()
end 

function BaseLayer:initData() 
    self._titleText = nil 
    self._normalSprite = nil 
    self._compareSprite = nil 

end 

function BaseLayer:initNode() 
    -- 返回按钮
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(display.width - 30, 30))
    backBtn:setTitleFontSize(18)
    backBtn:setTitleColor(cc.c3b(0,0,0))
    backBtn:setTitleText("返 回")
    backBtn:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then 
            self:removeFromParent()
        end 
    end)
    self:addChild(backBtn)

    -- 标题
    local titleText = ccui.Text:create("", "Arial", 30)
    titleText:setPosition(cc.p(display.width/2, display.height*5/6))
    titleText:setColor(cc.c3b(0, 0, 0))
    self:addChild(titleText)
    self._titleText = titleText

    -- 正常图片
    self._normalSprite = cc.Sprite:create(IMG_NAME)
    self._normalSprite:setPosition(cc.p(display.width/4, display.height/2))
    self:addChild(self._normalSprite)

    -- 变色图片
    self._compareSprite = cc.Sprite:create(IMG_NAME)
    self._compareSprite:setPosition(cc.p(display.width*3/4, display.height/2))
    self:addChild(self._compareSprite)
end 

function BaseLayer:show()
    -- 
end 

return BaseLayer 