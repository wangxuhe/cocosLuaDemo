-- 角色动作基类
-- 用于玩家或敌人通过切换状态来改变动作 共有5种状态，可参考：Fist_Const.ActionState

local const = require("app.Demo_FistFight.Fist_Const")
local ACTION = const.ActionState

local Fist_ActionBase = class("Fist_ActionBase", function()
    return cc.Sprite:create()
end)

function Fist_ActionBase:ctor()
    self._idleAction = nil              -- 站立动作
    self._walkAction = nil              -- 走动动作
    self._attackAction = nil            -- 攻击动作           
    self._hurtAction = nil              -- 被攻击动作
    self._dieAction = nil               -- 死亡动作

    self._actionState = ACTION.NONE             -- 状态
    self._walkSpeed = nil                       -- 走动速度
    self._damage = nil                          -- 伤害值
    self._hpNum = nil                           -- 血量
    self._centerToSide = nil                    -- 中心到侧面的偏移
    self._centerToBottom = nil                  -- 中心到底部的偏移
    self._desiredPos = cc.p(0, 0)               -- 
    self._hitBox = cc.rect(0,0,0,0)             -- 
    self._attackBox = cc.rect(0,0,0,0)          --

    self:_init()
end 

function Fist_ActionBase:_init()
    local RES_PATH = "fistfight/pd_role.plist"
    local isLoad = cc.SpriteFrameCache:getInstance():isSpriteFramesWithFileLoaded(RES_PATH)
    if not isLoad then 
        cc.SpriteFrameCache:getInstance():addSpriteFrames(RES_PATH)
    end 

    self:initWithSpriteFrameName("hero_idle_00.png")
    self:setTag(100)
end 

-- 站立
function Fist_ActionBase:idle()
    if self._actionState == ACTION.IDLE then 
        return 
    end 
    self._actionState = ACTION.IDLE
    self:stopAllActions()
    self:runAction(self._idleAction)
end 

-- 走动(方向相关)
function Fist_ActionBase:walkWithDirection(direction)
    -- 判定是否为站立状态，若是的话，开始走动
    if self._actionState == ACTION.IDLE then 
        self._actionState = ACTION.WALK
        self:stopAllActions()
        self:runAction(self._walkAction)
    end 

    if self._actionState == ACTION.WALK then 
        if direction.x >= 0 then 
            self:setFlippedX(false) 
        else 
            self:setFlippedX(true) 
        end 
        self._desiredPos = cc.pAdd(cc.p(self:getPosition()), cc.pMul(direction, self._walkSpeed))
    end 
end 

-- 攻击
function Fist_ActionBase:attack()
    -- 判定是否为死亡状态
    if self._actionState == ACTION.NONE or self._actionState == ACTION.DIE then 
        return
    end 
    self._actionState = ACTION.ATTACK
    self:stopAllActions()
    self:runAction(self._attackAction)
end 

-- 被攻击
function Fist_ActionBase:hurtWithDamage(damageNum)
    if self._actionState == ACTION.DIE then 
        return 
    end 
    self._actionState = ACTION.HURT
    self:stopAllActions()
    self:runAction(self._hurtAction)

    -- 避免伤害值不合法
    damageNum = tonumber(damageNum) or 10
    self._HpNum = self._HpNum - damageNum
    if self._HpNum <= 0 then 
        self:die()
    end 
end 

-- 死亡
function Fist_ActionBase:die()
    if self._actionState == ACTION.DIE then 
        return 
    end 
    self._actionState = ACTION.DIE
    self:stopAllActions()
    self:runAction(self._dieAction)
end

-- 设置动画位置
function Fist_ActionBase:setAniPos(pos)
    self._desiredPos = pos or cc.p(0, 0)
end 

-- 获取动画位置
function Fist_ActionBase:getAniPos()
    return self._desiredPos
end 

-- 获取动画状态
function Fist_ActionBase:getActionState()
    return self._actionState
end 

-- 创建碰撞体
function Fist_ActionBase:createBoundingBoxWithOrigin(point, size)
    -- 碰撞检测区域
    local box = {
        -- 动作矩形，会随着精灵的移动而改变
        actual = cc.rect(0, 0, 0, 0),
        -- 原始矩形，精灵的基本矩形，设置后不会再改变
        original = cc.rect(0, 0, 0, 0),
    }
    box.original = cc.rect(point.x, point.y, size.width, size.height)

    local posx, posy = self:getPosition()
    local actpos = cc.pAdd(cc.p(posx, posy), cc.p(point.x, point.y))
    box.actual = cc.rect(actpos.x, actpos.y, size.width, size.height)

    return box 
end 

-- 转换
function Fist_ActionBase:transformBoxes()
    local isFlipX, isFlipY = self:isFlippedX(), self:isFlippedY()
    local xfactor = isFlipX and -1 or 1
    local xfactor2 = isFlipX and 1 or 0
    local yfactor = isFlipY and -1 or 1
    local yfactor= isFlipY and 1 or 0
    local posx, posy = self:getPosition()

    local original_1 = self._hitBox.original
    local posx_1 = original_1.x * xfactor - original_1.width * xfactor2
    local posy_1 = original_1.y * yfactor - original_1.height * yfactor2
    local hitpos = cc.pAdd(cc.p(posx, posy), cc.p(posx_1, posy_1))
    self._hitBox.actual = cc.rect(hitpos.x, hitpos.y, original_1.width, original_1.height)

    local original_2 = self._attackBox.original
    local posx_2 = original_2.x * xfactor - original_2.width * xfactor2
    local posy_2 = original_2.y * yfactor - original_2.height * yfactor2
    local attackpos = cc.pAdd(cc.p(posx, posy), cc.p(posx_2, posy_2))
    self._attackBox.actual = cc.rect(attackpos.x, attackpos.y, original_2.width, original_2.height) 
end 

return Fist_ActionBase