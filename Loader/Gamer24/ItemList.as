package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   
   public class ItemList extends MovieClip
   {
      public var btnDown:SimpleButton;
      
      public var btnUp:SimpleButton;
      
      public var mcScrollBar:MovieClip;
      
      public var mcSort:MovieClip;
      
      internal var rootClass:MovieClip;
      
      internal var inventorySlot:Number = 20;
      
      internal var intSelected:Number = -1;
      
      internal var intPlacement:Number = 0;
      
      internal var itemList:Array;
      
      internal var sortedList:Array;
      
      internal var strSortBy:String = "all";
      
      public function ItemList()
      {
         var _loc2_:MovieClip = null;
         this.rootClass = MovieClip(Game.root);
         super();
         this.mcSort.visible = false;
         this.mcScrollBar.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,false,0,true);
         this.btnUp.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler,false,0,true);
         this.btnDown.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler,false,0,true);
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = new InventoryItem();
            _loc2_.name = "mcInventoryItem" + _loc1_;
            _loc2_.y = 22 * _loc1_;
            _loc2_.strIndex.text = "";
            _loc2_.strName.text = "";
            _loc2_.strLevel.text = "";
            _loc2_.intIndex = -1;
            this.addChild(_loc2_);
            _loc1_++;
         }
         this.mcSort.btnAll.addEventListener(MouseEvent.CLICK,this.onSortClick,false,0,true);
         this.mcSort.btnArmor.addEventListener(MouseEvent.CLICK,this.onSortClick,false,0,true);
         this.mcSort.btnWeapon.addEventListener(MouseEvent.CLICK,this.onSortClick,false,0,true);
         this.mcSort.btnHelm.addEventListener(MouseEvent.CLICK,this.onSortClick,false,0,true);
         this.mcSort.btnBack.addEventListener(MouseEvent.CLICK,this.onSortClick,false,0,true);
         this.mcSort.btnPet.addEventListener(MouseEvent.CLICK,this.onSortClick,false,0,true);
         this.mcSort.btnItem.addEventListener(MouseEvent.CLICK,this.onSortClick,false,0,true);
         this.mcSort.btnDesign.addEventListener(MouseEvent.CLICK,this.onSortClick,false,0,true);
      }
      
      private function onSortClick(param1:Event) : void
      {
         switch(param1.target.name)
         {
            case "btnAll":
               this.sortBy("all");
               break;
            case "btnArmor":
               this.sortBy("armor");
               break;
            case "btnWeapon":
               this.sortBy("weapon");
               break;
            case "btnHelm":
               this.sortBy("helm");
               break;
            case "btnBack":
               this.sortBy("back");
               break;
            case "btnPet":
               this.sortBy("pet");
               break;
            case "btnItem":
               this.sortBy("item");
               break;
            case "btnDesign":
               this.sortBy("design");
         }
      }
      
      public function sort() : void
      {
         this.sortBy(this.strSortBy);
      }
      
      public function sortBy(param1:String) : void
      {
         var _loc4_:Object = null;
         this.strSortBy = param1.toLowerCase();
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.itemList.length)
         {
            _loc4_ = this.itemList[_loc3_];
            switch(param1.toLowerCase())
            {
               case "all":
                  _loc2_.push(_loc4_);
                  break;
               case "armor":
                  if(_loc4_.sES == "ar" || _loc4_.sES == "co")
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case "weapon":
                  if(_loc4_.sES == "Weapon")
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case "helm":
                  if(_loc4_.sES == "he")
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case "back":
                  if(_loc4_.sES == "ba")
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case "pet":
                  if(_loc4_.sES == "pe")
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case "item":
                  if(_loc4_.sES == "None")
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case "design":
                  if(_loc4_.sES != "co" && _loc4_.sES != "None" && _loc4_.EnhID <= 0)
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case "nonac":
                  if(_loc4_.bCoins == 0)
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case "ac":
                  if(_loc4_.bCoins == 1)
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               default:
                  _loc2_.push(_loc4_);
                  break;
            }
            _loc3_++;
         }
         this.inventorySlot = _loc2_.length;
         this.sortedList = _loc2_;
         this.reset();
      }
      
      private function get intScrollCount() : Number
      {
         return this.inventorySlot - 10;
      }
      
      public function clearSelection() : void
      {
         var _loc1_:* = MovieClip(this.getChildByName("mcInventoryItem" + (this.intSelected - this.intPlacement)));
         if(_loc1_ != null)
         {
            _loc1_.reset();
         }
         this.intSelected = -1;
         if(this.intPlacement != 0)
         {
            this.intPlacement = 0;
            this.mcScrollBar.mcSlider.y = 0;
         }
         MovieClip(parent).refreshDetail();
      }
      
      public function init(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.itemList = param1;
         if(this.itemList == this.rootClass.world.myAvatar.items)
         {
            this.mcSort.visible = true;
         }
         this.mcScrollBar.mcSlider.visible = this.intScrollCount > 0;
         this.sort();
      }
      
      public function reset() : void
      {
         this.clearSelection();
         this.refreshList();
      }
      
      public function refreshList() : void
      {
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Class = null;
         var _loc10_:* = undefined;
         var _loc11_:Class = null;
         var _loc12_:MovieClip = null;
         var _loc13_:Number = NaN;
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = this.sortedList[_loc1_ + this.intPlacement];
            _loc3_ = MovieClip(this.getChildByName("mcInventoryItem" + _loc1_));
            _loc3_.strIndex.text = _loc1_ + this.intPlacement + 1;
            if(this.intSelected == _loc1_ + this.intPlacement)
            {
               _loc3_.select();
            }
            else
            {
               _loc3_.reset();
            }
            _loc3_.intIndex = _loc1_ + this.intPlacement;
            if(_loc2_ == null)
            {
               _loc3_.clearText();
               _loc3_.unequip();
            }
            else
            {
               if(_loc2_.sType == "Enhancement")
               {
                  _loc2_.sIcon = this.getESIcon(_loc2_.sES);
                  _loc2_.EnhLvl = _loc2_.iLvl;
               }
               _loc4_ = "#E6E2DB";
               if(_loc2_.bUpg == 1)
               {
                  _loc4_ = "#FFB817";
               }
               _loc3_.strName.htmlText = "<font color=\'" + _loc4_ + "\'>" + _loc2_.sName + "</font>";
               if(_loc2_.EnhLvl != null)
               {
                  _loc3_.strLevel.text = "Lvl " + _loc2_.EnhLvl;
               }
               else
               {
                  _loc3_.strLevel.text = "";
               }
               if(_loc2_.bEquip)
               {
                  _loc3_.equip();
               }
               else
               {
                  _loc3_.unequip();
               }
               _loc5_ = 21;
               _loc6_ = 19;
               _loc7_ = _loc5_;
               _loc8_ = _loc6_;
               _loc3_.icon.removeAllChildren();
               if(_loc2_.sIcon != null && _loc2_.sIcon != "" && _loc2_.sIcon != "none")
               {
                  try
                  {
                     _loc9_ = this.rootClass.world.getClass(_loc2_.sIcon) as Class;
                     _loc10_ = _loc3_.icon.addChild(new _loc9_());
                     _loc7_ = _loc10_.width;
                     _loc8_ = _loc10_.height;
                     if(_loc7_ > _loc8_)
                     {
                        _loc10_.scaleX = _loc10_.scaleY = _loc5_ / _loc7_;
                     }
                     else
                     {
                        _loc10_.scaleX = _loc10_.scaleY = _loc6_ / _loc8_;
                     }
                     _loc3_.icon.visible = true;
                  }
                  catch(err:Error)
                  {
                  }
               }
               if(this.isEnhanceable(_loc2_.sES) && _loc2_.EnhID <= 0)
               {
                  _loc11_ = this.rootClass.world.getClass("iidesign") as Class;
                  _loc12_ = new _loc11_();
                  _loc12_.alpha = 0.4;
                  _loc7_ = _loc12_.width;
                  _loc8_ = _loc12_.height;
                  if(_loc7_ > _loc8_)
                  {
                     _loc12_.scaleX = _loc12_.scaleY = _loc5_ / _loc7_;
                  }
                  else
                  {
                     _loc12_.scaleX = _loc12_.scaleY = _loc6_ / _loc8_;
                  }
                  _loc3_.icon.addChild(_loc12_);
               }
               if(_loc2_.sES == "ar" && _loc2_.EnhID > 0)
               {
                  _loc13_ = Number(this.rootClass.getRankFromPoints(_loc2_.iQty));
                  _loc3_.strName.htmlText += " <font color=\'#999999\'>(Rank " + _loc13_ + ")</font>";
               }
               if(_loc2_.iStk > 1)
               {
                  _loc3_.strName.htmlText += " <font color=\'#999999\'>x" + _loc2_.iQty + "</font>";
               }
            }
            _loc1_++;
         }
      }
      
      public function isEnhanceable(param1:String) : Boolean
      {
         var _loc2_:Array = ["Weapon","he","ba","pe","ar"];
         return _loc2_.indexOf(param1) >= 0;
      }
      
      public function getESIcon(param1:String) : String
      {
         switch(param1)
         {
            case "Weapon":
               return "iwsword";
            case "he":
               return "iihelm";
            case "ba":
               return "iicape";
            case "pe":
               return "iipet";
            case "ar":
               return "iiclass";
            case "co":
               return "iwarmor";
            case "ho":
               return "ihhouse";
            default:
               return "none";
         }
      }
      
      public function selectItem(param1:int) : void
      {
         var _loc3_:* = undefined;
         if(param1 == -1)
         {
            return;
         }
         if(this.intSelected - this.intPlacement >= 0 && this.intSelected - this.intPlacement < 10)
         {
            _loc3_ = MovieClip(this.getChildByName("mcInventoryItem" + (this.intSelected - this.intPlacement)));
            _loc3_.reset();
         }
         this.rootClass.mixer.playSound("Click");
         this.intSelected = param1;
         var _loc2_:* = MovieClip(this.getChildByName("mcInventoryItem" + (this.intSelected - this.intPlacement)));
         _loc2_.select();
         MovieClip(parent).refreshDetail();
      }
      
      internal function get selectedItem() : Object
      {
         if(this.itemList == null)
         {
            return null;
         }
         return this.sortedList[this.intSelected];
      }
      
      internal function mouseDownHandler(param1:Event) : void
      {
         this.mcScrollBar.mcSlider.startDrag(false,new Rectangle(0,0,0,103));
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,false,0,true);
      }
      
      internal function mouseUpHandler(param1:Event) : void
      {
         this.mcScrollBar.mcSlider.stopDrag();
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
      }
      
      internal function mouseMoveHandler(param1:Event) : void
      {
         var _loc2_:int = this.mcScrollBar.mcSlider.y * this.intScrollCount / 103;
         if(_loc2_ >= 0 && _loc2_ <= this.intScrollCount)
         {
            this.intPlacement = _loc2_;
         }
         this.refreshList();
      }
      
      private function onBtnClickHandler(param1:Event) : void
      {
         if(param1.currentTarget.name == "btnUp")
         {
            if(this.intPlacement > 0)
            {
               --this.intPlacement;
            }
         }
         else if(param1.currentTarget.name == "btnDown")
         {
            if(this.intPlacement < this.intScrollCount)
            {
               ++this.intPlacement;
            }
         }
         this.refreshList();
         this.mcScrollBar.mcSlider.y = Math.ceil(this.intPlacement * 103 / this.intScrollCount);
      }
   }
}

