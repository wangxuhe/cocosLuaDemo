--[[
Desc:   普通列表， 多选列表，多样列表示例
]]

local BaseLayer = require("app.Demo_FairyGUI.FguiBaseLayer")
local Demo_List = class("Demo_List", BaseLayer)

function Demo_List:Show() 
    fairygui.UIPackage:addPackage("fgui/Basic")

    local view = self:createFguiView("Basic", "Demo_List")

    ------------------ 普通列表 ------------------
    local itemNum = 500             -- item数目
    local normalList = view:getChild("list_1")
    -- 设置item绘制(索引从0开始)
    normalList.itemRenderer = function(index, item)
        item:setTitle("标题...." .. index)
    end 
    -- 开启列表虚拟功能
    normalList:setVirtual()
    -- 设置列表数目
    normalList:setNumItems(itemNum)
    normalList:addEventListener(fairygui.UIEventType.ClickItem, function(context)
        -- 获取列表选择索引(索引从0开始)
        local selIndex = normalList:getSelectedIndex()
        print("normalList 点击索引为:", selIndex)
    end)
    normalList:addEventListener(fairygui.UIEventType.PullUpRelease, function()
        print("上拉刷新回调")
    end)
    normalList:addEventListener(fairygui.UIEventType.PullDownRelease, function()
        print("下拉刷新回调")
    end)

    -- 获取列表内的滚动容器
    local scrollPane = normalList:getScrollPane()
    -- 设置是否可滚动
    local isTouch = (itemNum > 5) and true or false 
    scrollPane:setTouchEffect(isTouch)

    -- 置顶
    local topBtn = view:getChild("topBtn")
    topBtn:addEventListener(fairygui.UIEventType.Click, function()
        scrollPane:scrollTop()
    end)
    -- 置底
    local downBtn = view:getChild("downBtn")
    downBtn:addEventListener(fairygui.UIEventType.Click, function()
        scrollPane:scrollBottom()
    end)
    -- 滚动到指定索引位置
    local sureBtn = view:getChild("sureBtn")
    local inputText = view:getChild("inputText")
    sureBtn:addEventListener(fairygui.UIEventType.Click, function()
        local index = tonumber(inputText:getText())
        if not index then return end 
        if index < 0 or index >= itemNum then return end 
        normalList:scrollToView(index, false)
    end)

    ------------------ 多选列表 ------------------
    local multiList = view:getChild("list_2")
    multiList.itemRenderer = function(index, item)
        item:setTitle("多选...." .. index)
    end 
    multiList:setVirtual()
    multiList:setNumItems(10)
    multiList:addEventListener(fairygui.UIEventType.ClickItem, function(context)
        -- 获取选项，索引从0开始
        local selections = multiList:getSelection()
        print("selections:", table.concat(selections, ","))     -- selections:	0,2
    end)

    -- 重置
    local resetBtn = view:getChild("resetBtn")
    resetBtn:addEventListener(fairygui.UIEventType.Click, function()
        multiList:clearSelection()
    end)

    -- 全选
    local allBtn = view:getChild("allBtn")
    allBtn:addEventListener(fairygui.UIEventType.Click, function()
        multiList:selectAll()
    end)

    ------------------ 多样列表 ------------------
    local variList = view:getChild("list_3")
    -- 获取不同索引下的url(索引从0开始)
    variList.itemProvider = function(index)
        if index == 1 then 
            return "ui//Common/listitem_2"
        elseif index == 2 then 
            return "ui//Common/radio_btn_1"
        elseif index == 3 then 
            return "ui://a0imyaf1vx0u3s"
        else
            return "ui://Common/listitem_1"
        end  
    end 

    variList.itemRenderer = function(index, item)
        if index == 1 then 
            -- do something
        elseif index == 2 then 
            -- do something
        elseif index == 3 then 
            item:setTitle("选择框标题")
        else 
            local titleText = item:getChild("title")
            titleText:setText("文本标题:" .. index)
        end 
    end 
    variList:setNumItems(5)
    variList:addEventListener(fairygui.UIEventType.ClickItem, function(context)
        local selIndex = variList:getSelectedIndex()
        -- 根据选择索引获取对象索引
        local childIndex = variList:itemIndexToChildIndex(selIndex)
        -- 根据对象索引获取对象
        local child = variList:getChildAt(childIndex)
    end)
end 

return Demo_List