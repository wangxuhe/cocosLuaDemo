require("cocos/init")
require("cocos/framework/init")
require("app.Utils.GlobalRequire")


local MyApp = class("MyApp")
function MyApp:ctor()
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	local customListenerBg = cc.EventListenerCustom:create("APP_ENTER_BACKGROUND_EVENT",
								handler(self, self.onEnterBackground))
	eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
	local customListenerFg = cc.EventListenerCustom:create("APP_ENTER_FOREGROUND_EVENT",
								handler(self, self.onEnterForeground))
	eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)

end

function MyApp:run()
	local loginScene = require("app.TestScene"):create()
    display.runScene(loginScene)
end

function MyApp:onEnterBackground()
	-- 
end

function MyApp:onEnterForeground()
	-- 
end

return MyApp
