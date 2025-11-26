return {
    {
        "stevearc/profile.nvim",
        init = function()
            local should_profile = os.getenv("NVIM_PROFILE")
            if should_profile then
                require("profile").instrument_autocmds()
                if should_profile:lower():match("^start") then
                    require("profile").start("*")
                else
                    require("profile").instrument("*")
                end
            end

            local function toggle_profile()
                local prof = require("profile")
                if prof.is_recording() then
                    prof.stop()
                    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" },
                        function(filename)
                            if filename then
                                prof.export(filename)
                                vim.notify(string.format("Wrote %s", filename))
                            end
                        end)
                else
                    prof.start("*")
                end
            end
            vim.keymap.set("", "<f1>", toggle_profile)
        end,
        lazy = false
    },

    {
        {
            "folke/snacks.nvim",
            opts = function()
                -- Toggle the profiler
                Snacks.toggle.profiler():map("<leader>pp")
                -- Toggle the profiler highlights
                Snacks.toggle.profiler_highlights():map("<leader>ph")
            end,
            keys = {
                { "<leader>ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },

            },
            enabled = false,
        },
        -- -- optional lualine component to show captured events
        -- -- when the profiler is running
        -- {
        --     "nvim-lualine/lualine.nvim",
        --     opts = function(_, opts)
        --         table.insert(opts.sections.lualine_x, Snacks.profiler.status())
        --     end,
        -- },
    }

}
