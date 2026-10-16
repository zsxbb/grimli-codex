package org.sepy.ColorPicker
{
   import flash.display.*;
   import flash.events.*;
   
   public class AdvancedColorButton extends MovieClip
   {
      public function AdvancedColorButton()
      {
         super();
         useHandCursor = false;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         gotoAndStop(2);
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         gotoAndStop(1);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         MovieClip(parent.parent).click(this);
      }
   }
}

