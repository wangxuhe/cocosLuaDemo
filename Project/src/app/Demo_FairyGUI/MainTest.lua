-- 个人示例主页面
local FguiDebugTest = require("app.Demo_FairyGUI.FguiDebugTest")


local tests = {
    {title = "DebugTest", layer = FguiDebugTest, state = "示例"},
}
local TEST_COUNT = #tests                               -- 示例数目
local SCROLL_WIDTH, SCROLL_HEIGHT = 600, 450            -- scroll可视大小
local ITEM_WIDTH, ITEM_HEIGHT = SCROLL_WIDTH, 50        -- scroll Item大小

local MainTest = class("MainTest", function()
    return newLayerColor(cc.size(display.width, display.height), 255)
end)

function MainTest:ctor()
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

    if TEST_COUNT <= 0 then 
        return 
    end 

    -- ScrollView相关
    local scroll = ccui.ScrollView:create()
    scroll:setContentSize(cc.size(SCROLL_WIDTH, SCROLL_HEIGHT))
    scroll:setPosition(cc.p(display.width/2 - SCROLL_WIDTH/2, display.height/2 - SCROLL_HEIGHT/2))
    scroll:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)                               -- 设置滚动方向:垂直
    scroll:setBounceEnabled(true)                                                       -- 设置滑动惯性
    scroll:setScrollBarEnabled(false)                                                   -- 设置滚动条是否显示
    self:addChild(scroll)
    
    -- 设置滚动区域
    local inerHeight = math.max(SCROLL_HEIGHT, TEST_COUNT*(ITEM_HEIGHT))
    scroll:setInnerContainerSize(cc.size(SCROLL_WIDTH, inerHeight))

    -- 设置Item相关
    for i = 1, TEST_COUNT do 
        local panel = ccui.Layout:create()
        panel:setContentSize(cc.size(ITEM_WIDTH, ITEM_HEIGHT))
        panel:setPosition(cc.p(0, inerHeight - i * ITEM_HEIGHT))
        panel:addTouchEventListener(handler(self, self._onClickItemEvent))
        panel:setTouchEnabled(true)
        panel:setTag(i)
        scroll:addChild(panel)

        local str = string.format("%s(%s)", tests[i].title, tests[i].state)
        local stateText = ccui.Text:create(str, "Arial", 24)
        stateText:setPosition(cc.p(ITEM_WIDTH/2, ITEM_HEIGHT/2))
        panel:addChild(stateText)
    end 
end 

function MainTest:_onClickItemEvent(sender, event)
    if event ~= ccui.TouchEventType.ended then 
        return 
    end 
    local tag = sender:getTag()
    local node = tests[tag].layer:create()
    if node ~= nil then 
        self:addChild(node,1000) 
    end 
end 

return MainTest
