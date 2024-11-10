local M = {}

M.init = function(start, update_settings)
    local settings = { show_hints = false }

    local get_menu_text = function()
        return {
            "Place an X in the [ ] to activate ",
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
