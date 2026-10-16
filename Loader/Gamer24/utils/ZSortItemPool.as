package utils
{
   import flash.display.MovieClip;
   import types.*;
   
   public class ZSortItemPool
   {
      private static var _pool:Vector.<ZSortItem> = new Vector.<ZSortItem>();
      
      private static const MAX_SIZE:int = 100;
      
      public function ZSortItemPool()
      {
         super();
      }
      
      public static function getItem(param1:MovieClip, param2:Number) : ZSortItem
      {
         var _loc3_:ZSortItem = null;
         if(_pool.length > 0)
         {
            _loc3_ = _pool.pop();
            _loc3_.mc = param1;
            _loc3_.oy = param2;
            return _loc3_;
         }
         return new ZSortItem(param1,param2);
      }
      
      public static function releaseItem(param1:ZSortItem) : void
      {
         if(param1 != null && _pool.length < MAX_SIZE)
         {
            param1.mc = null;
            _pool.push(param1);
         }
      }
      
      public static function releaseAll(param1:Vector.<ZSortItem>) : void
      {
         var _loc2_:int = int(param1.length - 1);
         while(_loc2_ >= 0)
         {
            releaseItem(param1[_loc2_]);
            _loc2_--;
         }
      }
      
      public static function clear() : void
      {
         _pool.length = 0;
      }
   }
}

