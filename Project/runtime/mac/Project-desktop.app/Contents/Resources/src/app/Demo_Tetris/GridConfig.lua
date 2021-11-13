--[[
图形配置表
    每个图形的二维图数据为 4 * 4,若为1，表示存在格子，若为0，则不存在
]]

local gridConfig = {}

-- 图形数据
local typeTab = { 
    -- 条相关  
    [1] = {
        gridTab = {             -- 二维数组格子数据，为1表示实心
            {1,1,1,1},
            {0,0,0,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 1,        -- 最大有效行，用于计算格子在地图中的行数
        maxGridCol = 4,         -- 最大有效列，用于计算格子在地图中的列数
        startCol = 4,           -- 地图的起始列位置
        type = 1,               -- 方块类型，与索引相对应
        img = "tetris/1.png",   -- 对应的格子图片
    },
    [2] = {
        gridTab = { 
            {1,0,0,0},
            {1,0,0,0},
            {1,0,0,0},
            {1,0,0,0},
        },
        maxGridLine = 4, 
        maxGridCol = 1,
        startCol = 5,
        type = 2,
        img = "tetris/2.png",
    },
    -- 方块相关
    [3] = {
        gridTab = {
            {1,1,0,0},
            {1,1,0,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 2,
        startCol = 5, 
        type = 3,
        img = "tetris/19.png", 
    },
    -- 左7相关
    [4] = {
        gridTab = { 
            {1,1,0,0},
            {0,1,0,0},
            {0,1,0,0},
            {0,0,0,0},
        },
        maxGridLine = 3,
        maxGridCol = 2,
        startCol = 5, 
        type = 4,
        img = "tetris/10.png", 
    },
    [5] = {
        gridTab = { 
            {0,0,1,0},
            {1,1,1,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 3,
        startCol = 4, 
        type = 5,
        img = "tetris/7.png", 
    },
    [6] = {
        gridTab = { 
            {1,0,0,0},
            {1,0,0,0},
            {1,1,0,0},
            {0,0,0,0},
        },
        maxGridLine = 3,
        maxGridCol = 2,
        startCol = 5, 
        type = 6,
        img = "tetris/8.png", 
    },
    [7] = {
        gridTab = { 
            {1,1,1,0},
            {1,0,0,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 3,
        startCol = 4, 
        type = 7,
        img = "tetris/9.png", 
    },
    -- 右7相关
    [8] = {
        gridTab = { 
            {1,1,0,0},
            {1,0,0,0},
            {1,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 3,
        maxGridCol = 2,
        startCol = 5, 
        type = 8,
        img = "tetris/4.png", 
    },
    [9] = {
        gridTab = { 
            {1,1,1,0},
            {0,0,1,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 3,
        startCol = 4, 
        type = 9,
        img = "tetris/5.png", 
    },
    [10] = {
        gridTab = { 
            {0,1,0,0},
            {0,1,0,0},
            {1,1,0,0},
            {0,0,0,0},
        },
        maxGridLine = 3,
        maxGridCol = 2,
        startCol = 5, 
        type = 10,
        img = "tetris/6.png", 
    },
    [11] = {
        gridTab = { 
            {1,0,0,0},
            {1,1,1,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 3,
        startCol = 4, 
        type = 11,
        img = "tetris/3.png", 
    },

    -- 正Z相关
    [12] = {
        gridTab = {             
            {1,1,0,0},
            {0,1,1,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 3,
        startCol = 4,
        type = 12,
        img = "tetris/13.png",
    },
    [13] = {
        gridTab = {             
            {0,1,0,0},
            {1,1,0,0},
            {1,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 3,
        maxGridCol = 2,
        startCol = 5,
        type = 13,
        img = "tetris/14.png",
    },

    -- 反Z相关
    [14] = {
        gridTab = {             
            {0,1,1,0},
            {1,1,0,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 3,
        startCol = 4,
        type = 14,
        img = "tetris/11.png",
    },
    [15] = {
        gridTab = {             
            {1,0,0,0},
            {1,1,0,0},
            {0,1,0,0},
            {0,0,0,0},
        },
        maxGridLine = 3,
        maxGridCol = 2,
        startCol = 5,
        type = 15,
        img = "tetris/12.png",
    },

    -- 土相关
    [16] = {
        gridTab = {
            {0,1,0,0},
            {1,1,1,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 3,
        startCol = 4,
        type = 16,
        img = "tetris/15.png", 
    },
    [17] = {
        gridTab = {
            {1,0,0,0},
            {1,1,0,0},
            {1,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 3,
        maxGridCol = 2,
        startCol = 5,
        type = 17,
        img = "tetris/16.png", 
    },
    [18] = {
        gridTab = {
            {1,1,1,0},
            {0,1,0,0},
            {0,0,0,0},
            {0,0,0,0},
        },
        maxGridLine = 2,
        maxGridCol = 3,
        startCol = 4,
        type = 18,
        img = "tetris/17.png", 
    },
    [19] = {
        gridTab = {
            {0,1,0,0},
            {1,1,0,0},
            {0,1,0,0},
            {0,0,0,0},
        },
        maxGridLine = 3,
        maxGridCol = 2,
        startCol = 4,
        type = 19,
        img = "tetris/18.png", 
    },
}

-- 图形数目
local GRID_NUM = #typeTab

-- 随机获取方块类型
function gridConfig.getNewGridData()
    math.newrandomseed()
    local index = math.floor(math.random(1,GRID_NUM))
    return typeTab[index]
end 

-- 获取下一个类型的数据
function gridConfig.getNextGridData(curType)
    -- 方块类型无须变换
    if curType == 3 then 
        return 
    end 

    -- 格子种类列表
    local typeList = {
        [1] = {1,2},            -- 条相关
        [2] = {4,5,6,7},        -- 7相关
        [3] = {8,9,10,11}, 
        [4] = {12,13},          -- Z相关          
        [5] = {14,15},
        [6] = {16,17,18,19},    -- 土相关
    }

    -- 筛选当前类型是哪个种类中
    local index = 1         -- 种类索引
    local newtab = {}
    for _, tab in pairs(typeList) do 
        for i, _type in ipairs(tab) do 
            if _type == curType then 
                index = i 
                newtab = tab
                break 
            end 
        end 
    end 

    -- 获取下一个类型，依次累加，若超过最大值，从1开始
    if index < #newtab then 
        index = index + 1
    else 
        index = 1
    end 
    -- 获取类型数据
    local nextType = newtab[index]
    return typeTab[nextType]
end 

return gridConfig