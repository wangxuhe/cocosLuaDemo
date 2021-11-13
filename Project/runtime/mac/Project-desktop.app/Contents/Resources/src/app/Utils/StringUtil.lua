
local StringUtil = {}

-- 字符串保存到table
local function stringToTable(s)
    local tb = {}

    --[[
    UTF8的编码规则：
    1. 字符的第一个字节范围： 0x00—0x7F(0-127),或者 0xC2—0xF4(194-244);
        UTF8 是兼容 ascii 的，所以 0~127 就和 ascii 完全一致
    2. 0xC0, 0xC1,0xF5—0xFF(192, 193 和 245-255)不会出现在UTF8编码中
    3. 0x80—0xBF(128-191)只会出现在第二个及随后的编码中(针对多字节编码，如汉字)
    ]]
    for utfChar in string.gmatch(s, "[%z\1-\127\194-\244][\128-\191]*") do
        table.insert(tb, utfChar)
    end

    return tb
end
StringUtil.stringToTable = stringToTable

-- 获取字符串长度,英文字符为一个单位长, 中文字符为2个单位长
local function getUTFLen(s)
    local sTable = StringUtil.stringToTable(s)
    local len = 0
    local charLen = 0

    for i=1,#sTable do
        local utfCharLen = string.len(sTable[i])
        -- 长度大于1可认为为中文
        if utfCharLen > 1 then
            charLen = 2 
        else
            charLen = 1
        end
        -- charLen = 1
        len = len + charLen
    end

    return len
end
StringUtil.getUTFLen = getUTFLen

-- 获取字符串长度,中文，英文均为一个字符为1单位长
local function getNewUTFLen(s)
    local sTable = StringUtil.stringToTable(s)
    local len = 0
    local charLen = 0

    for i = 1, #sTable do
        local utfCharLen = string.len(sTable[i])
        if utfCharLen > 1 then
            charLen = 1         -- 修改为1
        else
            charLen = 1
        end

        len = len + charLen
    end

    return len
end
StringUtil.getNewUTFLen = getNewUTFLen

return StringUtil