local M = {}

M.opts = {}

M.open = function(num)
    local practice = require("practice.practice")
    local randomize = require("practice.randomize")
    local total = num or 10
    local completed = 0
    local randomized = randomize(total)
    local results = {}

    local function begin()
        local exercise = randomized[completed + 1]
        practice.open(exercise.input, exercise.expected, exercise.instructions, function(result)
            table.insert(results, result)
            completed = completed + 1
            if completed == #randomized then
                require("practice.show_results")(results)
            else
                begin()
            end
        end)
    end

    begin()
end

M.setup = function()
    vim.api.nvim_create_user_command("StartTypingChallenge", function(opts)
        M.open(tonumber(opts.fargs[1]))
    end, {
        nargs = 1,
        complete = "customlist,v:lua.practice#complete",
    })
end

return M
