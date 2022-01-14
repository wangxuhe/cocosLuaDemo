--[[
卡通渲染， 一种去真实感的渲染方法， 生成的图像呈现手绘的效果
渲染过程中一般会把常规光源的取值被逐一计算并投射到一小片独立的明暗区域上，产生卡通式的单调色彩；
然后会有一个勾边的过程，用于突出物体
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
    #define FILTER_SIZE 2
    #define COLOR_LEVELS 7.0
    #define EDGE_FILTER_SIZE 2
    #define EDGE_THRESHOLD 0.05

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

    vec2 resolution;
    
    vec4 edgeFilter(in int px, in int py)
    {
        vec4 color = vec4(0.0);
        for (int y = -EDGE_FILTER_SIZE; y <= EDGE_FILTER_SIZE; ++y)
        {
            for (int x = -EDGE_FILTER_SIZE; x <= EDGE_FILTER_SIZE; ++x)
            {
                color += texture2D(CC_Texture0, v_texCoord +vec2(px + x, py + y) / resolution.xy);
            }
        }
        color /= float((2 * EDGE_FILTER_SIZE +1) * (2 * EDGE_FILTER_SIZE +1));
        return color;
    }
    
    void main(void)
    {
        // Shade
        resolution = vec2(1024.0,768.0);
        vec4 color =vec4(0.0);
        for (int y = -FILTER_SIZE; y <= FILTER_SIZE; ++y)
        {
            for (int x = -FILTER_SIZE; x <= FILTER_SIZE; ++x)
            {
                color +=texture2D(CC_Texture0, v_texCoord +vec2(x, y) / resolution.xy);
            }
        }

        color /= float((2 * FILTER_SIZE +1) * (2 * FILTER_SIZE +1));
        for (int c =0; c <3; ++c)
        {
            color[c] =floor(COLOR_LEVELS * color[c]) / COLOR_LEVELS;
        }

        // Highlight edges
        vec4 sum =abs(edgeFilter(0,1) - edgeFilter(0,-1));
        sum += abs(edgeFilter(1,0) - edgeFilter(-1,0));
        sum /= 2.0;

        if (length(sum) > EDGE_THRESHOLD)
        {
            color.rgb =vec3(0.0);
        }
        gl_FragColor = color;
    }
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_Cartoon = class("Shader_Cartoon", BaseLayer)

function Shader_Cartoon:show() 
    self:setTitleName("卡通渲染效果")

    self._normalSprite:setScale(3)
    self._compareSprite:setScale(3)

    local programState = self:getProgramState("Cartoon", vertex, fragment)
    self._compareSprite:setGLProgramState(programState)
end 

return Shader_Cartoon
