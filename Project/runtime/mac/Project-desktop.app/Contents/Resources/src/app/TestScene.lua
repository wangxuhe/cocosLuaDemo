-- 
local TetrisTest = require("app.Demo_Tetris.UITetrisMain")
local LolitaTest = require("app.Demo_lolitaParkour.lolitaLoginScene")
local FistFightTest = require("app.Demo_FistFight.Fist_Scene")
local cocosTest = require("app.Demo_Cocos.MainTest")

local config = {
    {title = "cocosTest", layer = cocosTest, state = "Cocos示例Demo", type = "layer"},
    {title = "TetrisTest", layer = TetrisTest, state = "俄罗斯方块", type = "layer"},
    {title = "LolitaTest", layer = LolitaTest, state = "萝莉跑酷", type = "scene"},
    {title = "FistFightTest", layer = FistFightTest, state = "简单的格斗", type = "scene"},
}

local TestScene = class("TestScene", function()
    return cc.Scene:create()
end) 

function TestScene:ctor()
    self._root = cc.CSLoader:createNode("res/csd/UITest.csb")
    self:addChild(self._root)

    -- listView相关
    self._listView = self._root:getChildByName("ListView_1")
    self._listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)             -- 设置方向
    self._listView:setScrollBarEnabled(true)                                  -- 设置滚动条是否显示
    self._listView:setBounceEnabled(true)                                     -- 设置滑动惯性
    self._listView:setItemsMargin(0.1)                                        -- 设置Item间隔
    self._item = self._listView:getChildByName("Image_listTitle")
    self._item:removeFromParent(false)
    for i = 1, #config do 
        local item = self._item:clone()
        item:getChildByName("Text_title"):setString(config[i].title)
        item:getChildByName("Text_State"):setString(config[i].state)
        item:addTouchEventListener(handler(self, self._onLayerEvt))
        item:setTouchEnabled(true)
        item:setTag(i)
        item:setVisible(true)
        self._listView:pushBackCustomItem(item)
    end 

    -- 返回按钮相关
    local backBtn = self._root:getChildByName("Button_Back")
    local btnSize = backBtn:getContentSize()
    backBtn:setPosition(cc.p(display.width - btnSize.width, btnSize.height))
    backBtn:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then 
            cc.Director:getInstance():endToLua()
        end 
    end)
end 

function TestScene:_onLayerEvt(sender,eventType)
    if eventType ~= ccui.TouchEventType.ended then 
        return 
    end 
    local index = sender:getTag()
    local node = config[index].layer:create()
    if tolua.isnull(node) then 
        return 
    end 

    if config[index].type and config[index].type == "scene" then 
        display.runScene(node)
    else 
        self:addChild(node)
    end 
end 

return TestScene 
