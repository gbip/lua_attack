-- Copyright (c) 2020 Paul Florence
-- Copyright (c) 2020 Lucien Menassol
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


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
