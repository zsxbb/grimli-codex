package types
{
   public class LoaderData implements IDisposable
   {
      public var strFile:String;
      
      public var avt:*;
      
      public var sES:String;
      
      public var callBackA:Function;
      
      public var callBackB:Function;
      
      public var callBackProgress:Function;
      
      public var retries:int = 1;
      
      public var maxRetries:int = 1;
      
      public var timeout:int = 5000;
      
      public var priority:int = 0;
      
      public var loadType:String = "default";
      
      public var cancelled:Boolean = false;
      
      public var timestamp:Number;
      
      public var loaderId:String;
      
      public var waiters:Vector.<LoaderData>;
      
      private var _disposed:Boolean = false;
      
      public function LoaderData(param1:String = null, param2:* = null, param3:String = null)
      {
         super();
         this.strFile = param1;
         this.avt = param2;
         this.sES = param3;
         this.timestamp = new Date().time;
      }
      
      public static function fromObject(param1:Object) : LoaderData
      {
         var _loc3_:String = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:LoaderData = new LoaderData();
         for(_loc3_ in param1)
         {
            try
            {
               _loc2_[_loc3_] = param1[_loc3_];
            }
            catch(e:Error)
            {
            }
         }
         if(_loc2_.strFile == null)
         {
            _loc2_.strFile = "";
         }
         if(_loc2_.retries <= 0)
         {
            _loc2_.retries = 1;
         }
         return _loc2_;
      }
      
      public function addWaiter(param1:LoaderData) : void
      {
         if(this.waiters == null)
         {
            this.waiters = new Vector.<LoaderData>();
         }
         this.waiters.push(param1);
      }
      
      public function dispose() : void
      {
         var _loc1_:LoaderData = null;
         if(this._disposed)
         {
            return;
         }
         this.avt = null;
         this.callBackA = null;
         this.callBackB = null;
         this.callBackProgress = null;
         if(this.waiters != null)
         {
            for each(_loc1_ in this.waiters)
            {
               if(_loc1_ != null)
               {
                  _loc1_.dispose();
               }
            }
            this.waiters = null;
         }
         this._disposed = true;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
   }
}

