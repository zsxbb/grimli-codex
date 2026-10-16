package org.sepy.ColorPicker
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class ColorInput extends MovieClip
   {
      public var _color:Number;
      
      private var input:TextField;
      
      public function ColorInput()
      {
         var _loc1_:TextFormat = null;
         super();
         _loc1_ = new TextFormat();
         _loc1_.font = "_sans";
         _loc1_.size = 10;
         this.input = new TextField();
         this.input.name = "input";
         this.input.width = 57;
         this.input.height = 16;
         this.addChildAt(this.input,1);
         this.input.x = 2;
         this.input.y = 1;
         this.input.type = "input";
         this.input.maxChars = 7;
         this.input.defaultTextFormat = _loc1_;
         this.input.addEventListener(Event.CHANGE,this.onInput,false,0,true);
      }
      
      public function set color(param1:Number) : *
      {
         this._color = param1;
         this.input.text = "#" + ColorPicker2.ColorToString(param1);
      }
      
      public function get color() : Number
      {
         return this._color;
      }
      
      private function onInput(param1:Event) : void
      {
         MovieClip(parent.parent).changed(TextField(param1.currentTarget).text);
      }
   }
}

