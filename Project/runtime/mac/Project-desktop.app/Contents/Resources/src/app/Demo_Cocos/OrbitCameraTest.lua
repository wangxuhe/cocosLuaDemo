-- 翻牌效果
local OrbitCameraTest = class("OrbitCameraTest", function()
    return cc.LayerColor:create(cc.c4b(0,0,0,255), display.width, display.height)
end)

local CARD_COUNT = 13               -- 牌张数目 
local CARD_SPACE = 40               -- 牌张之间间隔
local STARTPOS = cc.p(100, 100)      -- 首张牌的起始位置

function OrbitCameraTest:ctor()
    self:_initUI()
end 

function OrbitCameraTest:_initUI()
    -- 返回按钮相关
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(display.width - 30, 30))
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

    self._cardBg = {}           -- 牌背景
    self._card = {}             -- 牌张
    for i = 1, CARD_COUNT do 
        self._cardBg[i] = cc.Sprite:create("res/Default/card_bg.png")
        self._cardBg[i]:setPosition(cc.p(STARTPOS.x + (i-1)*CARD_SPACE, STARTPOS.y))
        self:addChild(self._cardBg[i], i)

        self._card[i] = cc.Sprite:create("res/Default/card_1.png")
        self._card[i]:setPosition(cc.p(STARTPOS.x + (i-1)*CARD_SPACE, STARTPOS.y))
        self:addChild(self._card[i], i)
        self._card[i]:setVisible(false)
    end 

    -- 动作相关
    for i = 1, CARD_COUNT do 
        -- 延时
        local action0 = cc.DelayTime:create(1)
        -- 翻转
        -- duration: 动作持续时间
        -- radius: 镜头距离图像中心的距离，俗称为半径
        -- deltaRadius: 半径在持续时间内的变化总量
        -- angleZ: 动作开始是，镜头到图像中心的连线与Z轴的夹角
        -- deltaAngle:z角度的变化总量
        -- angleX: x轴的初始倾斜角度
        -- deltaAngleX: x轴的变化角度总量
        local action1 = cc.OrbitCamera:create(2, 1, 0, 0, -90, 0, 0)        
        local action2 = cc.CallFunc:create(function()
            local action4 = cc.OrbitCamera:create(2, 1, 0, 90, -90, 0, 0)
            self._card[i]:runAction(action4)
            self._card[i]:setVisible(true)
        end)
        local action3 = cc.Hide:create()    
        local action = cc.Sequence:create(action0, action1, action3, action2)
        self._cardBg[i]:runAction(action)
    end 
end 

return OrbitCameraTest