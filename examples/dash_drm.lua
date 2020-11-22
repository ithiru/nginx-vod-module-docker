local function pack (value)
    local map = {
        ['0'] = 0,
        ['1'] = 1,
        ['2'] = 2,
        ['3'] = 3,
        ['4'] = 4,
        ['5'] = 5,
        ['6'] = 6,
        ['7'] = 7,
        ['8'] = 8,
        ['9'] = 9,
        ['a'] = 10,
        ['b'] = 11,
        ['c'] = 12,
        ['d'] = 13,
        ['e'] = 14,
        ['f'] = 15
    }

    return string.gsub(value, "(.)(.)", function (a,b)  return string.char(map[a]*16+map[b]) end)
end
local function get_key(kid)
    return ngx.md5_bin('secret' .. kid)
end

local cjson = require "cjson"
local res = {}

if ngx.req.get_method() == 'POST' then
    local json_data = ngx.var.request_body
    local data = cjson.decode(json_data)
    local type = data.type
    local keys = {}
    for i,kid in ipairs(data.kids) do
        local key = ngx.encode_base64(get_key(ngx.decode_base64(kid)), true)
        table.insert(keys, {k = key, kty = 'oct', kid = kid})
    end

    res = {keys = keys, type = type}
else
    local kid = pack('0123456789abcdef0123456789abcdef')
    local key = ngx.encode_base64(get_key(kid))
    local key_id = ngx.encode_base64(kid)
    local pssh = {}
    local pssh_data = ngx.encode_base64(pack('00000001') .. kid .. pack('00000000'))
    table.insert(pssh, {uuid = '1077efec-c0b2-4d02-ace3-3c1e52e2fb4b', data = pssh_data})
    local data = {key = key, key_id = key_id, pssh = pssh}
    table.insert(res, data)
end

ngx.say(cjson.encode(res))

