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
    precision mediump float;  // shader默认精度为double，openGL为了提升渲染效率将精度设为float  
    #endif 

    varying vec4 v_fragmentColor;  // 片段颜色  
    varying vec2 v_texCoord;       // 坐标  

    uniform vec3 u_grayColor;
    void main(void)   
    {   
        // texture2D方法从采样器中进行纹理采样，得到当前片段的颜色值
        vec4 c = texture2D(CC_Texture0, v_texCoord);   
         
        // gl_FragColor当前片段的颜色  
        float gray = dot(c.rgb, u_grayColor);  
        gl_FragColor.xyz = vec3(gray);   
        gl_FragColor.a = c.a;   
    }  
]]

local BaseLayer = require("app.Demo_Shader.BaseLayer")
local Shader_GrayTest = class("Shader_GrayTest", BaseLayer)

function Shader_GrayTest:show() 
    self._titleText:setString("Shader 置灰效果")

    local compareSpr = self._compareSprite
    if not compareSpr then 
        return 
    end 

    local program = cc.GLProgram:createWithByteArrays(vertex , fragment)
    local programState = cc.GLProgramState:create(program)
    programState:setUniformVec3("u_grayColor", cc.vec3(0.2, 0.5, 0.1))
    compareSpr:setGLProgram(program)
    compareSpr:setGLProgramState(programState)
end 

return Shader_GrayTest
