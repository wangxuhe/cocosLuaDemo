--[[
Desc:   文本示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Text = class("Demo_Text", BaseLayer)

function Demo_Text:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Text")

    ------------------ 普通文本 ------------------
    local contents = [[
    这是一个多行文本
    这是一个多行文本
    这是一个多行文本
    这是一个多行文本
    这是一个多行文本
    这是一个多行文本
    ]]
    local normalText = view:getChild("text_1"):getChild("text")
    -- 设置内容
    normalText:setText(contents)

    ------------------ 输入文本 ------------------
    local inputText = view:getChild("inputText")
    -- 设置提示文本
    inputText:setPrompt("[color=#999999]请输入文本[/color]")
    -- 设置最大长度，单个字符和汉字均为1
    inputText:setMaxLength(10)
    -- 设置是否为密码
    inputText:setPassword(false)

    ------------------ 富文本 ------------------
end 

return Demo_Text