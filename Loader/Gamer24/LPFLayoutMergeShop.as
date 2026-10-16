package
{
   import flash.display.*;
   import flash.text.*;
   
   public class LPFLayoutMergeShop extends LPFLayout
   {
      public var iQty:int = 1;
      
      private var aSel:String = "";
      
      private var bSel:String = "";
      
      public var iSel:Object;
      
      public var eSel:Object;
      
      public var itemsInv:Array;
      
      public var itemsShop:Array;
      
      public var mergePanel:MovieClip;
      
      public var rootClass:MovieClip;
      
      public function LPFLayoutMergeShop()
      {
         super();
         x = 0;
         y = 0;
         panels = [];
         fData = {};
      }
      
      override public function fOpen(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:MovieClip = null;
         this.rootClass = MovieClip(stage.getChildAt(0));
         fData = param1.fData;
         sMode = param1.sMode;
         if("itemsInv" in fData)
         {
            this.itemsInv = fData.itemsInv;
         }
         if("itemsShop" in fData)
         {
            this.itemsShop = fData.itemsShop;
         }
         _loc2_ = param1.r;
         var _loc3_:String = "";
         x = _loc2_.x;
         y = _loc2_.y;
         w = _loc2_.w;
         h = _loc2_.h;
         _loc4_ = {};
         _loc4_.panel = new LPFPanelMergeShop();
         _loc3_ = this.rootClass.world.shopinfo.sName;
         _loc4_.fData = {
            "items":this.itemsShop,
            "itemsInv":this.itemsInv,
            "sName":_loc3_,
            "objData":fData.objData
         };
         _loc4_.r = {
            "x":30,
            "y":80,
            "w":900,
            "h":400
         };
         _loc4_.isOpen = true;
         this.mergePanel = addPanel(_loc4_);
         this.updatePreviewButtons();
         this.rootClass.dropStackBoost();
      }
      
      override public function fClose() : void
      {
         var _loc1_:MovieClip = null;
         this.rootClass.dropStackReset();
         while(panels.length > 0)
         {
            panels[0].mc.fClose();
            panels.shift();
         }
         if(parent != null)
         {
            _loc1_ = MovieClip(parent);
            _loc1_.removeChild(this);
            _loc1_.onClose();
         }
      }
      
      override protected function handleUpdate(param1:Object) : Object
      {
         var _loc3_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         var _loc8_:* = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:Object = null;
         var _loc2_:Boolean = false;
         var _loc4_:Object = this.iSel;
         var _loc5_:Object = null;
         if(param1.eventType == "sModeSet")
         {
            if(sMode != param1.sModeBroadcast)
            {
               sMode = param1.sModeBroadcast;
               this.iSel = null;
               this.eSel = null;
               param1.iSel = this.iSel;
               _loc6_ = this.itemsInv;
               if(sMode == "shopBuy")
               {
                  _loc6_ = this.itemsShop;
               }
               param1.fData = {"list":_loc6_};
            }
         }
         if(param1.eventType == "listItemASel")
         {
            this.iQty = 1;
            this.iSel = null;
            this.aSel = param1.fData.sType.toLowerCase();
            this.iSel = param1.fData;
            param1.fData = {
               "iSel":this.iSel,
               "oSel":param1.fData
            };
            if(_loc4_ == this.iSel)
            {
               _loc2_ = true;
            }
         }
         if(param1.eventType == "refreshItems")
         {
         }
         if(param1.eventType == "buyItem")
         {
            _loc7_ = this.iSel != null ? this.iSel : this.eSel;
            if(_loc7_ != null)
            {
               _loc8_ = "Are you sure you want to buy \'" + _loc7_.sName + "\'?";
               if(this.iQty > 1)
               {
                  _loc8_ = "Are you sure you want to buy " + String(this.iQty) + "x \'" + _loc7_.sName + "\'?";
               }
               _loc9_ = new ModalMC();
               _loc10_ = {};
               _loc10_.strBody = _loc8_;
               _loc10_.params = {
                  "iSel":_loc7_,
                  "iQty":this.iQty
               };
               _loc10_.callback = this.rootClass.world.sendBuyItemRequestWithQuantity;
               _loc10_.glow = "white,medium";
               _loc10_.greedy = true;
               this.rootClass.ui.ModalStack.addChild(_loc9_);
               _loc9_.init(_loc10_);
            }
         }
         if(param1.eventType == "sellItem")
         {
            if(this.iSel != null)
            {
               _loc11_ = this.iSel;
            }
            _loc9_ = new ModalMC();
            _loc10_ = {};
            _loc10_.strBody = "Are you sure you want to sell \'" + _loc11_.sName + "\'?";
            _loc10_.params = {"iSel":_loc11_};
            _loc10_.callback = this.onSellRequest;
            _loc10_.glow = "white,medium";
            this.rootClass.ui.ModalStack.addChild(_loc9_);
            _loc9_.init(_loc10_);
         }
         if(param1.eventType == "buyBagSlots")
         {
            _loc2_ = true;
            this.rootClass.world.loadMovieFront(this.rootClass.bagSpace,"Inline Asset");
            this.fClose();
         }
         if(param1.eventType == "helpAC")
         {
            _loc2_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         this.updatePreviewButtons(_loc5_);
         _loc4_ = null;
         if(!_loc2_)
         {
            return param1;
         }
         return null;
      }
      
      private function updatePreviewButtons(param1:Object = null, param2:Object = null) : void
      {
         var _loc3_:Object = {};
         if(param1 != null && param2 != null)
         {
            _loc3_ = param2;
         }
         else
         {
            _loc3_.eventType = "previewButton1Update";
            _loc3_.fData = {};
            _loc3_.fData.sText = "";
            _loc3_.sMode = "grey";
            _loc3_.buttonNewEventType = "";
            if(sMode == "shopBuy")
            {
               if(this.iSel != null)
               {
                  _loc3_.fData.sText = "Buy";
                  _loc3_.buttonNewEventType = "buyItem";
                  _loc3_.sMode = "red";
               }
               else
               {
                  _loc3_.fData.sText = "";
                  _loc3_.buttonNewEventType = "";
               }
            }
            if(sMode == "shopSell")
            {
               if(this.iSel != null)
               {
                  _loc3_.fData.sText = "Sell";
                  _loc3_.buttonNewEventType = "sellItem";
                  _loc3_.sMode = "red";
               }
               else
               {
                  _loc3_.fData.sText = "";
                  _loc3_.buttonNewEventType = "";
               }
            }
         }
         notifyByEventType(_loc3_);
      }
      
      private function onSellRequest(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.world.sendSellItemRequest(param1.iSel);
         }
      }
      
      public function getTabStates(param1:Object = null) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = [{
            "sTag":"Show All",
            "icon":"iipack",
            "state":-1,
            "filter":"*",
            "mc":{}
         },{
            "sTag":"Show only weapons",
            "icon":"iwsword",
            "state":-1,
            "filter":"Weapon",
            "mc":{}
         },{
            "sTag":"Show only armor",
            "icon":"iiclass",
            "state":-1,
            "filter":"ar",
            "mc":{}
         },{
            "sTag":"Show only helms",
            "icon":"iihelm",
            "state":-1,
            "filter":"he",
            "mc":{}
         },{
            "sTag":"Show only capes",
            "icon":"iicape",
            "state":-1,
            "filter":"ba",
            "mc":{}
         },{
            "sTag":"Show only pets",
            "icon":"iipet",
            "state":-1,
            "filter":"pe",
            "mc":{}
         },{
            "sTag":"Show only amulets",
            "icon":"iin1",
            "state":-1,
            "filter":"am",
            "mc":{}
         },{
            "sTag":"Show only items",
            "icon":"iibag",
            "state":-1,
            "filter":"it",
            "mc":{}
         },{
            "sTag":"Show only house items",
            "icon":"ihhouse",
            "state":-1,
            "filter":"houseitems",
            "mc":{}
         }];
         if(param1 != null)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.filter == param1.sES)
               {
                  return [_loc3_];
               }
            }
            return [_loc2_[0]];
         }
         return _loc2_;
      }
   }
}

