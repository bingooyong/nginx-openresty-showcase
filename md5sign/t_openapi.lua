local m_utils = require "m_utils"
local m_security = require "m_security"
local cjson = require "cjson.safe"
local HTTP_UNAUTHORIZED = '{"status":4101, "message":"身份信息已失效，请重新登录","more info":"安全验证不通过，请检查API设置"}'
local HTTP_SIGN_ERR = '{"status":4102, "message":"身份信息错误，请重新登录","more info":"安全验证不通过，请检查API设置"}'
cjson.encode_sparse_array(true)

ngx.header.content_type = "application/json;charset=UTF-8"

local function get_all_args()
    local uri_args = ngx.req.get_uri_args()

    ngx.req.read_body()
    local post_args, err = ngx.req.get_post_args()
    if not post_args then
        ngx.log(ngx.WARN, string.format("[REQ] [agent] ngx.req.get_post_args():%s", err))
        post_args = {}
    else
        ngx.log(ngx.DEBUG, string.format("[REQ] [agent] post_args:%s", cjson.encode(post_args)))
    end

    return m_utils.merge_table(uri_args, post_args)
end

local chain_print = function (data)
    -- JSONP
    local arg_callback = ngx.var.arg_callback
    if arg_callback then
        local m, err = ngx.re.match(arg_callback, "[^\\w]")
        if not m then
            data = arg_callback .. "(" .. data .. ");"
            ngx.header.content_type = "application/x-javascript;charset=UTF-8"
        else
            ngx.log(ngx.WARN, "[REQ] [agent] josnp callback is invalid:[" .. arg_callback .. "]")
        end
    end

    ngx.header['Content-Length'] = string.len(data)
    ngx.print(data)
end

local all_args = get_all_args()
local check_app_succ = false
local auth_err_msg = HTTP_UNAUTHORIZED

local args = m_utils.copy_table(all_args)
if m_security.check_is_app_valid(args) then
   check_app_succ = true
else
   auth_err_msg = HTTP_SIGN_ERR
end

if not check_app_succ then
    chain_print(auth_err_msg)
    ngx.exit(ngx.HTTP_OK)
end

ngx.say('{"status":200, "message":"OK"}')