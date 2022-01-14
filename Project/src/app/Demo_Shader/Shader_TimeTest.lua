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

local fragment = [[  
    #ifdef GL_ES
    varying lowp vec4 v_fragmentColor;
    varying mediump vec2 v_texCoord;
    #else
    varying vec4 v_fragmentColor;
    varying vec2 v_texCoord;
    #endif
    
    void main()
    {
        vec4 textColor = texture2D(CC_Texture0, v_texCoord);
        /*
        CC_Time 赋值为time/10.0, time, time*2, time*4
        CC_SinTime 赋值为time/8.0, time/4.0, time/2.0, sinf(time)
        CC_CosTime 赋值为time/8.0, time/4.0, time/2.0, cosf(time)
        */
        // 根据时间控制颜色的变化
        gl_FragColor = textColor * CC_SinTime.x;
        gl_FragColor.a = textColor.a;
    } 
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_TimeTest = class("Shader_TimeTest", BaseLayer)

function Shader_TimeTest:show() 
    self:setTitleName("时间效果")

    local programState = self:getProgramState("time", vertex, fragment)
    self._compareSprite:setGLProgramState(programState)
end 

return Shader_TimeTest
