local M = {}

M.init = function(start, update_settings)
    local settings = { show_hints = false }

    local get_menu_text = function()
        return {
            "Press f in the [ ] to toggle",
            "[ ] Begin",
            string.format("[%s] Toggle hints", settings.show_hints and "X" or " "),
        }
    end

    local actions = {
        ["[x] begin"] = start,
        ["[x] toggle hints"] = function()
            settings.show_hints = true
            update_settings(settings)
        end,
        ["[ ] toggle hints"] = function()
            settings.show_hints = false
            update_settings(settings)
        end,
    }
    local menu_buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_keymap(menu_buf, "n", "f", "", {
        noremap = true,
        silent = true,
        callback = function()
            local line = vim.fn.getline(".")
            local col = vim.fn.col(".") - 1
            local char = vim.fn.strpart(line, col, 1)

            if string.lower(char) == "x" then
                vim.cmd("normal! r ")
            else
                vim.cmd("normal! rx")
            end
        end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = menu_buf,
        callback = function()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))

            col = 1

            if row < 2 then
                row = 2
            elseif row > 3 then
                row = 3
            end

            vim.api.nvim_win_set_cursor(0, { row, col })
        end,
    })

    local show_menu_text = function()
        local menu_text = get_menu_text()
        vim.api.nvim_buf_set_lines(menu_buf, 0, -1, false, menu_text)
    end

    show_menu_text()

    vim.api.nvim_create_autocmd({ "TextChangedi", "TextChanged" }, {
        buffer = menu_buf,
        callback = function()
            local line = string.lower(vim.api.nvim_get_current_line())
            local action = actions[line]
            if action then
                action()
            end
            show_menu_text()
        end,
    })
    return menu_buf
end

return M
