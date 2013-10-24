package;

import haxe.io.Bytes;
import haxe.io.BytesData;

import flash.Lib;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.IOErrorEvent;
import flash.utils.ByteArray;

import motion.Actuate;
import motion.easing.Linear;

class Main extends Sprite {

  static inline var OFFSET_Y:Int = 400;
  static inline var BTN_WIDTH:Int = 90;

  private var format:TextFormat;
  private var label:TextField;
  private var label_mode:TextField;
  private var mode:Int = 0;

  public function new () {

    super ();

    format = new TextFormat();
    format.font = "Arial";
    format.color = 0xE5EDB6;
    format.size = 14;

    label = new TextField();
    label.defaultTextFormat = format;
    label.text = "demo ImagePicker";
    label.selectable = false;
    label.x = 10;
    label.y = OFFSET_Y - 30;
    label.width = 150;
    addChild(label);

    label_mode = new TextField();
    label_mode.defaultTextFormat = format;
    label_mode.text = "";
    label_mode.selectable = false;
    label_mode.x = label.width + 5;
    label_mode.y = OFFSET_Y - 30;
    label_mode.width = 150;
    addChild(label_mode);

    var btn1 = createBtn("check");
    btn1.x = 10;
    btn1.y = OFFSET_Y;
    addChild(btn1);

    var btn2 = createBtn("take photo");
    btn2.x = 10 + (10 + BTN_WIDTH)*1;
    btn2.y = OFFSET_Y;
    addChild(btn2);

    var btn3 = createBtn("select photo");
    btn3.x = 10 + (10 + BTN_WIDTH)*2;
    btn3.y = OFFSET_Y;
    addChild(btn3);

    btn1.addEventListener(MouseEvent.CLICK, check);
    btn2.addEventListener(MouseEvent.CLICK, takePhoto);
    btn3.addEventListener(MouseEvent.CLICK, selectPhoto);

    Extension.setEventHandle(onEvent);

    startAnimation();
  }

  private function startAnimation():Void {
    var box:Shape = new Shape();
    box.graphics.beginFill(0xF6695B, 1);
    box.graphics.drawRect(0,0,10,10);
    box.graphics.endFill();
    box.y = 0;
    addChild(box);

    // loop
    Actuate.tween(box, 2, { x:stage.stageWidth-box.width } ).ease(Linear.easeNone).repeat().reflect();
  }

  private function onEvent(e:Dynamic) {
    var data = Reflect.field(e, "data");
    var type = Reflect.field(e, "type");
    trace("onEvent:"+type+":" #if !cpp +data #end );

    if (type=="0") {
      label.text = "";
    }
    if (type=="1") {
      Lib.resume();
    }
    if (type=="2") {
      Lib.resume();
      //trace("Decode:"+Base64.decodeBytesData(data));
      //label_mode.text = Base64.decodeBytesData(data).toString();
      loadBase64JPEG(data);
    }
  }

  private function loadBase64JPEG(data:String) {

#if cpp

    // bytesData to byteArray
    //var byteArray = ByteArray.fromBytes(Base64.decodeBytesData(data));
    //trace("imageBase64JPEG:"+byteArray.length+":"+byteArray.position);

    var bmd:BitmapData = BitmapData.loadFromHaxeBytes(Base64.decodeBytesData(data));
    var bitmap:Bitmap = new Bitmap(bmd);
    bitmap.x = 170;
    bitmap.y = 20;
    addChild(bitmap);

#end

  }

  private function createBtn(txt:String):Sprite {

    var tf:TextField = new TextField();
    tf.defaultTextFormat = format;
    tf.text = txt;
    tf.selectable = false;
    tf.x = (BTN_WIDTH-tf.textWidth)*.5;
    tf.y = (36-tf.textHeight)*.5;

    var btn:Sprite = new Sprite();
    btn.graphics.beginFill(0x00766C, 1);
    btn.graphics.drawRoundRect(0, 0, BTN_WIDTH, 36, 12, 12);
    btn.graphics.endFill();

    btn.addChild(tf);

    return btn;
  }

  private function check(e:MouseEvent):Void {

    //trace("show:"+Extension.sampleMethod(777));
    Extension.initImagePicker();
  }

  private function takePhoto(e:MouseEvent):Void {

    Lib.pause();
    Extension.takePhoto();

  }

  private function selectPhoto(e:MouseEvent):Void {

    Lib.pause();
    Extension.selectPhoto();

  }

}
