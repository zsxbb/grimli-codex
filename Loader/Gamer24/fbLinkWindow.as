package
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.*;
   
   public class fbLinkWindow extends MovieClip
   {
      private var mcFB:MovieClip;
      
      private var rootClass:MovieClip;
      
      public function fbLinkWindow(param1:MovieClip, param2:MovieClip)
      {
         super();
         this.mcFB = param1;
         this.rootClass = param2;
         this.mcFB.strPassword.tabIndex = 1;
         this.mcFB.btnFBLink.addEventListener(MouseEvent.CLICK,this.onLinkClick,false,0,true);
         this.mcFB.btnFBCreate.addEventListener(MouseEvent.CLICK,this.onCreateClick,false,0,true);
         this.mcFB.btnClose.addEventListener(MouseEvent.CLICK,this.destroy,false,0,true);
         this.mcFB.visible = this.rootClass.showFB = true;
      }
      
      private function onLinkClick(param1:MouseEvent) : void
      {
         var rand:Number;
         var url:String;
         var request:URLRequest;
         var variables:URLVariables;
         var e:MouseEvent = param1;
         this.rootClass.mcConnDetail.showConn("Authenticating Account Info...");
         rand = Number(this.rootClass.rand());
         url = "cf-userlogin.asp?ran=" + rand;
         if(this.rootClass.loaderInfo.url.toLowerCase().indexOf("file://") >= 0 || this.rootClass.loaderInfo.url.toLowerCase().indexOf("cdn.aq.com") >= 0 || this.rootClass.loaderInfo.url.toLowerCase().indexOf("aqworldscdn.aq.com") >= 0)
         {
            url = "https://www.aq.com/game/" + url;
         }
         else
         {
            url = this.rootClass.params.loginURL + "?ran=" + rand;
         }
         request = new URLRequest(url);
         variables = new URLVariables();
         variables.fbid = FacebookConnect.Me.id;
         variables.fbtoken = FacebookConnect.AccessToken;
         variables.doLink = "true";
         variables.user = this.mcFB.strUsername.text;
         variables.pass = this.mcFB.strPassword.text;
         request.data = variables;
         request.method = URLRequestMethod.POST;
         this.rootClass.loginLoader.removeEventListener(Event.COMPLETE,this.rootClass.onLoginComplete);
         this.rootClass.loginLoader.addEventListener(Event.COMPLETE,this.rootClass.onLoginComplete);
         this.rootClass.loginLoader.addEventListener(IOErrorEvent.IO_ERROR,this.rootClass.onLoginError,false,0,true);
         try
         {
            this.rootClass.loginLoader.load(request);
         }
         catch(error:Error)
         {
            trace("Unable to load URL");
         }
      }
      
      private function onCreateClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/landing/"),"_blank");
      }
      
      public function destroy(param1:MouseEvent = null) : void
      {
         this.mcFB.btnFBLink.removeEventListener(MouseEvent.CLICK,this.onLinkClick);
         this.mcFB.btnFBCreate.removeEventListener(MouseEvent.CLICK,this.onCreateClick);
         this.mcFB.btnClose.removeEventListener(MouseEvent.CLICK,this.destroy);
         this.mcFB.visible = this.rootClass.showFB = false;
         this.rootClass.fbL = null;
      }
   }
}

