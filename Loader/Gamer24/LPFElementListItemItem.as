package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import liteAssets.draw.detailedCheck;
   
   public class LPFElementListItemItem extends LPFElementListItem
   {
      public var check:detailedCheck;
      
      public var eqpBG:MovieClip;
      
      public var hit:MovieClip;
      
      public var icon:MovieClip;
      
      public var iconAC:MovieClip;
      
      public var iconRing:MovieClip;
      
      public var selBG:MovieClip;
      
      public var tLevel:TextField;
      
      public var tName:TextField;
      
      public var wearBG:MovieClip;
      
      public var sel:Boolean = false;
      
      private var rootClass:MovieClip;
      
      private var allowDesel:Boolean = false;
      
      private var bLimited:Boolean = false;
      
      private var multiSelect:Boolean = false;
      
      private const MAX_SELECTED:int = 100;
      
      private var redCT:ColorTransform;
      
      private var greenCT:ColorTransform;
      
      private var blueCT:ColorTransform;
      
      private var whiteCT:ColorTransform;
      
      private var orangeCT:ColorTransform;
      
      private var yellowCT:ColorTransform;
      
      private var purpleCT:ColorTransform;
      
      private var greyCT:ColorTransform;
      
      private var blackoutCT:ColorTransform;
      
      private var greyoutCT:ColorTransform;
      
      private var staffFilter:GlowFilter;
      
      private var mispricedFilter:GlowFilter;
      
      public function LPFElementListItemItem()
      {
         this.redCT = new ColorTransform(1,1,1,1,96,0,0,0);
         this.greenCT = new ColorTransform(1,1,1,1,0,96,0,0);
         this.blueCT = new ColorTransform(1,1,1,1,0,0,96,0);
         this.whiteCT = new ColorTransform(1,1,1,1,64,64,64,0);
         this.orangeCT = new ColorTransform(1,1,1,1,96,36,0,0);
         this.yellowCT = new ColorTransform(1,1,1,1,96,64,24,0);
         this.purpleCT = new ColorTransform(1,1,1,1,96,0,96,0);
         this.greyCT = new ColorTransform(1,1,1,1,0,0,0,0);
         this.blackoutCT = new ColorTransform(0,0,0,1,0,0,0,0);
         this.greyoutCT = new ColorTransform(0,0,0,1,40,40,40,0);
         this.staffFilter = new GlowFilter(16776960,1,5,5,5,1,false,true);
         this.mispricedFilter = new GlowFilter(16711680,1,5,5,5,1,false,true);
         super();
         this.check.visible = false;
         this.check.mouseEnabled = false;
         addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
      }
      
      override public function fOpen(param1:Object) : void
      {
         fData = param1.fData;
         if("eventType" in param1)
         {
            eventType = param1.eventType;
         }
         if("allowDesel" in param1)
         {
            this.allowDesel = param1.allowDesel == true;
         }
         if("bLimited" in param1)
         {
            this.bLimited = param1.bLimited == true;
         }
         if("multiSelect" in param1)
         {
            this.multiSelect = param1.multiSelect == true;
         }
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.fDraw();
      }
      
      override protected function fDraw() : void
      {
         var _loc4_:Object = null;
         var _loc12_:Number = NaN;
         var _loc13_:Class = null;
         var _loc14_:* = undefined;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc1_:Object = this.rootClass.world.myAvatar.dataLeaf;
         var _loc2_:int = this.hit.width - 2;
         var _loc3_:* = "<font color=\'#FFFFFF\'>" + fData.sName + "</font>";
         if(fData.bUpg == 1)
         {
            _loc3_ = "<font color=\'#FCC749\'>" + fData.sName + "</font>";
         }
         if(fData.iLvl > _loc1_.intLevel || fData.EnhLvl != null && fData.EnhLvl > _loc1_.intLevel)
         {
            _loc3_ = "<font color=\'#FF0000\'>" + fData.sName + "</font>";
         }
         if(Boolean(this.bLimited) && fData.iQtyRemain <= 0)
         {
            _loc3_ = "<font color=\'#666666\'>" + fData.sName + "</font>";
         }
         this.tName.htmlText = _loc3_;
         if(fData.iRty != null)
         {
         }
         if(this.rootClass.world.enhPatternTree == null)
         {
            this.rootClass.world.initPatternTree();
         }
         if(["Weapon","he","ar","ba"].indexOf(fData.sES) > -1)
         {
            if(fData.PatternID != null)
            {
               _loc4_ = this.rootClass.world.enhPatternTree[fData.PatternID];
            }
            if(fData.EnhPatternID != null)
            {
               _loc4_ = this.rootClass.world.enhPatternTree[fData.EnhPatternID];
            }
            if(_loc4_ != null)
            {
            }
         }
         if(this.bLimited)
         {
            this.tName.htmlText += "<font color=\'#AA0000\'> x" + fData.iQtyRemain + "</font>";
         }
         else if(fData.iStk > 1)
         {
            this.tName.htmlText += "<font color=\'#999999\'> x" + fData.iQty + "</font>";
         }
         if(fData.sES == "ar" && fData.EnhID > 0)
         {
            _loc12_ = Number(this.rootClass.getRankFromPoints(fData.iQty));
            this.tName.htmlText += "<font color=\'#999999\'>, Rank " + _loc12_ + "</font>";
         }
         if(fData.EnhLvl != null && fData.EnhLvl > 0)
         {
            this.tLevel.htmlText = "<font color=\'#00CCFF\'>" + fData.EnhLvl + "</font>";
         }
         else if(fData.iLvl != null && fData.iLvl > 0)
         {
            this.tLevel.htmlText = "<font color=\'#FFFFFF\'>" + fData.iLvl + "</font>";
         }
         else
         {
            this.tLevel.visible = false;
         }
         this.iconAC.visible = false;
         if("bCoins" in fData && fData.bCoins == 1)
         {
            this.iconAC.visible = true;
         }
         var _loc5_:* = 23;
         var _loc6_:* = 19;
         var _loc7_:* = 13;
         var _loc8_:* = 11;
         var _loc9_:* = _loc5_;
         var _loc10_:* = _loc6_;
         var _loc11_:String = "";
         this.icon.removeAllChildren();
         this.icon.visible = false;
         try
         {
            if(fData.sType.toLowerCase() == "enhancement")
            {
               _loc11_ = this.rootClass.getIconBySlot(fData.sES);
            }
            else if(fData.sType.toLowerCase() == "serveruse" || fData.sType.toLowerCase() == "clientuse")
            {
               if("sFile" in fData && fData.sFile.length > 0 && this.rootClass.world.getClass(fData.sFile) != null)
               {
                  _loc11_ = fData.sFile;
               }
               else
               {
                  _loc11_ = fData.sIcon;
               }
            }
            else if(fData.sIcon == null || fData.sIcon == "" || fData.sIcon == "none")
            {
               if(fData.sLink.toLowerCase() != "none")
               {
                  _loc11_ = "iidesign";
               }
               else
               {
                  _loc11_ = "iibag";
               }
            }
            else
            {
               _loc11_ = fData.sIcon;
            }
            try
            {
               _loc13_ = this.rootClass.world.getClass(_loc11_) as Class;
               _loc14_ = this.icon.addChild(new _loc13_());
               _loc9_ = _loc14_.width;
               _loc10_ = _loc14_.height;
               _loc15_ = 0;
               _loc16_ = 0;
               if(fData.sType.toLowerCase() == "enhancement")
               {
                  _loc15_ = (_loc5_ - _loc7_) / 4 - 1;
                  _loc16_ = (_loc6_ - _loc8_) / 4 - 1;
                  _loc5_ = _loc7_;
                  _loc6_ = _loc8_;
               }
               if(_loc9_ > _loc10_)
               {
                  _loc14_.scaleX = _loc14_.scaleY = _loc5_ / _loc9_;
               }
               else
               {
                  _loc14_.scaleX = _loc14_.scaleY = _loc6_ / _loc10_;
               }
               _loc14_.x = -(_loc14_.width / 2) + _loc15_;
               _loc14_.y = -(_loc14_.height / 2) + _loc16_;
               this.icon.visible = true;
            }
            catch(e:Error)
            {
            }
            this.iconRing.visible = true;
            this.iconRing.y = this.iconRing.y = 2;
            this.iconRing.width = this.iconRing.height = 25;
            if(fData.sType.toLowerCase() == "enhancement")
            {
               this.icon.transform.colorTransform = this.blackoutCT;
            }
            else if(fData.EnhLvl != null && fData.EnhLvl > 0)
            {
               this.iconRing.width = this.iconRing.height = 19;
               this.iconRing.x += 3;
               this.iconRing.y += 3;
            }
            else
            {
               this.iconRing.visible = false;
               if(["Weapon","he","ar","ba"].indexOf(fData.sES) > -1)
               {
                  this.icon.transform.colorTransform = this.greyoutCT;
               }
            }
            if(_loc4_ != null)
            {
               if(_loc4_.hasOwnProperty("COLOR"))
               {
                  this.iconRing.bg.transform.colorTransform = _loc4_.COLOR;
               }
               else
               {
                  this.iconRing.bg.transform.colorTransform = this.getCatCT(_loc4_.sDesc);
               }
            }
            this.wearBG.visible = false;
            this.eqpBG.visible = false;
            if(fData.bEquip)
            {
               this.eqpBG.visible = true;
            }
            else if(Boolean(fData.hasOwnProperty("bWear")) && Boolean(fData.bWear))
            {
               this.wearBG.visible = true;
            }
            this.selBG.alpha = 0;
            if(Boolean(this.rootClass.litePreference.data.bDebugger) && !this.rootClass.litePreference.data.dOptions["debugColor"])
            {
               if(Number(fData.bStaff) == 1)
               {
                  this.eqpBG.visible = true;
                  this.eqpBG.filters = [this.staffFilter];
               }
               else
               {
                  this.eqpBG.filters = [];
                  if(Number(fData.iCost) > 12000 && Number(fData.bCoins) == 1)
                  {
                     this.eqpBG.visible = true;
                     this.eqpBG.filters = [this.mispricedFilter];
                  }
                  else if(Number(fData.iCost) == 0)
                  {
                     this.eqpBG.visible = true;
                     this.eqpBG.filters = [this.mispricedFilter];
                  }
               }
            }
            buttonMode = true;
            mouseChildren = false;
         }
         catch(e:*)
         {
         }
      }
      
      override public function select() : void
      {
         this.sel = true;
         if(this.multiSelect)
         {
            this.check.visible = true;
         }
         else
         {
            this.selBG.alpha = 1;
         }
      }
      
      override public function deselect() : void
      {
         this.sel = false;
         if(this.multiSelect)
         {
            this.check.visible = false;
         }
         else
         {
            this.selBG.alpha = 0;
         }
      }
      
      override protected function onClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         if(!this.rootClass.isGreedyModalInStack())
         {
            if(this.multiSelect)
            {
               if(this.sel)
               {
                  this.deselect();
               }
               else if(LPFFrameListViewTabbed(fParent).getSelected() < this.MAX_SELECTED)
               {
                  this.select();
               }
               else
               {
                  this.rootClass.MsgBox.notify("You can only select up to a maximum of " + this.MAX_SELECTED + " items.");
               }
            }
            else if(!this.sel)
            {
               _loc2_ = LPFFrameListViewTabbed(fParent).getListItemByiSel();
               if(_loc2_ != null)
               {
                  _loc2_.deselect();
               }
               this.select();
            }
            else if(this.allowDesel)
            {
               this.deselect();
            }
            update();
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         if(!this.sel)
         {
            this.selBG.alpha = 0.6;
         }
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         if(!this.sel)
         {
            this.selBG.alpha = 0;
         }
      }
      
      private function getCatCT(param1:String) : ColorTransform
      {
         var _loc2_:ColorTransform = this.greyCT;
         if(param1 == "M1")
         {
            _loc2_ = this.redCT;
         }
         if(param1 == "M2")
         {
            _loc2_ = this.greenCT;
         }
         if(param1 == "M3")
         {
            _loc2_ = this.yellowCT;
         }
         if(param1 == "C1")
         {
            _loc2_ = this.blueCT;
         }
         if(param1 == "C2")
         {
            _loc2_ = this.whiteCT;
         }
         if(param1 == "C3")
         {
            _loc2_ = this.orangeCT;
         }
         if(param1 == "S1")
         {
            _loc2_ = this.purpleCT;
         }
         if(param1 == "none")
         {
            _loc2_ = this.greyCT;
         }
         return _loc2_;
      }
      
      override public function fClose() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.icon.removeAllChildren();
         this.rootClass = null;
         super.fClose();
      }
   }
}

