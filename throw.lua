
util = require("framework.util")

local throw = {}

local __throw_metatable = {
	__tostring = function(t)
		if util.is_string(t.msg) then
			return debug.traceback(t.msg, 2)
		else
			return debug.traceback("(error object: " .. tostring(t) .. ")", 2)
		end
	end
}

function throw.error(table)
	setmetatable(table, __throw_metatable)
	error(table)
end

function throw.errfmt(table, fmt, ...)
	table.msg = string.format(fmt, ...)
	setmetatable(table, __throw_metatable)
	error(table)
end

errfmt = throw.errfmt

function throw.try(try, catch)
	local status, exception = pcall(try)
	if not status then
		catch(exception)
	end
end

return throw
