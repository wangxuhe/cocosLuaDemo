-- 个人示例主页面
local ClipTest = require("app.Demo_Cocos.ClipTest")
local DrawGraphTest = require("app.Demo_Cocos.DrawGraphTest")
local DrawLineTest = require("app.Demo_Cocos.DrawLineTest")
local OpenGLTest = require("app.Demo_Cocos.OpenGLTest")
local ProcessorTest = require("app.Demo_Cocos.ProcessorTest")
local SpineTest = require("app.Demo_Cocos.SpineTest")
local KeyboardTest = require("app.Demo_Cocos.KeyboardTest")
local ScheduleTest = require("app.Demo_Cocos.ScheduleTest")
local OrbitCameraTest = require("app.Demo_Cocos.OrbitCameraTest")
local RubberTest = require("app.Demo_Cocos.RubberTest")
local RubCardTest = require("app.Demo_Cocos.rubCard.RubCardTest")
local ScreenShotTest = require("app.Demo_Cocos.ScreenShotTest")
local EffectTest = require("app.Demo_Cocos.EffectTest")
local MotionStreakTest = require("app.Demo_Cocos.MotionStreakTest")
local GhostTest = require("app.Demo_Cocos.GhostTest")

local tests = {
    {title = "ClipTest", layer = ClipTest, state = "裁切图形相关"},
    {title = "DrawGraphTest", layer = DrawGraphTest, state = "cocos自带的绘制图形相关"}, -- Demo代码不对
    {title = "DrawLineTest", layer = DrawLineTest, state = "cocos自带的绘制线段相关"},
    --{title = "OpenGLTest", layer = OpenGLTest, state = "shaderDemo相关"},
    {title = "ProcessorTest", layer = ProcessorTest, state = "进度条动画相关"},
    {title = "SpineTest", layer = SpineTest, state = "骨骼动画相关"},                 -- 读取资源失败
    {title = "KeyboardTest", layer = KeyboardTest, state = "键盘事件相关"},
    {title = "ScheduleTest", layer = ScheduleTest, state = "定时器相关"},
    {title = "OrbitCameraTest", layer = OrbitCameraTest, state = "扑克翻转相关"},
    {title = "RubCardTest", layer = RubCardTest, state = "搓牌效果相关"},
    {title = "RubberTest", layer = RubberTest, state = "橡皮擦效果"},
    {title = "ScreenShotTest", layer = ScreenShotTest, state = "截图效果"},
    {title = "EffectTest", layer = EffectTest, state = "粒子效果"},
    {title = "MotionStreakTest", layer = MotionStreakTest, state = "拖尾渐隐效果"},
    {title = "GhostTest", layer = GhostTest, state = "残影效果"},
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
    scroll:setBounceEnabled(false)                                                      -- 设置滚动条是否显示
    scroll:setScrollBarWidth(10)                                                        -- 设置滚动条宽度
    scroll:setScrollBarColor(cc.RED)                                                    -- 设置滚动条颜色
    self:addChild(scroll)
    
    -- 设置滚动区域，针对于inerHeight 建议使用math.max否则，滚动区域小于可视区域的情况下，容易出现警告：
    -- Warn: Inner height <= scrollView height, it will be force sized!
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
