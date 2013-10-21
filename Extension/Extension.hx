package;

#if cpp
	import cpp.Lib;
#elseif neko
	import neko.Lib;
#end


class Extension {

	public static function setEventHandle(handler:Dynamic):Void {

		extension_set_event_handle(handler);

	}
	private static var extension_set_event_handle = Lib.load("extension", "extension_set_event_handle", 1);


	public static function sampleMethod (inputValue:Int):Int {

		return extension_sample_method(inputValue);

	}
	private static var extension_sample_method = Lib.load ("extension", "extension_sample_method", 1);


	public static function initImagePicker():Bool {

		return extension_init_imagepicker();

	}
	private static var extension_init_imagepicker = Lib.load ("extension", "extension_init_imagepicker", 0);


	public static function takePhoto():Void {

		extension_take_photo();

	}
	private static var extension_take_photo = Lib.load ("extension", "extension_take_photo", 0);


	public static function selectPhoto():Void {

		extension_select_photo();

	}
	private static var extension_select_photo = Lib.load ("extension", "extension_select_photo", 0);

}
