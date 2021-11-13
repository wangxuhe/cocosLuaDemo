-- 地图背景类
-- 碰撞相关，可参考： https://blog.csdn.net/akof1314/article/details/8572546

local const = require("app.Demo_FistFight.Fist_Const")
local UIRole = require("app.Demo_FistFight.Fist_Role")
local UIEnemy = require("app.Demo_FistFight.Fist_Enemy")
local ENEMY_COUNT = const.ENEMY_COUNT
local RANDOM = math.random
local MAX = math.max 
local MIN = math.min 

local Fist_Game = class("Fist_Game", function()
    return newLayerColor(cc.size(display.width, display.height), 255)
end)

function Fist_Game:ctor()
    self._map = nil                     -- 地图节点
    self._mapSize = nil                 -- 地图尺寸(瓦片)
    self._tileSize = nil                -- 瓦片尺寸(像素)
    
    self._roleNode = nil                -- 英雄节点相关
    self._enemyNodes = {}               -- 敌人相关

    self:_init()
end 

function Fist_Game:_init()
    -- 初始化地图
    self._map = ccexp.TMXTiledMap:create("fistfight/pd_tilemap.tmx")
    self._mapSize = self._map:getMapSize()
    self._tileSize = self._map:getTileSize()
    self:addChild(self._map, 0)

    -- 初始化英雄
    local rolepos = cc.p(100,50)
    self._roleNode = UIRole.new()
    self._roleNode:idle()
    self._roleNode:setPosition(rolepos)
    self._roleNode:setAniPos(rolepos)
    self:addChild(self._roleNode, 1)

    -- 初始化敌人
    math.newrandomseed()
    for i = 1, ENEMY_COUNT do 
        self._enemyNodes[i] = UIEnemy.new()
        self._enemyNodes[i]:setFlippedX(true)
        self._enemyNodes[i]:idle()
        self:addChild(self._enemyNodes[i], 2)

        local cSide, cBottom = self._enemyNodes[i]._centerToSide, self._enemyNodes[i]._centerToBottom
        local minX, maxX = display.width/2 + cSide, self._mapSize.width * self._tileSize.width - cSide
        local minY, maxY = cBottom + 20, 3 * self._tileSize.height + cBottom
        local pos = cc.p(RANDOM(minX, maxX), RANDOM(minY, maxY))
        self._enemyNodes[i]:setPosition(pos)
        self._enemyNodes[i]:setAniPos(pos)
    end 
    
    -- 定时器相关
    self:scheduleUpdateWithPriorityLua(handler(self, self._update), 0)
end 

-- 刷新
function Fist_Game:_update(dt)
    self:_updatePositions(dt)
    self:_updateReorder()
    self:_updateRobots(dt)
end 

-- 更新位置相关
function Fist_Game:_updatePositions(dt)
    -- 角色位置相关
    local aniPos = self._roleNode:getAniPos()
    local _posx1 = self._mapSize.width * self._tileSize.width - self._roleNode._centerToSide
    local _posx2 = MAX(self._roleNode._centerToSide, aniPos.x)

    local _posy1 = 3 * self._mapSize.height + self._roleNode._centerToBottom
    local _posy2 = MAX(self._roleNode._centerToBottom, aniPos.y)
    local rolepos = cc.p(MIN(_posx1, _posx2), MIN(_posy1, _posy2))
    self._roleNode:setPosition(rolepos)

    -- 地图位置相关
    self:setViewpointCenter(rolepos)
end 

-- 更新视图位置
function Fist_Game:setViewpointCenter(rolepos)
    local mapWidth, mapHight = self._mapSize.width * self._tileSize.width, self._mapSize.height * self._tileSize.height
    local x1, x2 = MAX(rolepos.x, display.width/2), mapWidth - display.width/2
    local y1, y2 = MAX(rolepos.y, display.height/2), mapHight - display.height/2
    local point = cc.p(MIN(x1, x2), MIN(y1, y2))
    local newpos = cc.pSub(display.center, point)
    self:setPosition(newpos)
end 

-- 更新层级
function Fist_Game:_updateReorder()
    --do return end 
    for i = 1, ENEMY_COUNT do 
        local tag = self._enemyNodes[i]:getTag()
        if tag == 100 then 
            local newTag = self._mapSize.height * self._tileSize.height - self._enemyNodes[i]:getPositionY()
            self:reorderChild(self._enemyNodes[i], newTag)
        end 
    end 
end 

-- 更新机器人相关
function Fist_Game:_updateRobots(dt)
    local dieCount = 0             -- 死亡敌人数目
    for i = 1, ENEMY_COUNT do 
        local actionState = self._enemyNodes[i]:getActionState()
        if actionState == const.ActionState.DIE then 
            dieCount = dieCount + 1
        end 

        if dieCount >= ENEMY_COUNT then 
            -- 游戏结束
            break 
        end 
    end 

end 

-- 获取英雄节点
function Fist_Game:getRoleNode()
    return self._roleNode
end 

function Fist_Game:dispose()
    self:unscheduleUpdate()
end 

return Fist_Game