-- 
local RubCardTest = require("app.Demo_Shader.rubCard.RubCardTest")
local Shader_Gray = require("app.Demo_Shader.Shader_GrayTest")
local Shader_Blur = require("app.Demo_Shader.Shader_BlurTest")

local tests = {
    {title = "Gray", layer = Shader_Gray, state = "shader置灰"},
    {title = "Blur", layer = Shader_Blur, state = "shader模糊"},
    {title = "RubCardTest", layer = RubCardTest, state = "搓牌效果相关"},
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
    scroll:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    scroll:setBounceEnabled(true)
    scroll:setScrollBarEnabled(false)
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
