--
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

--[[
置灰效果：RGB的三个分量的值都相等，值越高越白，反之越黑， 主要方式：
1. 平均值， 三个值相加后取平均值， 然后将平均值赋值给RGB
2. 最大值， 取RGB中最大值，然后赋值
3. 加权平均值， RGB分别乘以应用程序给予的比例计算, 累加后赋值给RGB
]]
local fragment = [[  
    #ifdef GL_ES
    varying lowp vec4 v_fragmentColor;
    varying mediump vec2 v_texCoord;
    #else
    varying vec4 v_fragmentColor;
    varying vec2 v_texCoord;
    #endif
    uniform float u_strength;           // 强度[0~1]
    void main()
    {
        vec4 textColor = texture2D(CC_Texture0, v_texCoord);
        float color = (textColor.r + textColor.g + textColor.b)/3.0 * u_strength;
        gl_FragColor.rgb = vec3(color);
        gl_FragColor.a = textColor.a;
    } 
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_GrayTest = class("Shader_GrayTest", BaseLayer)

function Shader_GrayTest:show() 
    self:setTitleName("置灰效果")

    local node = self._compareSprite
    if not node then 
        return 
    end 

    local programState = self:getProgramState("grayShader", vertex, fragment)
    programState:setUniformFloat("u_strength", 0.8)
    node:setGLProgramState(programState)
end 

return Shader_GrayTest
