--[[
彩色横条效果
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
    precision lowp float;
    #endif
    #ifdef GL_ES
    varying lowp vec4 v_fragmentColor;
    varying mediump vec2 v_texCoord;
    #else
    varying vec4 v_fragmentColor;
    varying vec2 v_texCoord;
    #endif
    
    vec4 colors[8];
    
    void main()
    {
        colors[0] = vec4(1, 0, 0, 1);
        colors[1] = vec4(0, 1, 0, 1);
        colors[2] = vec4(0, 0, 1, 1);
        colors[3] = vec4(0, 1, 1, 1);
        colors[4] = vec4(1, 0, 1, 1);
        colors[5] = vec4(1, 1, 0, 1);
        colors[6] = vec4(1, 1, 1, 1);
        colors[7] = vec4(0, 0, 0, 1);
        // 使用gl_FragCoord.x表示竖向效果; 使用gl_FragCoord.y表示横向效果
        int y = int(mod(gl_FragCoord.x/3.0, 8.0));          
        gl_FragColor = colors[y] * texture2D(CC_Texture0, v_texCoord);
    } 
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_ColoursTest = class("Shader_ColoursTest", BaseLayer)


function Shader_ColoursTest:show() 
    self:setTitleName("彩色横条效果")
    local node = self._compareSprite
    if not node then 
        return 
    end 

    local programState = self:getProgramState("Colours", vertex, fragment)
    node:setGLProgramState(programState)
end 

return Shader_ColoursTest
