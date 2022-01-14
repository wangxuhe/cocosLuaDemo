--[[
石刻效果
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

    vec4 composite(vec4 upColor, vec4 downColor)
    {
        return upColor + (1.0 - upColor.a) * downColor;
    }
    
    void main()
    {
        vec2 offset = vec2(0.05, 0.0);
        float opacity = 0.5;
        float alpha = texture2D(CC_Texture0, v_texCoord).a;

        vec4 textureColor = texture2D(CC_Texture0, v_texCoord + offset);
        vec4 shadowColor = vec4(0, 0, 0, alpha * opacity);
        gl_FragColor = composite(textureColor, shadowColor);
    } 
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_ShadowTest = class("Shader_ShadowTest", BaseLayer)

function Shader_ShadowTest:show() 
    self:setTitleName("阴影效果")

    local programState = self:getProgramState("Cool", vertex, fragment)
    self._compareSprite:setGLProgramState(programState)
end 

return Shader_ShadowTest
