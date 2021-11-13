--[[
天气效果,针对于粒子效果，写了三种：
1. 手动创建
2. 通过cocos2d 自带的粒子系统创建
3. 通过plist创建，推荐
]]

local EffectTest = class("EffectTest", function()
    return cc.LayerColor:create(cc.c4b(0,0,0,0),display.width,display.height)
end)

function EffectTest:ctor()
    self._snow = nil                -- 雪
    self._rain = nil                -- 雨
    self._titleText = nil           -- 标题
    self._playIndex = 0             -- 播放索引

    self._thunderScheduler = nil    

    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then 
            self:onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end 

--[[
@function: 显示指定类型的天气
@pram: 天气类型， 参考 weatherType
@pram: 天气程度，参考 levelType, 默认为SMALL
@pram: 是否播放气象效果, 默认为false
]]
function EffectTest:onEnter()
    -- 背景相关
    local bgImg = ccui.ImageView:create(Res.BTN_D)
    bgImg:setContentSize(cc.size(display.width, display.height))
    bgImg:setPosition(display.center)
    bgImg:setScale9Enabled(true)
    self:addChild(bgImg)

    -- 标题相关
    self._titleText = ccui.Text:create("粒子效果", "Arial", 25)
    self._titleText:setPosition(cc.p(display.width/2, display.height - 100))
    self:addChild(self._titleText)

    -- 下一个按钮
    local nextBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    nextBtn:setPosition(cc.p(display.width/2, 100))
    nextBtn:setTitleFontSize(20)
    nextBtn:setTitleColor(cc.c3b(0,0,0))
    nextBtn:setTitleText("Next")
    nextBtn:addTouchEventListener(handler(self, self._onClickNextEvent))
    self:addChild(nextBtn)

    -- 返回按钮
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(display.width - 30, 30))
    backBtn:setTitleFontSize(18)
    backBtn:setTitleColor(cc.c3b(0,0,0))
    backBtn:setTitleText("返 回")
    backBtn:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then 
            self:removeFromParent()
        end 
    end)
    self:addChild(backBtn)

    self:_onClickNextEvent(nextBtn, ccui.TouchEventType.ended)
end 

function EffectTest:onExit()
    if self._thunderScheduler ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._thunderScheduler)
        self._thunderScheduler = nil
    end
end 

function EffectTest:_onClickNextEvent(sender, eventType)
    if eventType ~= ccui.TouchEventType.ended then 
        return 
    end 
    
    -- 判定数目
    local PLAY_NUM = 5
    if self._playIndex < PLAY_NUM then 
        self._playIndex = self._playIndex + 1
    else 
        self._playIndex = 1
    end 
    -- 判定是否子节点不为空
    if self:getChildByTag(1000) ~= nil then 
        self:removeChildByTag(1000)
    end 

    if self._playIndex == 1 then 
        self._titleText:setString("通过 ParticleSystemQuad 手动创建的粒子效果")
        self:_initCustomParticle() 
    elseif self._playIndex == 2 then 
        self._titleText:setString("使用cocos2d自带的ParticleSnow，还有其它...")
        self:_initSnow() 
    elseif self._playIndex == 3 then
        self._titleText:setString("使用plist粒子文件创建")
        self:_initGraph() 
    elseif self._playIndex == 4 then  
        self._titleText:setString("action动画，随机播放4种")
        self:_initThunderAni()
    elseif self._playIndex == 5 then 
        self._titleText:setString("使用cocos2d自带的ParticleSnow修改")
        self:_initRain() 
    end 
end 

-- 通过 ParticleSystemQuad 手动创建的粒子示例
function EffectTest:_initCustomParticle()
    -- 缓存纹理
    local texture = cc.Director:getInstance():getTextureCache():addImage("effect/stars.png")

    -- 创建粒子数目
    local emitter = cc.ParticleSystemQuad:createWithTotalParticles(1000)
    self:addChild(emitter, 10, 1000)

    -- 设置纹理
    emitter:setTexture(texture)

    -- 设置粒子持续时间
    emitter:setDuration(-1)

    -- 设置重力方向
    emitter:setGravity(cc.p(0,0))

    -- 设置角度，角度变化率
    emitter:setAngle(0)
    emitter:setAngleVar(360)

    -- 设置径向加速度，径向加速度变化率 
    emitter:setRadialAccel(70)
    emitter:setRadialAccelVar(10)

    -- 设置切向加速度，切向加速度变化率 
    emitter:setTangentialAccel(80)
    emitter:setTangentialAccelVar(0)

    -- 设置运动速度，运动速度变化率
    emitter:setSpeed(50)
    emitter:setSpeedVar(10)

    -- 设置粒子位置，粒子位置变化率
    emitter:setPosition(display.width/2, display.height/2)
    emitter:setPosVar(cc.p(0, 0))

    -- 设置粒子存在时间，存在时间变化率 
    emitter:setLife(2.0)
    emitter:setLifeVar(0.3)

    -- -- 设置每秒产生的粒子数目： 每秒产生的粒子数 = 粒子总数 / 存活时间
    emitter:setEmissionRate(emitter:getTotalParticles() / emitter:getLife())

    -- 设置粒子开始时候颜色，粒子开始时颜色变化率
	emitter:setStartColor(cc.c4f(0.5, 0.5, 0.5, 1.0))
    emitter:setStartColorVar(cc.c4f(0.5, 0.5, 0.5, 1.0))

    -- 设置粒子结束时候颜色，粒子结束时颜色变化率 
    emitter:setEndColor(cc.c4f(0.1, 0.1, 0.1, 0.2))
    emitter:setEndColorVar(cc.c4f(0.1, 0.1, 0.1, 0.2))

    -- 设置粒子开始时候大小，粒子开始时大小变化率 
    emitter:setStartSize(1.0)
    emitter:setStartSizeVar(1.0)

    -- 设置粒子结束时候大小，粒子结束时大小变化率 
    emitter:setEndSize(32.0)
    emitter:setEndSizeVar(8.0)

    -- additive
    emitter:setBlendAdditive(false)
end 

-- 初始化雪
function EffectTest:_initSnow()
    --[[
    通过cocos2d 自带的 粒子系统创建， 其它的还有:
        ParticleExplosion:爆炸粒子效果
        ParticleFireworks:烟花粒子效果
        CCParticleFire:火焰粒子效果
        CCParticleFlower:花束粒子效果
        CCParticleGalaxy:星系粒子效果  
        CCParticleMeteor:流星粒子效果
        ParticleSpiral:漩涡粒子效果
        ParticleSnow:雪粒子效果
        ParticleSmoke:烟粒子效果
        ParticleSun:太阳粒子效果
        ParticleRain:雨粒子效果 
    ]]
    local texture = cc.Director:getInstance():getTextureCache():addImage("effect/snow.png")

    local emitter = cc.ParticleSnow:create()
    emitter:setPosition(cc.p(display.width/2, display.height))
    emitter:setTexture(texture)
    self:addChild(emitter, 10, 1000)
    
    -- 设置粒子存在时间及存在时间变化率
    emitter:setLife(3)
    emitter:setLifeVar(1)

    -- 设置重力方向
    emitter:setGravity(cc.p(0, -10))

    -- 设置运动速度及运动速度变化率
    emitter:setSpeed(130)
    emitter:setSpeedVar(30)

    -- 设置粒子开始时候的颜色
    local startColor = emitter:getStartColor()
    startColor.r, startColor.g, startColor.b = 0.9, 0.9, 0.9
    emitter:setStartColor(startColor)
    -- 设置粒子开始时的颜色变化率
    local startColorVar = emitter:getStartColorVar()
    startColorVar.b = 0.1
    emitter:setStartColorVar(startColorVar)
    -- 设置每秒产生的粒子数目： 每秒产生的粒子数 = 粒子总数 / 存活时间
    emitter:setEmissionRate(emitter:getTotalParticles() / emitter:getLife())
end 

-- 初始化图形特效
function EffectTest:_initGraph()
    --[[
    使用.plist 文件加载粒子是最常用也最灵活的方式，其文件内容包含了相关的参数数据以及图片的存储等
    线上工具： http://www.effecthub.com/particle2dx
    ]]
    local emitter = cc.ParticleSystemQuad:create("effect/particle_graph.plist")
    -- 设置发射粒子的位置
    emitter:setPosition(cc.p(display.width/2, 0))
    -- 完成后移除
    emitter:setAutoRemoveOnFinish(true)
    -- 设置粒子持续的时间秒数
    emitter:setDuration(10)
    self:addChild(emitter, 10, 1000)
end 

-- 初始化雷电动画
function EffectTest:_initThunderAni()
    math.newrandomseed()

    local randIndex = math.random(1, 4)
    local strName = string.format("effect/thunder/thunder_%d.png", randIndex)
    print(randIndex)
    local thunderSpr = cc.Sprite:create(strName)
    thunderSpr:setScale(0.8)
    thunderSpr:setOpacity(100)
    local size = thunderSpr:getContentSize()
    thunderSpr:setPosition(display.center)
    self:addChild(thunderSpr, 10, 1000)

    local action1 = cc.FadeIn:create(0.5)           -- 渐现
    local action2 = cc.Blink:create(1.0, 5)         -- 闪烁
    local action3 = cc.FadeOut:create(1)            -- 渐隐
    local action = cc.Sequence:create(action0, action1,action2, action3)
    thunderSpr:runAction(action)
end 

-- 初始化雨
function EffectTest:_initRain()
    local texture = cc.Director:getInstance():getTextureCache():addImage("effect/rain.png")

    local emitter = cc.ParticleSnow:create()
    emitter:setPosition(cc.p(display.width/2, display.height))
    emitter:setTexture(texture)
    self:addChild(emitter, 10, 1000)
    
    -- 设置粒子存在时间及存在时间变化率
    emitter:setLife(4)
    emitter:setLifeVar(1)

    -- 设置重力方向
    emitter:setGravity(cc.p(-10, -50))

    -- 设置运动速度及运动速度变化率
    emitter:setSpeed(130)
    emitter:setSpeedVar(30)

    -- 设置每秒产生的粒子数目： 每秒产生的粒子数 = 粒子总数 / 存活时间
    emitter:setEmissionRate(emitter:getTotalParticles() / emitter:getLife())
end 

return EffectTest

