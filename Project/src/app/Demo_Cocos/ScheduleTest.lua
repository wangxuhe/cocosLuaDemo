-- lua定时器相关

local ScheduleTest = class("ScheduleTest", function()
    return cc.LayerColor:create(cc.c4b(0,0,0,255), display.width, display.height)
end)

function ScheduleTest:ctor()
    -- 返回按钮相关
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(display.width - 30, 30))
    backBtn:setTitleFontSize(18)
    backBtn:setTitleColor(cc.c3b(0,0,0))
    backBtn:setTitleText("返 回")
    backBtn:addTouchEventListener(handler(self, self._onRemoveEvent))
    self:addChild(backBtn)
 
    -- 内容显示相关
    self._states = {}
    for i = 1, 2 do 
        self._states[i] = ccui.Text:create()
        self._states[i]:setPosition(cc.p(display.width/2, display.height*2/3 - (i-1) * 100))
        self._states[i]:setString("content ...")
        self._states[i]:setFontSize(20)
        self:addChild(self._states[i])
    end 

    local count1, count2 = 0, 0    
    local function frameUpdate(dt)
        count2 = count2 + dt
        self._states[2]:setString("帧刷新时间:" .. count2)
    end
    
    --[[
    定时器一： 帧刷新 （调用该方法一定为 Node 相关，且无法自定义时间间隔）
    参数1： 回调接口用于刷新
    参数2： 刷新优先级

    其调用实质上就是C++中的 scheduleUpdate ， 该方法会在每帧调用C++中的 update 方法
    在 cocoslua中其 NodeEx.lua中 Node.scheduleUpdate 的实现就是此方法

    在销毁的时候，一定要注意调用 unscheduleUpdate() 方法，否则会出现问题
    ]]
    self:scheduleUpdateWithPriorityLua(frameUpdate, 0)


    local function timerUpdate(dt)
        count1 = count1 + dt
        self._states[1]:setString("定时刷新时间:" .. count1)
    end 
    --[[
    定时器二： 定时刷新
    参数1： 回调接口用于刷新
    参数2： 每次刷新的时间间隔
    参数3： 是否仅执行一次，false为无限次 （此参数若设置为 true 的话，也就是 C++中的 scheduleOnce ）

    在销毁的时候，一定要调用 unscheduleScriptEntry
    ]]
    local _schedule = cc.Director:getInstance():getScheduler()
    -- 添加判定是为了避免定时器的重复定义
    if self._timerScheduler ~= nil then 
        _schedule:unscheduleScriptEntry(self._timerScheduler)
        self._timerScheduler = nil 
    end 
    self._timerScheduler = _schedule:scheduleScriptFunc(timerUpdate, 5, false)
end 

function ScheduleTest:_onRemoveEvent(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then 
        return     
    end 
    -- 删除帧刷新定时器
    self:unscheduleUpdate()

    -- 删除定时器
    if self._timerScheduler ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._timerScheduler)
        self._timerScheduler = nil 
    end 

    -- 删除UI
    self:removeFromParent()
end 

return ScheduleTest
