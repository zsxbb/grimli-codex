package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.TextField;
   
   public class LoaderMC extends MovieClip
   {
      public var btnCancel:SimpleButton;
      
      public var mcPct:TextField;
      
      public var strLoad:TextField;
      
      internal var mcDest:MovieClip;
      
      internal var isEvent:Boolean = false;
      
      private var rootClass:MovieClip;
      
      public var history:Object;
      
      private var _file:String;
      
      private var loadSeq:int = 0;
      
      public function LoaderMC(param1:MovieClip)
      {
         this.history = {};
         super();
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.rootClass = param1;
      }
      
      public function loadFile(param1:MovieClip, param2:String, param3:String, param4:Boolean = false) : void
      {
         this._file = param2;
         var _loc5_:Number = Number(new Date().getTime());
         if(param2.indexOf("https://") == -1 && param2.indexOf("http://") == -1 && param2.indexOf("file://") == -1)
         {
            param2 = Game.serverFilePath + param2;
         }
         this.isEvent = param4;
         if(param3 != "Inline Asset")
         {
            MovieClip(Game.root).addChild(this);
         }
         this.mcDest = param1;
         var _loc6_:* = new Loader();
         _loc6_.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onContentError,false,0,true);
         _loc6_.contentLoaderInfo.addEventListener(Event.INIT,this.onFileLoadComplete,false,0,true);
         _loc6_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onFileLoadComplete,false,0,true);
         _loc6_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onFileLoadProgress,false,0,true);
         _loc6_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadError,false,0,true);
         _loc6_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFileLoadSecurityError,false,0,true);
         this.history[param2 + "#" + ++this.loadSeq] = {
            "ts":_loc5_,
            "ldr":_loc6_,
            "dest":param1,
            "evt":param4
         };
         trace("[Load] LoaderMC loadFile: " + param2);
         _loc6_.load(new URLRequest(Game.vurl(param2)),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
      }
      
      private function onContentError(param1:UncaughtErrorEvent) : void
      {
         var _loc2_:Error = null;
         param1.preventDefault();
         param1.stopImmediatePropagation();
         try
         {
            _loc2_ = param1.error as Error;
            trace("[Load] ERR LoaderMC suppressed: " + (_loc2_ != null ? _loc2_.message : String(param1.error)));
         }
         catch(e2:Error)
         {
         }
      }
      
      private function onFileLoadComplete(param1:Event) : void
      {
         var _loc6_:String = null;
         var _loc2_:* = this.rootClass.world;
         var _loc3_:Loader = Loader(param1.target.loader);
         var _loc4_:MovieClip = this.mcDest;
         var _loc5_:Boolean = Boolean(this.isEvent);
         try
         {
            for(_loc6_ in this.history)
            {
               if(this.history[_loc6_].ldr == _loc3_)
               {
                  if(this.history[_loc6_].dest != null)
                  {
                     _loc4_ = this.history[_loc6_].dest;
                  }
                  _loc5_ = Boolean(this.history[_loc6_].evt);
                  delete this.history[_loc6_];
               }
            }
         }
         catch(e:Error)
         {
         }
         _loc3_.contentLoaderInfo.removeEventListener(Event.INIT,this.onFileLoadComplete);
         _loc3_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onFileLoadComplete);
         _loc3_.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onFileLoadProgress);
         _loc3_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadError);
         _loc3_.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFileLoadSecurityError);
         try
         {
            if(_loc3_.content != null && _loc4_ != null)
            {
               _loc4_.addChild(_loc3_.content);
            }
         }
         catch(e:Error)
         {
         }
         if(_loc5_ && _loc2_ != null)
         {
            trace("[Load] LoaderMC fileLoaded event -> world");
            _loc2_.mapEventTrigger({
               "cmd":"fileLoaded",
               "args":{"loc":"default"}
            });
         }
         this.isEvent = false;
         this.mcDest = null;
         try
         {
            MovieClip(parent).removeChild(this);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onFileLoadProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = Math.floor(param1.bytesLoaded / param1.bytesTotal * 100);
         if(param1.bytesTotal <= 0)
         {
            _loc2_ = 0;
         }
         this.strLoad.text = "Loading!";
         this.mcPct.text = _loc2_ + "%";
      }
      
      private function onFileLoadError(param1:IOErrorEvent) : void
      {
         trace("[Load] ERR LoaderMC IO: " + param1.text);
         this.strLoad.text = "Load Error";
         this.signalEventLoadDone(Loader(param1.target.loader));
         this.cleanupLoader(Loader(param1.target.loader));
      }
      
      private function onFileLoadSecurityError(param1:SecurityErrorEvent) : void
      {
         trace("[Load] ERR LoaderMC security: " + param1.text);
         this.strLoad.text = "Security Error";
         this.signalEventLoadDone(Loader(param1.target.loader));
         this.cleanupLoader(Loader(param1.target.loader));
      }
      
      private function signalEventLoadDone(param1:Loader) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         try
         {
            _loc2_ = false;
            _loc3_ = false;
            for(_loc4_ in this.history)
            {
               if(this.history[_loc4_].ldr == param1)
               {
                  _loc3_ = true;
                  if(this.history[_loc4_].evt)
                  {
                     _loc2_ = true;
                  }
               }
            }
            if(!_loc3_)
            {
               _loc2_ = Boolean(this.isEvent);
            }
            _loc5_ = this.rootClass.world;
            if(_loc2_ && _loc5_ != null)
            {
               trace("[Load] LoaderMC fileLoaded event (error path) -> world");
               _loc5_.mapEventTrigger({
                  "cmd":"fileLoaded",
                  "args":{"loc":"default"}
               });
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function cleanupLoader(param1:Loader) : void
      {
         var _loc2_:String = null;
         try
         {
            param1.contentLoaderInfo.removeEventListener(Event.INIT,this.onFileLoadComplete);
            param1.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onFileLoadComplete);
            param1.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onFileLoadProgress);
            param1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadError);
            param1.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFileLoadSecurityError);
            for(_loc2_ in this.history)
            {
               if(this.history[_loc2_].ldr == param1)
               {
                  delete this.history[_loc2_];
                  break;
               }
            }
         }
         catch(e:Error)
         {
         }
         this.mcDest = null;
         try
         {
            MovieClip(parent).removeChild(this);
         }
         catch(e:Error)
         {
         }
      }
      
      public function closeHistory(param1:MovieClip = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:Loader = null;
         for(_loc2_ in this.history)
         {
            if(!(param1 != null && this.history[_loc2_].dest != param1))
            {
               trace("[Load] LoaderMC closeHistory killing: " + _loc2_);
               try
               {
                  this.history[_loc2_].ldr.close();
               }
               catch(e:Error)
               {
               }
               try
               {
                  _loc3_ = this.history[_loc2_].ldr;
                  if(_loc3_.content != null && _loc3_.content is MovieClip)
                  {
                     MovieClip(_loc3_.content).stop();
                  }
               }
               catch(e:Error)
               {
               }
               try
               {
                  this.history[_loc2_].ldr.unloadAndStop(true);
               }
               catch(e:Error)
               {
               }
               delete this.history[_loc2_];
            }
         }
         if(param1 == null)
         {
            this.history = {};
         }
      }
      
      private function onCancelClick(param1:MouseEvent) : void
      {
         MovieClip(Game.root).logout();
         MovieClip(parent).removeChild(this);
      }
   }
}

