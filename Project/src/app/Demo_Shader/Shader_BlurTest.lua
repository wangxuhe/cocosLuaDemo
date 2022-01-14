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
    uniform vec2 resolution;        // 纹理尺寸
    uniform float blurRadius;       // 模糊区域, 数值越大， 效果越模糊
    uniform float sampleNum;        // 采样数
    
    vec4 blur(vec2 p)
    {
        // 检测模糊区域和采样数是否允许模糊处理，否则返回原色
        if (blurRadius <= 0.0 || sampleNum <= 1.0)
        {
            return texture2D(CC_Texture0, p);
        }
        
        // 纹理坐标的范围[0, 1], 1除以纹理尺寸九可以得出像素的单位距离
        vec2 unit = 1.0/resolution.xy;
        
        // 模糊区域除以采样数，得到要遍历的步长
        float r = blurRadius;
        float sampleStep = r / sampleNum;
        vec4 col = vec4(0);
        float count = 0.0;
        // 以当前像素点为中心，遍历指定大小内矩形范围
        for(float x = -r; x < r; x += sampleStep)
        {
            for(float y = -r; y < r; y += sampleStep)
            {
                // 计算权重，越靠边缘权重越小
                float weight = (r - abs(x)) * (r - abs(y));
                // 所有的颜色值*权重并累加
                col += texture2D(CC_Texture0, p + vec2(x * unit.x, y * unit.y)) * weight;
                count += weight;
            }
        }
        // 颜色累加除以权重，返回平均值
        return col / count;
    }
    void main()
    {
        vec4 color = blur(v_texCoord);
        gl_FragColor = vec4(color) * v_fragmentColor;
    } 
]]

local BaseLayer = require("app.Demo_Shader.ShaderBaseLayer")
local Shader_BlurTest = class("Shader_BlurTest", BaseLayer)


function Shader_BlurTest:show() 
    self:setTitleName("模糊效果")
    local node = self._compareSprite
    if not node then 
        return 
    end 

    local size = nil
    if not node.getTexture then
        size = node:getVirtualRenderer():getSprite():getTexture():getContentSizeInPixels()
    else
        size = node:getTexture():getContentSizeInPixels()
    end
    local blurRadius = 4.0
    local sampleNum = 10.0

    local programState = self:getProgramState("blurShader", vertex, fragment)
    programState:setUniformVec2("resolution", cc.vertex2F(size.width, size.height))
    programState:setUniformFloat("blurRadius", blurRadius);
    programState:setUniformFloat("sampleNum", sampleNum);
    node:setGLProgramState(programState)
end 

return Shader_BlurTest
