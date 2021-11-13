-- 裁切Demo(资源丢失，使用其他资源替代吧)
-- 博客地址：https://www.cnblogs.com/SkyflyBird/p/10166374.html

local BG_RES = "Default/r2.png"
local SPR_RES = "Default/r1.png"

local ClipTest = class("ClipTest", function()
	return cc.LayerColor:create(cc.c4b(0,0,0,255), display.width, display.height)
end)

function ClipTest:ctor()
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

	self:creatClipWnd()
end 

function ClipTest:creatClipWnd()
	-- 添加背景
    local bgSprite = cc.Sprite:create(BG_RES)
    bgSprite:setPosition(cc.p(display.width/2, display.height/2))
    self:addChild(bgSprite)
 
    local bgSize = bgSprite:getContentSize()
    local bgPosX, bgPosY = bgSprite:getPosition()
    local center = cc.p(bgPosX,bgPosY)          -- 中心点位置
    local radius = bgSize.height/2              -- 半径 
    local angle = math.rad(30) 					-- 角度

    -- 测试数据
    local numList = {70,10,80,90,60,50}
    local textList = {
        [1] = {name = "攻击", pos = cc.p(bgPosX, bgPosY + radius+ 10)},
        [2] = {name = "防御", pos = cc.p(bgPosX + radius * math.cos(angle) + 20, bgPosY + radius/2)},
        [3] = {name = "生命", pos = cc.p(bgPosX + radius * math.cos(angle) + 20, bgPosY - radius/2)},
        [4] = {name = "暴击", pos = cc.p(bgPosX, bgPosY - radius - 10)},
        [5] = {name = "闪避", pos = cc.p(bgPosX - radius * math.cos(angle) - 20, bgPosY - radius/2)},
        [6] = {name = "魅力", pos = cc.p(bgPosX - radius * math.cos(angle) - 20, bgPosY + radius/2)},
    }

    -- 属性文本
    for i = 1, 6 do 
    	local label = ccui.Text:create(textList[i].name, "Arial", 18)
    	label:setPosition(textList[i].pos)
    	self:addChild(label)
    end 

    -- 每条半径点上的位置要进行等比换算，公式： X/num = radius/100， 求X
    -- 攻击
    local pos1 = {}
    pos1.x = center.x
    pos1.y = center.y + math.floor((numList[1]*radius)/100)
    -- 防御
    local pos2 = {}
    local radius2 = math.floor((numList[2]*radius)/100)   
    pos2.x = center.x + math.cos(angle)*radius2
    pos2.y = center.y + math.sin(angle)*radius2
    -- 生命
    local pos3 = {}
    local radius3 = math.floor((numList[3]*radius)/100)
    pos3.x = center.x + math.cos(angle)*radius3
    pos3.y = center.y - math.sin(angle)*radius3
    -- 暴击
    local pos4 = {}
    pos4.x = center.x
    pos4.y = center.y - math.floor((numList[4]*radius)/100)
    -- 闪避
    local pos5 = {}
    local radius5 = math.floor((numList[5]*radius)/100)
    pos5.x = center.x - math.cos(angle)*radius5
    pos5.y = center.y - math.sin(angle)*radius5
    -- 魅力
    local pos6 = {}
    local radius6 = math.floor((numList[6]*radius)/100)
    pos6.x = center.x - math.cos(angle)*radius6
    pos6.y = center.y + math.sin(angle)*radius6
    -- 
    local drawnode = cc.DrawNode:create()
    local vertices = {pos1,pos2,pos3,pos4,pos5,pos6}
    drawnode:drawSolidPoly(vertices, 6, cc.c4b(0,1,0,1))

    -- 将绘制的六边形作为模版，对其clipSprite进行裁切
    local clipSprite = cc.Sprite:create(SPR_RES)
    clipSprite:setPosition(cc.p(bgPosX,bgPosY))

    -- 
    local clipnode = cc.ClippingNode:create()
    clipnode:setPosition(cc.p(0,0))
    clipnode:setAlphaThreshold(1)           -- 设置alpha
    clipnode:addChild(clipSprite)           -- 添加底板       
    clipnode:setStencil(drawnode)           -- 设置模板    
    clipnode:setInverted(false)             -- true底板可见，false模板可见     
    self:addChild(clipnode,100)
end

return ClipTest
