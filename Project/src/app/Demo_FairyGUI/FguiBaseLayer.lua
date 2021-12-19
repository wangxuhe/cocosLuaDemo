--[[
Desc:   FairyGUI 示例基类
]]

local FguiBaseLayer = class("FguiBaseLayer")

function FguiBaseLayer:ctor() 
    -- 
end 

-- 创建view 
function FguiBaseLayer:createFguiView(pkgName, componentName)
    local curScene = display.getRunningScene()
    local gRoot = fairygui.GRoot:create(curScene)
    gRoot:retain()

    -- view相关
    local view = fairygui.UIPackage:createObject(pkgName, componentName)
    if tolua.isnull(view) then 
        local str = string.format("Error: createFguiView failed, the pkgName:%s, the componentName:%s", pkgName, componentName)
        assert(false, str)
        return 
    end 
    gRoot:addChild(view)

    -- 返回按钮
    local backBtn = view:getChild("backBtn")
    backBtn:addEventListener(fairygui.UIEventType.Click, function(context)
        view:removeFromParent()
    end)
    return view 
end 

return FguiBaseLayer
