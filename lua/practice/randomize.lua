local randomize = function(count)
    local tbl = require("practice.exercises")
    local tbl_len = #tbl
    local pick_count = math.min(count, tbl_len)

    -- Create a shuffled copy of the table indices
    local indices = {}
    for i = 1, tbl_len do
        indices[i] = i
    end

    for i = tbl_len, 2, -1 do
        local j = math.random(i)
        indices[i], indices[j] = indices[j], indices[i]
    end

    local result = {}
    for i = 1, pick_count do
        table.insert(result, tbl[indices[i]])
    end

    return result
end

return randomize
