--[[
Desc:   树示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_Tree = class("Demo_Tree", BaseLayer)

function Demo_Tree:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_Tree")

    ------------------ UI构建 ------------------
    local tree1 = view:getChild("tree_1")
    -- 使用回调渲染，前提是节点已经添加到树中
    tree1.treeNodeRender = function(treeNode, component)
        local isFolder = treeNode:isFolder() 
        if isFolder then 
            component:setTitle("主页签")
        else 
            component:setTitle("次页签")
        end 
    end 
    tree1:addEventListener(fairygui.UIEventType.ClickItem, function(context)
        local treeNode = context:getData():treeNode()
        local isFolder = treeNode:isFolder()
        if isFolder then 
            print("点击了主页签")
        else 
            print("点击了次页签")
        end 
    end)

    ------------------ 动态构建 ------------------
    local urls = {
        [1] = "ui://Basic/listitem_3",    -- 主页签
        [2] = "ui://Basic/listitem_2",    -- 次页签
    }

    local tree = view:getChild("tree_2")
    -- 获取树的根节点，它是不可见的
    local rootNode = tree:getRootNode()

    --[[
    @ func: 用于树列表展开或缩放时使用，可增加或减少页签
    @ param: treeNode 树节点
    @ param: isExpand 是否展开
    ]]
    tree.treeNodeWillExpand = function(treeNode, isExpand)
        local isFolder = treeNode:isFolder()
        if isExpand then 
            print("展开...")
        else 
            print("收回...")
        end 
    end 
    tree:addEventListener(fairygui.UIEventType.ClickItem, function(context)
        local selIndex = tree:getSelectedIndex()
        print("页签索引:", selIndex)
    end)

    -- 每级主页签下的子页签数目
    local datas = {0, 2, 1}                 
    for i = 1, #datas do 
        -- 创建主页签, 节点放置到根节点中
        local treeNode = fairygui.GTreeNode:create(true, urls[1])
        rootNode:addChild(treeNode)
        -- 设置主页签是否打开,必须在addChild之后才能使用
        treeNode:setExpaned(true)
        -- 设置标题
        treeNode:getCell():setTitle("主页签" .. i)

        -- 创建子页签,节点在主页签中放置
        local num = datas[i]
        if num ~= 0 then 
            for j = 1, num do 
                local node = fairygui.GTreeNode:create(false, urls[2])
                treeNode:addChild(node)

                node:getCell():setTitle("次页签" .. j)
            end 
        end 
    end 
end 

return Demo_Tree