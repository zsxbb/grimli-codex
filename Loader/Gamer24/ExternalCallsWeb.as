package
{
   import flash.display.MovieClip;
   import flash.external.*;
   
   public class ExternalCallsWeb
   {
      private static const ALLOWED_JS_FUNCTIONS:Vector.<String> = new <String>["showIt","setToken","setUpPayment","logQuestProgress","getGroup","fbLogin","fbLogout","fbLoginWithPermissions","fbLoginNoAuth","showFeedDialog","GetCurrentUser","setGameObject","openAdsWindow","closeAdsWindow"];
      
      private var sourceID:String;
      
      private var isFBSource:Boolean = false;
      
      private var rootClass:MovieClip;
      
      private var conn:*;
      
      public function ExternalCallsWeb(param1:String, param2:MovieClip)
      {
         super();
         this.sourceID = param1;
         this.isFBSource = this.sourceID == "FACEBOOK";
         this.rootClass = param2;
         this.conn = ExternalInterface.addCallback("SendMessage",this.rootClass.FBMessage);
      }
      
      public function setGameObject(param1:Object) : void
      {
         ExternalInterface.call("setGameObject",param1);
      }
      
      public function showFeedDialog(param1:String, param2:String, param3:String) : void
      {
         if(!this.isFBSource)
         {
            return;
         }
         ExternalInterface.call("showFeedDialog",param1,param2,param3);
      }
      
      public function fbLogin() : void
      {
         ExternalInterface.call("fbLoginNoAuth","email,publish_actions","fbLogin");
      }
      
      public function fbLoginWithPermissions() : void
      {
         ExternalInterface.call("fbLoginWithPermissions","email,publish_actions","linkAccount");
      }
      
      public function fbLogout() : void
      {
         ExternalInterface.call("fbLogout","Logout");
      }
      
      public function getFBUser() : void
      {
         if(!this.rootClass.params.FBID)
         {
            return;
         }
         ExternalInterface.call("GetCurrentUser");
      }
      
      public function showIt(param1:String) : void
      {
         var _loc2_:String = "none";
         ExternalInterface.call("showIt",param1,this.rootClass.world.myAvatar.objData.iAge,this.rootClass.world.myAvatar.objData.UserID,_loc2_,this.rootClass.world.myAvatar.isUpgraded());
      }
      
      public function callJSFunction(param1:String) : void
      {
         if(ALLOWED_JS_FUNCTIONS.indexOf(param1) == -1)
         {
            trace("Security: Blocked non-whitelisted JS function call: " + param1);
            return;
         }
         ExternalInterface.call(param1);
      }
      
      public function getQueryString() : String
      {
         return ExternalInterface.call("window.location.search.substring",1);
      }
      
      public function setToken(param1:Object) : void
      {
         ExternalInterface.call("setToken",param1.strToken);
      }
      
      public function setUpPayment(param1:String) : void
      {
         ExternalInterface.call("setUpPayment",this.rootClass.world.myAvatar.objData.CharID,param1,"");
      }
      
      public function logQuestProgress(param1:int, param2:String) : void
      {
         ExternalInterface.call("logQuestProgress",param1,param2);
      }
      
      public function getGroup() : int
      {
         return ExternalInterface.call("getGroup");
      }
   }
}

