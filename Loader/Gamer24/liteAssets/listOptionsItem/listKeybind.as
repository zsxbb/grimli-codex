package liteAssets.listOptionsItem
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.text.TextField;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.handlers.*;
   
   public class listKeybind extends MovieClip
   {
      public var txtName:TextField;
      
      public var txtKey:TextField;
      
      public var btnSetKeybindActive:SimpleButton;
      
      public var sKey:uint;
      
      public var sDesc:String;
      
      public var r:MovieClip;
      
      internal var keyDict:Dictionary;
      
      public function listKeybind(param1:MovieClip, param2:uint, param3:String)
      {
         super();
         this.r = param1;
         this.keyDict = this.getKeyboardDict();
         if(!param2)
         {
            this.txtKey.text = "NONE";
         }
         else
         {
            this.txtKey.text = this.keyDict[param2];
         }
         this.txtKey.mouseEnabled = false;
         this.sKey = param2;
         this.sDesc = param3;
         this.btnSetKeybindActive.addEventListener(MouseEvent.CLICK,this.onActive,false,0,true);
      }
      
      internal function getKeyboardDict() : Dictionary
      {
         var _loc1_:XML = describeType(Keyboard);
         var _loc2_:XMLList = _loc1_.constant.@name;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:int = int(_loc2_.length());
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_[Keyboard[_loc2_[_loc5_]]] = _loc2_[_loc5_];
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function onActive(param1:MouseEvent) : void
      {
         this.r.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         this.r.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseExit,false,0,true);
         this.txtKey.text = "...";
      }
      
      public function onMouseExit(param1:MouseEvent) : void
      {
         this.r.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseExit);
         this.r.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.txtKey.text = this.keyDict[this.sKey];
      }
      
      public function onKeyDown(param1:KeyboardEvent) : void
      {
         param1.preventDefault();
         param1.stopPropagation();
         var _loc2_:* = param1.keyCode;
         this.r.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.r.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseExit);
         if(param1.keyCode == Keyboard.ENTER || param1.keyCode == 191)
         {
            this.txtKey.text = this.keyDict[this.sKey];
            return;
         }
         if(param1.keyCode >= 96 && param1.keyCode <= 105)
         {
            param1.keyCode -= 48;
         }
         if(param1.keyCode == 8)
         {
            this.txtKey.text = "NONE";
            _loc2_ = null;
         }
         else
         {
            this.txtKey.text = this.keyDict[param1.keyCode];
         }
         optionHandler.key(this.r,this.txtName.text,_loc2_);
         this.sKey = _loc2_;
      }
   }
}

