package org.sepy.ColorPicker
{
   import flash.display.*;
   import flash.geom.*;
   
   public class ColorBox extends MovieClip
   {
      private var faceMC:MovieClip;
      
      private var face_border:MovieClip;
      
      private var colorObj:Object;
      
      public function ColorBox(param1:Object)
      {
         super();
         this.colorObj = param1;
         this.useHandCursor = false;
         this.faceMC = new FaceColor() as MovieClip;
         this.faceMC.name = "face";
         this.addChild(this.faceMC);
         this.faceMC.transform.colorTransform = new ColorTransform(1,1,1,1,param1.red,param1.green,param1.blue,0);
         this.face_border = new face_borders() as MovieClip;
         this.face_border.name = "face_border";
         this.addChild(this.face_border);
      }
      
      public function get color() : Object
      {
         return this.colorObj;
      }
      
      public function getRGB() : String
      {
         return "0x" + this.faceMC.color.toString(16);
      }
   }
}

