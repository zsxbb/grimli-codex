package org.sepy.ColorPicker
{
   import flash.display.MovieClip;
   
   public class FaceColor extends MovieClip
   {
      private var _color:Number;
      
      public function FaceColor()
      {
         super();
      }
      
      public function set color(param1:Number) : *
      {
         this._color = param1;
      }
      
      public function get color() : Number
      {
         return this._color;
      }
      
      public function getRGB() : String
      {
         return "0x" + this._color.toString(16);
      }
   }
}

