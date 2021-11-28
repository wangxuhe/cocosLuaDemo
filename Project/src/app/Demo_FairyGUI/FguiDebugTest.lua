-- 橡皮擦效果
local FguiDebugTest = class("FguiDebugTest", function()
    return cc.LayerColor:create(cc.c4b(0,0,0,255), display.width, display.height)
end)

function FguiDebugTest:ctor()
    self:_initUI()
end 

function FguiDebugTest:_initUI()
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

    -- 测试
    local root = fairygui.GRoot:create(display.getRunningScene())
    print("-------------- root:", tolua.isnull(root), tolua.type(root))
    if tolua.isnull(root) then 
        return 
    end 
    root:retain()

    fairygui.UIPackage:addPackage("fgui/Bag")
    local view = fairygui.UIPackage:createObject("Bag", "Main")
    print("-------------- view:", tolua.isnull(view), tolua.type(view))
    root:addChild(view)
end 

return FguiDebugTest