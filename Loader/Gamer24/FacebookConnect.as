package
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.external.*;
   import flash.net.*;
   import flash.utils.*;
   
   public class FacebookConnect
   {
      public static var Me:Object;
      
      private static var _game:MovieClip;
      
      private static var FBWeb:FacebookWeb;
      
      public static var fbpoll:Timer = new Timer(5000);
      
      public static var pollTries:int = 0;
      
      public static var FB_ME_URL:String = "https://graph.facebook.com/me?access_token=";
      
      public static var AccessToken:String = "";
      
      public static var IPAddr:String = "";
      
      public static var isLoggedIn:Boolean = false;
      
      public static var Mode:String = "";
      
      private static var sURL:String = "https://www.aq.com/game/";
      
      private static var rdURL:String = "https://www.aq.com/game/";
      
      public function FacebookConnect()
      {
         super();
      }
      
      public static function consoleLog(param1:String) : void
      {
         trace(param1);
      }
      
      public static function RegisterGame(param1:MovieClip) : void
      {
         _game = param1;
         if(Game.ISWEB)
         {
            FBWeb = new FacebookWeb();
            FBWeb.InitListener(param1);
         }
         AccessToken = GetToken();
      }
      
      public static function RequestFBConnect(param1:String = "") : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLVariables = null;
         var _loc4_:URLLoader = null;
         if(Game.ISWEB)
         {
            FBWeb.Login();
         }
         else
         {
            Mode = param1;
            if(GetToken() != "")
            {
               FetchMe(AccessToken);
            }
            else
            {
               consoleLog("Making a request at " + Game.serverGamePath + "api/login/FBRequestConnect?state=" + GUID.GetGUID());
               _loc2_ = new URLRequest(Game.serverGamePath + "api/login/FBRequestConnect");
               _loc3_ = new URLVariables();
               _loc3_.state = GUID.GetGUID();
               _loc2_.data = _loc3_;
               _loc2_.method = URLRequestMethod.POST;
               _loc4_ = new URLLoader();
               _loc4_.addEventListener(Event.COMPLETE,onFBRequestComplete);
               _loc4_.addEventListener(IOErrorEvent.IO_ERROR,onFBRequestError);
               _loc4_.load(_loc2_);
            }
         }
      }
      
      public static function onFBRequestError(param1:IOErrorEvent) : void
      {
         consoleLog("ERROR:  " + param1.text);
         if(param1.target is URLLoader)
         {
            URLLoader(param1.target).close();
         }
         onFBRequestComplete(null);
      }
      
      public static function onFBRequestComplete(param1:Event) : void
      {
         if(param1 != null && param1.target is URLLoader)
         {
            URLLoader(param1.target).close();
         }
         navigateToURL(new URLRequest("https://www.facebook.com/v2.12/dialog/oauth?client_id=163679093835836&&auth_type=rerequest&scope=email&redirect_uri=" + Game.serverGamePath + "AQWFB.html&state=" + GUID.GetGUID()),"_blank");
         StartPoll();
      }
      
      public static function pollFBApi(param1:TimerEvent) : void
      {
         var _loc2_:URLRequest = null;
         var _loc3_:URLVariables = null;
         var _loc4_:URLLoader = null;
         ++pollTries;
         if(pollTries > 10)
         {
            StopPoll();
            _game.mcConnDetail.showConn("Facebook Connection Timed Out.  Please try again.");
         }
         else
         {
            consoleLog("Making a request at " + Game.serverGamePath + "api/login/FBCheckConnect?state=" + GUID.GetGUID());
            _loc2_ = new URLRequest(Game.serverGamePath + "api/login/FBCheckConnect");
            _loc3_ = new URLVariables();
            _loc3_.state = GUID.GetGUID();
            _loc2_.data = _loc3_;
            _loc2_.method = URLRequestMethod.POST;
            _loc4_ = new URLLoader();
            _loc4_.addEventListener(Event.COMPLETE,onFBCheckComplete);
            _loc4_.addEventListener(IOErrorEvent.IO_ERROR,onFBPollError);
            _loc4_.load(_loc2_);
         }
      }
      
      public static function onFBCheckComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = param1.target as URLLoader;
         var _loc3_:String = _loc2_.data;
         _loc2_.close();
         if(_loc3_.indexOf("status=") == -1)
         {
            IPAddr = _loc3_.split("::")[0];
            AccessToken = _loc3_.split("::")[1];
            consoleLog("FBTOKEN: " + AccessToken + "IP ADDR: " + IPAddr);
            StopPoll();
            isLoggedIn = true;
            SaveToken();
            FetchMe(AccessToken);
         }
      }
      
      public static function onFBPollError(param1:IOErrorEvent) : *
      {
         consoleLog(param1.toString());
         if(param1.target is URLLoader)
         {
            URLLoader(param1.target).close();
         }
         StopPoll();
      }
      
      public static function StopPoll() : *
      {
         if(!fbpoll)
         {
            return;
         }
         fbpoll.reset();
         if(fbpoll.hasEventListener(TimerEvent.TIMER))
         {
            fbpoll.removeEventListener(TimerEvent.TIMER,pollFBApi);
         }
         consoleLog("FB Poll stopped");
         pollTries = 0;
      }
      
      public static function StartPoll() : *
      {
         StopPoll();
         consoleLog("Starting FB Polling...");
         if(!fbpoll.hasEventListener(TimerEvent.TIMER))
         {
            fbpoll.addEventListener(TimerEvent.TIMER,pollFBApi);
         }
         fbpoll.start();
      }
      
      public static function FetchMe(param1:String) : *
      {
         var _loc2_:URLRequest = new URLRequest(FB_ME_URL + param1 + "&fields=id,name,email,birthday");
         _loc2_.method = URLRequestMethod.GET;
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,onFBMeRequestComplete);
         _loc3_.load(_loc2_);
      }
      
      public static function onFBMeRequestComplete(param1:Event) : *
      {
         var meObj:Object = null;
         var evt:* = undefined;
         var e:Event = param1;
         var loader:URLLoader = e.target as URLLoader;
         var result:Boolean = false;
         var msg:String = "Failed to retrieve Facebook User.";
         try
         {
            meObj = JSON.parse(loader.data);
            Me = meObj;
            result = true;
            msg = "Retrieved Facebook User: " + Me.name;
            isLoggedIn = true;
         }
         catch(e:Error)
         {
            trace("[Game] ERR FetchMe: " + e.message);
            ClearToken();
         }
         loader.close();
         if(_game != null)
         {
            evt = new FacebookConnectEvent(FacebookConnectEvent.ONCONNECT,{
               "success":result,
               "message":msg,
               "mode":Mode
            });
            _game.dispatchEvent(evt);
         }
      }
      
      public static function Logout() : *
      {
         Me = null;
         isLoggedIn = false;
         AccessToken = "";
         ClearToken();
         if(Game.ISWEB)
         {
            FBWeb.Logout();
         }
      }
      
      private static function GetToken() : String
      {
         var _loc1_:SharedObject = GetSharedObjectToken();
         if(_loc1_.size > 0)
         {
            AccessToken = _loc1_.data.token;
            return AccessToken;
         }
         return "";
      }
      
      public static function SaveToken() : *
      {
         var so_token:SharedObject = GetSharedObjectToken();
         try
         {
            if(so_token.size == 0)
            {
               so_token.data.token = AccessToken;
               try
               {
                  so_token.flush();
               }
               catch(e:Error)
               {
                  trace("[Game] ERR SaveToken flush: " + e.message);
               }
            }
         }
         catch(e:Error)
         {
            trace("[Game] ERR SaveToken: " + e.message);
         }
      }
      
      public static function ClearToken() : *
      {
         AccessToken = "";
         var _loc1_:SharedObject = GetSharedObjectToken();
         if(_loc1_.size > 0)
         {
            _loc1_.clear();
         }
      }
      
      public static function handleFBMessage(param1:*, param2:*) : *
      {
         FBWeb.FBMessage(param1,param2);
      }
      
      private static function GetSharedObjectToken() : SharedObject
      {
         var _loc1_:SharedObject = null;
         if(Game.ISWEB)
         {
            _loc1_ = SharedObject.getLocal("FBT");
         }
         else
         {
            _loc1_ = SharedObject.getLocal("FBTSA");
         }
         return _loc1_;
      }
   }
}

