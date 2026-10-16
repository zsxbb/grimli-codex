package types
{
   import flash.display.*;
   import flash.utils.*;
   
   public class LoaderSlot implements IDisposable
   {
      public var id:String;
      
      public var n:String;
      
      public var ldr:Loader;
      
      public var timer:Timer;
      
      public var loaderData:LoaderData;
      
      public var free:Boolean = true;
      
      public var isOpen:Boolean = false;
      
      public var lastBytes:Number = -1;
      
      public var url:String = "";
      
      public var callBackA:Function;
      
      public var callBackB:Function;
      
      public var loadCount:int = 0;
      
      public var errorCount:int = 0;
      
      public var lastUsed:Number = 0;
      
      private var _disposed:Boolean = false;
      
      public function LoaderSlot(param1:String, param2:int = 5000)
      {
         super();
         this.id = param1;
         this.n = param1;
         this.ldr = new Loader();
         this.timer = new Timer(param2,1);
      }
      
      public function assign(param1:LoaderData) : void
      {
         this.loaderData = param1;
         this.callBackA = param1 != null ? param1.callBackA : null;
         this.callBackB = param1 != null ? param1.callBackB : null;
         this.free = false;
         this.isOpen = false;
         this.lastBytes = -1;
         this.lastUsed = new Date().time;
         if(param1 != null)
         {
            ++this.loadCount;
         }
      }
      
      public function reset() : void
      {
         this.loaderData = null;
         this.callBackA = null;
         this.callBackB = null;
         this.free = true;
         this.isOpen = false;
         this.lastBytes = -1;
         this.url = "";
         this.timer.stop();
         this.timer.reset();
      }
      
      public function dispose() : void
      {
         if(this._disposed)
         {
            return;
         }
         this.reset();
         try
         {
            if(this.ldr)
            {
               this.ldr.close();
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(this.ldr)
            {
               this.ldr.unloadAndStop(true);
            }
         }
         catch(e:Error)
         {
         }
         this.ldr = null;
         this.timer = null;
         this._disposed = true;
      }
      
      public function get disposed() : Boolean
      {
         return this._disposed;
      }
   }
}

