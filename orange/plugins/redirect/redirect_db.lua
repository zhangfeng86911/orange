
local cjson = require("cjson")
local _M = {}
_M.mysql = {}

function _M.mysql.replace_meta_value(store,key,value)
	return store:update({
		sql = "replace into meta SET `key`=?, `value`=?",
		params = { key, value }
	})
end

function _M.mysql.select_meta_value(store,key)
	return store:query({
		sql = "select `value` from meta where `key`=?",
		params = { key }
	})
end

function _M.mysql.select_redirect_rules(store)
	return store:query({
		sql = "select `value` from redirect order by id asc"
	})
end

function _M.mysql.insert_redirect_rules(store,key,value)
	return store:insert({
		sql = "insert into redirect(`key`, `value`) values(?,?)",
		params = { key, cjson.encode(value)}
	})
end

function _M.mysql.delete_redirect_rules(store,key)
	return store:delete({
		sql = "delete from redirect where `key`=?",
		params = { key }
	})
end

function _M.mysql.update_redirect_rules(store,key,value)
	return store:update({
		sql = "update redirect set `value`=? where `key`=?",
		params = { cjson.encode(value), key }
	})
end

_M.pgsql = {}

function _M.pgsql.replace_meta_value(store,key,value)
	return store:update({
		sql = "select replace_meta_value(?,?);",
		params = { key, value }
	})
end

function _M.pgsql.select_meta_value(store,key)
	return store:query({
		sql = "select value from meta where key=?",
		params = { key }
	})
end

function _M.pgsql.select_redirect_rules(store)
	return store:query({
		sql = "select value from redirect order by id asc"
	})
end

function _M.pgsql.insert_redirect_rules(store,key,value)
	return store:insert({
		sql = "insert into redirect(key, value) values(?,?)",
		params = { key, value}
	})
end

function _M.pgsql.delete_redirect_rules(store,key)
	return store:delete({
		sql = "delete from redirect where key=?",
		params = { key }
	})
end

function _M.pgsql.update_redirect_rules(store,key,value)
	return store:update({
		sql = "update redirect set value=? where key=?",
		params = { value, key }
	})
end




function _M.replace_meta_value(store,key,value)
	return _M[store.store_type].replace_meta_value(store,key,value)
end

function _M.select_meta_value(store,key)
	return _M[store.store_type].select_meta_value(store,key)
end

function _M.select_redirect_rules(store)
	return _M[store.store_type].select_redirect_rules(store)
end

function _M.insert_redirect_rules(store,key,value)
	return _M[store.store_type].insert_redirect_rules(store,key,value)
end

function _M.delete_redirect_rules(store,key)
	return _M[store.store_type].delete_redirect_rules(store,key)
end

function _M.update_redirect_rules(store,key,value)
	return _M[store.store_type].update_redirect_rules(store,key,value)
end

return _M

