package org.sepy.ColorPicker
{
   import flash.display.MovieClip;
   
   public class ColorDisplay extends MovieClip
   {
      private var face:MovieClip;
      
      public function ColorDisplay()
      {
         super();
         this.useHandCursor = false;
         this.face = new FaceColor();
         this.face.name = "face";
         this.addChild(this.face);
         this.face.x = 1;
         this.face.y = 1;
         this.face.width = 39;
         this.face.height = 17;
      }
      
      public function set color(param1:Number) : *
      {
         this.face.color = param1;
      }
      
      public function get color() : Number
      {
         return this.face.color;
      }
      
      public function getRGB() : String
      {
         return "0x" + this.face.color.toString(16);
      }
   }
}

