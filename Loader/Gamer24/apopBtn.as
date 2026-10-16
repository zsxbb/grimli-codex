package
{
   import fl.motion.Color;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.text.TextField;
   
   public class apopBtn extends Sprite
   {
      public var txt:TextField;
      
      public var BG:btnBack;
      
      private var rootClass:MovieClip;
      
      private var intAction:int;
      
      private var locksArr:Array;
      
      private var intID:int = -1;
      
      private var strActionData:String;
      
      private var strAction:*;
      
      private var strFrame:String;
      
      private var strMap:String;
      
      private var strPad:String;
      
      private var id:int;
      
      private var tintColor:Color;
      
      private var parent_:apopScene;
      
      private var iconClass:Class;
      
      private var actionParams:Array;
      
      public function apopBtn(param1:MovieClip, param2:Object, param3:apopScene)
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Number = NaN;
         this.locksArr = new Array();
         this.tintColor = new Color();
         super();
         this.rootClass = param1;
         this.tintColor.setTint(16711680,0.27);
         this.parent_ = param3;
         if(param2.width != null)
         {
            this.BG.width = param2.width;
         }
         if(param2 != null)
         {
            this.intAction = int(param2.intAction);
            this.setupLock(String(param2.strLocks));
            this.actionParams = String(param2.strActionData).split(",");
            this.id = int(param2.buttonID);
            this.txt.text = param2.buttonText;
            this.txt.mouseEnabled = false;
            if(param2.strIcon != null)
            {
               this.iconClass = this.rootClass.world.getClass(param2.strIcon);
               _loc4_ = this.addChild(new this.iconClass());
               _loc5_ = 25 / _loc4_.height;
               _loc4_.width *= _loc5_;
               _loc4_.height = 25;
               if(_loc4_.width < 43)
               {
                  _loc4_.x = 43 - _loc4_.width >> 1;
               }
               if(_loc4_.height < 30)
               {
                  _loc4_.y = (30 - _loc4_.height >> 1) + 1;
               }
            }
            this.addEventListener(MouseEvent.MOUSE_UP,this.onClick,false,0,true);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
            this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
            this.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
            this.buttonMode = true;
         }
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.tintColor.setTint(16711680,0);
         this.transform.colorTransform = this.tintColor;
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.tintColor.setTint(16711680,0.27);
         this.transform.colorTransform = this.tintColor;
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         this.tintColor.setTint(16711680,0);
         this.tintColor.brightness = -0.28;
         this.transform.colorTransform = this.tintColor;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.tintColor.setTint(16711680,0);
         this.tintColor.brightness = 0;
         this.transform.colorTransform = this.tintColor;
         if(this.checkLock())
         {
            switch(this.intAction)
            {
               case 0:
                  this.parent_.Parent.showScene(this.actionParams[0]);
                  break;
               case 1:
                  this.rootClass.world.sendLoadShopRequest(this.actionParams[0]);
                  break;
               case 2:
                  this.rootClass.world.sendLoadHairShopRequest(this.actionParams[0]);
                  break;
               case 3:
                  this.rootClass.world.sendLoadEnhShopRequest(this.actionParams[0]);
                  break;
               case 4:
                  this.rootClass.world.attachMovieFront(this.actionParams[0]);
                  break;
               case 5:
                  this.rootClass.loadExternalSWF(this.actionParams[0]);
                  break;
               case 6:
                  this.rootClass.world.gotoTown(this.actionParams[0],this.actionParams[1],this.actionParams[2]);
                  this.rootClass.removeApop();
                  break;
               case 7:
                  this.rootClass.world.moveToCell(this.actionParams[0],this.actionParams[1]);
                  break;
               case 9:
                  this.rootClass.world.acceptQuest(this.parent_.QuestID);
                  this.rootClass.removeApop();
                  break;
               case 10:
                  this.parent_.Back();
                  break;
               case 11:
                  this.rootClass.world.tryQuestComplete(this.parent_.QuestID);
                  break;
               case 12:
                  this.rootClass.world.abandonQuest(this.parent_.QuestID);
                  this.parent_.Back();
            }
         }
      }
      
      private function setupLock(param1:String) : *
      {
         var _loc4_:Array = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = param1.split(";");
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_].split(",");
            switch(_loc4_[0])
            {
               case "QS":
               case "qs":
                  this.locksArr.push({
                     "strType":_loc4_[0],
                     "qsIndex":_loc4_[1],
                     "qsValue":_loc4_[2]
                  });
                  break;
               case "mapVar":
                  this.locksArr.push({
                     "strType":_loc4_[0],
                     "strName":_loc4_[1]
                  });
                  break;
               case "rep":
                  this.locksArr.push({
                     "strType":_loc4_[0],
                     "intRep":_loc4_[1],
                     "intValue":_loc4_[2]
                  });
                  break;
               case "class":
               case "classor":
                  this.locksArr.push({
                     "strType":_loc4_[0],
                     "intClass":_loc4_[1],
                     "intValue":_loc4_[2]
                  });
                  break;
               case "item":
                  this.locksArr.push({
                     "strType":_loc4_[0],
                     "intID":_loc4_[1]
                  });
                  break;
               case "upgrade":
                  this.locksArr.push({"strType":"upgrade"});
                  break;
            }
            _loc3_++;
         }
      }
      
      private function checkLock() : Boolean
      {
         var _loc1_:Boolean = true;
         var _loc2_:uint = 0;
         while(_loc2_ < this.locksArr.length)
         {
            switch(this.locksArr[_loc2_].strType)
            {
               case "QS":
               case "qs":
                  _loc1_ &&= this.rootClass.getQuestValue(this.locksArr[_loc2_].qsIndex) >= this.locksArr[_loc2_].qsValue;
                  break;
               case "mapVar":
                  _loc1_ &&= Boolean(this.rootClass.world.map[this.locksArr[_loc2_].strName]);
                  break;
               case "rep":
                  _loc1_ &&= this.rootClass.world.myAvatar.getRep(this.locksArr[_loc2_].intRep) >= this.locksArr[_loc2_].intValue;
                  break;
               case "class":
                  _loc1_ &&= this.rootClass.world.myAvatar.getCPByID(this.locksArr[_loc2_].intClass) >= Number(this.locksArr[_loc2_].intValue);
                  break;
               case "classor":
                  _loc1_ ||= this.rootClass.world.myAvatar.getCPByID(this.locksArr[_loc2_].intClass) >= Number(this.locksArr[_loc2_].intValue);
                  break;
               case "item":
                  _loc1_ &&= Boolean(this.rootClass.world.myAvatar.isItemInInventory(int(this.locksArr[_loc2_].intID)));
                  break;
               case "upgrade":
                  _loc1_ &&= Boolean(this.rootClass.world.myAvatar.isUpgraded());
                  break;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get ID() : int
      {
         return this.id;
      }
   }
}

