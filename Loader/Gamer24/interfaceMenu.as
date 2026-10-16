package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   
   public class interfaceMenu extends MovieClip
   {
      public var mcMenu:MovieClip;
      
      private var currentPos:Number;
      
      private var h:Number = 25.2;
      
      private var w:Number = 118.25;
      
      public var btnOpen:String = "";
      
      private var rootClass:MovieClip;
      
      public function interfaceMenu(param1:Array, param2:String, param3:MovieClip)
      {
         var _loc4_:MovieClip = null;
         var _loc5_:uint = 0;
         super();
         this.btnOpen = param2;
         this.rootClass = param3;
         this.mcMenu = new MovieClip();
         _loc4_ = new menuBottom() as MovieClip;
         --_loc4_.height;
         --_loc4_.width;
         _loc4_.x -= 43;
         _loc4_.y -= 10.7;
         this.currentPos = _loc4_.y - 2;
         this.mcMenu.addChild(_loc4_);
         _loc4_ = new menuListItem() as MovieClip;
         _loc4_.x += 17;
         _loc4_.height = this.h;
         _loc4_.width = this.w;
         _loc4_.mTxt.text = param1[0].txt;
         _loc4_.y = this.currentPos - (this.h >> 1) + 1;
         _loc4_.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         _loc4_.buttonMode = true;
         _loc4_.mouseChildren = false;
         _loc4_.name = param1[0].fct;
         this.currentPos = _loc4_.y;
         this.mcMenu.addChild(_loc4_);
         _loc5_ = 1;
         while(_loc5_ < param1.length - 1)
         {
            _loc4_ = new menuListItem() as MovieClip;
            _loc4_.x += 17;
            _loc4_.height = this.h;
            _loc4_.width = this.w;
            _loc4_.y = this.currentPos - this.h + 1;
            this.currentPos = _loc4_.y;
            _loc4_.mTxt.text = param1[_loc5_].txt;
            _loc4_.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
            _loc4_.buttonMode = true;
            _loc4_.mouseChildren = false;
            _loc4_.name = param1[_loc5_].fct;
            this.mcMenu.addChild(_loc4_);
            _loc5_++;
         }
         _loc4_ = new menuTop() as MovieClip;
         --_loc4_.height;
         --_loc4_.width;
         _loc4_.y = this.currentPos - _loc4_.height;
         _loc4_.txt.text = param1[param1.length - 1].txt;
         _loc4_.x += 17;
         this.mcMenu.addChild(_loc4_);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc3_:Function = null;
         var _loc2_:Array = param1.currentTarget.name.split(".");
         switch(_loc2_.length)
         {
            case 1:
               _loc3_ = this[param1.currentTarget.name];
               break;
            case 2:
               _loc3_ = this.rootClass[_loc2_[1]];
               break;
            case 3:
               _loc3_ = this.rootClass.world[_loc2_[2]];
         }
         _loc3_();
      }
      
      private function gotoMyHouse() : void
      {
         if(this.rootClass.world.strMapName.toLowerCase() == "house" && Boolean(this.rootClass.world.isMyHouse()))
         {
            this.rootClass.world.moveToCell("Enter","Spawn");
         }
         if(this.rootClass.world.isHouseEquipped())
         {
            this.rootClass.world.gotoHouse(this.rootClass.sfc.myUserName);
         }
         else
         {
            this.rootClass.world.gotoTown("buyhouse","Enter","Spawn");
         }
      }
      
      private function gotoCentaur() : void
      {
         this.rootClass.world.gotoTown("buyhouse","Enter","Spawn");
      }
      
      private function toggleHouseInventory() : void
      {
         if(!this.rootClass.world.uiLock)
         {
            if(this.rootClass.ui.mcPopup.currentLabel == "HouseInventory")
            {
               MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcInventory")).fClose();
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("HouseInventory");
            }
         }
      }
      
      private function charPage() : void
      {
         var _loc1_:String = this.rootClass.world.myAvatar.objData.strUsername;
         if(this.rootClass.params.strSourceID == "BBGames")
         {
            navigateToURL(new URLRequest("https://www.aq.com/embed/bbgames/aw-character.asp?id=" + _loc1_),"_blank");
         }
         else
         {
            navigateToURL(new URLRequest("https://www.aq.com/aw-character.asp?id=" + _loc1_),"_blank");
         }
      }
      
      private function toggleTempInventory() : void
      {
         if(!this.rootClass.world.uiLock)
         {
            if(this.rootClass.ui.mcPopup.currentLabel == "Temp")
            {
               this.rootClass.ui.mcPopup.onClose();
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("Temp");
            }
         }
      }
      
      private function toggleInventory() : void
      {
         if(!this.rootClass.world.uiLock)
         {
            if(this.rootClass.ui.mcPopup.currentLabel == "Inventory" || this.rootClass.ui.mcPopup.currentLabel == "HouseInventory")
            {
               MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcInventory")).fClose();
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("Inventory");
            }
         }
      }
   }
}

