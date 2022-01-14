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
    
    void main()
    {
        vec2 onePixel = vec2(1.0/480.0, 1.0/320.0);

        vec2 texCoord = v_texCoord;

        vec4 color;
        color.rgb = vec3(0.5);
        color -= texture2D(CC_Texture0, texCoord - onePixel) * 5.0;
        color += texture2D(CC_Texture0, texCoord + onePixel) * 5.0;
    
        color.rgb = vec3((color.r + color.g + color.b) / 3.0);
        gl_FragColor = vec4(color.rgb, 1);
    } 
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_CoolTest = class("Shader_CoolTest", BaseLayer)

function Shader_CoolTest:show() 
    self:setTitleName("石刻效果")
    local node = self._compareSprite
    if not node then 
        return 
    end 

    local programState = self:getProgramState("Cool", vertex, fragment)
    node:setGLProgramState(programState)
end 

return Shader_CoolTest
