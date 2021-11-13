-- 萝莉跑酷主页面
local ACTION = require("app.Demo_lolitaParkour.lolitaConst").ACTION
local UIRole = require("app.Demo_lolitaParkour.lolitaRole")

local BG_WIDTH, BG_HEIGHT = 1024, 516           -- 后，中背景大小
local BACK_SPEED = 1                            -- 后背景移动速度
local MID_SPEED = 5                             -- 中背景移动速度

local lolitaMainScene = class("lolitaMainScene", function()
    return cc.Scene:create()
end)

function lolitaMainScene:ctor()
    self._backSpr = {}                  -- 后背景
    self._midSpr = {}                   -- 中背景
    self._frontMap = nil                -- 前背景地图
    self._stars = {}                    -- 星星
    self._role = nil                    -- 角色
    self._roleSize = nil                -- 角色大小
    self._starRects = {}                -- 
    self._wallRects = {}                -- 
    self._scoreLabel = nil              -- 分数
    self._backBtn = nil                 -- 返回按钮
    self._timeScheduler = nil           -- 定时器

    self._curScore = 0                  -- 当前分数

    self:_init()
end 

function lolitaMainScene:_init()
    -- 背景相关
    for i = 1, 2 do 
        self._backSpr[i] = cc.Sprite:create("lolitaParkour/bg_1.png", cc.rect(0,BG_HEIGHT/3,BG_WIDTH,BG_HEIGHT/3))
        self._backSpr[i]:setAnchorPoint(cc.p(0, 0.5))

        self._midSpr[i] = cc.Sprite:create("lolitaParkour/bg_2.png")
        self._midSpr[i]:setAnchorPoint(cc.p(0, 0.5))
    end 

    -- 地图相关
    self._frontMap = ccexp.TMXTiledMap:create("lolitaParkour/map.tmx")
    local cs = self._frontMap:getContentSize()
    -- 获取地图的尺寸，单位是瓦片
    local ms = self._frontMap:getMapSize() 
    -- 获取瓦片尺寸，单位是像素，因此大小为 ms.width * ts.width = size.width            
    local ts = self._frontMap:getTileSize()             
    -- 获取星星对象数组
    local starGroup = self._frontMap:getObjectGroup("star")
    local starObjects = starGroup:getObjects()
    for i, obj in ipairs(starObjects) do 
        self._stars[i] = cc.Sprite:create("lolitaParkour/star_1.png")
        self._stars[i]:setPosition(cc.p(obj.x, obj.y))
        self._frontMap:addChild(self._stars[i])

        local size = self._stars[i]:getContentSize()
        self._starRects[i] = cc.rect(obj.x - size.width/2, obj.y - size.height/2, size.width, size.height)
    end 

    -- 获取碰撞对象数组
    local crashGroup = self._frontMap:getObjectGroup("crash")
    local crashObjects = crashGroup:getObjects()
    for i, obj in ipairs(crashObjects) do 
        self._wallRects[i] = cc.rect(obj.x, obj.y, obj.width, obj.height)
    end 

    -- 分数相关
    self._scoreLabel = ccui.Text:create()
    self._scoreLabel:setPosition(cc.p(display.width - 20, display.height - 20))
    self._scoreLabel:setAnchorPoint(cc.p(1, 0.5))
    self._scoreLabel:setString("分数： 0")
    self._scoreLabel:setFontSize(30)
    self:addChild(self._scoreLabel, 100)

    -- 返回按钮
    local normal = "lolitaParkour/backB.png"
    local press = "lolitaParkour/backA.png"
    self._backBtn = ccui.Button:create(normal, press, normal)
    local btnSize = self._backBtn:getContentSize()
    self._backBtn:addTouchEventListener(handler(self, self._backEvent))
    self._backBtn:setPosition(cc.p(btnSize.width + 10, display.height - btnSize.height/2 - 10))
    self:addChild(self._backBtn, 101)

    -- 角色相关
    self._roleNode = UIRole.new()
    self._roleSize = self._roleNode:getContentSize()
    self._roleNode:setPosition(cc.p(100, ts.height * 8 + self._roleSize.height/2))
    self._roleNode:changeRoleAction(ACTION.RUN)
    self:addChild(self._roleNode, 1)

    -- 触摸监听
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(handler(self, self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(handler(self, self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)

    -- 定时器监听
    if self._timeScheduler == nil then 
        local _hander = handler(self, self._update)
        self._timeScheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(_hander, 0.1, false)
    end

    self:_updateMapMove()
end 

-- 地图移动
function lolitaMainScene:_updateMapMove()
    local voidNode = cc.ParallaxNode:create()
    self:addChild(voidNode)
    --[[
    参数1： 视图层
    参数2： 视图层中的层级
    参数3： x，y轴中的移动速率
    参数4， 位置坐标
    ]]
    voidNode:addChild(self._backSpr[1], -1, cc.p(0.4,0), cc.p(0, display.height - BG_HEIGHT/6))
    voidNode:addChild(self._backSpr[2], -1, cc.p(0.4,0), cc.p(BG_WIDTH, display.height - BG_HEIGHT/6))
    voidNode:addChild(self._midSpr[1], 1, cc.p(1,0),cc.p(0, display.height/2))
    voidNode:addChild(self._midSpr[2], 1, cc.p(1,0), cc.p(BG_WIDTH, display.height/2))
    voidNode:addChild(self._frontMap, 2, cc.p(3.0,0), cc.p(0,0))

    local ms = self._frontMap:getMapSize()
    local ts = self._frontMap:getTileSize()
    local action1 = cc.MoveBy:create(30, cc.p(-ms.width * ts.width/2 + display.width, 0))
    local action2 = cc.CallFunc:create(function()
        -- 游戏结束
        self:_gameOver()
    end)
    local action = cc.Sequence:create(action1, action2)
    voidNode:runAction(action)

    self._voidNode = voidNode
end 

function lolitaMainScene:onTouchBegan(sender, event)
    return true 
end 

function lolitaMainScene:onTouchEnded(sender, event)
    self._roleNode:changeRoleAction(ACTION.JUMP)
end 

-- 返回按钮事件
function lolitaMainScene:_backEvent(sender, event)
    if event ~= ccui.TouchEventType.ended then 
        return 
    end 
    -- 游戏结束
    self:_gameOver()

    -- 切换场景
    local scene = require("app.Demo_lolitaParkour.lolitaLoginScene"):create()
    if scene ~= nil then 
        display.runScene(scene)
    end 
end 

function lolitaMainScene:_update(dt)
    -- 将角色坐标转换为相对于地图的坐标
    local rolePos = self._frontMap:convertToNodeSpace(cc.p(self._roleNode:getPosition()))
    -- 角色的碰撞区域存在瑕疵，只实现基本的效果算了
    local rolerect = cc.rect(
        rolePos.x, rolePos.y + self._roleNode:getRolePosY() - 10, 
        self._roleSize.width*3/4, self._roleSize.height*2/3
    )

    ------------------------- 检测玩家是否在地面上 -------------------------
    local isInWall = true 
    for i, wallrect in pairs(self._wallRects) do 
        -- 判定是否在非碰撞区域段
        if rolerect.x >= wallrect.x and rolerect.x + self._roleSize.width <= wallrect.x + wallrect.width then 
            if rolerect.y - 50 <= wallrect.y + wallrect.height then 
                isInWall = false 
                break
            end  
        end 
    end 

    if not isInWall then 
        -- 游戏结束
        self:_gameOver()
        -- 掉落下去
        local layer = require("app.Demo_lolitaParkour.lolitaReport"):create()
        if layer ~= nil then 
            self:addChild(layer, 1000)
        end 
        self._roleNode:changeRoleAction(ACTION.DIE)
        return 
    end 

    ------------------------- 检测玩家是否碰到星星 -------------------------
    local num = 0 
    for i, startrect in pairs(self._starRects) do 
        if rolerect.y >= startrect.y then 
            if (rolerect.x >= startrect.x and rolerect.x <= startrect.x + startrect.width) or (rolerect.x + rolerect.width >= startrect.x and rolerect.x + rolerect.width <= startrect.x) then 
                self._stars[i]:setVisible(false)
                num = num + 1
            end 
        end 
    end 

    if num > 0 then 
        self:_updateScore(num)
    end 
end

-- 更新分数
function lolitaMainScene:_updateScore(num)
    self._curScore = self._curScore + num *100
    self._scoreLabel:setString("分数:" .. self._curScore)
end 

-- 游戏结束
function lolitaMainScene:_gameOver()
    -- 停止定时器
    if self._timeScheduler ~= nil then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._timeScheduler)
        self._timeScheduler = nil 
    end 
    -- 停止地图移动动作
    self._voidNode:stopAllActions()
    MsgTip("游戏结束")
end 

return lolitaMainScene