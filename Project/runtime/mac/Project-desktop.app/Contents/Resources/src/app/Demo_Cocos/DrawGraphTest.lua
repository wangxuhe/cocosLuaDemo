-- 绘制多边形
local size  = cc.Director:getInstance():getWinSize()

local DrawGraphTest = class("DrawGraphTest",function()
    return cc.LayerColor:create(cc.c4b(0,0,0,255), display.width, display.height)
end)

function DrawGraphTest:ctor()
    local function onNodeEvent(event)
        if event == "enter" then
            self:init()
            local scheduleHandler = cc.Director:getInstance():getScheduler()
	        self.scheduleHandler = scheduleHandler:scheduleScriptFunc(handler(self, self.update), 0.5, false)
        elseif event == "exit" then 
            if self.scheduleHandler ~= nil then
                local scheduler = cc.Director:getInstance():getScheduler()		
                scheduler:unscheduleScriptEntry(self.scheduleHandler)
                self.scheduleHandler = nil 
            end
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function DrawGraphTest:init()
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
    
    -- 创建drawNode，并添加到指定的层中
    local drawNode = cc.DrawNode:create()
    self:addChild(drawNode, 10)

    -- 绘制点
    local pointpos = cc.p(460,460)          -- 点位置
    local pointSize = 100                   -- 点大小
    local color = cc.c4f(0.8, 1, 0.8, 1)    -- 颜色，取值范围0~1之间
    drawNode:drawPoint(pointpos, pointSize, color)

    -- 绘制一组点
    local pointGroup = {                    -- 点位置组
        cc.p(160,160), cc.p(170,170), cc.p(160,170), 
        cc.p(170,160), cc.p(170,180)
    }
    local pointNum = #pointGroup            -- 点数目
    pointSize = 1                           -- 点大小
    color = cc.c4f(0.8, 1, 0.8, 1)          -- 颜色，取值范围0~1之间
    drawNode:drawPoints(pointGroup, pointNum, pointSize, color)

    -- 绘制线段
    local origin = cc.p(0,0)                              -- 起始点
    local destination = cc.p(size.width, size.height)     -- 结束点
    local color = cc.c4f(0,1,0,1)                         -- 线段颜色，取值范围0~1之间
    drawNode:drawLine(origin, destination, color)

    -- 绘制有粗度的线条
    local from = cc.p(size.width*3/4,100)         -- 起始点 
    local to = cc.p(size.width*3/4,size.height/2) -- 结束点
    local radius = 100                            -- 半径
    local color = cc.c4f(0, 1, 1, 1)              -- 线条颜色
    drawNode:drawSegment(from, to, radius, color)

    -- 绘制空心矩形
    local anglepos1 = cc.p(123,123)         -- 对角线原点
    local anglepos2 = cc.p(700,400)         -- 对角线终点
    local color = cc.c4f(1,1,0,1)           -- 颜色
    drawNode:drawRect(anglepos1, anglepos2, color)

    -- 绘制实心矩形
    local anglepos1 = cc.p(200,200)         -- 对角线原点
    local anglepos2 = cc.p(600,300)         -- 对角线终点
    local color = cc.c4f(1,1,1,1)           -- 颜色
    drawNode:drawSolidRect(anglepos1, anglepos2, color)

    -- 绘制空心多边形
    local poliGroup = {cc.p(30,130), cc.p(30,230),  -- 点位置组
        cc.p(50,200),cc.p(60,270),cc.p(80,20)
    }        
    local poliNum = #poliGroup                      -- 点数目
    local isClose = true                            -- 是否封闭多边形，true为是
    local color = cc.c4f(math.random(0,1), math.random(0,1), math.random(0,1), 1)
    drawNode:drawPoly(poliGroup, poliNum, isClose, color)

    -- 绘制实心多边形
    local poliGroup = {cc.p(130,130), cc.p(130,230),  -- 点位置组
        cc.p(150,200),cc.p(160,270),cc.p(180,20)}        
    local poliNum = #poliGroup                        -- 点数目
    local color = cc.c4f(math.random(0,1), math.random(0,1), math.random(0,1), 1)
    drawNode:drawSolidPoly(poliGroup, poliNum, color)

    -- 绘制空心椭圆
    local center = cc.p(680 ,360)           -- 圆心
    local radius = 50                       -- 半径
    local angle = math.pi/2                 -- 角度 
    local segments = 100                    -- 段数(数值越大，越精细)
    local drawLineToCenter = true           -- 是否绘制原点到圆心的直线
    local scaleX, scaleY = 2.0, 1.0         -- 中心缩放值(两值相等就是圆)
    local color = cc.c4f(1,1,0,1)           -- 颜色
    drawNode:drawCircle(center,radius,angle,segments,drawLineToCenter,scaleX,scaleY,color)

    -- 绘制实心椭圆
    local center = cc.p(480 ,360)           -- 圆心
    local radius = 100                      -- 半径
    local angle = math.pi/2                 -- 角度 
    local segments = 100                    -- 段数(数值越大，越精细)
    local scaleX, scaleY = 2.0, 1.0         -- 中心缩放值(两值相等就是圆)
    local color = cc.c4f(1,0,0,1)           -- 颜色
    drawNode:drawSolidCircle(center, radius, angle, segments, scaleX, scaleY, color)

    -- 绘制贝塞尔曲线
    local origin = cc.p(size.width - 150, size.height - 150)               -- 原点
    local control = cc.p(size.width - 70, size.height - 10)                -- 控制点
    local destination = cc.p(size.width - 10, size.height - 10)            -- 终点
    local color = cc.c4f(1,0,0,1)                                          -- 颜色
    drawNode:drawQuadBezier(origin, control, destination, 10, color)

    -- 绘制三次贝塞尔曲线
    local origin = cc.p(480,360)        -- 原点
    local control = cc.p(10,410)        -- 控制点1
    local control2 = cc.p(40,310)       -- 控制点2
    local destination = cc.p(0,640)     -- 终点
    local segments = 100                -- 段数(数值越大，越精细)
    local color = cc.c4f(1,1,1,1)       -- 颜色
    drawNode:drawCubicBezier(origin, control, control2, control2, segments, color)
        
    --绘制画基数样条
    local pointArray = {                -- 数组点
        cc.p(200, 80),              
        cc.p(size.width - 130, 80),
        cc.p(size.width - 130, size.height - 180),
        cc.p(0, size.height - 180),
        cc.p(200, 80) 
    }
    local tension = 0.1                 -- 张力(数值越大，越平整)
    local segments = 50                 -- 段数(数值越大，越精细)
    local color = cc.c4f(0.8, 0.7, 1, 1)-- 样条颜色
    drawNode:drawCardinalSpline(pointArray,tension,segments,color)

    -- 
    local pointArray = {                           -- 指向控制点的点数组
        cc.p(size.width/2, 30),
        cc.p(size.width - 80, 30),
        cc.p(size.width - 80, size.height - 80),
        cc.p(size.width/2, size.height - 80),
        cc.p(size.width/2, 30) 
    }
    local segments = 50                             -- 段数(数值越大，越精细)
    local color = cc.c4f(1, 0, 1, 1)                -- 颜色
    drawNode:drawCatmullRom(pointArray, segments, color)

    -- 绘制圆
    for i=1, 10 do
        local pos = cc.p(size.width/4, size.height*3/4)     -- 原点
        local radius = 10*(10-i)                            -- 半径
        local color = cc.c4f(math.random(0,1),math.random(0,1),math.random(0,1),1)
        drawNode:drawDot(pos, radius, color)
    end

    -- 绘制一个带有填充色和线条色的多边形
    local o, w, h = 80, 20, 50
    local verts = {                        -- 点坐标组
        cc.p(o, o), cc.p(o + w, o - h), cc.p(o + w*2, o),   -- lower spike
        cc.p(o + w*2 + h, o + w ), cc.p(o + w*2, o + w*2),  -- right spike
        cc.p(o + w, o + w*2 + h), cc.p(o, o + w*2),         -- top spike
        cc.p(o - h, o + w),                                 -- left spike
    }
    local count = #verts                    -- 点数目
    local fillColor = cc.c4f(1,0,0,0.5)     -- 填充颜色
    local borderWidth = 1                   -- 线条宽度
    local borderColor = cc.c4f(0,0,1,1)     -- 线条颜色
    drawNode:drawPolygon(verts, count, fillColor, borderWidth, borderColor)-- 创建drawNode，并添加到指定的层中
    local drawNode = cc.DrawNode:create()
    self:addChild(drawNode, 10)

    -- 绘制点
    local pointpos = cc.p(460,460)          -- 点位置
    local pointSize = 100                   -- 点大小
    local color = cc.c4f(0.8, 1, 0.8, 1)    -- 颜色，取值范围0~1之间
    drawNode:drawPoint(pointpos, pointSize, color)

    -- 绘制一组点
    local pointGroup = {                    -- 点位置组
        cc.p(160,160), cc.p(170,170), cc.p(160,170), 
        cc.p(170,160), cc.p(170,180)
    }
    local pointNum = #pointGroup            -- 点数目
    pointSize = 1                           -- 点大小
    color = cc.c4f(0.8, 1, 0.8, 1)          -- 颜色，取值范围0~1之间
    drawNode:drawPoints(pointGroup, pointNum, pointSize, color)

    -- 绘制线段
    local origin = cc.p(0,0)                              -- 起始点
    local destination = cc.p(size.width, size.height)     -- 结束点
    local color = cc.c4f(0,1,0,1)                         -- 线段颜色，取值范围0~1之间
    drawNode:drawLine(origin, destination, color)

    -- 绘制有粗度的线条
    local from = cc.p(size.width*3/4,100)         -- 起始点 
    local to = cc.p(size.width*3/4,size.height/2) -- 结束点
    local radius = 100                            -- 半径
    local color = cc.c4f(0, 1, 1, 1)              -- 线条颜色
    drawNode:drawSegment(from, to, radius, color)

    -- 绘制空心矩形
    local anglepos1 = cc.p(123,123)         -- 对角线原点
    local anglepos2 = cc.p(700,400)         -- 对角线终点
    local color = cc.c4f(1,1,0,1)           -- 颜色
    drawNode:drawRect(anglepos1, anglepos2, color)

    -- 绘制实心矩形
    local anglepos1 = cc.p(200,200)         -- 对角线原点
    local anglepos2 = cc.p(600,300)         -- 对角线终点
    local color = cc.c4f(1,1,1,1)           -- 颜色
    drawNode:drawSolidRect(anglepos1, anglepos2, color)

    -- 绘制空心多边形
    local poliGroup = {cc.p(30,130), cc.p(30,230),  -- 点位置组
        cc.p(50,200),cc.p(60,270),cc.p(80,20)
    }        
    local poliNum = #poliGroup                      -- 点数目
    local isClose = true                            -- 是否封闭多边形，true为是
    local color = cc.c4f(math.random(0,1), math.random(0,1), math.random(0,1), 1)
    drawNode:drawPoly(poliGroup, poliNum, isClose, color)

    -- 绘制实心多边形
    local poliGroup = {cc.p(130,130), cc.p(130,230),  -- 点位置组
        cc.p(150,200),cc.p(160,270),cc.p(180,20)}        
    local poliNum = #poliGroup                        -- 点数目
    local color = cc.c4f(math.random(0,1), math.random(0,1), math.random(0,1), 1)
    drawNode:drawSolidPoly(poliGroup, poliNum, color)

    -- 绘制空心椭圆
    local center = cc.p(680 ,360)           -- 圆心
    local radius = 50                       -- 半径
    local angle = math.pi/2                 -- 角度 
    local segments = 100                    -- 段数(数值越大，越精细)
    local drawLineToCenter = true           -- 是否绘制原点到圆心的直线
    local scaleX, scaleY = 2.0, 1.0         -- 中心缩放值(两值相等就是圆)
    local color = cc.c4f(1,1,0,1)           -- 颜色
    drawNode:drawCircle(center,radius,angle,segments,drawLineToCenter,scaleX,scaleY,color)

    -- 绘制实心椭圆
    local center = cc.p(480 ,360)           -- 圆心
    local radius = 100                      -- 半径
    local angle = math.pi/2                 -- 角度 
    local segments = 100                    -- 段数(数值越大，越精细)
    local scaleX, scaleY = 2.0, 1.0         -- 中心缩放值(两值相等就是圆)
    local color = cc.c4f(1,0,0,1)           -- 颜色
    drawNode:drawSolidCircle(center, radius, angle, segments, scaleX, scaleY, color)

    -- 绘制贝塞尔曲线
    local origin = cc.p(size.width - 150, size.height - 150)               -- 原点
    local control = cc.p(size.width - 70, size.height - 10)                -- 控制点
    local destination = cc.p(size.width - 10, size.height - 10)            -- 终点
    local color = cc.c4f(1,0,0,1)                                          -- 颜色
    drawNode:drawQuadBezier(origin, control, destination, 10, color)

    -- 绘制三次贝塞尔曲线
    local origin = cc.p(480,360)        -- 原点
    local control = cc.p(10,410)        -- 控制点1
    local control2 = cc.p(40,310)       -- 控制点2
    local destination = cc.p(0,640)     -- 终点
    local segments = 100                -- 段数(数值越大，越精细)
    local color = cc.c4f(1,1,1,1)       -- 颜色
    drawNode:drawCubicBezier(origin, control, control2, control2, segments, color)
        
    --绘制画基数样条
    local pointArray = {                -- 数组点
        cc.p(200, 80),              
        cc.p(size.width - 130, 80),
        cc.p(size.width - 130, size.height - 180),
        cc.p(0, size.height - 180),
        cc.p(200, 80) 
    }
    local tension = 0.1                 -- 张力(数值越大，越平整)
    local segments = 50                 -- 段数(数值越大，越精细)
    local color = cc.c4f(0.8, 0.7, 1, 1)-- 样条颜色
    drawNode:drawCardinalSpline(pointArray,tension,segments,color)

    -- 
    local pointArray = {                           -- 指向控制点的点数组
        cc.p(size.width/2, 30),
        cc.p(size.width - 80, 30),
        cc.p(size.width - 80, size.height - 80),
        cc.p(size.width/2, size.height - 80),
        cc.p(size.width/2, 30) 
    }
    local segments = 50                             -- 段数(数值越大，越精细)
    local color = cc.c4f(1, 0, 1, 1)                -- 颜色
    drawNode:drawCatmullRom(pointArray, segments, color)

    -- 绘制圆
    for i=1, 10 do
        local pos = cc.p(size.width/4, size.height*3/4)     -- 原点
        local radius = 10*(10-i)                            -- 半径
        local color = cc.c4f(math.random(0,1),math.random(0,1),math.random(0,1),1)
        drawNode:drawDot(pos, radius, color)
    end

    -- 绘制一个带有填充色和线条色的多边形
    local o, w, h = 80, 20, 50
    local verts = {                        -- 点坐标组
        cc.p(o, o), cc.p(o + w, o - h), cc.p(o + w*2, o),   -- lower spike
        cc.p(o + w*2 + h, o + w ), cc.p(o + w*2, o + w*2),  -- right spike
        cc.p(o + w, o + w*2 + h), cc.p(o, o + w*2),         -- top spike
        cc.p(o - h, o + w),                                 -- left spike
    }
    local count = #verts                    -- 点数目
    local fillColor = cc.c4f(1,0,0,0.5)     -- 填充颜色
    local borderWidth = 1                   -- 线条宽度
    local borderColor = cc.c4f(0,0,1,1)     -- 线条颜色
    drawNode:drawPolygon(verts, count, fillColor, borderWidth, borderColor)
end


return DrawGraphTest
