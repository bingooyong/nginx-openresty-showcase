local P = {}

local ngx = require "ngx"
local cjson = require "cjson.safe"
cjson.encode_sparse_array(true)

local m_utils = require "m_utils"
--密钥配置,后期可从redis读取
local m_api_config = {["17f233b067464215b47ae45eea9e9fe8"] = "NhycYKdy7J0QqDXw"}

local function check_is_app_valid_all(args)
    local sign = args.sign or "nil"
    args.sign = nil

    local param_list = {}
    for key, val in pairs(args) do
        if type(val) == "table" then
            table.insert(param_list, key .. "" .. table.concat(val, ", "))
        else
            table.insert(param_list, key .. "" .. val)
        end
    end
    table.sort(param_list)
    local _security  = m_api_config[args.app_key]
    local _src = _security .. table.concat(param_list, "") .. _security
    local sign_ok = ngx.md5(_src)
    ngx.log(ngx.INFO, "[check_is_app_valid_all] [sign_ok]:" .. sign_ok .. "[sign]:" .. sign .. "[_src]:" .. _src)
    return (string.lower(sign) == string.lower(sign_ok))
end

local function check_is_app_valid(args)
    ngx.log(ngx.DEBUG, string.format("[check_is_app_valid] [app_key]:%s",  args.app_key or "null"))
    args.app_secret = m_api_config[args.app_key]
    if not args.app_secret then
        return false
    end

    ngx.log(ngx.DEBUG, "[check_is_app_valid] " .. "[app_secret]:" .. args.app_secret)
    return check_is_app_valid_all(m_utils.copy_table(args)) or check_is_app_valid_all(m_utils.copy_table(args))
end

-- END

P.check_is_app_valid = check_is_app_valid

return P