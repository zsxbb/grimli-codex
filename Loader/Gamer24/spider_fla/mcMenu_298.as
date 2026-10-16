package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   
   public dynamic class mcMenu_298 extends MovieClip
   {
      public var btnBag:SimpleButton;
      
      public var btnBook:SimpleButton;
      
      public var btnChar:MovieClip;
      
      public var btnHouse:MovieClip;
      
      public var btnMap:SimpleButton;
      
      public var btnMenu:SimpleButton;
      
      public var btnOption:SimpleButton;
      
      public var btnQuest:MovieClip;
      
      public var btnRest:SimpleButton;
      
      public var menu:*;
      
      public function mcMenu_298()
      {
         super();
      }
      
      public function onMouseOver(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = !!stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc2_ || !_loc2_.ui || !_loc2_.ui.ToolTip)
         {
            return;
         }
         var _loc3_:* = _loc2_.ui.ToolTip;
         switch(param1.currentTarget.name)
         {
            case "btnRest":
               _loc3_.openWith({"str":"Rest"});
               break;
            case "btnBag":
               _loc3_.openWith({"str":"Inventory"});
               break;
            case "btnTemp":
               _loc3_.openWith({"str":"Temp Inventory"});
               break;
            case "btnMenu":
               _loc3_.openWith({"str":"Game Menu"});
               break;
            case "btnMap":
               _loc3_.openWith({"str":"Map"});
               break;
            case "btnOption":
               _loc3_.openWith({"str":"Options"});
               break;
            case "btnQuest":
               _loc3_.openWith({"str":"Quests"});
               break;
            case "btnBook":
               _loc3_.openWith({"str":"Book of Lore"});
               break;
            case "btnHouse":
               _loc3_.openWith({"str":"House"});
               break;
            case "btnChar":
               if(this.menu == null)
               {
                  _loc3_.openWith({"str":"Character"});
               }
         }
      }
      
      public function onMouseOut(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = !!stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc2_ || !_loc2_.ui || !_loc2_.ui.ToolTip)
         {
            return;
         }
         _loc2_.ui.ToolTip.close();
      }
      
      public function onMouseClick(param1:MouseEvent) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:MovieClip = null;
         var _loc2_:MovieClip = !!stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc2_)
         {
            return;
         }
         if(MovieClip(Game.root) != null && MovieClip(Game.root).mixer != null)
         {
            MovieClip(Game.root).mixer.playSound("Click");
         }
         if(param1.currentTarget.name != "btnMenu")
         {
            if(_loc2_.menuClose != null)
            {
               _loc2_.menuClose();
            }
         }
         switch(param1.currentTarget.name)
         {
            case "btnRest":
               this.handleMenu(null);
               _loc3_ = parent;
               _loc4_ = !!_loc3_ ? _loc3_.parent : null;
               _loc5_ = !!_loc4_ ? _loc4_.parent as MovieClip : null;
               if((_loc5_) && _loc5_.world && _loc5_.world.rest != null)
               {
                  _loc5_.world.rest();
               }
               break;
            case "btnBag":
               this.handleMenu(null);
               this.toggleInventory();
               break;
            case "btnMenu":
               this.handleMenu(null);
               _loc2_.MenuShow();
               break;
            case "btnMap":
               if(Boolean(_loc2_.ui) && Boolean(_loc2_.ui.mcPopup))
               {
                  if(_loc2_.ui.mcPopup.currentLabel == "Map")
                  {
                     _loc2_.ui.mcPopup.onClose();
                  }
                  else
                  {
                     this.handleMenu(null);
                     _loc2_.ui.mcPopup.fOpen("Map");
                  }
               }
               break;
            case "btnBook":
               if(Boolean(_loc2_.ui) && Boolean(_loc2_.ui.mcPopup))
               {
                  if(_loc2_.ui.mcPopup.currentLabel == "Book")
                  {
                     _loc2_.ui.mcPopup.onClose();
                  }
                  else
                  {
                     this.handleMenu(null);
                     _loc2_.ui.mcPopup.fOpen("Book");
                  }
               }
               break;
            case "btnOption":
               if(Boolean(_loc2_.ui) && Boolean(_loc2_.ui.mcPopup))
               {
                  if(_loc2_.ui.mcPopup.currentLabel == "Option")
                  {
                     _loc2_.ui.mcPopup.onClose();
                  }
                  else
                  {
                     this.handleMenu(null);
                     _loc2_.ui.mcPopup.fOpen("Option");
                  }
               }
               break;
            case "btnQuest":
               this.handleMenu(MovieClip(param1.currentTarget));
               break;
            case "btnHouse":
               if(_loc2_.world)
               {
                  if(_loc2_.world.strMapName && _loc2_.world.strMapName.toLowerCase() == "house" && _loc2_.world.isMyHouse != null && Boolean(_loc2_.world.isMyHouse()))
                  {
                     if(_loc2_.world.moveToCell != null)
                     {
                        _loc2_.world.moveToCell("Enter","Spawn");
                     }
                     break;
                  }
                  if(_loc2_.world.isHouseEquipped != null && Boolean(_loc2_.world.isHouseEquipped()))
                  {
                     if(_loc2_.world.gotoHouse != null && _loc2_.sfc && Boolean(_loc2_.sfc.myUserName))
                     {
                        _loc2_.world.gotoHouse(_loc2_.sfc.myUserName);
                     }
                  }
                  else if(_loc2_.world.gotoTown != null)
                  {
                     _loc2_.world.gotoTown("buyhouse","Enter","Spawn");
                  }
               }
               break;
            case "btnChar":
               this.handleMenu(MovieClip(param1.currentTarget));
         }
      }
      
      public function handleMenu(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         if(param1 == null)
         {
            if(this.menu == null)
            {
               return;
            }
            _loc2_ = MovieClip(this.getChildByName(this.menu.btnOpen));
            if(Boolean(_loc2_) && Boolean(this.menu.mcMenu))
            {
               _loc2_.removeChild(this.menu.mcMenu);
            }
            this.menu = null;
            return;
         }
         if(this.menu == null)
         {
            _loc3_ = !!stage ? stage.getChildAt(0) as MovieClip : null;
            if(_loc3_)
            {
               this.menu = new interfaceMenu(param1.buttons,param1.name,_loc3_);
               if(this.menu && Boolean(this.menu.mcMenu))
               {
                  param1.addChild(this.menu.mcMenu);
               }
            }
         }
         else if(param1 == null || this.menu.btnOpen == param1.name)
         {
            if(this.menu && Boolean(this.menu.mcMenu))
            {
               param1.removeChild(this.menu.mcMenu);
            }
            this.menu = null;
         }
         else
         {
            _loc4_ = MovieClip(this.getChildByName(this.menu.btnOpen));
            if((_loc4_) && this.menu && Boolean(this.menu.mcMenu))
            {
               _loc4_.removeChild(this.menu.mcMenu);
            }
            this.menu = null;
            _loc5_ = !!stage ? stage.getChildAt(0) as MovieClip : null;
            if(_loc5_)
            {
               this.menu = new interfaceMenu(param1.buttons,param1.name,_loc5_);
               if(this.menu && Boolean(this.menu.mcMenu))
               {
                  param1.addChild(this.menu.mcMenu);
               }
            }
         }
      }
      
      public function toggleTempInventory() : void
      {
         var _loc1_:MovieClip = !!stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc1_ || !_loc1_.world || !_loc1_.ui || !_loc1_.ui.mcPopup)
         {
            return;
         }
         if(!_loc1_.world.uiLock)
         {
            if(_loc1_.ui.mcPopup.currentLabel == "Temp")
            {
               if(_loc1_.ui.mcPopup.onClose != null)
               {
                  _loc1_.ui.mcPopup.onClose();
               }
            }
            else if(_loc1_.ui.mcPopup.fOpen != null)
            {
               _loc1_.ui.mcPopup.fOpen("Temp");
            }
         }
      }
      
      public function toggleInventory() : void
      {
         var _loc2_:MovieClip = null;
         var _loc1_:MovieClip = !!stage ? stage.getChildAt(0) as MovieClip : null;
         if(!_loc1_ || !_loc1_.world || !_loc1_.ui || !_loc1_.ui.mcPopup)
         {
            return;
         }
         if(!_loc1_.world.uiLock)
         {
            if(_loc1_.ui.mcPopup.currentLabel == "Inventory" || _loc1_.ui.mcPopup.currentLabel == "HouseInventory")
            {
               _loc2_ = _loc1_.ui.mcPopup.getChildByName("mcInventory") as MovieClip;
               if(Boolean(_loc2_) && _loc2_.fClose != null)
               {
                  _loc2_.fClose();
               }
            }
            else if(_loc1_.ui.mcPopup.fOpen != null)
            {
               _loc1_.ui.mcPopup.fOpen("Inventory");
            }
         }
      }
   }
}

