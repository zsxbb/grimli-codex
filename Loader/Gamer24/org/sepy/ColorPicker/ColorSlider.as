package org.sepy.ColorPicker
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class ColorSlider extends MovieClip
   {
      private var mc:MovieClip;
      
      private var slider:MovieClip;
      
      private var _color:Number;
      
      private var bmp:BitmapData;
      
      private var down:Boolean = false;
      
      public function ColorSlider()
      {
         super();
         this.mc = new MovieClip();
         this.mc.name = "mc";
         this.addChildAt(this.mc,1);
         this.mc.x = 1;
         this.mc.y = 1;
         this.mc.useHandCursor = false;
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onPressDown,false,0,true);
         this.slider = new slider_mc();
         this.slider.name = "slider";
         this.addChildAt(this.slider,2);
         this.slider.x = 15;
         this.slider.y = 98;
      }
      
      private function onPressDown(param1:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
         this.changing(mouseY);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp,false);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false);
      }
      
      private function onMove(param1:MouseEvent) : void
      {
         if(mouseY >= 0 && mouseY <= this.mc.height)
         {
            this.changing(mouseY);
         }
      }
      
      private function changing(param1:Number) : *
      {
         this.slider.y = param1;
         var _loc2_:Number = Number(this.bmp.getPixel(5,this.slider.y));
         MovieClip(parent).changing(_loc2_);
      }
      
      public function getCurrentColor() : Number
      {
         return this.bmp.getPixel(5,this.slider.y);
      }
      
      public function set color(param1:Number) : void
      {
         this._color = param1;
         this.draw();
      }
      
      public function get color() : Number
      {
         return this._color;
      }
      
      private function draw() : void
      {
         this.mc.graphics.clear();
         var _loc1_:Array = [0,this.color,16777215];
         var _loc2_:Array = [100,100,100];
         var _loc3_:Array = [0,127,255];
         var _loc4_:Matrix = new Matrix();
         _loc4_.createGradientBox(187,187,270 * Math.PI / 180);
         this.mc.graphics.clear();
         this.mc.graphics.beginGradientFill("linear",_loc1_,_loc2_,_loc3_,_loc4_ as Matrix,"reflect","linear");
         this.mc.graphics.moveTo(0,0);
         this.mc.graphics.lineTo(12,0);
         this.mc.graphics.lineTo(12,187);
         this.mc.graphics.lineTo(0,187);
         this.mc.graphics.lineTo(0,0);
         this.mc.graphics.endFill();
         if(this.bmp != null)
         {
            this.bmp.dispose();
         }
         this.bmp = new BitmapData(this.mc.width,this.mc.height,false);
         this.bmp.draw(this.mc);
      }
   }
}

