package wren
import "core:strings"
import "core:fmt"
import "core:runtime"

init_configuration :: inline proc(configuration : ^WrenConfiguration) do wrenInitConfiguration(configuration);
new_vm :: inline proc (configuration: ^WrenConfiguration) -> WrenVM do return wrenNewVM(configuration);
free_vm :: inline proc (vm: WrenVM) do wrenFreeVM(vm);
collect_garbage :: inline proc (vm: WrenVM) do wrenCollectGarbage(vm);
interpret :: proc (vm: WrenVM, module: string, source: string) -> WrenInterpretResult {
	cmodule := strings.clone_to_cstring(module, context.temp_allocator);
	csource := strings.clone_to_cstring(source, context.temp_allocator);
	return wrenInterpret(vm, cmodule, csource);
}
make_call_handle :: inline proc (vm: WrenVM, signature: cstring) -> WrenHandle do return wrenMakeCallHandle(vm, signature);
call :: inline proc (vm: WrenVM, method: WrenHandle) -> WrenInterpretResult do return wrenCall(vm, method);
release_handle :: inline proc (vm: WrenVM, handle: WrenHandle) do wrenReleaseHandle(vm, handle);
get_slot_count :: inline proc (vm: WrenVM) -> i32 do return wrenGetSlotCount(vm);

ensure_slots :: inline proc (vm: WrenVM, num_slots: i32) do wrenEnsureSlots(vm, num_slots);

get_slot_type :: inline proc (vm: WrenVM, slot: i32) -> WrenType do return wrenGetSlotType(vm, slot);
get_slot_bool :: inline proc (vm: WrenVM, slot: i32) -> bool do return wrenGetSlotBool(vm, slot);
get_slot_bytes :: proc (vm: WrenVM, slot: i32, length: ^i32) -> string {
	cstr := wrenGetSlotBytes(vm, slot, length);
	return string(cstr);
}
get_slot_double :: inline proc (vm: WrenVM, slot: i32) -> f64 do return wrenGetSlotDouble(vm, slot);

get_slot_foreign :: inline proc (vm: WrenVM, slot: i32) -> rawptr do return wrenGetSlotForeign(vm, slot);
get_slot_string ::  proc (vm:  WrenVM, slot: i32) -> string {
	cstr := wrenGetSlotString(vm, slot);
	return string(cstr);
}
get_slot_handle :: inline proc (vm: WrenVM, slot: i32) -> WrenHandle do return wrenGetSlotHandle(vm, slot);
set_slot_bool :: inline proc (vm: WrenVM, slot: i32, value: bool) do wrenSetSlotBool(vm, slot, value);
set_slot_bytes :: proc (vm: WrenVM, slot: i32, bytes: string) {
	cstr := strings.clone_to_cstring(bytes, context.temp_allocator);
	wrenSetSlotBytes(vm, slot, cstr, uint(len(bytes)));
}

set_slot_double :: inline proc (vm: WrenVM, slot: i32, value: f64) do wrenSetSlotDouble(vm, slot, value);
set_slot_new_foreign :: inline proc (vm: WrenVM, slot: i32, classSlot: i32, size: uint) -> rawptr do return wrenSetSlotNewForeign(vm, slot, classSlot, size);
set_slot_new_list :: inline proc (vm: WrenVM, slot: i32) do wrenSetSlotNewList(vm, slot);
set_slot_new_map :: inline proc (vm: WrenVM, slot: i32) do wrenSetSlotNewMap(vm, slot);
set_slot_null :: inline proc (vm: WrenVM, slot: i32) do wrenSetSlotNull(vm, slot);
set_slot_string :: proc (vm: WrenVM, slot: i32, str: string) {
	cstr := strings.clone_to_cstring(str, context.temp_allocator);
	wrenSetSlotString(vm, slot, cstr);
}
set_slot_handle :: inline proc (vm: WrenVM, slot: i32, handle: WrenHandle) do wrenSetSlotHandle(vm, slot, handle);

get_list_count :: inline proc (vm: WrenVM, slot: i32) -> i32 do return wrenGetListCount(vm, slot);
get_list_element :: inline proc (vm: WrenVM, listSlot: i32, index: i32, elementSlot: i32) do wrenGetListElement(vm, listSlot, index, elementSlot);
set_list_element :: inline proc (vm: WrenVM, listSlot: i32, index: i32, elementSlot: i32) do wrenSetListElement(vm, listSlot, index, elementSlot);
insert_in_list :: inline proc (vm: WrenVM, listSlot: i32, index: i32, elementSĺot: i32) do wrenInsertInList(vm, listSlot, index, elementSĺot);
get_map_count :: inline proc (vm: WrenVM, slot: i32) -> i32 do return wrenGetMapCount(vm, slot);
get_map_contains_key :: inline proc (vm: WrenVM, mapSlot: i32, keySlot: i32) -> bool do return wrenGetMapContainsKey(vm, mapSlot, keySlot);
get_map_value :: inline proc (vm: WrenVM, mapSlot: i32, keySlot: i32, valueSlot: i32) do wrenGetMapValue(vm, mapSlot, keySlot, valueSlot);
set_map_value :: inline proc (vm: WrenVM, mapSlot: i32, keySlot: i32, valueSlot: i32) do wrenSetMapValue(vm, mapSlot, keySlot, valueSlot);
remove_map_value :: inline proc (vm: WrenVM, mapSlot: i32, keySlot: i32, removedValueSlot: i32) do wrenRemoveMapValue(vm, mapSlot, keySlot, removedValueSlot);
get_variable :: inline proc (vm: WrenVM, module: cstring, name: cstring, slot: i32) do wrenGetVariable(vm, module, name, slot);

has_varible :: inline proc (vm: WrenVM, module: cstring, name: cstring, slot: i32) -> bool do return wrenHasVariable(vm, module, name);
has_module :: inline proc (vm: WrenVM, module: cstring) -> bool do return wrenHasModule (vm, module);
abort_fiber :: inline proc (vm: WrenVM, slot: i32) do wrenAbortFiber(vm, slot);
get_user_data :: inline proc (vm: WrenVM) -> rawptr do return wrenGetUserData(vm);
set_user_data :: inline proc (vm: WrenVM, userData: rawptr) do wrenSetUserData(vm,userData);