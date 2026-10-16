package
{
   import flash.display.*;
   import flash.text.*;
   
   public class LPFLayoutBank extends LPFLayout
   {
      public var iSel:Object;
      
      public var bSel:Object;
      
      public var itemsI:Array;
      
      public var itemsB:Array;
      
      public var bankPanel:MovieClip;
      
      public var rootClass:MovieClip;
      
      public var previewPanel:MovieClip;
      
      public function LPFLayoutBank()
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
         if("itemsI" in fData)
         {
            this.itemsI = fData.itemsI;
         }
         if("itemsB" in fData)
         {
            this.itemsB = fData.itemsB;
         }
         _loc2_ = param1.r;
         var _loc3_:String = "";
         x = _loc2_.x;
         y = _loc2_.y;
         w = _loc2_.w;
         h = _loc2_.h;
         _loc4_ = {};
         _loc4_.panel = new LPFPanelBank();
         _loc4_.fData = {
            "itemsI":this.itemsI,
            "itemsB":this.itemsB,
            "avatar":this.rootClass.world.myAvatar,
            "objData":fData.objData
         };
         _loc4_.r = {
            "x":30,
            "y":80,
            "w":900,
            "h":400
         };
         _loc4_.isOpen = true;
         this.bankPanel = addPanel(_loc4_);
         _loc4_ = {};
         _loc4_.panel = new BankPreview();
         _loc3_ = "Preview";
         _loc4_.fData = {"sName":_loc3_};
         _loc4_.r = {
            "x":357,
            "y":197,
            "w":255,
            "h":204.2
         };
         _loc4_.closeType = "hide";
         _loc4_.isOpen = false;
         this.previewPanel = addChild(_loc4_.panel) as MovieClip;
         this.previewPanel.Open(_loc4_);
         this.previewPanel.visible = false;
         this.previewPanel.mouseEnabled = false;
         this.previewPanel.mouseChildren = false;
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
         this.rootClass.world.bankinfo.resetSearch();
      }
      
      override protected function handleUpdate(param1:Object) : Object
      {
         var _loc3_:Object = null;
         var _loc2_:Boolean = false;
         var _loc4_:Object = this.iSel;
         var _loc5_:Object = this.bSel;
         var _loc6_:Object = null;
         if(param1.eventType == "inventorySel")
         {
            this.iSel = param1.fData;
            if(_loc4_ == this.iSel)
            {
               this.iSel = null;
            }
            param1.fData = {"iSel":this.iSel};
            this.previewPanel.Show(this.iSel);
         }
         if(param1.eventType == "bankSel")
         {
            this.bSel = param1.fData;
            if(_loc5_ == this.bSel)
            {
               this.bSel = null;
            }
            param1.fData = {"bSel":this.bSel};
            this.previewPanel.Show(this.bSel);
         }
         if(param1.eventType == "categorySel")
         {
            this.bSel = null;
            param1.eventType = "refreshBank";
         }
         if(param1.eventType == "refreshBank")
         {
         }
         if(param1.eventType == "refreshInventory")
         {
         }
         if(param1.eventType == "refreshItems")
         {
         }
         if(param1.eventType == "sendBankFromInvRequest")
         {
            this.rootClass.world.sendBankFromInvRequest(this.iSel);
            this.iSel = null;
         }
         if(param1.eventType == "sendBankToInvRequest")
         {
            this.rootClass.world.sendBankToInvRequest(this.bSel);
            this.bSel = null;
         }
         if(param1.eventType == "sendBankSwapInvRequest")
         {
            this.rootClass.world.sendBankSwapInvRequest(this.bSel,this.iSel);
            this.iSel = null;
            this.bSel = null;
         }
         if(param1.eventType == "buyBagSlots")
         {
            _loc2_ = true;
            this.rootClass.world.loadMovieFront(this.rootClass.bagSpace,"Inline Asset");
            this.fClose();
         }
         if(param1.eventType == "switchBank")
         {
            this.rootClass.world.toggleHouseBank();
         }
         if(param1.eventType == "helpAC")
         {
            _loc2_ = true;
            this.rootClass.world.loadMovieFront("interface/goldAC5.swf","Inline Asset");
         }
         this.updatePreviewButtons(_loc6_);
         _loc4_ = null;
         _loc5_ = null;
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
            if(this.iSel != null && this.bSel == null)
            {
               _loc3_.fData.sText = "< To Bank";
               _loc3_.buttonNewEventType = "sendBankFromInvRequest";
               _loc3_.sMode = "red";
            }
            else if(this.iSel == null && this.bSel != null)
            {
               _loc3_.fData.sText = "To Inventory >";
               _loc3_.buttonNewEventType = "sendBankToInvRequest";
               _loc3_.sMode = "red";
            }
            else if(this.iSel != null && this.bSel != null)
            {
               _loc3_.fData.sText = "< Swap >";
               _loc3_.buttonNewEventType = "sendBankSwapInvRequest";
               _loc3_.sMode = "red";
            }
            else
            {
               _loc3_.fData.sText = "";
               _loc3_.buttonNewEventType = "";
            }
         }
         notifyByEventType(_loc3_);
      }
      
      public function getTabStates(param1:Object = null, param2:Array = null) : Array
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc3_:Array = [{
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
            "sTag":"Show only enhancements",
            "icon":"iidesign",
            "state":-1,
            "filter":"enh",
            "mc":{}
         }];
         if(param2 != null)
         {
            for each(_loc4_ in param2)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc3_.length)
               {
                  if(_loc3_[_loc5_].filter == _loc4_)
                  {
                     _loc3_.splice(_loc5_--,1);
                  }
                  _loc5_++;
               }
            }
         }
         if(param1 != null)
         {
            for each(_loc6_ in _loc3_)
            {
               if(_loc6_.filter == param1.sES)
               {
                  return [_loc6_];
               }
            }
            return [_loc3_[0]];
         }
         return _loc3_;
      }
   }
}

