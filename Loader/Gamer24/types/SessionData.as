package types
{
   public dynamic class SessionData
   {
      public var userId:int;
      
      public var token:String;
      
      public var timestamp:Number;
      
      public var serverHash:String;
      
      public var accessLevel:int;
      
      public var objFoundEggs:Object;
      
      public function SessionData()
      {
         super();
         this.userId = 0;
         this.token = "";
         this.timestamp = 0;
         this.serverHash = "";
         this.accessLevel = 0;
         this.objFoundEggs = {};
      }
      
      public static function fromObject(param1:Object) : SessionData
      {
         var _loc2_:SessionData = new SessionData();
         if(param1)
         {
            _loc2_.userId = int(param1.userId || 0);
            _loc2_.token = String(param1.token || "");
            _loc2_.timestamp = Number(param1.timestamp || 0);
            _loc2_.serverHash = String(param1.serverHash || "");
            _loc2_.accessLevel = int(param1.accessLevel || 0);
         }
         return _loc2_;
      }
      
      public function toObject() : Object
      {
         return {
            "userId":this.userId,
            "token":this.token,
            "timestamp":this.timestamp,
            "serverHash":this.serverHash,
            "accessLevel":this.accessLevel
         };
      }
   }
}

