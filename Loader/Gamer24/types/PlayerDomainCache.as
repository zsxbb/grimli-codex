package types
{
   import flash.system.*;
   
   public class PlayerDomainCache
   {
      private var cache:Object;
      
      private var lruList:Vector.<String>;
      
      private var maxSize:int = 20;
      
      public function PlayerDomainCache(param1:int = 20)
      {
         this.cache = {};
         this.lruList = new Vector.<String>();
         super();
         this.maxSize = param1;
      }
      
      public function getContext(param1:String) : LoaderContext
      {
         if(param1 == null)
         {
            return null;
         }
         if(this.cache[param1] != null)
         {
            this.updateLRU(param1);
            return this.cache[param1].loaderC;
         }
         if(this.lruList.length >= this.maxSize)
         {
            this.evictLRU();
         }
         var _loc2_:ApplicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
         var _loc3_:LoaderContext = new LoaderContext(false,_loc2_);
         this.cache[param1] = {
            "loaderD":_loc2_,
            "loaderC":_loc3_,
            "lastUsed":new Date().time
         };
         this.lruList.push(param1);
         return _loc3_;
      }
      
      public function remove(param1:String) : void
      {
         if(this.cache[param1] == null)
         {
            return;
         }
         delete this.cache[param1];
         var _loc2_:int = int(this.lruList.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.lruList.splice(_loc2_,1);
         }
      }
      
      public function clear() : void
      {
         this.cache = {};
         this.lruList = new Vector.<String>();
      }
      
      public function getStats() : Object
      {
         return {
            "size":this.lruList.length,
            "maxSize":this.maxSize,
            "entries":this.lruList.slice()
         };
      }
      
      private function updateLRU(param1:String) : void
      {
         if(this.cache[param1] != null)
         {
            this.cache[param1].lastUsed = new Date().time;
         }
      }
      
      private function evictLRU() : void
      {
         var _loc4_:String = null;
         if(this.lruList.length == 0)
         {
            return;
         }
         var _loc1_:String = this.lruList[0];
         var _loc2_:Number = Number(this.cache[_loc1_].lastUsed);
         var _loc3_:int = 1;
         while(_loc3_ < this.lruList.length)
         {
            _loc4_ = this.lruList[_loc3_];
            if(this.cache[_loc4_].lastUsed < _loc2_)
            {
               _loc2_ = Number(this.cache[_loc4_].lastUsed);
               _loc1_ = _loc4_;
            }
            _loc3_++;
         }
         this.remove(_loc1_);
      }
   }
}

