-- 格斗主场景

local UIGame = require("app.Demo_FistFight.Fist_Game")
local UIControl = require("app.Demo_FistFight.Fist_Control")


local Fist_Scene = class("Fist_Scene", function()
    return cc.Scene:create()
end)

function Fist_Scene:ctor()
    self._game = nil                -- 游戏相关
    self._control = nil             -- 控制相关
    self._exitBtn = nil             -- 控制按钮

    self:_init()
end 

function Fist_Scene:_init()
    self._game = UIGame.new()
    self:addChild(self._game, 0)

    self._control = UIControl.new(self)
    self:addChild(self._control, 1)

    -- 退出按钮
    local exitBtn = ccui.Button:create(Res.CLOSE_IMG, Res.CLOSE_IMG, Res.CLOSE_IMG)
    exitBtn:setPosition(cc.p(display.width - 30, display.height - 30))
    exitBtn:addTouchEventListener(handler(self, self._onExitEvent))
    self:addChild(exitBtn, 3)
end 

function Fist_Scene:_onExitEvent(sender, event)
    if event ~= ccui.TouchEventType.ended then 
        return 
    end 

    self._game:dispose()
    self._control:dispose()

    -- 替换场景
    local scene = require("app.TestScene"):create()
    display.runScene(scene)
end

-- 获取游戏节点
function Fist_Scene:getGameRoot()
    return self._game
end 

return Fist_Scene