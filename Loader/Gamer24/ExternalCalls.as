package
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.*;
   
   public class ExternalCalls
   {
      private var isWeb:Boolean = false;
      
      private var sourceID:String;
      
      private var isFBSource:Boolean = false;
      
      private var rootClass:MovieClip;
      
      private var conn:*;
      
      private var webCall:ExternalCallsWeb;
      
      public function ExternalCalls(param1:Boolean, param2:String, param3:MovieClip)
      {
         super();
         this.isWeb = Game.ISWEB;
         this.sourceID = param2;
         this.isFBSource = this.sourceID == "FACEBOOK";
         this.rootClass = param3;
         if(this.isWeb)
         {
            this.webCall = new ExternalCallsWeb(param2,param3);
         }
      }
      
      public function setGameObject(param1:Object) : void
      {
         if(this.isWeb)
         {
            this.webCall.setGameObject(param1);
         }
      }
      
      public function showFeedDialog(param1:String, param2:String, param3:String) : void
      {
         if(!this.isFBSource)
         {
            return;
         }
         if(this.isWeb)
         {
            this.webCall.showFeedDialog(param1,param2,param3);
         }
      }
      
      public function fbLogin() : void
      {
         if(this.isWeb)
         {
            this.webCall.fbLogin();
         }
      }
      
      public function fbLoginWithPermissions() : void
      {
         if(this.isWeb)
         {
            this.webCall.fbLoginWithPermissions();
         }
      }
      
      public function fbLogout() : void
      {
         if(this.isWeb)
         {
            this.webCall.fbLogout();
         }
      }
      
      public function getFBUser() : void
      {
         if(this.isWeb)
         {
            this.webCall.getFBUser();
         }
      }
      
      public function showIt(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc4_:URLRequest = null;
         var _loc5_:URLLoader = null;
         var _loc2_:Boolean = Boolean(this.isWeb);
         switch(param1)
         {
            case "level10":
               navigateToURL(new URLRequest("https://www.aq.com/aw-level10.asp"),"_blank");
               _loc2_ = false;
               break;
            case "signup":
               _loc3_ = encodeURIComponent(String(this.rootClass.world.myAvatar.objData.UserID));
               navigateToURL(new URLRequest("https://www.aq.com/aw-welcome.asp?id=" + _loc3_),"_blank");
               _loc4_ = new URLRequest("https://www.aq.com/game/quest.asp?userid=" + _loc3_ + "&qvalue=1");
               _loc4_.method = URLRequestMethod.GET;
               _loc5_ = new URLLoader();
               _loc5_.addEventListener(IOErrorEvent.IO_ERROR,this.onQuestTrackError,false,0,true);
               _loc5_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onQuestTrackSecurityError,false,0,true);
               _loc5_.load(_loc4_);
               break;
            case "login":
               break;
            default:
               if(!this.isWeb)
               {
                  navigateToURL(new URLRequest("https://www.aq.com/aextras/offers/"),"_blank");
               }
         }
         if(this.webCall)
         {
            this.webCall.showIt(param1);
         }
      }
      
      public function callJSFunction(param1:String) : void
      {
         if(this.isWeb)
         {
            this.webCall.callJSFunction(param1);
         }
      }
      
      public function getQueryString() : String
      {
         if(this.isWeb)
         {
            return this.webCall.getQueryString();
         }
         return "";
      }
      
      public function setToken(param1:Object) : void
      {
         if(this.isWeb)
         {
            this.webCall.setToken(param1);
         }
      }
      
      public function setUpPayment(param1:String) : void
      {
         if(this.isWeb)
         {
            this.webCall.setUpPayment(param1);
         }
         else
         {
            navigateToURL(new URLRequest("https://www.aq.com/order-now/direct/"),"_blank");
         }
      }
      
      public function logQuestProgress(param1:int, param2:String) : void
      {
         var userIdEnc:String = null;
         var qsValEnc:String = null;
         var request:URLRequest = null;
         var loader:URLLoader = null;
         var uid:int = param1;
         var qsVal:String = param2;
         try
         {
            userIdEnc = encodeURIComponent(String(this.rootClass.world.myAvatar.objData.UserID));
            qsValEnc = encodeURIComponent(qsVal);
            request = new URLRequest("https://www.aq.com/game/quest.asp?userid=" + userIdEnc + "&qvalue=" + qsValEnc);
            request.method = URLRequestMethod.GET;
            loader = new URLLoader();
            loader.addEventListener(IOErrorEvent.IO_ERROR,this.onQuestTrackError,false,0,true);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onQuestTrackSecurityError,false,0,true);
            loader.load(request);
         }
         catch(e:Error)
         {
            trace("[Game] ERR quest tracking request: " + e.message);
         }
      }
      
      private function onQuestTrackError(param1:IOErrorEvent) : void
      {
         trace("[Game] ERR quest tracking IO: " + param1.text);
      }
      
      private function onQuestTrackSecurityError(param1:SecurityErrorEvent) : void
      {
         trace("[Game] ERR quest tracking security: " + param1.text);
      }
      
      public function getGroup() : int
      {
         if(this.isWeb)
         {
            return this.webCall.getGroup();
         }
         return 1;
      }
   }
}

