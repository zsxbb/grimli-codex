package
{
   import flash.display.*;
   import flash.events.*;
   
   public class PVPPanelMC extends MovieClip
   {
      public var btnClose:SimpleButton;
      
      public var cnt:MovieClip;
      
      private var rootClass:MovieClip;
      
      private var world:MovieClip;
      
      private var mcPopup:MovieClip;
      
      private var nextMode:String;
      
      private var uoLeaf:Object;
      
      private var uoData:Object;
      
      private var itemSel:MovieClip;
      
      private var pending:Boolean = false;
      
      private var resultsTicks:int = 0;
      
      public function PVPPanelMC()
      {
         this.rootClass = stage.getChildAt(0) as MovieClip;
         this.world = this.rootClass.world as MovieClip;
         this.mcPopup = this.rootClass.ui.mcPopup;
         this.uoLeaf = this.world.myLeaf();
         this.uoData = this.world.myAvatar.objData;
         super();
         this.btnClose.addEventListener(MouseEvent.MOUSE_DOWN,this.btnCloseClick,false,0,true);
      }
      
      public function openWith(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         this.nextMode = param1 != null && param1.typ != null ? String(param1.typ) : null;
         if(this.nextMode == null || !this.isValidMode(this.nextMode))
         {
            _loc2_ = this.world != null && this.world.PVPResults != null && this.world.PVPResults.ts is Number ? Number(this.world.PVPResults.ts) : -1;
            this.nextMode = _loc2_ > 0 && new Date().getTime() - _loc2_ < 60000 ? "results" : "maps";
         }
         if(this.isValidMode(this.nextMode))
         {
            if(this.currentLabel != "init" && this.currentLabel.indexOf("-out") < 0)
            {
               this.gotoAndPlay(this.currentLabel + "-out");
            }
            else
            {
               this.gotoAndPlay(this.nextMode);
            }
         }
      }
      
      public function fClose() : void
      {
         this.killCurrentListeners();
      }
      
      private function playNextMode() : void
      {
         this.killCurrentListeners();
         this.btnClose.addEventListener(MouseEvent.MOUSE_DOWN,this.btnCloseClick,false,0,true);
         this.gotoAndPlay(this.nextMode);
      }
      
      private function isValidMode(param1:String) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < this.currentLabels.length && !_loc2_)
         {
            if(this.currentLabels[_loc3_].name == param1)
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function update() : void
      {
         if(MovieClip(this).currentLabel == "maps")
         {
            this.updateMaps();
         }
         if(MovieClip(this).currentLabel == "results")
         {
            this.updateResults();
         }
      }
      
      private function updateMaps() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         _loc1_ = {};
         while(this.cnt.iList.numChildren > 1)
         {
            this.cnt.iList.removeChildAt(1);
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.world.PVPMaps.length)
         {
            _loc1_ = this.world.PVPMaps[_loc4_];
            if(!_loc1_.hidden)
            {
               _loc2_ = this.cnt.iList.addChild(new pvpProto());
               _loc2_.t1.ti.text = _loc1_.nam;
               _loc2_.t2.ti.text = _loc1_.desc;
               _loc2_.icon.gotoAndStop(_loc1_.icon);
               _loc2_.y = _loc3_ * 55;
               _loc2_.iSel = false;
               _loc2_.iHi = false;
               _loc2_.label = _loc1_.label;
               _loc2_.warzone = _loc1_.warzone;
               _loc2_.hit.alpha = 0;
               _loc2_.hit.buttonMode = true;
               _loc2_.hit.addEventListener(MouseEvent.CLICK,this.onMapItemClick,false,0,true);
               _loc2_.hit.addEventListener(MouseEvent.MOUSE_OVER,this.onMapItemOver,false,0,true);
               _loc2_.hit.addEventListener(MouseEvent.MOUSE_OUT,this.onMapItemOut,false,0,true);
               _loc3_++;
            }
            _loc4_++;
         }
         this.cnt.iList.iproto.visible = false;
         this.cnt.body.bJoin.addEventListener(MouseEvent.MOUSE_DOWN,this.btnJoinClick,false,0,true);
         this.cnt.body.bExit.addEventListener(MouseEvent.MOUSE_DOWN,this.btnExitClick,false,0,true);
         this.cnt.body.bJoin.visible = false;
         this.cnt.body.bExit.visible = false;
         this.cnt.body.msg.visible = false;
         this.cnt.body.gotoAndPlay("init");
      }
      
      private function updateResults() : void
      {
         this.applyResults();
         this.resultsTicks = 20;
         removeEventListener(Event.ENTER_FRAME,this.resultsSettleTick);
         addEventListener(Event.ENTER_FRAME,this.resultsSettleTick,false,0,true);
      }
      
      private function resultsSettleTick(param1:Event) : void
      {
         if(--this.resultsTicks < 0 || this.currentLabel != "results")
         {
            removeEventListener(Event.ENTER_FRAME,this.resultsSettleTick);
            return;
         }
         this.applyResults();
      }
      
      private function applyResults() : void
      {
         var mapName:String = null;
         var o:Object = this.world.PVPResults;
         var t:int = int(o.team);
         var myTeam:int = -1;
         try
         {
            myTeam = int(this.world.myAvatar.dataLeaf.pvpTeam);
         }
         catch(eMT:Error)
         {
         }
         try
         {
            if(t == myTeam)
            {
               this.cnt.outlineV.visible = true;
               this.cnt.outlineL.visible = false;
            }
            else
            {
               this.cnt.outlineV.visible = false;
               this.cnt.outlineL.visible = true;
            }
            if(this.world.PVPFactions.length == 0 || this.world.PVPFactions[t] == null)
            {
               this.cnt.ti.text = t == myTeam ? "You won!" : "You lost!";
            }
            else
            {
               this.cnt.ti.text = "The " + this.world.PVPFactions[t].sName + " team won!";
            }
         }
         catch(eRs:Error)
         {
            trace("[UI] ERR applyResults: " + eRs.message);
         }
         try
         {
            this.cnt.back_txt.mouseEnabled = false;
            mapName = this.world.strAreaName;
            if(mapName.indexOf("dage1v1") != -1 || mapName.indexOf("dagepvp") != -1)
            {
               this.cnt.back_txt.text = "Legion PvP";
            }
            else if(mapName.indexOf("deathpitbrawl") != -1)
            {
               this.cnt.back_txt.text = "Deathpit Arena";
            }
            else
            {
               this.cnt.back_txt.text = "Doom Arena";
            }
         }
         catch(eBt:Error)
         {
         }
         try
         {
            this.cnt.btnBack.addEventListener(MouseEvent.CLICK,this.btnBackClick,false,0,true);
         }
         catch(eBb:Error)
         {
            trace("[UI] ERR applyResults btnBack: " + eBb.message);
         }
      }
      
      private function onMapItemClick(param1:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:MovieClip = param1.currentTarget.parent as MovieClip;
         _loc2_.iHi = false;
         if(!_loc2_.iSel)
         {
            this.itemSel = _loc2_;
            _loc2_.iSel = true;
            _loc2_.gotoAndPlay("in2");
         }
         var _loc4_:int = 1;
         while(_loc4_ < this.cnt.iList.numChildren)
         {
            _loc3_ = this.cnt.iList.getChildAt(_loc4_) as MovieClip;
            if(_loc3_ != _loc2_)
            {
               if(_loc3_.iSel)
               {
                  _loc3_.gotoAndPlay("out2");
               }
               if(_loc3_.iHi)
               {
                  _loc3_.gotoAndPlay("out1");
               }
               _loc3_.iSel = false;
               _loc3_.iHi = false;
            }
            _loc4_++;
         }
         this.cnt.body.gotoAndStop(_loc2_.label);
      }
      
      private function onMapItemOver(param1:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:MovieClip = param1.currentTarget.parent as MovieClip;
         if(!_loc2_.iHi && !_loc2_.iSel)
         {
            _loc2_.iHi = true;
            _loc2_.gotoAndPlay("in1");
         }
         var _loc4_:int = 1;
         while(_loc4_ < this.cnt.iList.numChildren)
         {
            _loc3_ = this.cnt.iList.getChildAt(_loc4_) as MovieClip;
            if(_loc3_ != _loc2_)
            {
               if(Boolean(_loc3_.iHi) && !_loc3_.iSel)
               {
                  _loc3_.gotoAndPlay("out1");
               }
               _loc3_.iHi = false;
            }
            _loc4_++;
         }
      }
      
      private function onMapItemOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = param1.currentTarget.parent as MovieClip;
         if(Boolean(_loc2_.iHi) && !_loc2_.iSel)
         {
            _loc2_.iHi = false;
            _loc2_.gotoAndPlay("out1");
         }
      }
      
      public function updateBody() : void
      {
         var _loc1_:MovieClip = this.cnt.body;
         if(this.pending)
         {
            this.pending = false;
         }
         if(this.itemSel.warzone != this.world.PVPQueue.warzone)
         {
            _loc1_.bJoin.visible = true;
            _loc1_.msg.visible = false;
            _loc1_.bExit.visible = false;
         }
         else
         {
            _loc1_.bJoin.visible = false;
            _loc1_.msg.visible = true;
            _loc1_.bExit.visible = true;
         }
      }
      
      private function killCurrentListeners() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.resultsSettleTick);
         try
         {
            if(this.currentLabel == "maps")
            {
               this.cnt.body.bJoin.removeEventListener(MouseEvent.MOUSE_DOWN,this.btnJoinClick);
               this.cnt.body.bExit.removeEventListener(MouseEvent.MOUSE_DOWN,this.btnExitClick);
            }
            if(this.currentLabel == "results")
            {
               this.cnt.btnBack.removeEventListener(MouseEvent.CLICK,this.btnBackClick);
            }
         }
         catch(eKL:Error)
         {
         }
         this.btnClose.removeEventListener(MouseEvent.MOUSE_DOWN,this.btnCloseClick);
      }
      
      private function btnCloseClick(param1:MouseEvent = null) : void
      {
         this.mcPopup.onClose();
      }
      
      private function btnJoinClick(param1:MouseEvent) : void
      {
         if(!this.pending)
         {
            this.pending = true;
            this.world.requestPVPQueue(this.itemSel.warzone);
         }
      }
      
      private function btnExitClick(param1:MouseEvent) : void
      {
         if(!this.pending)
         {
            this.pending = true;
            this.world.requestPVPQueue("none");
         }
      }
      
      private function btnBackClick(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = this.world.strAreaName;
         if(_loc2_.indexOf("dage1v1") != -1 || _loc2_.indexOf("dagepvp") != -1)
         {
            _loc3_ = "legionpvp";
         }
         else if(_loc2_.indexOf("deathpitbrawl") != -1)
         {
            _loc3_ = "deathpitarena";
         }
         else
         {
            _loc3_ = "doomarena";
         }
         this.world.gotoTown(_loc3_,"Enter","Spawn");
         this.mcPopup.onClose();
      }
   }
}

