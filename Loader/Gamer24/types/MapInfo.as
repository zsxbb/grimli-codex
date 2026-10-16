package types
{
   public dynamic class MapInfo
   {
      public var mapID:int;
      
      public var mapName:String;
      
      public var mapFile:String;
      
      public var areaName:String;
      
      public var type:int;
      
      public var killCount:int;
      
      public var difficulty:String;
      
      public function MapInfo()
      {
         super();
         this.mapID = 0;
         this.mapName = "";
         this.mapFile = "";
         this.areaName = "";
         this.type = 0;
         this.killCount = 0;
         this.difficulty = "normal";
      }
      
      public static function fromObject(param1:Object) : MapInfo
      {
         var _loc2_:MapInfo = new MapInfo();
         if(param1)
         {
            _loc2_.mapID = int(param1.mapID || param1.iMapID || 0);
            _loc2_.mapName = String(param1.mapName || param1.sName || "");
            _loc2_.mapFile = String(param1.mapFile || param1.sFile || "");
            _loc2_.areaName = String(param1.areaName || param1.sArea || "");
            _loc2_.type = int(param1.type || param1.iType || 0);
            _loc2_.killCount = int(param1.killCount || param1.iKillCount || 0);
            _loc2_.difficulty = String(param1.difficulty || param1.sDifficulty || "normal");
         }
         return _loc2_;
      }
      
      public function toObject() : Object
      {
         return {
            "mapID":this.mapID,
            "mapName":this.mapName,
            "mapFile":this.mapFile,
            "areaName":this.areaName,
            "type":this.type,
            "killCount":this.killCount,
            "difficulty":this.difficulty
         };
      }
   }
}

