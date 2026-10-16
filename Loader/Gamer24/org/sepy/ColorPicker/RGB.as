package org.sepy.ColorPicker
{
   public class RGB
   {
      private var _r:Number;
      
      private var _g:Number;
      
      private var _b:Number;
      
      public function RGB(param1:Number, param2:Number, param3:Number)
      {
         super();
         this._r = param1;
         this._g = param2;
         this._b = param3;
      }
      
      public function set r(param1:Number) : void
      {
         this._r = param1;
      }
      
      public function get r() : Number
      {
         return this._r;
      }
      
      public function set g(param1:Number) : void
      {
         this._g = param1;
      }
      
      public function get g() : Number
      {
         return this._g;
      }
      
      public function set b(param1:Number) : void
      {
         this._b = param1;
      }
      
      public function get b() : Number
      {
         return this._b;
      }
      
      public function getRGB() : Number
      {
         return this.r << 16 | this.g << 8 | this.b;
      }
      
      public function toString() : String
      {
         return "[R:" + this.r + ", G:" + this.g + ", B:" + this.b + "]";
      }
   }
}

