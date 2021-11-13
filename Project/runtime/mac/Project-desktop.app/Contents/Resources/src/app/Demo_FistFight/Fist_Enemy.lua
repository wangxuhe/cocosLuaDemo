-- 敌人类
local super = require("app.Demo_FistFight.Fist_ActionBase")
local Fist_Enemy = class("Fist_Enemy", super)

function Fist_Enemy:ctor()
    self.super.ctor(self)

    self:_initAction()
end 

function Fist_Enemy:_initAction()
    self._hpNum = 100               -- 血量
    self._damage = 10               -- 伤害值
    self._walkSpeed = 4.0           -- 移动速度
    self._centerToSide = 29         -- 中心到侧面的偏移
    self._centerToBottom = 39       -- 中心到底部的偏移
    self:_initIdleAction()
    self:_initWalkAction()
    self:_initAttackAction()
    self:_initHurtAction()
    self:_initDieAction()
end 

function Fist_Enemy:_initIdleAction()
    local aniFrames = {}
    for i = 1, 5 do 
        local strName = string.format("robot_idle_%02d.png", i-1)
        aniFrames[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(strName)
    end 
    local animation = cc.Animation:createWithSpriteFrames(aniFrames, 1.0/4)
    self._idleAction = cc.RepeatForever:create(cc.Animate:create(animation))
    self._idleAction:retain()
end 

function Fist_Enemy:_initWalkAction()
    local aniFrames = {}
    for i = 1, 6 do 
        local strName = string.format("robot_walk_%02d.png", i-1)
        aniFrames[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(strName)
    end 
    local animation = cc.Animation:createWithSpriteFrames(aniFrames, 1.0/12)
    self._walkAction = cc.RepeatForever:create(cc.Animate:create(animation))
    self._walkAction:retain()
end 

function Fist_Enemy:_initAttackAction()
    local aniFrames = {}
    for i = 1, 5 do 
        local strName = string.format("robot_attack_%02d.png", i-1)
        aniFrames[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(strName)
    end 
    local animation = cc.Animation:createWithSpriteFrames(aniFrames, 1.0/12)
    local act1 = cc.Animate:create(animation)
    local act2 = cc.CallFunc:create(function()
        self:idle()
    end)
    self._attackAction = cc.Sequence:create(act1, act2)
    self._attackAction:retain()
end 

function Fist_Enemy:_initHurtAction()
    local aniFrames = {}
    for i = 1, 3 do 
        local strName = string.format("robot_hurt_%02d.png", i-1)
        aniFrames[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(strName)
    end 
    local animation = cc.Animation:createWithSpriteFrames(aniFrames, 1.0/12)
    local act1 = cc.Animate:create(animation)
    local act2 = cc.CallFunc:create(function()
        self:idle()
    end)
    self._hurtAction = cc.Sequence:create(act1, act2)
    self._hurtAction:retain()
end 

function Fist_Enemy:_initDieAction()
    local aniFrames = {}
    for i = 1, 5 do 
        local strName = string.format("robot_knockout_%02d.png", i-1)
        aniFrames[i] = cc.SpriteFrameCache:getInstance():getSpriteFrame(strName)
    end 
    local animation = cc.Animation:createWithSpriteFrames(aniFrames, 1.0/12)
    local act1 = cc.Animate:create(animation)
    local act2 = cc.Blink:create(2, 10)
    self._dieAction = cc.Sequence:create(act1, act2)
    self._dieAction:retain()
end 

return Fist_Enemy