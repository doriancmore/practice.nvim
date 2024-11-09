local M = {}

local function show_pane(buf, height, width, row, col)
    return vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
end

local function show_window(practice_buf, instructions_buf, timer_buf)
    local gap = 2

    local width = math.floor(vim.o.columns * 0.4)
    local timer_height = 1
    local instructions_height = math.floor(vim.o.lines * 0.4)
    local practice_height = math.floor(vim.o.lines * 0.4)
    local total_height = instructions_height + practice_height + gap * 2

    local row = math.floor((vim.o.lines - total_height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local practice_pane =
        show_pane(practice_buf, practice_height, width, row + instructions_height + timer_height + gap * 2, col)
    local timer_pane = show_pane(timer_buf, timer_height, width, row, col)
    local instructions_pane = show_pane(instructions_buf, instructions_height, width, row + timer_height + gap, col)
    vim.api.nvim_win_set_option(practice_pane, "relativenumber", true)

    return {
        timer = timer_pane,
        instructions = instructions_pane,
        practice = practice_pane,
    }
end

local function update_timer(timer_buf, start_time)
    local elapsed_time = (vim.loop.now() - start_time) / 1000
    local timer_text = string.format("Timer: %.2f s", elapsed_time)

    vim.api.nvim_buf_set_lines(timer_buf, 0, -1, false, { timer_text })
end

function M.start(instructions_buf, practice_buf, timer_buf, expected_content, callback)
    local start_time = vim.loop.now()

    local timer_handle = vim.loop.new_timer()
    timer_handle:start(
        0,
        20,
        vim.schedule_wrap(function()
            update_timer(timer_buf, start_time)
        end)
    )

    -- Function to check if the buffer matches the expected content
    local function check_content()
        local current_content = vim.api.nvim_buf_get_lines(practice_buf, 0, -1, false)
        local actual = table.concat(current_content, "\n")
        local expected = table.concat(expected_content, "\n")

        if actual == expected then
            timer_handle:stop()

            local elapsed_time = (vim.loop.now() - start_time) / 1000

            vim.api.nvim_buf_delete(practice_buf, { force = true })
            vim.api.nvim_buf_delete(timer_buf, { force = true })
            vim.api.nvim_buf_delete(instructions_buf, { force = true })
            vim.api.nvim_command("stopinsert")
            callback(elapsed_time)
        end
    end

    vim.api.nvim_create_autocmd({ "TextChangedi", "TextChanged" }, {
        buffer = practice_buf,
        callback = check_content,
    })
end

local global_instructions = {
    "",
    "Press j to begin",
    "You will be moved to a random position in the practice window",
}

function M.open(input, expected_content, instructions, callback)
    local practice_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(practice_buf, 0, -1, false, input)

    -- Create a buffer for instructions
    local instructions_buf = vim.api.nvim_create_buf(false, true)
    for i = 1, #global_instructions do
        table.insert(instructions, global_instructions[i])
    end
    vim.api.nvim_buf_set_lines(instructions_buf, 0, -1, false, instructions)

    local timer_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(timer_buf, 0, -1, false, { "Timer: 0.00s" })

    local panes = show_window(practice_buf, instructions_buf, timer_buf)

    vim.api.nvim_set_current_win(panes.instructions)
    vim.api.nvim_win_set_cursor(panes.instructions, { 1, 0 })

    vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = instructions_buf,
        callback = function()
            local cursor = vim.api.nvim_win_get_cursor(panes.instructions)[1]
            if cursor == 1 then
                return false
            end
            vim.api.nvim_clear_autocmds({ buffer = instructions_buf, event = "CursorMoved" })

            -- Randomly select a line and a column
            math.randomseed(os.time())
            local random_line = math.random(1, #input)
            local random_col = math.random(1, #input[random_line])

            vim.api.nvim_set_current_win(panes.practice)
            vim.api.nvim_win_set_cursor(panes.practice, { random_line, random_col - 1 })
            M.start(instructions_buf, practice_buf, timer_buf, expected_content, callback)
        end,
    })
end

return M
