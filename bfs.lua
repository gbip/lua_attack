collectgarbage("stop")
local b = require("bytecode_exploit")

local _M = {}

local start = function() end

function print_gc_object(obj)
	print("\t[bfs] GCObject* : ", b.addr_to_string(obj))
	local tag_addr = b.pointer_add(obj, b.sizeof_pointer)
	print("\t[bfs] Tag* : ", b.addr_to_string(tag_addr))
	local tag = b.read_memory(tag_addr,1)
	print("\t[bfs] Tag = ", b.addr_to_string(tag))
	local next_addr = b.read_memory(obj_addr, b.sizeof_pointer)
	print("\t[bfs] Next object is at : ", b.addr_to_string(next_addr))
	print("---\n")
end

function is_thread_state(obj)
	--local obj_addr = b.address_of(obj)
	return False
end

function get_next(obj)
	local obj_addr = b.address_of(obj)
	local next_addr = b.read_memory(obj_addr, b.sizeof_pointer)
	return next_addr
end

function _M.do_bfs()
	local obj = b.address_of(start)
	collectgarbage("stop")
		while not is_thread_state(obj) do
			print_gc_object(obj)
			--obj = get_next(obj)
		end
	print("Found")
	return obj
end

return _M