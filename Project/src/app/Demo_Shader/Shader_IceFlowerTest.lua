--[[
冰花效果， 原理是根据一个随机的向量平移像素的位置
]]
-- 顶点shader  
local vertex = [[  
    attribute vec4 a_position;
    attribute vec2 a_texCoord;
    attribute vec4 a_color;
    #ifdef GL_ES
    varying lowp vec4 v_fragmentColor;
    varying mediump vec2 v_texCoord;
    #else
    varying vec4 v_fragmentColor;
    varying vec2 v_texCoord;
    #endif
    void main()
    {
        gl_Position = CC_PMatrix * a_position;
        v_fragmentColor = a_color;
        v_texCoord = a_texCoord;
    }
]]  

-- 片段shader  
local fragment= [[  
    #ifdef GL_ES
    precision mediump float;
    #endif
    #ifdef GL_ES
    varying lowp vec4 v_fragmentColor;
    varying mediump vec2 v_texCoord;
    #else
    varying vec4 v_fragmentColor;
    varying vec2 v_texCoord;
    #endif

    float rand(vec2 co)
    {
        return fract(sin(dot(co.xy ,vec2(100,100))) + cos(dot(co.xy ,vec2(50,50))) *5.0);
    }
    
    void main()
    {
        vec2 rnd = vec2(0.0);
        rnd = vec2(rand(v_texCoord),rand(v_texCoord));   
        gl_FragColor = texture2D(CC_Texture0, v_texCoord+rnd*0.02);
    } 
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_IceFlower = class("Shader_IceFlower", BaseLayer)


function Shader_IceFlower:show() 
    self:setTitleName("冰花效果")

    self._normalSprite:setScale(3)
    self._compareSprite:setScale(3)

    local programState = self:getProgramState("IceFlower", vertex, fragment)
    self._compareSprite:setGLProgramState(programState)
end 

return Shader_IceFlower
