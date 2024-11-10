local M = {}

local function show_pane(buf, height, width, row, col, title)
    return vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = title,
    })
end

local panes = {}

local function show_window(bufs, settings)
    local gap = 2

    local width = math.floor(vim.o.columns * 0.4)
    local timer_height = 1
    local instructions_height = math.floor(vim.o.lines * 0.2)
    local menu_height = math.floor(vim.o.lines * 0.2)
    local practice_height = math.floor(vim.o.lines * 0.4)
    local total_height = instructions_height + menu_height + practice_height + gap * 4

    local row = math.floor((vim.o.lines - total_height) / 2)
    local left_col = math.floor(vim.o.columns * 0.1)
    local right_col = left_col + width + gap

    if panes.timer == nil then
        panes.timer = show_pane(bufs.timer, timer_height, width, row, left_col, "Timer")
    end

    if panes.menu == nil then
        panes.menu = show_pane(bufs.menu, menu_height, width, row + timer_height + gap, left_col, "Menu")
    end

    if panes.instructions == nil then
        panes.instructions = show_pane(
            bufs.instructions,
            instructions_height,
            width,
            row + timer_height + menu_height + gap * 2,
            left_col,
            "Instructions"
        )
    end

    if panes.practice == nil then
        panes.practice = show_pane(
            bufs.practice,
            practice_height,
            width,
            row + instructions_height + menu_height + timer_height + gap * 3,
            left_col,
            "Exercise"
        )
    end

    if panes.hints == nil and settings.show_hints then
        panes.hints = show_pane(
            bufs.hints,
            instructions_height,
            width,
            row + menu_height + timer_height + gap * 2,
            left_col + width + gap,
            "Hints"
        )
    elseif panes.hints and settings.show_hints == false then
        vim.api.nvim_win_close(panes.hints, true)
        panes.hints = nil
    end

    vim.api.nvim_set_current_win(panes.menu)
    vim.api.nvim_win_set_option(panes.practice, "relativenumber", true)
end

local function update_timer(timer_buf, start_time)
    local elapsed_time = (vim.loop.now() - start_time) / 1000
    local timer_text = string.format("Timer: %.2f s", elapsed_time)

    if vim.api.nvim_buf_is_valid(timer_buf) then
        vim.api.nvim_buf_set_lines(timer_buf, 0, -1, false, { timer_text })
    end
end

function M.start(bufs, exercise, callback)
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
            timer_handle:close()

            local elapsed_time = (vim.loop.now() - start_time) / 1000

            vim.api.nvim_buf_delete(bufs.practice, { force = true })
            vim.api.nvim_buf_delete(bufs.timer, { force = true })
            vim.api.nvim_buf_delete(bufs.instructions, { force = true })
            vim.api.nvim_buf_delete(bufs.menu, { force = true })
            panes = {}
            vim.api.nvim_command("stopinsert")
            callback(elapsed_time)
        end
    end

    vim.api.nvim_create_autocmd({ "TextChangedi", "TextChanged" }, {
        buffer = bufs.practice,
        callback = check_content,
    })
end

function M.open(exercise, callback)
    local bufs = {
        instructions = vim.api.nvim_create_buf(false, true),
        practice = vim.api.nvim_create_buf(false, true),
        timer = vim.api.nvim_create_buf(false, true),
        hints = vim.api.nvim_create_buf(false, true),
    }

    local function start()
        vim.api.nvim_clear_autocmds({ buffer = bufs.practice, event = "BufEnter" })
        M.start(bufs, exercise, callback)
    end

    bufs.menu = require("practice.menu").init(function()
        vim.api.nvim_set_current_win(panes.practice)
        start()
    end, function(settings)
        show_window(bufs, settings)
    end)

    vim.api.nvim_buf_set_lines(bufs.practice, 0, -1, false, exercise.input)
    vim.api.nvim_buf_set_lines(bufs.instructions, 0, -1, false, exercise.instructions)
    vim.api.nvim_buf_set_lines(bufs.timer, 0, -1, false, { "Timer: 0.00s" })
    vim.api.nvim_buf_set_lines(bufs.hints, 0, -1, false, exercise.hints)

    show_window(bufs, {})

    vim.api.nvim_win_set_cursor(panes.menu, { 2, 1 })
    vim.api.nvim_create_autocmd("BufEnter", {
        buffer = bufs.practice,
        callback = start,
    })
end

return M
