local sgsub = string.gsub
local tinsert = table.insert
local type = type
local ipairs = ipairs
local pairs = pairs
local setmetatable = setmetatable
local ngx_quote_sql_str = ngx.quote_sql_str
local pgmoon = require("resty.pgmoon")
local cjson = require("cjson")
local utils = require("orange.utils.utils")
local DB = {}

function DB:new(conf)
    local instance = {}
    instance.conf = conf
    setmetatable(instance, { __index = self})
    return instance
end

function DB:exec(sql)
    local conf = self.conf
    local db, err = pgmoon.new(conf.connect_config)
    if not db then
        ngx.log(ngx.ERR, "failed to instantiate pgsql: ", err)
        return
    end
    --db:set_timeout(conf.timeout) -- 1 sec

    local ok, err = db:connect()
    if not ok then
        ngx.log(ngx.ERR, "failed to connect: ", err)
        return
    end

    local res, err_query, partial, num_queries = db:query(sql)
    if not res then
		if partial and num_queries then
			ngx.log(ngx.ERR,"sql:",sql,":","bad result: ", err_query)
		else
			ngx.log(ngx.ERR,"sql:",sql,":","bad result: ", err_query)
		end
	end


    local ok, err = db:keepalive(conf.pool_config.max_idle_timeout, conf.pool_config.pool_size)
    if not ok then
        ngx.log(ngx.ERR, "failed to set keepalive: ", err)
    end

    return res,err_query,partial,num_queries
end



function DB:query(sql, params)
    sql = self:parse_sql(sql, params)
    return self:exec(sql)
end

function DB:select(sql, params)
    return self:query(sql, params)
end

function DB:insert(sql, params)
	return self:query(sql,params)
	--[[
    local res, err_query, partial, num_queries = self:query(sql, params)
    if res and not err_query then
        return  res.insert_id, err
    else
        return res, err
    end
	--]]
end

function DB:update(sql, params)
    return self:query(sql, params)
end

function DB:delete(sql, params)
    local res, err_query, partial, num_queries = self:query(sql, params)
    if res then
        return res.affected_rows, err_query
    else
        return res, err_query
    end
end

local function split(str, delimiter)
    if str==nil or str=='' or delimiter==nil then
        return nil
    end

    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        tinsert(result, match)
    end
    return result
end


local function compose(t, params)
    if t==nil or params==nil or type(t)~="table" or type(params)~="table" or #t~=#params+1 or #t==0 then
        return nil
    else
        local result = t[1]
        for i=1, #params do
            result = result  .. params[i].. t[i+1]
        end
        return result
    end
end


function DB:parse_sql(sql, params)
    if not params or not utils.table_is_array(params) or #params == 0 then
        return sql
    end

    local new_params = {}
    for i, v in ipairs(params) do
        if v and type(v) == "string" then
            v = ngx_quote_sql_str(v)
        end

		if type(v) == "boolean" then
			v = tostring(v)
		end

		if type(v) == "table" then
			local json = require("resty.pgmoon.json")
			v = json.encode_json(v)
		end

        tinsert(new_params, v)
    end

    local t = split(sql,"?")
    local sql = compose(t, new_params)

    return sql
end

return DB
