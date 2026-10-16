package org.sepy.ColorPicker
{
   import flash.display.*;
   import flash.events.*;
   
   public class OkButton extends MovieClip
   {
      public function OkButton()
      {
         super();
         useHandCursor = false;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onPress,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_UP,this.onRelease,false,0,true);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.gotoAndStop(1);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         gotoAndStop(1);
      }
      
      internal function onPress(param1:MouseEvent) : void
      {
         gotoAndStop(2);
      }
      
      internal function onRelease(param1:MouseEvent) : void
      {
         gotoAndStop(1);
         MovieClip(parent).click(this);
      }
   }
}

