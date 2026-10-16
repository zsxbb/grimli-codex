package
{
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class mapData
   {
      private var rootClass:MovieClip;
      
      private var qID:int;
      
      private var qAccepted:Boolean;
      
      private var qTimer:Timer;
      
      public function mapData(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
      }
      
      public function initObjSess(param1:Array, param2:Array) : void
      {
         var _loc3_:uint = 0;
         if(this.rootClass.world.objSession[this.rootClass.world.strMapName] == null)
         {
            this.rootClass.world.objSession[this.rootClass.world.strMapName] = new Object();
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               this.initClicky(param2[_loc3_],param1[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      public function updateSessArray(param1:String, param2:int = 0) : void
      {
         var _loc3_:Object = this.rootClass.world.objSession[this.rootClass.world.strMapName];
         if(_loc3_ == null)
         {
            _loc3_ = new Object();
            this.rootClass.world.objSession[this.rootClass.world.strMapName] = _loc3_;
         }
         _loc3_[param1 + param2] = true;
      }
      
      public function checkSess(param1:String, param2:int = 0) : Boolean
      {
         var _loc3_:Object = this.rootClass.world.objSession[this.rootClass.world.strMapName];
         return _loc3_ != null && Boolean(_loc3_[param1 + param2]);
      }
      
      public function checkSessArr(param1:String, param2:Array) : Boolean
      {
         var _loc3_:* = this.checkSess(param1,param2[0] - 1);
         var _loc4_:uint = 1;
         while(_loc4_ < param2.length)
         {
            _loc3_ &&= this.checkSess(param1,param2[_loc4_] - 1);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function completeQuest(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         if(param2)
         {
            if(this.rootClass.world.isQuestInProgress(param1))
            {
               _loc3_ = this.rootClass.world.questTree[param1];
               if(_loc3_ != null)
               {
                  if(!this.isOneTimeQuestDone(_loc3_) && _loc3_.status != null && _loc3_.status == "c")
                  {
                     this.rootClass.world.tryQuestComplete(param1);
                  }
               }
               else
               {
                  this.rootClass.world.tryQuestComplete(param1);
               }
            }
         }
         else
         {
            this.rootClass.world.tryQuestComplete(param1);
         }
      }
      
      public function delayedTurnin(param1:int, param2:Boolean = false) : void
      {
         this.qID = param1;
         this.qAccepted = param2;
         this.qTimer = new Timer(3000,1);
         this.qTimer.addEventListener(TimerEvent.TIMER,this.onQuestTimer,false,0,true);
         this.qTimer.start();
      }
      
      public function checkChaos() : Boolean
      {
         var _loc1_:Boolean = Boolean(this.rootClass.world.getAchievement("ia1",20));
         _loc1_ ||= Boolean(this.rootClass.world.getAchievement("ia1",21));
         _loc1_ ||= Boolean(this.rootClass.world.getAchievement("ia1",22));
         return _loc1_ || Boolean(this.rootClass.world.getAchievement("ia1",23));
      }
      
      public function checkUpholder() : Boolean
      {
         var _loc1_:Boolean = Boolean(this.rootClass.world.getAchievement("ip0",3)) || Boolean(this.rootClass.world.getAchievement("ip0",4));
         _loc1_ = _loc1_ || Boolean(this.rootClass.world.getAchievement("ip0",10)) || Boolean(this.rootClass.world.getAchievement("ip0",24));
         _loc1_ = _loc1_ || Boolean(this.rootClass.world.getAchievement("ip1",16)) || Boolean(this.rootClass.world.getAchievement("ip2",27));
         return _loc1_ || Boolean(this.rootClass.world.getAchievement("ip4",22)) || Boolean(this.rootClass.world.getAchievement("ip8",11));
      }
      
      private function onQuestTimer(param1:TimerEvent) : void
      {
         this.qTimer.stop();
         this.qTimer.removeEventListener(TimerEvent.TIMER,this.onQuestTimer);
         this.qTimer = null;
         this.completeQuest(this.qID,this.qAccepted);
      }
      
      private function initClicky(param1:int, param2:String) : void
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1)
         {
            this.rootClass.world.objSession[this.rootClass.world.strMapName][param2 + _loc3_] = false;
            _loc3_++;
         }
      }
      
      private function isOneTimeQuestDone(param1:*) : Boolean
      {
         return param1.bOnce == 1 && (param1.iSlot < 0 || this.rootClass.world.getQuestValue(param1.iSlot) >= param1.iValue);
      }
   }
}

