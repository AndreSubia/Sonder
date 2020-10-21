local G_

function val(value)
    G_ = value
end

function get_val()
    return G_
end

return {val = val, get = get_val}