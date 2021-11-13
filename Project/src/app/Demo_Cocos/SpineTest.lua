--
require "cocos.spine.SpineConstants"
local winSize = cc.Director:getInstance():getWinSize()

local SpineTest = class("SpineTest",function()
    return cc.LayerColor:create(cc.c4b(0,0,0,255), display.width, display.height)
end)

function SpineTest:ctor()
    local function onNodeEvent(event)
    if event == "enter" then
        self:init()
    end
end

  self:registerScriptHandler(onNodeEvent)
end

function SpineTest:init()
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

    --[[
    帧动画与骨骼动画的区别：
    帧动画：每一帧都是角色特定姿势的一个快照，动画的流畅性和平滑效果都取决于帧数的多少。
    骨骼动画：角色的身体部件图片绑定到一根根互相作用连接的“骨骼”上，通过控制这些骨骼的位置、旋转和缩放而生成的动画

    骨骼动画比帧动画要求更高的处理器性能，但同时它也具有更多的优势:
    1. 更少的美术资源：骨骼动画的资源是一块块小的角色部件
    2. 更小的体积：帧动画需要提供每一帧图片。而骨骼动画只需要少量的图片资源
    3. 更好的流畅性：骨骼动画使用差值算法计算中间帧，这能让动画总是保持流畅的效果
    4. 装备附件：图片绑定在骨骼上来实现动画。你可以更换角色的装备,甚至改变角色的样貌来达到动画重用的效果
    5. 不同动画可混合使用：不同的骨骼动画可以被结合到一起。比如一个角色可以转动头部、射击并且同时也在走路
    6. 程序动画：可以通过代码控制骨骼，比如可以实现跟随鼠标的射击，注视敌人，或者上坡时的身体前倾等效果
    ]]
    local skeletonNode = sp.SkeletonAnimation:create("Default/spineboy.json", "Default/spineboy.atlas", 0.6)
    skeletonNode:setPosition(cc.p(display.width/2, 20))
    --[[
    设置混合,避免衔接的动画不连贯
    参数1：起始动画
    参数2：结束动画
    参数3：间隔时间
    ]]
    skeletonNode:setMix("walk", "jump", 0.2)
    skeletonNode:setMix("jump", "run", 0.2)
    --[[ 
    @设置当前播放动画，只能播放一种
    @参数1： 层级
    @参数2： 动画名
    @参数3： 是否循环
    ]]
    skeletonNode:setAnimation(0, "walk", true)
    --[[
    @添加不同的动画
    @参数1: 层级
    @参数2: 动画名
    @参数3: 是否循环
    @参数4：延迟时间
    ]]
    skeletonNode:addAnimation(0, "jump", false, 3)
    skeletonNode:addAnimation(0, "run", true)
    self:addChild(skeletonNode,100)

    skeletonNode:registerSpineEventHandler(function (event)
        print(string.format("[spine] %d start: %s", event.trackIndex, event.animation))
    end, sp.EventType.ANIMATION_START)

    skeletonNode:registerSpineEventHandler(function (event)
        print(string.format("[spine] %d end:", event.trackIndex))
    end, sp.EventType.ANIMATION_END)
        
    skeletonNode:registerSpineEventHandler(function (event)
        print(string.format("[spine] %d complete: %d", event.trackIndex, event.loopCount))
    end, sp.EventType.ANIMATION_COMPLETE)

    skeletonNode:registerSpineEventHandler(function (event)
        local data = event.eventData
        print(string.format("[spine] %d event: %s, %d, %f, %s", event.trackIndex, data.name, data.intValue, data.floatValue,data.stringValue)) 
    end, sp.EventType.ANIMATION_EVENT)
  

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function (touch, event)
            if not skeletonNode:getDebugBonesEnabled() then
                -- 设置骨骼显示
                skeletonNode:setDebugBonesEnabled(true)
            elseif skeletonNode:getTimeScale() == 1 then
                -- 设置动画播放的快慢
                skeletonNode:setTimeScale(0.3)
            else
                skeletonNode:setTimeScale(1)
                -- 设置骨骼隐藏
                skeletonNode:setDebugBonesEnabled(false)
            end
            return true
        end,cc.Handler.EVENT_TOUCH_BEGAN)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return SpineTest
