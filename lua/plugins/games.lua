return {
    -- {
    --     'spikedoanz/brainrot.nvim',
    --     opts = {},
    -- },
    {
        "seandewar/killersheep.nvim",
        opts = {},
        cmd = "KillKillKill"
    },
    {
        "Dhanus3133/LeetBuddy.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("leetbuddy").setup({})
        end,
        cmd = "LBQuestions"
    },
    {
        "ThePrimeagen/vim-apm",
        cmd = "VimApm",
    },

    -- vimbegood
    {
        "ThePrimeagen/vim-be-good",
        cmd = "VimBeGood",
    },
    {
        "Eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        init = function()
            local wk = require('stuff.wkutils')
            wk.makeGroup("n", "<leader>C", "[C]ellular Automaton", function(remap)
                remap("r", "[R]ain", ":CellularAutomaton make_it_rain<CR>", { noremap = true })
                remap("l", "[L]ife", ":CellularAutomaton game_of_life<CR>", { noremap = true })
                remap("b", "[B]ounce", ":CellularAutomaton bounce<CR>", { noremap = true })
            end)
            wk.writeBuf()
        end,
        config = function()
            local animation = {
                fps = 20,
                name = "bounce",
            }
            function animation.init(grid)
                for i = 1, #grid do
                    for j = 1, #grid[i] do
                        if grid[i][j].char ~= " " then
                            local velBound = 1
                            local velX = math.random(-velBound, velBound)
                            local velY = math.random(-velBound, velBound)
                            while velX == 0 and velY == 0 do
                                velX = math.random(-velBound, velBound)
                                velY = math.random(-velBound, velBound)
                            end
                            grid[i][j].velocity = { x = velX, y = velY }
                            -- grid[i][j].hl_group = { "@comment", "
                        else
                            grid[i][j].char = " "
                        end
                    end
                end
            end

            function animation.update(grid)
                local skipList = {}
                for i = 1, #grid do
                    for j = 1, #grid[i] do
                        if skipList[i] == nil then
                            skipList[i] = {}
                        end
                        if skipList[i][j] then
                            goto continue
                        end
                        if grid[i][j].char ~= " " then
                            local vel = grid[i][j].velocity
                            local x = i
                            local y = j
                            local newX = x + vel.x
                            local newY = y + vel.y
                            -- print("yo")
                            -- print(newX, newY)
                            if newX < 1 then
                                vel.x = 1
                                newX = 1
                            end
                            if newY < 1 then
                                vel.y = 1
                                newY = 1
                            end
                            if newX > #grid then
                                vel.x = -1
                                newX = #grid
                            end
                            if newY > #grid[i] then
                                vel.y = -1
                                newY = #grid[i]
                            end
                            -- print(newX, newY)
                            if grid[newX][newY].char == " " then
                                local temp = grid[newX][newY].hl_group
                                grid[newX][newY].hl_group = grid[x][y].hl_group
                                grid[x][y].hl_group = temp
                                grid[newX][newY].char = grid[x][y].char
                                grid[x][y].char = " "
                                grid[newX][newY].velocity = grid[x][y].velocity
                                grid[x][y].velocity = { x = 0, y = 0 }
                                if skipList[newX] == nil then
                                    skipList[newX] = {}
                                end
                                skipList[newX][newY] = true
                            else
                                -- print("hi")
                                grid[x][y].velocity = { x = -vel.x, y = -vel.y }
                            end
                        end
                        ::continue::
                    end
                end
                return true
            end

            require("cellular-automaton").register_animation(animation)
        end,
    },
    {
        'jim-fx/sudoku.nvim',
        cmd = 'Sudoku',
        opts = {},
    },
    {
        'alec-gibson/nvim-tetris',
        cmd = 'Tetris',
    },
}
