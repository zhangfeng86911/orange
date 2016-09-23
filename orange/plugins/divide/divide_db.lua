

local cjson = require("cjson")
local _M = {}

_M.mysql = {}

function _M.mysql.replace_meta_value(store,key,value)
	return store:update({
		sql = "replace into meta SET `key`=?, `value`=?",
		params = { key, value }
	})
end

function _M.mysql.update_divide_rule(store,key,value)
	return store:delete({
		sql = "update divide set `value`=? where `key`=?",
		params = { cjson.encode(value), key }
	})
end

function _M.mysql.delete_divide_rule(store,key)
	return store:delete({
		sql = "delete from divide where `key`=?",
		params = { key }
	})
end

function _M.mysql.insert_divide_rule(store,key,value)
	return store:insert({
		sql = "insert into divide(`key`, `value`) values(?,?)",
		params = { key, cjson.encode(value) }
	})
end

function _M.mysql.select_meta_value(store,key)
	return store:query({
		sql = "select `value` from meta where `key`=?",
		params = { key }
	})
end

function _M.mysql.select_divide_rules(store)
	return store:query({
		sql = "select `value` from divide order by id asc"
	})
end



_M.pgsql = {}

function _M.pgsql.replace_meta_value(store,key,value)
	return store:update({
		sql = "select replace_meta_value(?,?);",
		params = { key, value }
	})

end

function _M.pgsql.update_divide_rule(store,key,value)
	return store:delete({
		sql = "update divide set value=? where key=?",
		params = { value, key }
	})
end

function _M.pgsql.delete_divide_rule(store,key)
	return store:delete({
		sql = "delete from divide where key=?",
		params = { key }
	})
end

function _M.pgsql.insert_divide_rule(store,key,value)
	return store:insert({
		sql = "insert into divide(key, value) values(?,?)",
		params = { key, value }
	})
end


function _M.pgsql.select_meta_value(store,key)
	return store:query({
		sql = "select value from meta where key=?",
		params = { key }
	})
end

function _M.pgsql.select_divide_rules(store)
	return store:query({
		sql = "select value from divide order by id asc"
	})
end




function _M.replace_meta_value(store,key,value)
	return _M[store.store_type].replace_meta_value(store,key,value)
end

function _M.update_divide_rule(store,key,value)
	return _M[store.store_type].update_divide_rule(store,key,value)
end

function _M.delete_divide_rule(store,key)
	return _M[store.store_type].delete_divide_rule(store,key)
end

function _M.insert_divide_rule(store,key,value)
	return _M[store.store_type].insert_divide_rule(store,key,value)
end


function _M.select_meta_value(store,key)
	return _M[store.store_type].select_meta_value(store,key)
end

function _M.select_divide_rules(store)
	return _M[store.store_type].select_divide_rules(store)
end




return _M
