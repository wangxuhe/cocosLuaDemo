
local NumUtil = {}

local NumUtil = {}

local PHONETYPE = {
    WIN = 1,
    NOTNUM = 2,         -- 非数字
    SHORT = 3,          -- 缺少位数
    NOMATCH = 4,        -- 不匹配

}
NumUtil.PHONETYPE = PHONETYPE

--[[
检测手机号码,有效的11位手机号码，简要说明下：
前三位: 网络识别号，比如移动，联通，电信，号码区段如下：
    电信：133,149,153,173,177,180,181,189,191,199
    联通：130,131,132,145,155,156,166,171,175,176,185,186
    移动：134,135,136,137,138,139,147,150,151,152,157,158,159,172,178,182,183,184,187,188,198
中间四位: 地区编码，每位的范围为[0,9]
最后四位：MDN号码，即用户被叫时，主叫用户所需拨打的号码，每位的范围为[0,9]
]]
local function checkPhone(strNum)
    -- 检测是否为数字
    if tonumber(strNum) == nil then 
        return NumUtil.PHONETYPE.NOTNUM 
    end 

    -- 去除两侧空格
    strNum = string.trim(strNum)
    if #strNum ~= 11 then 
        return NumUtil.PHONETYPE.SHORT 
    end 

    -- 是否匹配
    local isMatch = string.match(strNum,"[1][3,4,5,7,8,9]%d%d%d%d%d%d%d%d%d") == strNum
    if not isMatch then 
        return 
    end 
    return NumUtil.PHONETYPE.WIN
end 

-- 检测邮箱
-- do something

-- 检测微信号