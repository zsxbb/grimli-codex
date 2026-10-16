package liteAssets.listOptionsItem
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.text.TextField;
   import liteAssets.handlers.*;
   
   public class listOptionsItemBtn extends MovieClip
   {
      public var txtName:TextField;
      
      public var btnActive:SimpleButton;
      
      public var sDesc:String;
      
      public var rootClass:MovieClip;
      
      internal var bypass:Boolean = false;
      
      public function listOptionsItemBtn(param1:MovieClip, param2:String)
      {
         super();
         this.rootClass = param1;
         this.sDesc = param2;
         this.btnActive.addEventListener(MouseEvent.CLICK,this.onActive,false,0,true);
      }
      
      public function confirmAction(param1:Object) : void
      {
         if(param1.accept)
         {
            this.bypass = true;
            this.btnActive.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      public function onActive(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         switch(this.txtName.text)
         {
            case "Decline All Drops":
               if(this.bypass)
               {
                  break;
               }
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Are you sure you want to decline all drops?";
               _loc3_.params = {};
               _loc3_.callback = this.confirmAction;
               _loc3_.glow = "red,medium";
               this.rootClass.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
               return;
         }
         this.bypass = false;
         optionHandler.cmd(this.rootClass,this.txtName.text);
      }
   }
}

