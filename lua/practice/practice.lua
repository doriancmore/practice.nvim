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

local function show_window(bufs)
    local gap = 2

    local width = math.floor(vim.o.columns * 0.4)
    local timer_height = 1
    local instructions_height = math.floor(vim.o.lines * 0.4)
    local practice_height = math.floor(vim.o.lines * 0.4)
    local total_height = instructions_height + practice_height + gap * 2

    local row = math.floor((vim.o.lines - total_height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local panes = {
        practice = show_pane(
            bufs.practice,
            practice_height,
            width,
            row + instructions_height + timer_height + gap * 2,
            col
        ),
        timer = show_pane(bufs.timer, timer_height, width, row, col),
        instructions = show_pane(bufs.instructions, instructions_height, width, row + timer_height + gap, col),
    }

    vim.api.nvim_win_set_option(panes.practice, "relativenumber", true)

    return panes
end

local function update_timer(timer_buf, start_time)
    local elapsed_time = (vim.loop.now() - start_time) / 1000
    local timer_text = string.format("Timer: %.2f s", elapsed_time)

    vim.api.nvim_buf_set_lines(timer_buf, 0, -1, false, { timer_text })
end

function M.start(panes, bufs, exercise, callback)
    vim.api.nvim_set_current_win(panes.practice)
    if exercise.cursor then
        vim.api.nvim_win_set_cursor(panes.practice, { exercise.cursor.line, exercise.cursor.col })
    else
        -- Randomly select a line and a column
        math.randomseed(os.time())
        local random_line = math.random(1, #exercise.input)
        local random_col = math.random(1, #exercise.input[random_line])
        vim.api.nvim_win_set_cursor(panes.practice, { random_line, random_col - 1 })
    end

    local start_time = vim.loop.now()

    local timer_handle = vim.loop.new_timer()
    timer_handle:start(
        0,
        20,
        vim.schedule_wrap(function()
            update_timer(bufs.timer, start_time)
        end)
    )

    -- Function to check if the buffer matches the expected content
    local function check_content()
        local current_content = vim.api.nvim_buf_get_lines(bufs.practice, 0, -1, false)
        local actual = table.concat(current_content, "\n")
        local expected = table.concat(exercise.expected, "\n")

        if actual == expected then
            timer_handle:stop()

            local elapsed_time = (vim.loop.now() - start_time) / 1000

            vim.api.nvim_buf_delete(bufs.practice, { force = true })
            vim.api.nvim_buf_delete(bufs.timer, { force = true })
            vim.api.nvim_buf_delete(bufs.instructions, { force = true })
            vim.api.nvim_command("stopinsert")
            callback(elapsed_time)
        end
    end

    vim.api.nvim_create_autocmd({ "TextChangedi", "TextChanged" }, {
        buffer = bufs.practice,
        callback = check_content,
    })
end

local global_instructions = {
    "",
    "Press j to begin",
}
local random_pos_instructions = "You will be moved to a random position in the practice window"

function M.open(exercise, callback)
    -- Create a buffer for instructions
    local bufs = {
        instructions = vim.api.nvim_create_buf(false, true),
        practice = vim.api.nvim_create_buf(false, true),
        timer = vim.api.nvim_create_buf(false, true),
    }

    vim.api.nvim_buf_set_lines(bufs.practice, 0, -1, false, exercise.input)

    for i = 1, #global_instructions do
        table.insert(exercise.instructions, global_instructions[i])
    end

    if exercise.cursor then
        table.insert(exercise.instructions, exercise.cursor.instructions)
    else
        table.insert(exercise.instructions, random_pos_instructions)
    end

    vim.api.nvim_buf_set_lines(bufs.instructions, 0, -1, false, exercise.instructions)

    vim.api.nvim_buf_set_lines(bufs.timer, 0, -1, false, { "Timer: 0.00s" })

    local panes = show_window(bufs)

    vim.api.nvim_set_current_win(panes.instructions)
    vim.api.nvim_win_set_cursor(panes.instructions, { 1, 0 })

    vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = bufs.instructions,
        callback = function()
            local cursor = vim.api.nvim_win_get_cursor(panes.instructions)[1]
            if cursor == 1 then
                return false
            end
            vim.api.nvim_clear_autocmds({ buffer = bufs.instructions, event = "CursorMoved" })

            M.start(panes, bufs, exercise, callback)
        end,
    })
end

return M
