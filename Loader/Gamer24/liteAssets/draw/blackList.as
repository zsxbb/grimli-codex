package liteAssets.draw
{
   import fl.controls.List;
   import fl.data.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class blackList extends MovieClip
   {
      public var btnClear:SimpleButton;
      
      public var btnClose:SimpleButton;
      
      public var btnDel:SimpleButton;
      
      public var frame:MovieClip;
      
      public var listBlack:List;
      
      internal var rootClass:MovieClip;
      
      public function blackList(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
         this.frame.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrag,false,0,true);
         this.frame.addEventListener(MouseEvent.MOUSE_UP,this.onMRelease,false,0,true);
         this.btnDel.addEventListener(MouseEvent.CLICK,this.onBtnRemoveBlacklist,false,0,true);
         this.btnClear.addEventListener(MouseEvent.CLICK,this.onBtnClearBlacklist,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClose,false,0,true);
         if(this.rootClass.litePreference.data.blackList)
         {
            this.listBlack.dataProvider = new DataProvider(this.rootClass.litePreference.data.blackList.sortOn("label"));
         }
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.parent.removeChild(this);
      }
      
      private function onBtnRemoveBlacklist(param1:MouseEvent) : void
      {
         if(this.listBlack.selectedIndex != -1)
         {
            this.listBlack.removeItemAt(this.listBlack.selectedIndex);
            this.listBlack.selectedIndex = -1;
         }
         this.rootClass.litePreference.data.blackList = this.listBlack.dataProvider.toArray();
         this.rootClass.litePreference.flush();
      }
      
      private function onBtnClearBlacklist(param1:MouseEvent) : void
      {
         if(!this.listBlack)
         {
            return;
         }
         this.listBlack.removeAll();
         this.rootClass.litePreference.data.blackList = this.listBlack.dataProvider.toArray();
         this.rootClass.litePreference.flush();
      }
      
      private function onDrag(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function onMRelease(param1:MouseEvent) : void
      {
         this.stopDrag();
      }
   }
}

