package wren

foreign import wrn "external/libwren.a"

import _c "core:c"

wren_h :: 1;
WREN_VERSION_MAJOR :: 0;
WREN_VERSION_MINOR :: 4;
WREN_VERSION_PATCH :: 0;
WREN_VERSION_STRING :: "0.4.0";
WREN_VERSION_NUMBER :: 4000;

WrenReallocateFn :: #type proc();
WrenForeignMethodFn :: #type proc(vm: WrenVM);
WrenFinalizerFn :: #type proc();
WrenResolveModuleFn :: #type proc();
WrenLoadModuleCompleteFn :: #type proc();
WrenLoadModuleFn :: #type proc();
WrenBindForeignMethodFn :: #type proc(vm: WrenVM, module: cstring, class_name: cstring, is_static: bool, signature: cstring) -> WrenForeignMethodFn;
WrenWriteFn :: #type proc(vm: WrenVM, str: cstring);
WrenErrorFn :: #type proc(vm: WrenVM, errorType: WrenErrorType, module: cstring, line: int, msg: cstring);
WrenBindForeignClassFn :: #type proc(vm: WrenVM, module: cstring, class_name: cstring) -> WrenForeignClassMethods;

WrenErrorType :: enum i32 {
    Compile,
    Runtime,
    Stack_Trace,
};

WrenInterpretResult :: enum i32 {
    Success,
    Compile_Error,
    Runtime_Error,
};

WrenType :: enum i32 {
    Bool,
    Num,
    Foreign,
    List,
    Map,
    Null,
    String,
    Unknown,
};

WrenVM :: rawptr;
WrenHandle :: rawptr;

WrenLoadModuleResult :: struct {
    source : cstring,
    onComplete : WrenLoadModuleCompleteFn,
    userData : rawptr,
};

WrenForeignClassMethods :: struct {
    allocate : WrenForeignMethodFn,
    finalize : WrenFinalizerFn,
};

WrenConfiguration :: struct {
    reallocateFn : WrenReallocateFn,
    resolveModuleFn : WrenResolveModuleFn,
    loadModuleFn : WrenLoadModuleFn,
    bindForeignMethodFn : WrenBindForeignMethodFn,
    bindForeignClassFn : WrenBindForeignClassFn,
    writeFn : WrenWriteFn,
    errorFn : WrenErrorFn,
    initialHeapSize : _c.size_t,
    minHeapSize : _c.size_t,
    heapGrowthPercent : _c.int,
    userData : rawptr,
};

@(default_calling_convention="c")
foreign wrn {

    @(link_name="wrenInitConfiguration")
    wrenInitConfiguration :: proc(configuration : ^WrenConfiguration) ---;

    @(link_name="wrenNewVM")
    wrenNewVM :: proc(configuration : ^WrenConfiguration) -> WrenVM ---;

    @(link_name="wrenFreeVM")
    wrenFreeVM :: proc(vm : WrenVM) ---;

    @(link_name="wrenCollectGarbage")
    wrenCollectGarbage :: proc(vm : WrenVM) ---;

    @(link_name="wrenInterpret")
    wrenInterpret :: proc(
        vm : WrenVM,
        module : cstring,
        source : cstring
    ) -> WrenInterpretResult ---;

    @(link_name="wrenMakeCallHandle")
    wrenMakeCallHandle :: proc(
        vm : WrenVM,
        signature : cstring
    ) -> WrenHandle ---;

    @(link_name="wrenCall")
    wrenCall :: proc(
        vm : WrenVM,
        method : WrenHandle
    ) -> WrenInterpretResult ---;

    @(link_name="wrenReleaseHandle")
    wrenReleaseHandle :: proc(
        vm : WrenVM,
        handle : WrenHandle
    ) ---;

    @(link_name="wrenGetSlotCount")
    wrenGetSlotCount :: proc(vm : WrenVM) -> _c.int ---;

    @(link_name="wrenEnsureSlots")
    wrenEnsureSlots :: proc(
        vm : WrenVM,
        numSlots : _c.int
    ) ---;

    @(link_name="wrenGetSlotType")
    wrenGetSlotType :: proc(
        vm : WrenVM,
        slot : _c.int
    ) -> WrenType ---;

    @(link_name="wrenGetSlotBool")
    wrenGetSlotBool :: proc(
        vm : WrenVM,
        slot : _c.int
    ) -> bool ---;

    @(link_name="wrenGetSlotBytes")
    wrenGetSlotBytes :: proc(
        vm : WrenVM,
        slot : _c.int,
        length : ^_c.int
    ) -> cstring ---;

    @(link_name="wrenGetSlotDouble")
    wrenGetSlotDouble :: proc(
        vm : WrenVM,
        slot : _c.int
    ) -> _c.double ---;

    @(link_name="wrenGetSlotForeign")
    wrenGetSlotForeign :: proc(
        vm : WrenVM,
        slot : _c.int
    ) -> rawptr ---;

    @(link_name="wrenGetSlotString")
    wrenGetSlotString :: proc(
        vm : WrenVM,
        slot : _c.int
    ) -> cstring ---;

    @(link_name="wrenGetSlotHandle")
    wrenGetSlotHandle :: proc(
        vm : WrenVM,
        slot : _c.int
    ) -> WrenHandle ---;

    @(link_name="wrenSetSlotBool")
    wrenSetSlotBool :: proc(
        vm : WrenVM,
        slot : _c.int,
        value : bool
    ) ---;

    @(link_name="wrenSetSlotBytes")
    wrenSetSlotBytes :: proc(
        vm : WrenVM,
        slot : _c.int,
        bytes : cstring,
        length : _c.size_t
    ) ---;

    @(link_name="wrenSetSlotDouble")
    wrenSetSlotDouble :: proc(
        vm : WrenVM,
        slot : _c.int,
        value : _c.double
    ) ---;

    @(link_name="wrenSetSlotNewForeign")
    wrenSetSlotNewForeign :: proc(
        vm : WrenVM,
        slot : _c.int,
        classSlot : _c.int,
        size : _c.size_t
    ) -> rawptr ---;

    @(link_name="wrenSetSlotNewList")
    wrenSetSlotNewList :: proc(
        vm : WrenVM,
        slot : _c.int
    ) ---;

    @(link_name="wrenSetSlotNewMap")
    wrenSetSlotNewMap :: proc(
        vm : WrenVM,
        slot : _c.int
    ) ---;

    @(link_name="wrenSetSlotNull")
    wrenSetSlotNull :: proc(
        vm : WrenVM,
        slot : _c.int
    ) ---;

    @(link_name="wrenSetSlotString")
    wrenSetSlotString :: proc(
        vm : WrenVM,
        slot : _c.int,
        text : cstring
    ) ---;

    @(link_name="wrenSetSlotHandle")
    wrenSetSlotHandle :: proc(
        vm : WrenVM,
        slot : _c.int,
        handle : WrenHandle
    ) ---;

    @(link_name="wrenGetListCount")
    wrenGetListCount :: proc(
        vm : WrenVM,
        slot : _c.int
    ) -> _c.int ---;

    @(link_name="wrenGetListElement")
    wrenGetListElement :: proc(
        vm : WrenVM,
        listSlot : _c.int,
        index : _c.int,
        elementSlot : _c.int
    ) ---;

    @(link_name="wrenSetListElement")
    wrenSetListElement :: proc(
        vm : WrenVM,
        listSlot : _c.int,
        index : _c.int,
        elementSlot : _c.int
    ) ---;

    @(link_name="wrenInsertInList")
    wrenInsertInList :: proc(
        vm : WrenVM,
        listSlot : _c.int,
        index : _c.int,
        elementSlot : _c.int
    ) ---;

    @(link_name="wrenGetMapCount")
    wrenGetMapCount :: proc(
        vm : WrenVM,
        slot : _c.int
    ) -> _c.int ---;

    @(link_name="wrenGetMapContainsKey")
    wrenGetMapContainsKey :: proc(
        vm : WrenVM,
        mapSlot : _c.int,
        keySlot : _c.int
    ) -> bool ---;

    @(link_name="wrenGetMapValue")
    wrenGetMapValue :: proc(
        vm : WrenVM,
        mapSlot : _c.int,
        keySlot : _c.int,
        valueSlot : _c.int
    ) ---;

    @(link_name="wrenSetMapValue")
    wrenSetMapValue :: proc(
        vm : WrenVM,
        mapSlot : _c.int,
        keySlot : _c.int,
        valueSlot : _c.int
    ) ---;

    @(link_name="wrenRemoveMapValue")
    wrenRemoveMapValue :: proc(
        vm : WrenVM,
        mapSlot : _c.int,
        keySlot : _c.int,
        removedValueSlot : _c.int
    ) ---;

    @(link_name="wrenGetVariable")
    wrenGetVariable :: proc(
        vm : WrenVM,
        module : cstring,
        name : cstring,
        slot : _c.int
    ) ---;

    @(link_name="wrenHasVariable")
    wrenHasVariable :: proc(
        vm : WrenVM,
        module : cstring,
        name : cstring
    ) -> bool ---;

    @(link_name="wrenHasModule")
    wrenHasModule :: proc(
        vm : WrenVM,
        module : cstring
    ) -> bool ---;

    @(link_name="wrenAbortFiber")
    wrenAbortFiber :: proc(
        vm : WrenVM,
        slot : _c.int
    ) ---;

    @(link_name="wrenGetUserData")
    wrenGetUserData :: proc(vm : WrenVM) -> rawptr ---;

    @(link_name="wrenSetUserData")
    wrenSetUserData :: proc(
        vm : WrenVM,
        userData : rawptr
    ) ---;

}
