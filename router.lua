local route = require('providers.route_service_provider')

local _M = {}

function _M:init()

        route:get('/index', 'index_controller', 'index')
        route:get('/captcha', 'auth_controller', 'getCaptcha')
        route:post('/register', 'auth_controller', 'register')
        route:post('/login', 'auth_controller', 'login')
        route:get('/oauth/wechat/web', 'wechat_controller', 'webLogin')
        -- group middleware should put at last (after get post function called)
        route:group({
            'authenticate',
            -- 'example_middleware'
        }, function()
            route:post('/logout', 'auth_controller', 'logout') -- http_method/uri/controller/action
            route:post('/reset-password', 'user_controller', 'resetPassword')
            route:group({
                'token_refresh'
            }, function()
                route:get('/userinfo', 'user_controller', 'userinfo')
                route:get("/users/{user_id}/", 'user_controller', 'show')
                route:get("/users/{user_id}/comments/{comment_id}", 'user_controller', 'comments')
                -- test upsteam usage (suppose /home api write by Java or PHP) use nginx reverse proxy
                route:get('/home')
            end)
        end)
        route:group({
            'throttle'
        }, function()
            route:get('/phone/code', 'auth_controller', 'getPhoneCode')
        end)
    
    ngx.log(ngx.WARN, 'not find method, uri in router.lua or didn`t response in action, current method:'.. ngx.var.request_method ..' current uri:'..ngx.var.request_uri)
end

return _M