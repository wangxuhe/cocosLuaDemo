-- 控制类
-- 参考：https://blog.csdn.net/lttree/article/details/47813095

local RES_PATH = "fistFight/UI.plist"

-- 摇杆方向
local JOYSTICK_DIR = {
    STAY = 0,
    LEFT = 1,               -- 左
    LEFT_UP = 2,            -- 左上
    UP = 3,                 -- 上
    RIGHT_UP = 4,           -- 右上
    RIGHT = 5,              -- 右
    RIGHT_DOWN = 6,         -- 右下
    DOWN = 7,               -- 下
    LEFT_DOWN = 8,          -- 左下
}

local DIR_NAME = {
    [JOYSTICK_DIR.LEFT] = "左",
    [JOYSTICK_DIR.LEFT_UP] = "左上",
    [JOYSTICK_DIR.UP] = "上",
    [JOYSTICK_DIR.RIGHT_UP] = "右上",
    [JOYSTICK_DIR.RIGHT] = "右",
    [JOYSTICK_DIR.RIGHT_DOWN] = "右下",
    [JOYSTICK_DIR.DOWN] = "下",
    [JOYSTICK_DIR.LEFT_DOWN] = "左下",
}

local PI = math.pi          -- 
local POW = math.pow        -- 平方
local SQRT = math.sqrt      -- 平方根
local ABS = math.abs        -- 绝对值

local Fist_Control = class("Fist_Control", function()
    return cc.LayerColor:create(cc.c4b(0,0,0,0), display.width, display.height)
end)

function Fist_Control:ctor(parent)
    self._parent = parent               -- 场景节点
    self._joyStickBg = nil              -- 摇杆背景
    self._joyStick = nil                -- 摇杆
    self._attackBtn = nil               -- 攻击按钮

    self._isCanMove = false             -- 摇杆是否可移动
    self._centerPos = nil               -- 摇杆中心点位置
    self._maxRadius = nil               -- 摇杆最大半径
    self._joyStickDir = JOYSTICK_DIR.STAY -- 摇杆方向

    self._roleNode = nil                -- 英雄节点
    self._roleDir = 1                   -- 英雄方向(1右 -1左)
    self._mapNode = nil                 -- 地图节点

    self._attackScheduler = nil         -- 攻击定时器

    self:_init()
end 

function Fist_Control:_init()
    local isLoad = cc.SpriteFrameCache:getInstance():isSpriteFramesWithFileLoaded(RES_PATH)
    if not isLoad then 
        cc.SpriteFrameCache:getInstance():addSpriteFrames(RES_PATH)
    end 

    -- 节点相关
    self._roleNode = self._parent:getGameRoot():getRoleNode()
    self._mapNode = nil 

    -- 攻击按钮
    self._attackBtn = ccui.Button:create()
    self._attackBtn:loadTextureNormal("button-default.png", UI_TEX_TYPE_PLIST)
    self._attackBtn:loadTexturePressed("button-pressed.png", UI_TEX_TYPE_PLIST)
    self._attackBtn:loadTextureDisabled("button-activated.png", UI_TEX_TYPE_PLIST)
    local attackSize = self._attackBtn:getContentSize()
    self._attackBtn:setPosition(cc.p(display.width - attackSize.width, 100))
    self._attackBtn:addTouchEventListener(handler(self, self._attackEvent))
    self:addChild(self._attackBtn)

    ---------------------------- 摇杆相关 ----------------------------
    -- 摇杆背景
    self._joyStickBg = cc.Sprite:createWithSpriteFrameName("JoyStick-base.png")
    self._bgSize = self._joyStickBg:getContentSize()
    self._joyStickBg:setPosition(cc.p(self._bgSize.width, self._bgSize.height))
    self._parent:addChild(self._joyStickBg)

    -- 摇杆
    self._joyStick = cc.Sprite:createWithSpriteFrameName("JoyStick-thumb.png")
    self._joyStick:setPosition(cc.p(self._bgSize.width, self._bgSize.height))
    self._parent:addChild(self._joyStick)

    self._centerPos = cc.p(self._bgSize.width, self._bgSize.height)           -- 中心点位置
    self._maxRadius = self._bgSize.width/2                                    -- 摇杆半径

    -- 触摸监听
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(handler(self, self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self, self.onTouchMoved),cc.Handler.EVENT_TOUCH_MOVED)
    listener:registerScriptHandler(handler(self, self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)

    -- 添加帧刷新定时器
    self:scheduleUpdateWithPriorityLua(handler(self, self._updateMove), 0)
end 

function Fist_Control:onTouchBegan(node, event)
    -- 获取触摸点坐标
    local location = node:getLocation()
    -- 判定是否点击到摇杆
    if cc.rectContainsPoint(self._joyStick:getBoundingBox(), location) then 
        self._isCanMove = true 
    end 

    return true 
end 

function Fist_Control:onTouchMoved(node, event)
    -- 判定能否移动
    if not self._isCanMove then 
        return 
    end 
    -- 获取触摸点坐标
    local point = node:getLocation()
    if not cc.rectContainsPoint(self._joyStick:getBoundingBox(), point) then 
        --print("触摸超出范围了...")
        return 
    end 
    
    -- 判定移动距离是否大于半径长度
    local distance_z, radian = self:_getRadian(self._centerPos, point)
    if distance_z >= self._maxRadius then 
        -- 重新设定摇杆位置，不可超越半径长度
        local pos1 = self:_getPos(self._maxRadius, radian)
        local pos2 = cc.p(self._centerPos.x, self._centerPos.y)
        self._joyStick:setPosition(cc.p(cc.pAdd(pos1, pos2)))
    else 
        -- 没有超过，保持移动位置即可
        self._joyStick:setPosition(point)
    end 

    -- 设置方向
    if radian >= -PI/8 and radian < PI/8 then 
        self._joyStickDir = JOYSTICK_DIR.LEFT                 
    elseif radian >= PI/8 and radian < 3*PI/8 then 
        self._joyStickDir = JOYSTICK_DIR.LEFT_UP 
    elseif radian >= 3*PI/8 and radian < 5*PI/8 then 
        self._joyStickDir = JOYSTICK_DIR.UP         
    elseif radian >= 5*PI/8 and radian < 7*PI/8 then 
        self._joyStickDir = JOYSTICK_DIR.RIGHT_UP  
    elseif (radian >= 7*PI/8 and radian <= PI) or (radian >= -PI and radian < -7*PI/8) then 
        self._joyStickDir = JOYSTICK_DIR.RIGHT     
    elseif radian >= -7*PI/8 and radian < -5*PI/8 then 
        self._joyStickDir = JOYSTICK_DIR.RIGHT_DOWN 
    elseif radian >= -5*PI/8 and radian < -3*PI/8 then 
        self._joyStickDir = JOYSTICK_DIR.DOWN  
    elseif radian >= -3*PI/8 and radian < -PI/8 then 
        self._joyStickDir = JOYSTICK_DIR.LEFT_DOWN 
    end 
end 

function Fist_Control:onTouchEnded(node, event)
    if not self._isCanMove then 
        return 
    end 

    if self._moveScheduler ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._moveScheduler)
        self._moveScheduler = nil 
    end

    self._isCanMove = false 
    self._joyStickDir = JOYSTICK_DIR.STAY
    self._joyStick:stopAllActions()
    self._joyStick:runAction(cc.MoveTo:create(0.08, cc.p(self._joyStickBg:getPosition())))

    -- 玩家状态修改为站立
    self._roleNode:idle()
end 

-- 移动相关
function Fist_Control:_updateMove(dt)
    if not self._isCanMove then 
        return 
    end 

    local roleDir = cc.p(0, 0)
    if self._joyStickDir == JOYSTICK_DIR.LEFT then 
        roleDir = cc.p(-1, 0)
    elseif self._joyStickDir == JOYSTICK_DIR.LEFT_UP then 
        roleDir = cc.p(-1, 1)  
    elseif self._joyStickDir == JOYSTICK_DIR.UP then 
        roleDir = cc.p(0, 1)
    elseif self._joyStickDir == JOYSTICK_DIR.RIGHT_UP then 
        roleDir = cc.p(1, 1)
    elseif self._joyStickDir == JOYSTICK_DIR.RIGHT then 
        roleDir = cc.p(1, 0) 
    elseif self._joyStickDir == JOYSTICK_DIR.RIGHT_DOWN then 
        roleDir = cc.p(1, -1)
    elseif self._joyStickDir == JOYSTICK_DIR.DOWN then 
        roleDir = cc.p(0, -1)  
    elseif self._joyStickDir == JOYSTICK_DIR.LEFT_DOWN then 
        roleDir = cc.p(-1, -1) 
    end 

    -- 更新玩家位置
    self._roleNode:walkWithDirection(roleDir)
end 

-- 攻击事件
function Fist_Control:_attackEvent(sender, eventType)
    if eventType == ccui.TouchEventType.began then 
        local function update(dt)
            self._roleNode:attack()
        end 
        if self._attackScheduler == nil then 
            self._attackScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(update, 0.3, false)
        end 
    elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then 
        if self._attackScheduler ~= nil then 
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._attackScheduler)
            self._attackScheduler = nil 
        end 

        -- 添加，避免快速点击一次没有攻击
        if eventType == ccui.TouchEventType.ended then 
            self._roleNode:attack()
        end 
    end 
end 

-- 根据两个点的位置获取弧度(中心点，摇杆点位置)
function Fist_Control:_getRadian(ponit1, point2)
    -- 获取两点之间的x,y的距离
    local distance_x, distance_y = ponit1.x - point2.x, ponit1.y - point2.y
    -- 获取斜边长度,即 x*x + y*y = z*z 
    local distance_z = SQRT(POW(distance_x, 2) + POW(distance_y, 2))
    -- 获取弧度
    local radian = math.acos(distance_x/distance_z)
    if point2.y < ponit1.y then 
        radian = -radian
    end 
    return distance_z, radian 
end 

-- 根据弧度获取点坐标(长度，弧度)
function Fist_Control:_getPos(distance_z, radian)
    local point_x = math.cos(radian) * distance_z
    local point_y = math.sin(radian) * distance_z
    --local angle = math.radian2angle(radian)               -- 弧度转角度
    return cc.p(-point_x, point_y)
end 

-- 清空相关
function Fist_Control:dispose()
    -- 清空定时器相关
    self:unscheduleUpdate()

    if self._attackScheduler ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._attackScheduler)
        self._attackScheduler = nil 
    end 
end 

return Fist_Control
