#ifndef STATIC_LINK
#define IMPLEMENT_API
#endif

#if defined(HX_WINDOWS) || defined(HX_MACOS) || defined(HX_LINUX)
#define NEKO_COMPATIBLE
#endif


#include <hx/CFFI.h>
#include "Extension.h"


using namespace extension;

AutoGCRoot* onEventHandle = 0;

static void extension_set_event_handle(value onEvent) {

	onEventHandle = new AutoGCRoot(onEvent);

}
DEFINE_PRIM(extension_set_event_handle, 1);

extern "C" void sendEvent(int type, const char *data)
{
	value o = alloc_empty_object();
	alloc_field(o,val_id("type"),alloc_int(type));
	alloc_field(o,val_id("data"),alloc_string(data));
	val_call1(onEventHandle->get(), o);
}


static value extension_sample_method (value inputValue) {

	int returnValue = SampleMethod(val_int(inputValue));
	return alloc_int(returnValue);

}
DEFINE_PRIM (extension_sample_method, 1);


static value extension_init_imagepicker () {
	bool result = initImagePicker();
	return alloc_bool(result);
}
DEFINE_PRIM (extension_init_imagepicker, 0);


void extension_take_photo () {
	takePhoto();
}
DEFINE_PRIM (extension_take_photo, 0);


void extension_select_photo () {
	selectPhoto();
}
DEFINE_PRIM (extension_select_photo, 0);

extern "C" void extension_main () {}
DEFINE_ENTRY_POINT (extension_main);



extern "C" int extension_register_prims () { return 0; }
