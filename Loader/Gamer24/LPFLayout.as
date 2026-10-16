package
{
   import flash.display.*;
   import flash.text.*;
   
   public class LPFLayout extends MovieClip
   {
      public var panels:Array;
      
      public var fData:Object;
      
      public var w:int;
      
      public var h:int;
      
      public var panelID:int = 0;
      
      public var events:Object;
      
      public var sMode:String;
      
      public function LPFLayout()
      {
         this.events = {};
         super();
      }
      
      public function update(param1:Object) : *
      {
         param1 = this.handleUpdate(param1);
         this.notifyByEventType(param1);
      }
      
      protected function handleUpdate(param1:Object) : Object
      {
         return param1;
      }
      
      public function notifyByEventType(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         if(param1 != null)
         {
            if(this.events[param1.eventType] != null)
            {
               _loc2_ = this.events[param1.eventType];
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  _loc2_[_loc3_].notify(param1);
                  _loc3_++;
               }
            }
         }
      }
      
      public function registerForEvents(param1:LPFFrame, param2:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_ = param2[_loc4_];
            if(this.events[_loc3_] == null)
            {
               this.events[_loc3_] = [];
            }
            if(this.events[_loc3_].indexOf(param1) == -1)
            {
               this.events[_loc3_].push(param1);
            }
            _loc4_++;
         }
      }
      
      public function unregisterFrame(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc4_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.eventTypes.length)
         {
            _loc2_ = param1.eventTypes[_loc3_];
            if(this.events[_loc2_] == null)
            {
               return;
            }
            _loc4_ = int(this.events[_loc2_].indexOf(param1));
            while(_loc4_ > -1)
            {
               this.events[_loc2_].splice(_loc4_,1);
               _loc4_ = int(this.events[_loc2_].indexOf(param1));
            }
            _loc3_++;
         }
      }
      
      public function addPanel(param1:Object) : MovieClip
      {
         var _loc2_:LPFPanel = addChild(param1.panel) as LPFPanel;
         _loc2_.subscribeTo(this);
         this.panels.push({
            "mc":_loc2_,
            "id":this.panelID++
         });
         _loc2_.fOpen(param1);
         return _loc2_;
      }
      
      public function delPanel(param1:*) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.panels.length)
         {
            if(this.panels[_loc2_].mc == param1)
            {
               this.panels.splice(_loc2_,1);
            }
            _loc2_++;
         }
         removeChild(param1);
      }
      
      public function fOpen(param1:Object) : void
      {
         var _loc2_:Object = null;
         this.fData = param1.fData;
         _loc2_ = param1.r;
         x = _loc2_.x;
         y = _loc2_.y;
         this.w = _loc2_.w;
         this.h = _loc2_.h;
      }
      
      public function fClose() : void
      {
         var _loc1_:MovieClip = null;
         while(this.panels.length > 0)
         {
            this.panels[0].mc.fClose();
            this.panels.shift();
         }
         if(parent != null)
         {
            _loc1_ = MovieClip(parent);
            _loc1_.removeChild(this);
            _loc1_.onClose();
         }
      }
      
      protected function tempFill() : void
      {
      }
   }
}

