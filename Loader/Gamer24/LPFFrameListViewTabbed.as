package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.text.*;
   
   public class LPFFrameListViewTabbed extends LPFFrame
   {
      public var bgList:MovieClip;
      
      public var bgTabs:MovieClip;
      
      public var iList:MovieClip;
      
      public var listMask:MovieClip;
      
      public var scr:LPFElementScrollBar;
      
      public var tMsg:TextField;
      
      public var tabs:MovieClip;
      
      private var listA:Array;
      
      private var aSel:Array;
      
      private var iSel:Object;
      
      private var tSel:Object;
      
      private var tabStates:Array;
      
      private var filterMap:Object;
      
      private var itemEventType:String;
      
      private var tabEventType:String;
      
      private var sortOrder:Array;
      
      private var filter:String = "";
      
      private var allowDesel:Boolean = false;
      
      private var onDemand:Boolean = false;
      
      private var openBlank:Boolean = false;
      
      private var refreshTabs:Boolean = false;
      
      private var bLimited:Boolean = false;
      
      private var multiSelect:Boolean = false;
      
      private var itemList:Array;
      
      public function LPFFrameListViewTabbed()
      {
         this.listA = [];
         this.aSel = [];
         this.tabStates = [];
         this.filterMap = {};
         this.sortOrder = [];
         super();
         x = 0;
         y = 0;
         fData = {};
      }
      
      override public function fOpen(param1:Object) : void
      {
         fData = param1.fData;
         this.itemList = fData.list;
         positionBy(param1.r);
         this.drawBG();
         if("tabStates" in param1)
         {
            this.tabStates = param1.tabStates;
         }
         if("filterMap" in param1)
         {
            this.filterMap = param1.filterMap;
         }
         if("sortOrder" in param1)
         {
            this.sortOrder = param1.sortOrder;
         }
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("filter" in param1)
         {
            this.filter = param1.filter;
         }
         if("itemEventType" in param1)
         {
            this.itemEventType = param1.itemEventType;
         }
         if("tabEventType" in param1)
         {
            this.tabEventType = param1.tabEventType;
         }
         if("sName" in param1)
         {
            sName = param1.sName;
         }
         if("allowDesel" in param1)
         {
            this.allowDesel = param1.allowDesel == true;
         }
         if("openBlank" in param1)
         {
            this.openBlank = param1.openBlank == true;
         }
         if("onDemand" in param1)
         {
            this.onDemand = param1.onDemand == true;
         }
         if("refreshTabs" in param1)
         {
            this.refreshTabs = param1.refreshTabs == true;
         }
         if("multiSelect" in param1)
         {
            this.multiSelect = param1.multiSelect == true;
         }
         if("bLimited" in fData)
         {
            this.bLimited = param1.fData.bLimited == true;
         }
         if(!this.openBlank)
         {
            if(this.iSel == null)
            {
               this.tSel = this.getTabByFilter("*");
            }
            else
            {
               this.tSel = this.getTabByFilter(this.iSel.sType);
            }
         }
         this.initTabs();
         this.fDraw();
         getLayout().registerForEvents(this,eventTypes);
      }
      
      private function fRefresh(param1:Object) : void
      {
         if("tabStates" in param1)
         {
            this.tabStates = param1.tabStates;
         }
         if("filterMap" in param1)
         {
            this.filterMap = param1.filterMap;
         }
         if("sortOrder" in param1)
         {
            this.sortOrder = param1.sortOrder;
         }
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("filter" in param1)
         {
            this.filter = param1.filter;
         }
         if("itemEventType" in param1)
         {
            this.itemEventType = param1.itemEventType;
         }
         if("tabEventType" in param1)
         {
            this.tabEventType = param1.tabEventType;
         }
         if("sName" in param1)
         {
            sName = param1.sName;
         }
         this.iSel = null;
         this.tSel = this.getTabByFilter("*");
         if(fData.list != null)
         {
            this.itemList = fData.list;
         }
         this.initTabs();
         this.fDraw();
      }
      
      private function initTabs() : void
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Object = null;
         var _loc8_:DisplayObject = null;
         var _loc9_:String = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = {};
         var _loc4_:Array = [];
         var _loc5_:String = "";
         while(this.tabs.numChildren > 0)
         {
            this.tabs.removeChildAt(0);
         }
         this.bgTabs.graphics.clear();
         _loc2_ = 0;
         while(_loc2_ < this.tabStates.length)
         {
            if(this.onDemand)
            {
               this.tabStates[_loc2_].state = 0;
            }
            else
            {
               this.tabStates[_loc2_].state = -1;
               for each(_loc3_ in fData.list)
               {
                  for(_loc9_ in this.filterMap)
                  {
                     if(this.filterMap[_loc9_].indexOf(_loc3_.sType) > -1 || _loc3_.sType == "Enhancement" && _loc3_.sES == _loc9_)
                     {
                        if(this.tabStates[_loc2_].filter == _loc9_)
                        {
                           this.tabStates[_loc2_].state = 0;
                        }
                     }
                  }
               }
            }
            _loc2_++;
         }
         _loc4_ = [];
         _loc1_ = 0;
         while(_loc1_ < this.tabStates.length)
         {
            _loc3_ = this.tabStates[_loc1_];
            _loc6_ = this.tabs.addChild(new LPFElementListViewTab()) as MovieClip;
            _loc7_ = getLayout().rootClass.world.getClass(_loc3_.icon);
            _loc8_ = _loc6_.icon.addChild(new _loc7_());
            _loc8_.scaleX = _loc8_.scaleY = 16 / _loc8_.height;
            _loc8_.x -= _loc8_.width / 2;
            _loc8_.y = 2;
            _loc6_.icon.mouseEnabled = false;
            _loc6_.icon.mouseChildren = false;
            _loc6_.o = _loc3_;
            _loc3_.mc = _loc6_;
            _loc6_.bg2.visible = false;
            if(_loc3_ == this.tSel)
            {
               _loc3_.state = 1;
            }
            if(_loc3_.state == -1)
            {
               _loc6_.icon.alpha = 0.3;
               _loc6_.bg3.visible = true;
               _loc6_.bg2.visible = false;
               _loc6_.bg.visible = false;
               _loc6_.mouseEnabled = false;
               _loc6_.mouseChildren = false;
            }
            else
            {
               _loc6_.bg3.visible = false;
               _loc6_.buttonMode = true;
               if(_loc3_.state == 1)
               {
                  _loc6_.bg.visible = false;
                  _loc6_.bg2.visible = true;
               }
               _loc6_.addEventListener(MouseEvent.MOUSE_DOWN,this.tabClick,false,0,true);
            }
            _loc6_.x = int((_loc6_.width + 3) * _loc1_) + 1;
            _loc4_.push(_loc6_.getBounds(this.bgTabs));
            _loc1_++;
         }
         this.drawTabBG();
      }
      
      private function fDraw(param1:Boolean = true) : void
      {
         var _loc8_:String = null;
         var _loc10_:LPFElementListItemItem = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:DisplayObject = null;
         this.listA = [];
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc9_:Object = {};
         while(this.iList.numChildren > 0)
         {
            LPFElementListItem(this.iList.getChildAt(0)).fClose();
         }
         if(param1)
         {
            this.iList.y = this.bgTabs.height - 1;
         }
         if(this.tSel == null)
         {
            this.setMessage("No Tab Selected");
            this.scr.fOpen({
               "subject":this.iList,
               "subjectMask":this.listMask,
               "reset":param1
            });
            return;
         }
         this.setMessage("");
         if(this.tSel.filter != "*")
         {
            for each(_loc9_ in this.itemList)
            {
               if(this.filterMap[this.tSel.filter].indexOf(_loc9_.sType) > -1 || _loc9_.sType == "Enhancement" && _loc9_.sES.indexOf(this.tSel.filter) > -1)
               {
                  if(!(this.tSel.filter == "pots" && (_loc9_.sLink != "potion" && _loc9_.sLink != "elixir" && _loc9_.sLink != "tonic" && _loc9_.sLink != "scroll")))
                  {
                     _loc5_.push(_loc9_);
                  }
               }
            }
         }
         else
         {
            _loc5_ = this.itemList;
         }
         if(Boolean(this.onDemand) && _loc5_.length == 0)
         {
            this.setMessage("No items of this type");
            this.scr.fOpen({
               "subject":this.iList,
               "subjectMask":this.listMask,
               "reset":param1
            });
            return;
         }
         _loc6_ = 0;
         while(_loc6_ < this.sortOrder.length)
         {
            _loc2_ = [];
            for each(_loc9_ in _loc5_)
            {
               if(_loc9_.sType == this.sortOrder[_loc6_])
               {
                  _loc2_.push(_loc9_);
               }
            }
            if(_loc2_.length > 0)
            {
               _loc2_.sortOn(["sName","iLvl"],[undefined,Array.DESCENDING | Array.NUMERIC]);
               this.listA = this.listA.concat(_loc2_);
            }
            _loc6_++;
         }
         _loc2_ = [];
         for each(_loc9_ in _loc5_)
         {
            if(this.listA.indexOf(_loc9_) == -1)
            {
               _loc2_.push(_loc9_);
            }
         }
         if(_loc2_.length > 0)
         {
            _loc2_.sortOn(["sType","sName"]);
            this.listA = this.listA.concat(_loc2_);
         }
         var _loc11_:Object = {};
         _loc11_.eventType = this.itemEventType;
         _loc11_.allowDesel = this.allowDesel;
         _loc11_.multiSelect = this.multiSelect;
         _loc11_.bLimited = this.bLimited && getLayout().sMode == "shopBuy";
         _loc6_ = 0;
         while(_loc6_ < this.listA.length)
         {
            _loc11_.fData = this.listA[_loc6_];
            _loc10_ = new LPFElementListItemItem();
            _loc12_ = this.iList.addChild(_loc10_);
            _loc10_.subscribeTo(this);
            _loc10_.fOpen(_loc11_);
            if(_loc10_.fData == this.iSel)
            {
               _loc10_.select();
            }
            if(_loc6_ > 0)
            {
               _loc13_ = this.iList.getChildAt(_loc6_ - 1);
               _loc12_.y = _loc13_.y + _loc13_.height;
            }
            _loc6_++;
         }
         this.scr.fOpen({
            "subject":this.iList,
            "subjectMask":this.listMask,
            "reset":param1
         });
      }
      
      private function getTabByFilter(param1:String) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.tabStates.length)
         {
            _loc2_ = this.tabStates[_loc3_];
            if(_loc2_.filter == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         if(this.tabStates.length > 0 && param1 != "none")
         {
            return this.tabStates[0];
         }
         return null;
      }
      
      private function tabClick(param1:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = MovieClip(param1.currentTarget).o;
         if(this.tSel != null)
         {
            this.tSel.mc.bg.visible = true;
            this.tSel.mc.bg2.visible = false;
            this.tSel.state = 0;
         }
         this.tSel = _loc2_;
         this.tSel.mc.bg.visible = false;
         this.tSel.mc.bg2.visible = true;
         this.tSel.state = 1;
         this.drawTabBG();
         if(this.onDemand)
         {
            _loc3_ = {
               "fData":{"types":this.filterMap[this.tSel.filter]},
               "eventType":this.tabEventType,
               "fCaller":sName
            };
            while(this.iList.numChildren > 0)
            {
               LPFElementListItem(this.iList.getChildAt(0)).fClose();
            }
            this.iList.y = this.bgTabs.height - 1;
            this.update(_loc3_);
         }
         else
         {
            this.fDraw();
         }
      }
      
      private function drawTabBG() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Rectangle = null;
         var _loc5_:MovieClip = null;
         var _loc3_:Graphics = this.bgTabs.graphics;
         var _loc4_:int = this.bgTabs.bg.height - 1;
         _loc3_.clear();
         _loc3_.lineStyle(0,6710886,1);
         _loc3_.moveTo(0,_loc4_);
         if(this.tSel != null)
         {
            _loc5_ = this.tSel.mc;
            if(_loc5_.x > 1)
            {
               _loc3_.lineTo(this.tSel.mc.x,_loc4_);
            }
            _loc3_.moveTo(this.tSel.mc.x + this.tSel.mc.width,_loc4_);
            _loc3_.lineTo(this.bgList.width,_loc4_);
            this.bgTabs.bg.x = this.tSel.mc.x - 1;
            this.bgTabs.bg.visible = true;
         }
         else
         {
            _loc3_.lineTo(this.bgList.width,_loc4_);
            this.bgTabs.bg.visible = false;
         }
      }
      
      private function setMessage(param1:String) : void
      {
         if(param1 != null && param1.length > 0)
         {
            this.tMsg.text = param1;
            this.tMsg.visible = true;
         }
         else
         {
            this.tMsg.text = "";
            this.tMsg.visible = false;
         }
      }
      
      override public function update(param1:Object) : void
      {
         if(param1.eventType == this.itemEventType)
         {
            this.iSel = param1.fData;
         }
         if(param1.eventType == this.tabEventType)
         {
            this.iSel = null;
         }
         getLayout().update(param1);
      }
      
      override public function notify(param1:Object) : void
      {
         if(param1.eventType == "sModeSet")
         {
            fData = param1.fData;
            this.fRefresh(param1);
         }
         if(param1.eventType == "refreshItems")
         {
            if(fData.isBank)
            {
               this.itemList = getLayout().rootClass.world.bankinfo.items;
            }
            if(this.itemList.indexOf(this.iSel) == -1)
            {
               this.iSel = null;
            }
            this.fDraw(false);
            if(this.refreshTabs)
            {
               this.initTabs();
            }
         }
         if(param1.eventType == "refreshInv")
         {
            this.itemList = getLayout().rootClass.world.myAvatar.filtered_inventory;
            this.fDraw(true);
         }
         if(param1.eventType == "refreshBank")
         {
            if(fData.isBank)
            {
               this.itemList = getLayout().rootClass.world.bankinfo.items;
            }
            this.fDraw(fData.isBank != null);
         }
         if(param1.eventType == "listItemASel")
         {
            this.fRefresh(param1);
            if(this.filter != "")
            {
               this.shadeListByTypeFilter(param1.fData);
            }
         }
         if(param1.eventType == this.tabEventType && param1.fData != null)
         {
            if("loadPending" in param1.fData)
            {
               if("msg" in param1.fData)
               {
                  this.setMessage(param1.fData.msg);
               }
            }
         }
      }
      
      private function shadeListByTypeFilter(param1:Object) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         if(param1.eSel != null)
         {
            _loc3_ = param1.eSel;
         }
         if(param1.iSel != null)
         {
            _loc3_ = param1.iSel;
         }
         if(_loc3_ != null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.iList.numChildren)
            {
               _loc2_ = this.iList.getChildAt(_loc4_) as MovieClip;
               if(_loc2_.fData[this.filter] == _loc3_[this.filter] && _loc2_.fData.sType != _loc3_.sType)
               {
                  _loc2_.alpha = 1;
                  _loc2_.mouseEnabled = true;
                  _loc2_.mouseChildren = true;
               }
               else
               {
                  _loc2_.alpha = 0.3;
                  _loc2_.mouseEnabled = false;
                  _loc2_.mouseChildren = false;
               }
               _loc4_++;
            }
         }
      }
      
      public function getListItemByiSel() : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.iList.numChildren)
         {
            _loc2_ = MovieClip(this.iList.getChildAt(_loc1_));
            if(_loc2_.fData == this.iSel)
            {
               return _loc2_;
            }
            _loc1_++;
         }
         return null;
      }
      
      public function getSelected() : int
      {
         var _loc2_:MovieClip = null;
         var _loc1_:int = 0;
         var _loc3_:* = 0;
         while(_loc3_ < this.iList.numChildren)
         {
            _loc2_ = MovieClip(this.iList.getChildAt(_loc3_));
            if(_loc2_.sel)
            {
               _loc1_ += 1;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function getSelectedItems() : Array
      {
         var _loc2_:MovieClip = null;
         var _loc1_:Array = [];
         var _loc3_:* = 0;
         while(_loc3_ < this.iList.numChildren)
         {
            _loc2_ = MovieClip(this.iList.getChildAt(_loc3_));
            if(_loc2_.sel)
            {
               _loc1_.push(_loc2_.fData.ItemID);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      private function drawBG() : void
      {
         this.bgList.width = w;
         this.bgList.height = h - this.listMask.y + 3;
         this.bgList.y = this.listMask.y;
         this.listMask.width = w;
         this.listMask.height = h - this.listMask.y - 0;
         this.scr.b.height = this.listMask.height - 2 * this.scr.a2.height + 1;
         this.scr.hit.height = this.scr.b.height;
         this.scr.hit.alpha = 0;
         this.scr.a2.y = this.scr.b.y + this.scr.b.height + this.scr.a2.height;
         this.scr.x = w + 2;
         this.tMsg.x = Math.round(this.bgList.width / 2 - this.tMsg.width / 2);
         this.tMsg.y = Math.round(this.bgList.y + (this.bgList.height / 2 - this.tMsg.height / 2));
      }
   }
}

