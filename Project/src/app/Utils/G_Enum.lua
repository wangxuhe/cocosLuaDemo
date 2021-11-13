
--[[
-- 创建新的环境newgt
local newgt = {}
-- newgt 继承了原有的 _G 的环境变量 
-- 这样任何新的赋值操作可在 newgt 中进行，不用担心误操作了全局变量表
setmetatable(newgt, {__index = _G})
setfenv(1, newgt)
]]

cc.exports.Res = {
    -- 默认按钮
    BTN_N = "Default/Button_Normal.png",
    BTN_P = "Default/Button_Press.png",
    BTN_D = "Default/Button_Disable.png",
    -- 
    CLOSE_IMG = "Default/close.png",
    --
    LOGO = "Default/cocos_logo.png",
    STEAK = "Default/streak.png",
    STAR = "effect/stars.png",

    MAN = "Default/grossini.png",
}





return true