package liteAssets.listOptionsItem
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.text.TextField;
   import liteAssets.handlers.*;
   
   public class listOptionsItem extends MovieClip
   {
      public var txtName:TextField;
      
      public var txtStatus:TextField;
      
      public var btnLeft:MovieClip;
      
      public var btnRight:MovieClip;
      
      public var bEnabled:Boolean;
      
      public var sDesc:String;
      
      public var rootClass:MovieClip;
      
      internal var bypass:Boolean = false;
      
      public function listOptionsItem(param1:MovieClip, param2:Boolean, param3:String)
      {
         super();
         this.rootClass = param1;
         this.txtStatus.text = param2 ? "ON" : " OFF";
         this.bEnabled = param2;
         this.sDesc = param3;
         this.btnLeft.addEventListener(MouseEvent.CLICK,this.onToggle,false,0,true);
         this.btnRight.addEventListener(MouseEvent.CLICK,this.onToggle,false,0,true);
      }
      
      public function confirmAction(param1:Object) : void
      {
         if(param1.accept)
         {
            this.bypass = true;
            this.btnLeft.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      public function onToggle(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         switch(this.txtName.text)
         {
            case "Custom Drops UI":
               if(!this.bEnabled || Boolean(this.bypass))
               {
                  break;
               }
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Turning this off will decline all drops! Are you sure?";
               _loc3_.params = {};
               _loc3_.callback = this.confirmAction;
               _loc3_.glow = "red,medium";
               this.rootClass.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
               return;
               break;
            case "Chat UI":
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "You must restart your client for changes to take affect!";
               _loc3_.callback = null;
               _loc3_.btns = "mono";
               _loc3_.glow = "red,medium";
               this.rootClass.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
         }
         this.bypass = false;
         this.bEnabled = !this.bEnabled;
         this.txtStatus.text = this.bEnabled ? "ON" : " OFF";
         optionHandler.cmd(this.rootClass,this.txtName.text);
      }
   }
}

