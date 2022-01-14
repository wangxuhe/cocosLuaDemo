
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

    uniform float u_time;               // 刷新时间
    uniform float u_width;              // 流光的宽度
    uniform float u_strength;           // 流光的强度[0,max]
    uniform vec3 u_color;               // 流光颜色
    uniform float u_offset;             // 流光的偏移量
    
    
    void main()
    {
        float startPosX = u_time * 1.2;         // 起始位置坐标
        vec4 src_color = texture2D(CC_Texture0, v_texCoord).rgba;
        if( v_texCoord.x < (startPosX - u_offset * v_texCoord.y) &&  v_texCoord.x > (startPosX - u_offset * v_texCoord.y - u_width))
        {
            vec3 improve = u_strength * u_color;
            vec3 result = improve * vec3(src_color.r, src_color.g, src_color.b);
            gl_FragColor = vec4(result, src_color.a);
        } 
        else 
        {
            gl_FragColor = src_color;
        }
    } 
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_FluxayTest = class("Shader_FluxayTest", BaseLayer)

function Shader_FluxayTest:show() 
    self:setTitleName("流光效果")
    
    local time = 0
    local startTime = os.clock()
    local programState = self:getProgramState("Fluxay", vertex, fragment)
    programState:setUniformFloat("u_width", 0.1)                            -- 流光宽度
    programState:setUniformFloat("u_strength", 1)                           -- 流光宽度
    programState:setUniformFloat("u_offset", 0.2)                           -- 流光偏移量
    programState:setUniformVec3("u_color", cc.vec3(255, 0, 0))              -- 流光颜色

    schedule(self._compareSprite, function()
        if time > 1 then 
            startTime = os.clock()
            time = 0
        else 
            time = os.clock() - startTime
        end 
        programState:setUniformFloat("u_time", time)
    end, 0.01)
    self._compareSprite:setGLProgramState(programState)
end 

return Shader_FluxayTest
