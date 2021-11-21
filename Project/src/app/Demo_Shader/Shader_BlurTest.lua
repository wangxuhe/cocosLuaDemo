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
        // gl_Position表示当前位置
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

    varying vec4 v_fragmentColor;  
    varying vec2 v_texCoord;

    uniform float limit;
    uniform vec2 my_size;
    void main(void)   
    {   
        vec2 unit = 1.0/my_size.xy;
        float r = limit;
        float step = r/2.0;
        float totalWeight = 0.0;
        vec4 all = vec4(0);

        for(float i = -r; i < r; i += step)
        {
            for(float j = -r; j < r; j += step)
            {
                float weight = (r - abs(i)) * (r - abs(j));
                all += texture2D(CC_Texture0, v_texCoord + vec2(i * unit.x, j * unit.y)) * weight;
                totalWeight += weight;
            }
            gl_FragColor = all /totalWeight;
        }
    }  
]]

local BaseLayer = require("app.Demo_Shader.BaseLayer")
local Shader_GrayTest = class("Shader_GrayTest", BaseLayer)

function Shader_GrayTest:show() 
    self._titleText:setString("Shader 模糊效果")

    local compareSpr = self._compareSprite
    if not compareSpr then 
        return 
    end 

    local pixelSize = compareSpr:getTexture():getContentSizeInPixels()

    local program = cc.GLProgram:createWithByteArrays(vertex , fragment)
    local programState = cc.GLProgramState:create(program)
    programState:setUniformFloat("limit", 10)
    programState:setUniformVec2("my_size", cc.p(pixelSize.width, pixelSize.height))
    compareSpr:setGLProgram(program)
    compareSpr:setGLProgramState(programState)
end 

return Shader_GrayTest
