package org.sepy.ColorPicker
{
   internal class HLSRGB
   {
      private var _red:Number = 0;
      
      private var _green:Number = 0;
      
      private var _blue:Number = 0;
      
      private var _hue:Number = 0;
      
      private var _luminance:Number = 0;
      
      private var _saturation:Number = 0;
      
      public function HLSRGB()
      {
         super();
      }
      
      public function get red() : Number
      {
         return this._red;
      }
      
      public function set red(param1:Number) : void
      {
         this._red = param1;
         this.ToHLS();
      }
      
      public function get green() : Number
      {
         return this._green;
      }
      
      public function set green(param1:Number) : void
      {
         this._green = param1;
         this.ToHLS();
      }
      
      public function get blue() : Number
      {
         return this._blue;
      }
      
      public function set blue(param1:Number) : void
      {
         this._blue = param1;
         this.ToHLS();
      }
      
      public function get luminance() : Number
      {
         return this._luminance;
      }
      
      public function set luminance(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            trace(param1 + " exceeds luminance bounds.  Luminance must be between 0.0 and 1.0");
         }
         else
         {
            this._luminance = param1;
            this.ToRGB();
         }
      }
      
      public function get hue() : Number
      {
         return this._hue;
      }
      
      public function set hue(param1:Number) : void
      {
         if(param1 < 0 || param1 > 360)
         {
            trace(param1 + " exceeds hue bounds.  Hue must be between 0.0 and 360.0");
         }
         else
         {
            this._hue = param1;
            this.ToRGB();
         }
      }
      
      public function get saturation() : Number
      {
         return this._saturation;
      }
      
      public function set saturation(param1:Number) : void
      {
         if(param1 < 0 || param1 > 1)
         {
            trace(param1 + "exceeds saturation bounds.  Saturation must be between 0.0 and 1.0");
         }
         else
         {
            this._saturation = param1;
            this.ToRGB();
         }
      }
      
      public function get color() : RGB
      {
         return new RGB(this._red,this._green,this._blue);
      }
      
      public function getRGB() : Number
      {
         return this._red << 16 | this._green << 8 | this._blue;
      }
      
      public function set color(param1:RGB) : void
      {
         this._red = param1.r;
         this._green = param1.g;
         this._blue = param1.b;
         this.ToHLS();
      }
      
      public function lightenBy(param1:Number) : void
      {
         this._luminance *= 1 + param1;
         if(this._luminance > 1)
         {
            this._luminance = 1;
         }
         this.ToRGB();
      }
      
      public function darkenBy(param1:Number) : void
      {
         this._luminance *= param1;
         this.ToRGB();
      }
      
      private function ToHLS() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc1_:Number = Math.min(this._red,Math.min(this._green,this._blue));
         var _loc2_:Number = Math.max(this._red,Math.max(this._green,this._blue));
         var _loc3_:Number = _loc2_ - _loc1_;
         var _loc4_:Number = _loc2_ + _loc1_;
         this._luminance = _loc4_ / 510;
         if(_loc2_ == _loc1_)
         {
            this._saturation = 0;
            this._hue = 0;
         }
         else
         {
            _loc5_ = (_loc2_ - this._red) / _loc3_;
            _loc6_ = (_loc2_ - this._green) / _loc3_;
            _loc7_ = (_loc2_ - this._blue) / _loc3_;
            this._saturation = this._luminance <= 0.5 ? _loc3_ / _loc4_ : _loc3_ / (510 - _loc4_);
            if(this._red == _loc2_)
            {
               this._hue = 60 * (6 + _loc7_ - _loc6_);
            }
            else if(this._green == _loc2_)
            {
               this._hue = 60 * (2 + _loc5_ - _loc7_);
            }
            else if(this._blue == _loc2_)
            {
               this._hue = 60 * (4 + _loc6_ - _loc5_);
            }
            this._hue %= 360;
         }
      }
      
      private function ToRGB() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(this._saturation == 0)
         {
            this._red = this._green = this._blue = this._luminance * 255;
         }
         else
         {
            if(this._luminance <= 0.5)
            {
               _loc2_ = this._luminance + this._luminance * this._saturation;
            }
            else
            {
               _loc2_ = this._luminance + this._saturation - this._luminance * this._saturation;
            }
            _loc1_ = 2 * this._luminance - _loc2_;
            this._red = this.ToRGB1(_loc1_,_loc2_,this._hue + 120);
            this._green = this.ToRGB1(_loc1_,_loc2_,this._hue);
            this._blue = this.ToRGB1(_loc1_,_loc2_,this._hue - 120);
         }
      }
      
      private function ToRGB1(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param3 > 360)
         {
            param3 -= 360;
         }
         else if(param3 < 0)
         {
            param3 += 360;
         }
         if(param3 < 60)
         {
            param1 += (param2 - param1) * param3 / 60;
         }
         else if(param3 < 180)
         {
            param1 = param2;
         }
         else if(param3 < 240)
         {
            param1 += (param2 - param1) * (240 - param3) / 60;
         }
         return param1 * 255;
      }
      
      public function toString() : String
      {
         return "[R:" + this.red + ", G:" + this.green + ", B:" + this.blue + ", H:" + this.hue + ", S:" + this.saturation + ", L:" + this.luminance + "]";
      }
   }
}

