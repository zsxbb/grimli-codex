package
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.*;
   
   public class LPFElementListItem extends MovieClip
   {
      protected var eventType:String = "";
      
      protected var sMode:String;
      
      public var fData:Object;
      
      public var fParent:LPFFrame;
      
      public var state:int = 0;
      
      public function LPFElementListItem()
      {
         this.fData = {};
         super();
      }
      
      protected function update() : void
      {
         var _loc1_:Object = {
            "fData":this.fData,
            "eventType":this.eventType,
            "fCaller":this.fParent.sName
         };
         this.fParent.update(_loc1_);
      }
      
      public function fOpen(param1:Object) : void
      {
         this.fData = param1.fData;
         if("eventType" in param1)
         {
            this.eventType = param1.eventType;
         }
      }
      
      public function fClose() : void
      {
         this.fData = null;
         removeEventListener(MouseEvent.CLICK,this.onClick);
         parent.removeChild(this);
      }
      
      protected function fDraw() : void
      {
      }
      
      public function subscribeTo(param1:LPFFrame) : void
      {
         this.fParent = param1;
      }
      
      public function select() : void
      {
      }
      
      public function deselect() : void
      {
      }
      
      protected function onClick(param1:MouseEvent) : void
      {
         this.update();
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      protected function onMouseOut(param1:MouseEvent) : void
      {
      }
   }
}

