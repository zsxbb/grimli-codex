package types
{
   public class ResponseData
   {
      public var messageType:String;
      
      public var data:Object;
      
      public var error:String;
      
      public var success:Boolean;
      
      public function ResponseData()
      {
         super();
         this.messageType = "";
         this.data = {};
         this.error = "";
         this.success = false;
      }
      
      public static function fromObject(param1:Object) : ResponseData
      {
         var _loc2_:ResponseData = new ResponseData();
         if(param1)
         {
            _loc2_.messageType = String(param1.messageType || "");
            _loc2_.data = param1.data || {};
            _loc2_.error = String(param1.error || "");
            _loc2_.success = Boolean(param1.success);
         }
         return _loc2_;
      }
      
      public function toObject() : Object
      {
         return {
            "messageType":this.messageType,
            "data":this.data,
            "error":this.error,
            "success":this.success
         };
      }
   }
}

