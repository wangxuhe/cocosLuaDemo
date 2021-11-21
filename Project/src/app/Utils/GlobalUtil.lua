local winSize = cc.Director:getInstance():getWinSize()

local GlobalUtil = cc.exports.GlobalUtil
GlobalUtil = {
	--
}

-- @func:创建触摸屏蔽层
-- @param: _size 大小
-- @param: _param 层级或颜色
cc.exports.newLayerColor = function(_size, _param)
	local width = _size.width or winSize.width
	local height = _size.height or winSize.height

	local color = cc.c4b(0, 0, 0, 255) 
	if type(_param) == "table" then 
		color = cc.c4b(_param.r, _param.g, _param.b, _param.a)
	end 
	local layer = cc.LayerColor:create(color, width, height)

	local function onTouchBegan(touch, event)
		return true
	end
	local function onTouchEnded(touch, event)
		--
	end 
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	-- 设置触摸吞噬
	listener:setSwallowTouches(true)

	local eventDispatcher = layer:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

	return layer
end

-- @func:触摸注册事件
-- @param: node 注册节点
-- @param: callback 回调接口
-- @param: eventType 事件类型,可为nil
-- @param: scale 缩放, 可为nil
cc.exports.BindTouchEvent = function(register,callback,eventType,scale)
	if tolua.isnull(register) then 
		print("buttonTouchListener failed, the cboj is nill")
		return 
	end 

	-- 设置点击音效
	local soundRes = ""
	if soundRes ~= nil and string.len(soundRes) > 0 then 
		-- do something 
	end 

	-- 设置按钮缩放
	if scale then
		-- 设置按钮开启按下缩放效果
		node:setPressedActionEnabled(true)
		-- 设置按钮缩放
		node:setZoomScale(scale)
	end

	-- 设置回调
	eventType = eventType or ccui.TouchEventType.ended
	local touchEvent = function(sender, event)
		if event == eventType then 
			callback(sender)
		end 
	end 
	register:addTouchEventListener(touchEvent)
end

-- @function: 切换场景
-- @param: _transition 可参考：display.SCENE_TRANSITIONS
-- @param: _time 过渡时间，以秒为单位
cc.exports.ChangeScene = function(_scene, _transition, _time)
	if tolua.isnull(_scene) then 
		error("ERROR: ChangeScene the param _scene is nil")
		return 
	end 

	local runScene = cc.Director:getInstance():getRunningScene()
	runScene:stopAllActions()
	runScene:pause()

	-- 运行场景
	display.runScene(_scene, _transition, _time)
end 

cc.exports.MsgTip = function(_content, _bgRes)
	local root = cc.CSLoader:createNode("res/csd/UIMsgTip.csb")
	local size = root:getContentSize()
    root:setPosition(cc.p((winSize.width-size.width)/2, (winSize.height-size.height)/2))
	local _panel = root:getChildByName("Panel")
	cc.Director:getInstance():getRunningScene():addChild(root, 1000) 

	if _bgRes ~= nil then 
        _panel:getChildByName("Image_1"):setTexture(_bgRes)
    end 
    _panel:getChildByName("Text_1"):setString(_content)
	
	--
	local delay = cc.DelayTime:create(1)
	local fadeout = cc.FadeOut:create(1)
	local move = cc.MoveBy:create(1, cc.p(0, winSize.height))
	-- 动作由慢到快
    local move_ease_out = cc.EaseSineIn:create(move)
	local spawn = cc.Spawn:create(move_ease_out, fadeout)
    local callback = cc.CallFunc:create(function()
        root:removeFromParent()
    end)
    local action = cc.Sequence:create(delay, spawn, callback)
	_panel:runAction(action)
end 

return GlobalUtil
