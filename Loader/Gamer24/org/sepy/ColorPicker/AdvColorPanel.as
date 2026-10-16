package org.sepy.ColorPicker
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class AdvColorPanel extends MovieClip
   {
      private var _color:Object;
      
      private var color_map:MovieClip;
      
      private var color_slider:MovieClip;
      
      private var color_display:MovieClip;
      
      private var ok_btn:MovieClip;
      
      private var close_btn:MovieClip;
      
      private var _hue:Number;
      
      private var _saturation:Number;
      
      private var _luminosity:Number;
      
      private var _red:Number;
      
      private var _green:Number;
      
      private var _blue:Number;
      
      private var _hue_mc:MovieClip;
      
      private var _saturation_mc:MovieClip;
      
      private var _luminosity_mc:MovieClip;
      
      private var _red_mc:MovieClip;
      
      private var _green_mc:MovieClip;
      
      private var _blue_mc:MovieClip;
      
      private var _hlsrgb:HLSRGB;
      
      public function AdvColorPanel(param1:Object)
      {
         super();
         this._hlsrgb = new HLSRGB();
         this.color_map = new ColorMap() as MovieClip;
         this.color_map.name = "color_map";
         this.addChild(this.color_map);
         this.color_map.x = 10;
         this.color_map.y = 8;
         this.color_slider = new ColorSlider() as MovieClip;
         this.color_slider.name = "color_slider";
         this.addChildAt(this.color_slider,1);
         this.color_slider.x = this.color_map.x + this.color_map.width + 10;
         this.color_slider.y = this.color_map.y;
         this.color_display = new ColorDisplay() as MovieClip;
         this.color_display.name = "color_display";
         this.addChildAt(this.color_display,2);
         this.color_display.x = this.color_map.x;
         this.color_display.y = this.color_map.y + this.color_map.height;
         this._hue_mc = new IntInput("H","dynamic") as MovieClip;
         this._hue_mc.name = "_hue_mc";
         this.addChildAt(this._hue_mc,3);
         this._hue_mc.x = 125;
         this._hue_mc.y = this.color_map.y + this.color_map.height;
         this._saturation_mc = new IntInput("S","dynamic") as MovieClip;
         this._saturation_mc.name = "_saturation_mc";
         this.addChildAt(this._saturation_mc,4);
         this._saturation_mc.x = this._hue_mc.x;
         this._saturation_mc.y = this._hue_mc.y + this._hue_mc.height + 2;
         this._luminosity_mc = new IntInput("L","dynamic") as MovieClip;
         this._luminosity_mc.name = "_luminosity_mc";
         this.addChildAt(this._luminosity_mc,5);
         this._luminosity_mc.x = this._hue_mc.x;
         this._luminosity_mc.y = this._saturation_mc.y + this._saturation_mc.height + 2;
         this._red_mc = new IntInput("R","input") as MovieClip;
         this._red_mc.name = "_red_mc";
         this.addChildAt(this._red_mc,6);
         this._red_mc.x = 175;
         this._red_mc.y = this._hue_mc.y;
         this._green_mc = new IntInput("G","input") as MovieClip;
         this._green_mc.name = "_green_mc";
         this.addChildAt(this._green_mc,7);
         this._green_mc.x = 175;
         this._green_mc.y = this._saturation_mc.y;
         this._blue_mc = new IntInput("B","input") as MovieClip;
         this._blue_mc.name = "_blue_mc";
         this.addChildAt(this._blue_mc,8);
         this._blue_mc.x = 175;
         this._blue_mc.y = this._luminosity_mc.y;
         this.ok_btn = new OkButton() as MovieClip;
         this.ok_btn.name = "ok_btn";
         this.addChildAt(this.ok_btn,9);
         this.ok_btn.x = this.color_map.x;
         this.ok_btn.y = this._blue_mc.y;
         this.close_btn = new CancelButton() as MovieClip;
         this.close_btn.name = "close_btn";
         this.addChildAt(this.close_btn,10);
         this.close_btn.x = this.ok_btn.x + this.ok_btn.width;
         this.close_btn.y = this._blue_mc.y;
         this.color = param1;
         this.init();
      }
      
      public static function ColorToRGB(param1:Number) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.red = param1 >> 16 & 0xFF;
         _loc2_.green = param1 >> 8 & 0xFF;
         _loc2_.blue = param1 & 0xFF;
         return _loc2_;
      }
      
      internal function init() : *
      {
         this._hue_mc.max = 360;
         this._saturation_mc.max = 240;
         this._luminosity_mc.max = 240;
         this._red_mc.max = 255;
         this._green_mc.max = 255;
         this._blue_mc.max = 255;
         this.color_slider.color = this.color;
         if(!this.color_map.findTheColor(this.RGBtoColor(this.color)))
         {
         }
         this.change(this,this.RGBtoColor(this.color));
         this.updateHLS(this.color_slider.getCurrentColor(),true);
      }
      
      public function changed(param1:MovieClip, param2:Number) : void
      {
         this._hlsrgb.color = new RGB(this._red_mc.value,this._green_mc.value,this._blue_mc.value);
         var _loc3_:Number = Number(this._hlsrgb.getRGB());
         this.color_map.findTheColor(_loc3_);
         this.change(this,_loc3_);
      }
      
      private function RGBtoColor(param1:Object) : int
      {
         var _loc2_:int = 0;
         _loc2_ += param1.red << 16;
         _loc2_ += param1.green << 8;
         return int(_loc2_ + param1.blue);
      }
      
      public function change(param1:MovieClip, param2:Number) : void
      {
         var _loc3_:Object = ColorToRGB(param2);
         if(param1 == this.color_map)
         {
            this.color = _loc3_;
            this.color_slider.color = param2;
            this.color_display.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_.red,_loc3_.green,_loc3_.blue,0);
            this.updateHLS(this.color_slider.getCurrentColor(),true);
         }
         else if(param1 == this)
         {
            this.color = _loc3_;
            this.color_slider.color = param2;
            this.color_display.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_.red,_loc3_.green,_loc3_.blue,0);
            this.updateHLS(this.color_slider.getCurrentColor(),false);
         }
      }
      
      public function changing(param1:Number) : void
      {
         var _loc2_:Object = ColorToRGB(param1);
         this.color_display.transform.colorTransform = new ColorTransform(1,1,1,1,_loc2_.red,_loc2_.green,_loc2_.blue,0);
         this.color = _loc2_;
         this.updateHLS(this.color_slider.getCurrentColor(),true);
      }
      
      private function updateHLS(param1:Number, param2:Boolean) : *
      {
         var _loc3_:Object = null;
         if(param2)
         {
            _loc3_ = ColorPicker2.ColorToRGB(param1);
            this._hlsrgb.hue = this._hlsrgb.saturation = this._hlsrgb.luminance = 0;
            this._hlsrgb.red = _loc3_.red;
            this._hlsrgb.green = _loc3_.green;
            this._hlsrgb.blue = _loc3_.blue;
         }
         this.red = Math.round(this._hlsrgb.red);
         this.green = Math.round(this._hlsrgb.green);
         this.blue = Math.round(this._hlsrgb.blue);
         this.hue = this._hlsrgb.hue;
         this.saturation = this._hlsrgb.saturation;
         this.luminosity = this._hlsrgb.luminance;
      }
      
      public function click(param1:MovieClip) : *
      {
         if(param1 == this.ok_btn)
         {
            MovieClip(parent).click(this);
         }
         else if(param1 == this.close_btn)
         {
            MovieClip(parent)._opened = false;
            MovieClip(parent).advancedColorPanel = null;
            MovieClip(parent).removeChild(this);
         }
      }
      
      public function set color(param1:Object) : *
      {
         this._color = param1;
      }
      
      public function get color() : Object
      {
         return this._color;
      }
      
      public function set hue(param1:Number) : *
      {
         param1 = Math.round(param1);
         this._hue = param1;
         this._hue_mc.value = param1;
      }
      
      public function set saturation(param1:Number) : *
      {
         param1 = Math.round(param1 * 240);
         this._saturation = param1;
         this._saturation_mc.value = param1;
      }
      
      public function set luminosity(param1:Number) : *
      {
         param1 = Math.round(param1 * 240);
         this._luminosity = param1;
         this._luminosity_mc.value = param1;
      }
      
      public function set red(param1:Number) : *
      {
         this._red = param1;
         this._red_mc.value = param1;
      }
      
      public function set green(param1:Number) : *
      {
         this._green = param1;
         this._green_mc.value = param1;
      }
      
      public function set blue(param1:Number) : *
      {
         this._blue = param1;
         this._blue_mc.value = param1;
      }
   }
}

