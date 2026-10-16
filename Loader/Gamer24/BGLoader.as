package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   
   public class BGLoader
   {
      internal static var mcLogin:MovieClip;
      
      internal static var sUrl:String;
      
      internal static var sTitle:String = "";
      
      private static var titleLoader:Loader = null;
      
      public function BGLoader()
      {
         super();
      }
      
      public static function LoadBG(param1:String, param2:MovieClip, param3:String, param4:String) : void
      {
         mcLogin = param2;
         if(param1.indexOf("file:") > -1)
         {
            sUrl = "https://content.aq.com/game/";
         }
         else
         {
            sUrl = param1;
         }
         sTitle = param4;
         loadTitle(param3);
      }
      
      internal static function onDataComplete(param1:Event) : void
      {
         var _loc2_:URLVariables = new URLVariables(param1.target.data);
         if(_loc2_.status == "success")
         {
            loadTitle(_loc2_.sBG);
         }
         else
         {
            trace("[Load] ERR gameversion check failed: " + _loc2_.strReason);
         }
      }
      
      internal static function loadTitle(param1:String) : void
      {
         var _loc2_:ApplicationDomain = new ApplicationDomain();
         trace("[Load] title load start: " + param1);
         if(param1 != null)
         {
            titleLoader = new Loader();
            titleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onTitleComplete,false,0,true);
            titleLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onError,false,0,true);
            titleLoader.load(new URLRequest(Game.vurl(sUrl + "gamefiles/title/" + param1)),new LoaderContext(false,_loc2_));
         }
         else
         {
            Game.root["mcLogin"].gotoAndStop("GetLauncher");
         }
      }
      
      private static function cleanupTitleLoader() : void
      {
         if(titleLoader != null)
         {
            titleLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onTitleComplete);
            titleLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            titleLoader = null;
         }
      }
      
      internal static function onTitleComplete(param1:Event) : void
      {
         trace("[Load] title loaded");
         cleanupTitleLoader();
         var _loc2_:MovieClip = MovieClip(Loader(param1.target.loader).content);
         mcLogin.mcTitle.removeChildAt(0);
         mcLogin.mcTitle.addChild(_loc2_);
         mcLogin.mcLogo.txtTitle.htmlText = "<font color=\"#FFB231\">New Release:</font> " + sTitle;
         mcLogin = null;
      }
      
      internal static function onError(param1:IOErrorEvent) : void
      {
         trace("[Load] ERR BG load failed: " + param1.text);
         cleanupTitleLoader();
      }
   }
}

