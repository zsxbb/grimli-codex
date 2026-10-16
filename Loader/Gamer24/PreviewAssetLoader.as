package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.utils.*;
   
   public class PreviewAssetLoader
   {
      private static var sharedDomain:ApplicationDomain;
      
      private static var sharedContext:LoaderContext;
      
      private static var pvNonce:String = String(uint(Math.random() * 16777215));
      
      private var pLoaderD:ApplicationDomain;
      
      private var pLoaderC:LoaderContext;
      
      private var loaderStack:Array;
      
      private var killStack:Array;
      
      private var timeoutMs:int = 15000;
      
      private var maxRetries:int = 1;
      
      private var efHandler:Function;
      
      private var mcPreview:MovieClip;
      
      private var rootClass:MovieClip;
      
      private var useSharedDomain:Boolean;
      
      private var pendingCallback:Function;
      
      private var pendingErrorCallback:Function;
      
      private var pendingLinkage:String;
      
      private var pendingType:String;
      
      private var currentRetries:int = 0;
      
      private var timeoutTimer:Timer;
      
      private var currentURL:String;
      
      private var activeLoader:Loader;
      
      public function PreviewAssetLoader(param1:MovieClip, param2:MovieClip, param3:Boolean = true)
      {
         this.loaderStack = [];
         this.killStack = [];
         super();
         this.mcPreview = param1;
         this.rootClass = param2;
         this.useSharedDomain = param3;
         if(this.useSharedDomain)
         {
            if(sharedDomain == null)
            {
               sharedDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
               sharedContext = new LoaderContext(false,sharedDomain);
            }
            this.pLoaderD = sharedDomain;
            this.pLoaderC = sharedContext;
         }
         else
         {
            this.pLoaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
            this.pLoaderC = new LoaderContext(false,this.pLoaderD);
         }
         this.timeoutTimer = new Timer(this.timeoutMs,1);
         this.timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout,false,0,true);
      }
      
      public static function clearSharedDomain() : void
      {
         sharedDomain = null;
         sharedContext = null;
      }
      
      public function get applicationDomain() : ApplicationDomain
      {
         return this.pLoaderD;
      }
      
      private function bustURL(param1:String) : String
      {
         if(param1 == null || param1.indexOf("file://") == 0)
         {
            return param1;
         }
         var _loc2_:String = param1 + (param1.indexOf("?") < 0 ? "?pv=" : "&pv=") + pvNonce;
         if(this.currentRetries > 0)
         {
            _loc2_ += "&r=" + uint(Math.random() * 16777215);
         }
         return _loc2_;
      }
      
      public function loadAsset(param1:String, param2:String, param3:String, param4:Function, param5:Function = null) : void
      {
         this.clearLoaderStack();
         this.pendingCallback = param4;
         this.pendingErrorCallback = param5;
         this.pendingLinkage = param2;
         this.pendingType = param3;
         this.currentRetries = 0;
         this.currentURL = param1;
         this.doLoad(param1);
      }
      
      private function doLoad(param1:String) : void
      {
         var url:String = param1;
         var ldr:Loader = new Loader();
         var eventType:String = this.getEventType(this.pendingType);
         ldr.contentLoaderInfo.addEventListener(eventType,this.onLoadComplete,false,0,true);
         ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError,false,0,true);
         ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
         try
         {
            ldr.load(new URLRequest(this.bustURL(url)),this.pLoaderC);
         }
         catch(e:Error)
         {
            handleError("Load exception: " + e.message);
            return;
         }
         this.activeLoader = ldr;
         this.loaderStack.push(ldr);
         this.timeoutTimer.reset();
         this.timeoutTimer.start();
      }
      
      private function getEventType(param1:String) : String
      {
         switch(param1)
         {
            case "weapon":
            case "armor":
            case "misc":
               return Event.INIT;
            default:
               return Event.COMPLETE;
         }
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         if(this.activeLoader == null || param1.target != this.activeLoader.contentLoaderInfo)
         {
            this.removeLoaderListeners(LoaderInfo(param1.target));
            return;
         }
         this.timeoutTimer.stop();
         this.removeLoaderListeners(LoaderInfo(param1.target));
         this.removeFromLoaderStack(param1.target);
         this.activeLoader = null;
         if(this.pendingCallback != null)
         {
            this.pendingCallback(param1,this.pendingLinkage,this.pendingType);
         }
         this.cleanup();
      }
      
      private function onLoadError(param1:IOErrorEvent) : void
      {
         if(this.activeLoader == null || param1.target != this.activeLoader.contentLoaderInfo)
         {
            this.removeLoaderListeners(LoaderInfo(param1.target));
            return;
         }
         this.timeoutTimer.stop();
         trace("[Load] ERR PreviewAssetLoader IO: " + param1.text);
         this.removeLoaderListeners(LoaderInfo(param1.target));
         this.removeFromLoaderStack(param1.target);
         this.activeLoader = null;
         if(this.currentRetries < this.maxRetries)
         {
            ++this.currentRetries;
            this.doLoad(this.currentURL);
            return;
         }
         this.handleError("IO Error: " + param1.text);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         if(this.activeLoader == null || param1.target != this.activeLoader.contentLoaderInfo)
         {
            this.removeLoaderListeners(LoaderInfo(param1.target));
            return;
         }
         this.timeoutTimer.stop();
         trace("[Load] ERR PreviewAssetLoader security: " + param1.text);
         this.removeLoaderListeners(LoaderInfo(param1.target));
         this.removeFromLoaderStack(param1.target);
         this.activeLoader = null;
         this.handleError("Security Error: " + param1.text);
      }
      
      private function onTimeout(param1:TimerEvent) : void
      {
         if(this.activeLoader == null)
         {
            return;
         }
         trace("[Load] ERR PreviewAssetLoader: timeout for " + this.currentURL);
         if(this.currentRetries < this.maxRetries)
         {
            ++this.currentRetries;
            this.clearLoaderStack();
            this.doLoad(this.currentURL);
            return;
         }
         this.handleError("Load timeout");
      }
      
      private function handleError(param1:String) : void
      {
         this.clearLoaderStack();
         if(this.pendingErrorCallback != null)
         {
            this.pendingErrorCallback(param1);
         }
         this.cleanup();
      }
      
      private function cleanup() : void
      {
         this.pendingCallback = null;
         this.pendingErrorCallback = null;
      }
      
      private function removeFromLoaderStack(param1:Object) : void
      {
         var _loc3_:Loader = null;
         var _loc2_:int = this.loaderStack.length - 1;
         while(_loc2_ >= 0)
         {
            _loc3_ = this.loaderStack[_loc2_];
            if(_loc3_.contentLoaderInfo == param1)
            {
               this.loaderStack.splice(_loc2_,1);
               break;
            }
            _loc2_--;
         }
      }
      
      private function removeLoaderListeners(param1:LoaderInfo) : void
      {
         try
         {
            param1.removeEventListener(Event.INIT,this.onLoadComplete);
            param1.removeEventListener(Event.COMPLETE,this.onLoadComplete);
            param1.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError);
         }
         catch(e:Error)
         {
         }
      }
      
      public function clearLoaderStack() : void
      {
         var _loc1_:Loader = null;
         var _loc2_:MovieClip = null;
         this.timeoutTimer.stop();
         this.activeLoader = null;
         while(this.loaderStack.length > 0)
         {
            _loc1_ = this.loaderStack.shift();
            try
            {
               this.removeLoaderListeners(_loc1_.contentLoaderInfo);
               _loc1_.close();
            }
            catch(e:Error)
            {
            }
            try
            {
               if(_loc1_.content != null && _loc1_.content is MovieClip)
               {
                  _loc2_ = MovieClip(_loc1_.content);
                  _loc2_.stop();
                  if(this.rootClass != null && "recursiveStop" in this.rootClass)
                  {
                     this.rootClass.recursiveStop(_loc2_);
                  }
               }
            }
            catch(e:Error)
            {
            }
            try
            {
               _loc1_.unloadAndStop(true);
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function addToKillStack(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.killStack.length)
         {
            if(this.killStack[_loc2_].mc == param1)
            {
               return;
            }
            _loc2_++;
         }
         this.killStack.push({
            "c":0,
            "mc":param1
         });
      }
      
      public function processKillStack() : void
      {
         var _loc1_:int = this.killStack.length - 1;
         while(_loc1_ >= 0)
         {
            if(this.killStack[_loc1_].c++ > 2)
            {
               try
               {
                  if(this.mcPreview.contains(this.killStack[_loc1_].mc))
                  {
                     this.mcPreview.removeChild(this.killStack[_loc1_].mc);
                  }
               }
               catch(e:Error)
               {
               }
               this.killStack.splice(_loc1_,1);
            }
            _loc1_--;
         }
      }
      
      public function get hasKillStackItems() : Boolean
      {
         return this.killStack.length > 0;
      }
      
      public function clearPreview() : void
      {
         var _loc2_:MovieClip = null;
         this.clearLoaderStack();
         var _loc1_:int = this.mcPreview.numChildren - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = this.mcPreview.getChildAt(_loc1_) as MovieClip;
            if(_loc2_ != null && "fClose" in _loc2_)
            {
               if(this.rootClass != null && "recursiveStop" in this.rootClass)
               {
                  this.rootClass.recursiveStop(_loc2_);
               }
               try
               {
                  _loc2_.fClose();
               }
               catch(e:Error)
               {
               }
               try
               {
                  this.mcPreview.removeChild(_loc2_);
               }
               catch(e:Error)
               {
               }
            }
            else
            {
               this.mcPreview.removeChildAt(_loc1_);
            }
            _loc1_--;
         }
      }
      
      public function getDefinition(param1:String) : Class
      {
         var linkage:String = param1;
         try
         {
            return this.pLoaderD.getDefinition(linkage) as Class;
         }
         catch(e:Error)
         {
            trace("[Load] ERR PreviewAssetLoader: failed to get definition for " + linkage);
         }
         return null;
      }
      
      public function resetDomain() : void
      {
         if(!this.useSharedDomain)
         {
            this.pLoaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
            this.pLoaderC = new LoaderContext(false,this.pLoaderD);
         }
      }
      
      public function dispose() : void
      {
         this.clearLoaderStack();
         this.killStack = [];
         this.timeoutTimer.stop();
         this.timeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeout);
         this.timeoutTimer = null;
         this.pendingCallback = null;
         this.pendingErrorCallback = null;
         this.mcPreview = null;
         this.rootClass = null;
      }
   }
}

