
local IMG_NAME = "res/Default/elephant.png"

local ShaderBaseLayer = class("ShaderBaseLayer",function()
   return newLayerColor(cc.size(display.width, display.height), {r = 255, g = 255, b = 255, a = 255})
end)

function ShaderBaseLayer:ctor() 
    self:initData() 
    self:initNode()
    self:show()
end 

function ShaderBaseLayer:initData() 
    self._titleText = nil 
    self._normalSprite = nil 
    self._compareSprite = nil 
    self._shaderNames = {}
end 

function ShaderBaseLayer:initNode() 
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

    -- 标题
    local titleText = ccui.Text:create("", "Arial", 30)
    titleText:setPosition(cc.p(display.width/2, display.height*5/6))
    titleText:setColor(cc.c3b(0, 0, 0))
    self:addChild(titleText)
    self._titleText = titleText

    -- 正常图片
    self._normalSprite = cc.Sprite:create(IMG_NAME)
    self._normalSprite:setPosition(cc.p(display.width/4, display.height/2))
    self:addChild(self._normalSprite)

    -- 变色图片
    self._compareSprite = cc.Sprite:create(IMG_NAME)
    self._compareSprite:setPosition(cc.p(display.width*3/4, display.height/2))
    self:addChild(self._compareSprite)
end 

-- 设置标题
function ShaderBaseLayer:setTitleName(str)
    if tolua.isnull(self._titleText) then 
        return 
    end 
    local strTitle = tostring(str) or "shader title"
    self._titleText:setString(strTitle)
end 

--[[
@param shaderName: shader名
@param vertName: 顶点着色器名
@param fragName: 片段着色器名
]]
function ShaderBaseLayer:getProgramState(key, vertName, fragName)
    local program = cc.GLProgramCache:getInstance():getGLProgram(key)
    if not program then 
        program = cc.GLProgram:createWithByteArrays(vertName, fragName)
        assert(program ~= nil, "Error: create GLProgram Failed, key:" .. key)
        cc.GLProgramCache:getInstance():addGLProgram(program, key)
    end 
    local programState = cc.GLProgramState:getOrCreateWithGLProgram(program)
    return programState
end 

return ShaderBaseLayer 
