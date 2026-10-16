package types
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   
   public class LoaderError
   {
      public static const CATEGORY_NETWORK:String = "network";
      
      public static const CATEGORY_TIMEOUT:String = "timeout";
      
      public static const CATEGORY_SECURITY:String = "security";
      
      public static const CATEGORY_NOTFOUND:String = "notfound";
      
      public static const CATEGORY_CANCELLED:String = "cancelled";
      
      public var category:String;
      
      public var message:String;
      
      public var url:String;
      
      public var loaderData:LoaderData;
      
      public var originalEvent:Event;
      
      public function LoaderError(param1:String, param2:String, param3:String = null, param4:LoaderData = null)
      {
         super();
         this.category = param1;
         this.message = param2;
         this.url = param3;
         this.loaderData = param4;
      }
      
      public static function fromIOError(param1:IOErrorEvent, param2:String, param3:LoaderData) : LoaderError
      {
         var _loc4_:String = param1.text || param1.toString();
         var _loc5_:String = CATEGORY_NETWORK;
         var _loc6_:String = _loc4_.toLowerCase();
         if(_loc6_.indexOf("404") >= 0 || _loc6_.indexOf("not found") >= 0 || _loc6_.indexOf("#2035") >= 0)
         {
            _loc5_ = CATEGORY_NOTFOUND;
         }
         else if(_loc6_.indexOf("timeout") >= 0)
         {
            _loc5_ = CATEGORY_TIMEOUT;
         }
         var _loc7_:LoaderError = new LoaderError(_loc5_,_loc4_,param2,param3);
         _loc7_.originalEvent = param1;
         return _loc7_;
      }
      
      public static function fromTimeout(param1:String, param2:LoaderData) : LoaderError
      {
         return new LoaderError(CATEGORY_TIMEOUT,"Load timeout",param1,param2);
      }
      
      public static function fromSecurityError(param1:String, param2:LoaderData) : LoaderError
      {
         return new LoaderError(CATEGORY_SECURITY,"Security error",param1,param2);
      }
      
      public static function fromCancellation(param1:String, param2:LoaderData) : LoaderError
      {
         return new LoaderError(CATEGORY_CANCELLED,"Load cancelled",param1,param2);
      }
      
      public function shouldRetry() : Boolean
      {
         switch(this.category)
         {
            case CATEGORY_SECURITY:
            case CATEGORY_NOTFOUND:
            case CATEGORY_CANCELLED:
               return false;
            case CATEGORY_NETWORK:
            case CATEGORY_TIMEOUT:
         }
         return true;
      }
      
      public function toString() : String
      {
         return "[LoaderError category=" + this.category + " message=" + this.message + " url=" + this.url + "]";
      }
   }
}

