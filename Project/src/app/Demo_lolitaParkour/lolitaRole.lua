-- 角色类
local ACTION = require("app.Demo_lolitaParkour.lolitaConst").ACTION

local lolitaRole = class("lolitaRole", function()
    return cc.Node:create()
end)

function lolitaRole:ctor() 
    cc.SpriteFrameCache:getInstance():addSpriteFrames("lolitaParkour/lolitaRole.plist")

    self._role = cc.Sprite:createWithSpriteFrameName("s_1.png")
    local size = self._role:getContentSize()
    self._role:setScale(0.4)
    self:addChild(self._role)   

    self:setContentSize(cc.size(size.width * 0.4, size.height * 0.4))
    self:setAnchorPoint(cc.p(0, 0.5))
end 

-- 切换动作
function lolitaRole:changeRoleAction(state, callback)
    -- 停止动画的所有动作
    self._role:stopAllActions()

    if state == ACTION.RUN then 
        local animation = cc.Animation:create()
        for i = 1, 8 do 
            local strName = string.format("s_%d.png", i)
            local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(strName)
            animation:addSpriteFrame(spriteFrame)
        end 
        animation:setDelayPerUnit(0.15)             -- 设置两帧之间的播放时间
        animation:setRestoreOriginalFrame(true)     -- 设置动画播放后还原到初始状态

        local action = cc.RepeatForever:create(cc.Animate:create(animation))
        self._role:runAction(action)
    elseif state == ACTION.JUMP then 
        self._role:setSpriteFrame("s_jump.png")
        -- 跳跃：事件，距离，高度，次数
        local action1 = cc.JumpBy:create(2.5, cc.p(0,0), 50, 1)
        local action2 = cc.CallFunc:create(function()
            self:changeRoleAction(ACTION.RUN)
        end)
        local action = cc.Sequence:create(action1, action2)
        self._role:runAction(action)
    elseif state == ACTION.HURT then 
        self._role:setSpriteFrame("s_hurt.png")
        local action1 = cc.Blink:create(3, 10)
        local action2 = cc.CallFunc:create(function()
            self:changeRoleAction(ACTION.RUN)
        end)
        local action = cc.Sequence:create(action1, action2)
        self._role:runAction(action)
    elseif state == ACTION.DIE then 
        self._role:setSpriteFrame("s_hurt.png")
        local action1 = cc.RotateBy:create(1, -90)
        local action2 = cc.CallFunc:create(function()
            self._role:stopAllActions()
            if callback then 
                callback()
            end 
        end)
        local action = cc.Sequence:create(action1, action2)
        self._role:runAction(action)
    end 
end 

function lolitaRole:getRolePosY()
    return self._role:getPositionY()
end 

return lolitaRole