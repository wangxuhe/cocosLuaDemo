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
    precision mediump float;  // shader默认精度为double，openGL为了提升渲染效率将精度设为float  
    #endif   
    // varying变量为顶点shader经过光栅化阶段的线性插值后传给片段着色器  
    varying vec4 v_fragmentColor;  // 颜色  
    varying vec2 v_texCoord;       // 坐标  
    void main(void)   
    {   
        // texture2D方法从采样器中进行纹理采样，得到当前片段的颜色值。CC_Texture0即为一个采样器  
        vec4 c = texture2D(CC_Texture0, v_texCoord);   
        // c.rgb即是像素点的三种颜色，dot为点乘，vec3为经验值，可以随意修改  
        float gray = dot(c.rgb, vec3(0.299, 0.587, 0.114));   
        // shader的内建变量，表示当前片段的颜色  
        gl_FragColor.xyz = vec3(gray);   
        // a为透明度  
        gl_FragColor.a = c.a;   
    }  
]]

local OpenGLTest = class("OpenGLTest",function()
    return newLayerColor(cc.size(display.width, display.height), 255)
end)

function OpenGLTest:ctor()
    -- 返回按钮
    local backBtn = ccui.Button:create(Res.BTN_N, Res.BTN_P, Res.BTN_D)
    backBtn:setPosition(cc.p(display.width - 30, 30))
    backBtn:setTitleFontSize(18)
    backBtn:setTitleColor(cc.c3b(0,0,0))
    backBtn:setTitleText("返 回")
    backBtn:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then 
            self:removeFromParent()
        end 
    end)
    self:addChild(backBtn)

    --
    local pProgram = cc.GLProgram:createWithByteArrays(vertex , fragment)
    local ballSprite = cc.Sprite:create("res/Default/r1.png")
    ballSprite:setPosition(display.center)
    ballSprite:setGLProgram(pProgram)
    self:addChild(ballSprite,100)
end

return OpenGLTest
