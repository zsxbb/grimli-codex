package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.*;
   import flash.net.*;
   import flash.text.TextField;
   
   public class mcFBPassword extends MovieClip
   {
      public var btnClose:SimpleButton;
      
      public var btnManage:SimpleButton;
      
      public var btnPassClick:SimpleButton;
      
      public var frame:MovieClip;
      
      public var mcPassRecovery:SimpleButton;
      
      public var txtCharName:TextField;
      
      public var txtFBName:TextField;
      
      internal var rootClass:MovieClip;
      
      internal var callBack:Function;
      
      internal var errorFunction:Function;
      
      public function mcFBPassword(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
         this.txtCharName.text = this.rootClass.world.myAvatar.objData.strUsername;
         this.txtFBName.text = "Linked to Facebook account " + this.rootClass.strToProperCase(this.rootClass.FBApi.Name);
         this.btnPassClick.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         this.mcPassRecovery.addEventListener(MouseEvent.CLICK,this.onForgotClick,false,0,true);
         this.btnManage.addEventListener(MouseEvent.CLICK,this.onManageClick,false,0,true);
      }
      
      private function onForgotClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/help"),"_blank");
      }
      
      private function onManageClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/"),"_blank");
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","fbCmd",["unlinkAccount",this.rootClass.FBApi.ID],"str",1);
      }
      
      private function onCloseClick(param1:MouseEvent) : void
      {
         this.rootClass.ui.removeChild(this);
      }
   }
}

