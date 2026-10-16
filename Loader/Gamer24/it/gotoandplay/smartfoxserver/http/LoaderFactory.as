package it.gotoandplay.smartfoxserver.http
{
   import flash.events.*;
   import flash.net.*;
   
   public class LoaderFactory
   {
      private static const DEFAULT_POOL_SIZE:int = 8;
      
      private var loadersPool:Array;
      
      private var currentLoaderIndex:int;
      
      private var _responseHandler:Function;
      
      private var _errorHandler:Function;
      
      public function LoaderFactory(param1:Function, param2:Function, param3:int = 8)
      {
         var _loc5_:URLLoader = null;
         super();
         this.loadersPool = [];
         this._responseHandler = param1;
         this._errorHandler = param2;
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = new URLLoader();
            _loc5_.dataFormat = URLLoaderDataFormat.TEXT;
            _loc5_.addEventListener(Event.COMPLETE,param1);
            _loc5_.addEventListener(IOErrorEvent.IO_ERROR,param2);
            _loc5_.addEventListener(IOErrorEvent.NETWORK_ERROR,param2);
            this.loadersPool.push(_loc5_);
            _loc4_++;
         }
         this.currentLoaderIndex = 0;
      }
      
      public function getLoader() : URLLoader
      {
         var _loc1_:URLLoader = this.loadersPool[this.currentLoaderIndex];
         ++this.currentLoaderIndex;
         if(this.currentLoaderIndex >= this.loadersPool.length)
         {
            this.currentLoaderIndex = 0;
         }
         return _loc1_;
      }
      
      public function dispose() : void
      {
         var _loc2_:URLLoader = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.loadersPool.length)
         {
            _loc2_ = this.loadersPool[_loc1_];
            _loc2_.removeEventListener(Event.COMPLETE,this._responseHandler);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this._errorHandler);
            _loc2_.removeEventListener(IOErrorEvent.NETWORK_ERROR,this._errorHandler);
            try
            {
               _loc2_.close();
            }
            catch(e:Error)
            {
            }
            _loc1_++;
         }
         this.loadersPool = null;
         this._responseHandler = null;
         this._errorHandler = null;
      }
   }
}

