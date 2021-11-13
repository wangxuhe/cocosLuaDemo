-- 拖尾效果
local GhostTest = class("GhostTest", function()
    return newLayerColor(cc.size(display.width, display.height), 255)
end)

function GhostTest:ctor()
    self._isSave = false 
    -- 背景相关
    local bgImg = ccui.ImageView:create(Res.BTN_D)
    bgImg:setContentSize(cc.size(display.width, display.height))
    bgImg:setPosition(display.center)
    bgImg:setScale9Enabled(true)
    self:addChild(bgImg)

    -- 点击按钮
    local clickBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    clickBtn:setPosition(cc.p(display.width/2, display.height/4))
    clickBtn:setTitleFontSize(18)
    clickBtn:setTitleColor(cc.c3b(0,0,0))
    clickBtn:setTitleText("点 击")
    clickBtn:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then 
            self:_createGhost(self._spr)
        end 
    end)
    self:addChild(clickBtn)

    -- 返回按钮
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(display.width - 30, 30))
    backBtn:setTitleFontSize(18)
    backBtn:setTitleColor(cc.c3b(0,0,0))
    backBtn:setTitleText("返 回")
    backBtn:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then 
            self:getEventDispatcher():removeEventListenersForTarget(self)
            self:removeFromParent()
        end 
    end)
    self:addChild(backBtn)

    -- 精灵
    self._spr = cc.Sprite:create(Res.MAN)
    self._spr:setPosition(cc.p(display.width/2, display.height/2))
    self._oldpos = cc.p(display.width/2, display.height/2)
    self:addChild(self._spr)
end 

--[[
@function: 添加残影
@param: node 节点
@return: 返回当前纹理
]]
function GhostTest:_createGhost(node)
    if tolua.isnull(node) then 
        error("(ERROR)addGhost param node is nil!!!")
        return 
    end 

    local size = node:getContentSize()
    local posx, posy = node:getPosition()

    -- 绘制截图，其锚点默认为(0,0),位置默认为(0,0),故此要设置下绘制节点的位置，避免绘制无法出现图片的问题
    local render = cc.RenderTexture:create(size.width, size.height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
    node:setPosition(cc.p(size.width/2, size.height/2))
    render:begin()
    node:visit()
    render:endToLua()

    -- 将node恢复到原位置
    -- bug: 打开后，会出现无法渲染的问题,难道是本帧调用的问题???
    --node:setPosition(cc.p(posx, posy))

    local isSave = render:saveToFile("ghost.png", cc.IMAGE_FORMAT_PNG)
    if not isSave then 
        print("保存失败")
        return 
    else
        print("保存成功")
    end 
   
    -- 将纹理渲染到屏幕上
    local texture = render:getSprite():getTexture()
    local ghostSpr = cc.Sprite:createWithTexture(texture)
    ghostSpr:setPosition(posx + size.width/2, posx + size.height/2)
    ghostSpr:setFlippedY(true)
    self:addChild(ghostSpr, 999999)

    -- 添加变暗动作
    local action1 = cc.MoveBy:create(0.8,cc.p(display.width/2, display.height/2))
    local action2 = cc.FadeTo:create(0.8, 0)
    local action3 = cc.Spawn:create(action1, action2)
    local action4 = cc.CallFunc:create(function()
        ghostSpr:removeFromParent()
    end)
    local action = cc.Sequence:create(action3, action4)
    ghostSpr:runAction(action)
end


return GhostTest