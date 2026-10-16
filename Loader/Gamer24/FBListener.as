package
{
   import flash.display.*;
   import flash.events.*;
   import flash.external.*;
   import flash.net.*;
   import flash.system.*;
   
   public class FBListener
   {
      private var rootClass:MovieClip;
      
      private var fbID:Number = 0;
      
      private var strToken:String;
      
      private var fbName:String;
      
      private var fbEmail:String;
      
      private var fbIP:String;
      
      private var imgURL:String;
      
      private var fbImg:Bitmap;
      
      private var fbDOB:String;
      
      private var imgLoader:Loader;
      
      private var imgLoaded:Boolean = false;
      
      public function FBListener(param1:MovieClip)
      {
         this.imgLoader = new Loader();
         super();
         this.rootClass = param1;
         Security.allowDomain("fbcdn-profile-a.akamaihd.net");
         Security.loadPolicyFile("https://fbcdn-profile-a.akamaihd.net/crossdomain.xml");
      }
      
      public function consoleLog(param1:String) : void
      {
         trace(param1);
      }
      
      public function handleFBEvent(param1:String, param2:*) : *
      {
         var tokens:Array = null;
         var rand:Number = NaN;
         var url:String = null;
         var request:URLRequest = null;
         var variables:URLVariables = null;
         var cmd:String = param1;
         var fbData:* = param2;
         this.consoleLog("fb callback received, cmd: " + cmd);
         switch(cmd)
         {
            case "linkAccount":
               if(this.rootClass.params.FBID)
               {
                  ExternalInterface.call("GetCurrentUser");
               }
               break;
            case "GetCurrentUserComplete":
               this.consoleLog("FBData::::::::>>>>> " + fbData);
               tokens = fbData.split(",");
               this.fbID = Number(tokens[0]);
               this.fbName = tokens[1];
               this.fbEmail = tokens[2];
               this.strToken = tokens[4];
               this.fbIP = tokens[5];
               this.consoleLog("HANDLE FB EVENT USER DATA:   fbID: " + this.fbID + " strToken: " + this.strToken + " fbName: " + this.fbName + " fbEMail: " + this.fbEmail + " fbIP: " + this.fbIP);
               try
               {
                  if(this.fbID > 0 && this.rootClass.sfc != null && this.strToken != null)
                  {
                     this.consoleLog("!!   fb sfc sendxt   !!");
                     this.rootClass.sfc.sendXtMessage("zm","fbCmd",["linkAccount",this.fbID,this.fbName,this.fbEmail,this.fbIP],"str",1);
                  }
                  if(this.rootClass.mcO != null)
                  {
                     this.rootClass.mcO.checkFBStatus();
                  }
               }
               catch(e:Error)
               {
                  consoleLog("Something null happened");
               }
               FacebookConnect.Me = new Object();
               FacebookConnect.Me.id = this.fbID;
               FacebookConnect.Me.name = this.fbName;
               FacebookConnect.Me.email = this.fbEmail;
               try
               {
                  FacebookConnect.Me.birthday = tokens[3];
               }
               catch(e:Error)
               {
                  FacebookConnect.Me.birthday = "5/5/2001";
                  consoleLog("Facebook Birthday is undefined");
               }
               if(this.fbID)
               {
                  FacebookConnect.isLoggedIn = true;
                  if(this.rootClass.FBConnectCallback != null)
                  {
                     this.consoleLog("======> FBConnectCallback <======");
                     this.rootClass.FBConnectCallback();
                     this.rootClass.FBConnectCallback = null;
                  }
               }
               break;
            case "GetCurrentUserLogin":
               tokens = fbData.split(",");
               this.fbID = Number(tokens[0]);
               this.fbName = tokens[1];
               this.fbEmail = tokens[2];
               this.fbDOB = tokens[3];
               this.strToken = tokens[4];
               this.fbIP = tokens[5];
               this.imgURL = tokens[6];
               FacebookConnect.isLoggedIn = true;
               FacebookConnect.Me = new Object();
               FacebookConnect.Me.id = this.fbID;
               FacebookConnect.Me.name = this.fbName;
               FacebookConnect.Me.email = this.fbEmail;
               try
               {
                  FacebookConnect.Me.birthday = tokens[3];
               }
               catch(e:Error)
               {
                  FacebookConnect.Me.birthday = "5/5/2001";
                  consoleLog("Facebook Birthday is undefined");
               }
               if(this.rootClass.FBConnectCallback != null)
               {
                  this.consoleLog("======> FBConnectCallback <======");
                  this.rootClass.FBConnectCallback();
                  this.rootClass.FBConnectCallback = null;
               }
               break;
            case "fbLogin":
               if(fbData.indexOf("status:undefined") > -1)
               {
                  return;
               }
               tokens = fbData.split(";");
               this.fbID = Number(tokens[1].split(":")[1]);
               this.strToken = String(tokens[2].split(":")[1]);
               this.consoleLog("fbLogin received = fbData = " + fbData);
               if(this.fbID < 1)
               {
                  break;
               }
               ExternalInterface.call("GetCurrentUserLogin");
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
               variables.fbid = this.fbID;
               variables.fbtoken = this.strToken;
               request.data = variables;
               request.method = URLRequestMethod.POST;
               FacebookConnect.isLoggedIn = true;
               FacebookConnect.AccessToken = this.strToken;
               FacebookConnect.SaveToken();
               this.rootClass.loginLoader.removeEventListener(Event.COMPLETE,this.rootClass.onLoginComplete);
               this.rootClass.loginLoader.addEventListener(Event.COMPLETE,this.rootClass.onLoginComplete);
               this.rootClass.loginLoader.addEventListener(IOErrorEvent.IO_ERROR,this.rootClass.onLoginError,false,0,true);
               try
               {
                  this.rootClass.loginLoader.load(request);
               }
               catch(error:Error)
               {
                  consoleLog("Unable to load URL");
               }
               break;
            case "Logout":
               this.fbID = 0;
               this.strToken = "";
               FacebookConnect.ClearToken();
               if(this.rootClass.mcO != null)
               {
                  this.rootClass.mcO.checkFBStatus();
               }
         }
      }
      
      private function imgComplete(param1:Event) : void
      {
         this.fbImg = Bitmap(param1.target.content);
         this.fbImg.width = 62;
         this.fbImg.height = 60;
         this.imgLoaded = true;
      }
      
      private function imgError(param1:IOErrorEvent) : void
      {
         trace("[Game] ERR FBListener image load: " + param1.text);
         this.imgLoaded = false;
      }
      
      public function handleEvent(param1:Array) : void
      {
         switch(param1[2])
         {
            case "Link":
               if(param1[3] == "false")
               {
                  ExternalInterface.call("fbLogout","Logout");
               }
               break;
            case "unlink":
               if(param1[3] == "true")
               {
                  ExternalInterface.call("fbLogout","Logout");
                  this.fbID = 0;
               }
               if(this.rootClass.mcO != null)
               {
                  this.rootClass.mcO.checkFBStatus();
                  this.rootClass.mcO.closeUnlink();
               }
         }
      }
      
      public function doFBLogin(param1:Number, param2:String) : *
      {
         var rand:Number;
         var url:String;
         var request:URLRequest;
         var variables:URLVariables;
         var ID:Number = param1;
         var Token:String = param2;
         this.fbID = ID;
         this.strToken = Token;
         if(this.fbID < 1)
         {
            return;
         }
         ExternalInterface.call("GetCurrentUserLogin");
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
         variables.fbid = this.fbID;
         variables.fbtoken = this.strToken;
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
            consoleLog("Unable to load URL");
         }
      }
      
      public function fbLogout() : void
      {
         this.fbID = 0;
         this.strToken = "";
      }
      
      public function logoutFromFB() : void
      {
         ExternalInterface.call("fbLogout","Logout");
      }
      
      public function get isLoggedIn() : Boolean
      {
         return this.fbID > 0;
      }
      
      public function get ID() : Number
      {
         return this.fbID;
      }
      
      public function get Token() : String
      {
         return this.strToken;
      }
      
      public function get Loaded() : Boolean
      {
         return this.imgLoaded;
      }
      
      public function get FBImage() : Bitmap
      {
         return this.fbImg;
      }
      
      public function get Name() : String
      {
         return this.fbName;
      }
   }
}

