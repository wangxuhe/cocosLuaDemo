local winSize = cc.Director:getInstance():getWinSize()
local KeyboardTest = class("KeyboardTest", function()
	return cc.LayerColor:create(cc.c4b(0,0,0,255), winSize.width, winSize.height)
end)

function KeyboardTest:ctor()
    self:_initUI()
end 

function KeyboardTest:_initUI()
    -- 返回按钮相关
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(winSize.width - 30, 30))
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

    -- 标题
    local titleLabel = ccui.Text:create()
    titleLabel:setPosition(cc.p(winSize.width/2, winSize.height*4/5))
    titleLabel:setString("Keyboard Test")
    titleLabel:setFontSize(30)
    self:addChild(titleLabel)


    -- 内容
    local content = ccui.Text:create()
    content:setPosition(cc.p(winSize.width/2, winSize.height/2))
    content:setString("content ...")
    content:setFontSize(20)
    self:addChild(content)
    self._content = content

    -- 
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(handler(self, self._onKeyPressed), cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(handler(self, self._onKeyReleased), cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end 

function KeyboardTest:_onKeyPressed(keyCode, event)
    local code = self:_checkKeyIsValid(keyCode)
    print("pressed:" .. code or "nil")
end 

function KeyboardTest:_onKeyReleased(keyCode, event)
    local code = self:_checkKeyIsValid(keyCode)
    self._content:setString(code)
end 

-- 检测键值是否有效
function KeyboardTest:_checkKeyIsValid(key)
    if not key then 
        return nil 
    end 
    -- 判定其键值是否在键值列表中，若存在返回key，否则返回nil 
    return table.keyof(cc.KeyCode, key)
end 

return KeyboardTest
