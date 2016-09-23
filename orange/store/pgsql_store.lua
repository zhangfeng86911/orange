local type = type
local ipairs = ipairs
local tonumber = tonumber
local pgsql_db = require("orange.store.pgsql_db")
local Store = require("orange.store.base")
local PGSQLStore = Store:extend()


function PGSQLStore:new(options)
    self._name = options.name or "pgsql-store"
    PGSQLStore.super.new(self, self._name)
    self.store_type = "pgsql"
    local connect_config = options.connect_config
    self.pgsql_addr = connect_config.host .. ":" .. connect_config.port
    self.data = {}
    self.db = pgsql_db:new(options)
end


function PGSQLStore:find_all()
    return nil
end

function PGSQLStore:find_page()
    return nil
end



function PGSQLStore:query(opts)
    if not opts or opts == "" then return nil end
    local param_type = type(opts)
    local res, err, sql, params
    if param_type == "string" then
        sql = opts
    elseif param_type == "table" then
        sql = opts.sql
        params = opts.params
    end

    res, err = self.db:query(sql, params)
    if not res then
        ngx.log(ngx.ERR, "PGSQLStore:query, error:", err, " sql:", sql)
        return nil
    end

    if res and type(res) == "table" and #res <= 0 then
        ngx.log(ngx.WARN, "PGSQLStore:query empty, sql:", sql)
    end

    return res
end

function PGSQLStore:insert(opts)
    if not opts or opts == "" then return false end

    local param_type = type(opts)
    local res, err
    if param_type == "string" then
        res, err = self.db:query(opts)
    elseif param_type == "table" then
        res, err = self.db:query(opts.sql, opts.params or {})
    end

    if res then
        return true
    else
        ngx.log(ngx.ERR, "PGSQLStore:insert error:", err)
        return false
    end
end

function PGSQLStore:delete(opts)
    if not opts or opts == "" then return false end
    local param_type = type(opts)
    local res, err
    if param_type == "string" then
        res, err = self.db:query(opts)
    elseif param_type == "table" then
        res, err = self.db:query(opts.sql, opts.params or {})
    end

    if res  then
        return true
    else
        ngx.log(ngx.ERR, "PGSQLStore:delete error:", err)
        return false
    end
end

function PGSQLStore:update(opts)
    if not opts or opts == "" then return false end
    local param_type = type(opts)
    local res, err
    if param_type == "string" then
        res, err = self.db:query(opts)
    elseif param_type == "table" then
        res, err = self.db:query(opts.sql, opts.params or {})
    end

    if res then
        return true
    else
        ngx.log(ngx.ERR, "PGSQLStore:update error:", err)
        return false
    end
end

return PGSQLStore
