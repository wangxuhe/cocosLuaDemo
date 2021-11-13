
local const = {}

-- 动作状态
const.ActionState = {
    NONE = 0, 
    IDLE = 1,       -- 站立
    WALK = 2,       -- 走动
    ATTACK = 3,     -- 攻击
    HURT = 4,       -- 被攻击
    DIE = 5,        -- 死亡
}

-- 敌人数目
const.ENEMY_COUNT = 10



return const 