-- 绘制折线图
local winSize = cc.Director:getInstance():getWinSize()
local DrawLineTest = class("DrawLineTest", function()
	return cc.LayerColor:create(cc.c4b(0,0,0,255), winSize.width, winSize.height)
end)

function DrawLineTest:ctor()
    self:_initUI()
	self:drawLineWnd()
end 

function DrawLineTest:_initUI()
    -- 返回按钮相关
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(winSize.width - 30, 30))
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
end 

function DrawLineTest:drawLineWnd()
    math.randomseed(os.time())
    local drawNode = cc.DrawNode:create()
    self:addChild(drawNode,100)

    -- x,y轴阶段
    local startposX, startPosY = 200, 100           -- 原点坐标
    local xLen, yLen = 540, 300                     -- x,y轴长度
    local SPACEX, SPACEY = 60, 30                   -- x,y轴每段间隔
    local randlinepos = {}                          -- 随机点坐标
    for i = 1, 10 do 
        -- x轴坐标相关
        local labelX = ccui.Text:create(tostring((i-1)*100), "Arial", 18)
        labelX:setPosition(cc.p(startposX + (i - 1) * SPACEX, startPosY - 20))
        self:addChild(labelX)

        -- y轴坐标相关
        local labelY = ccui.Text:create(tostring((i-1)*100), "Arial", 18)
        labelY:setPosition(cc.p(startposX - 20, startPosY + (i -1) * SPACEY))
        self:addChild(labelY)

        -- y轴平行线相关
        local origin = cc.p(startposX, startPosY + (i - 1)* SPACEY)
        local destination = cc.p(startposX + xLen, startPosY + (i - 1)* SPACEY)
        local color = cc.c4f(0, 0, 1, 0.8)
        drawNode:drawLine(origin, destination,color)

        -- 绘制Y轴随机点，计算公式： x/len = 随机值／总数值
        local randPosY = math.floor(math.random(0,900) * yLen/900) + startPosY
        local pointSize = 5
        local color = cc.c4f(1,0,0,1)
        local newPos = cc.p(startposX + (i - 1) * SPACEX, randPosY)
        drawNode:drawPoint(newPos,pointSize, color)
        table.insert(randlinepos, newPos)
    end 

    -- 根据随机点连接线段
    local num = #randlinepos
    for i = 1, num do 
        if i >= 2 then 
            local origin = randlinepos[i-1]
            local destination = randlinepos[i]
            drawNode:drawLine(origin, destination, cc.c4f(1,1,0,1))
        end 
    end 
end

return DrawLineTest
