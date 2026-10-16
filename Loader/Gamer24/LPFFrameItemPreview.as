package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.text.*;
   
   public class LPFFrameItemPreview extends LPFFrame
   {
      private static const WHITE_GLOW:GlowFilter = new GlowFilter(16777215,1,8,8,2,1,false,false);
      
      public var btnDelete:SimpleButton;
      
      public var btnFGender:SimpleButton;
      
      public var btnMGender:SimpleButton;
      
      public var btnTry:SimpleButton;
      
      public var btnWiki:SimpleButton;
      
      public var mcCoin:MovieClip;
      
      public var mcPreview:MovieClip;
      
      public var mcUpgrade:MovieClip;
      
      public var tInfo:TextField;
      
      protected var iSel:Object;
      
      private var previewArgs:Object;
      
      protected var rootClass:MovieClip;
      
      protected var curItem:Object;
      
      private var sLinkArmor:String = "";
      
      private var sLinkCape:String = "";
      
      private var sLinkHelm:String = "";
      
      private var sLinkPet:String = "";
      
      private var sLinkWeapon:String = "";
      
      private var sLinkMisc:String = "";
      
      private var assetLoader:PreviewAssetLoader;
      
      private var efActive:Boolean = false;
      
      internal var preventSpam:Boolean;
      
      public function LPFFrameItemPreview()
      {
         this.previewArgs = {};
         super();
         this.mcCoin.visible = false;
         this.mcUpgrade.visible = false;
         this.btnTry.visible = false;
         this.btnFGender.visible = false;
         this.btnMGender.visible = false;
         this.btnWiki.visible = false;
         this.btnTry.addEventListener(MouseEvent.CLICK,this.onBtnTryClick,false,0,true);
         this.btnTry.addEventListener(MouseEvent.MOUSE_OVER,this.onTryTTOver,false,0,true);
         this.btnTry.addEventListener(MouseEvent.MOUSE_OUT,this.onTryTTOut,false,0,true);
         this.btnMGender.addEventListener(MouseEvent.CLICK,this.onBtnGender,false,0,true);
         this.btnMGender.addEventListener(MouseEvent.MOUSE_OVER,this.onGenderTTOver,false,0,true);
         this.btnMGender.addEventListener(MouseEvent.MOUSE_OUT,this.onGenderTTOut,false,0,true);
         this.btnFGender.addEventListener(MouseEvent.CLICK,this.onBtnGender,false,0,true);
         this.btnFGender.addEventListener(MouseEvent.MOUSE_OVER,this.onGenderTTOver,false,0,true);
         this.btnFGender.addEventListener(MouseEvent.MOUSE_OUT,this.onGenderTTOut,false,0,true);
         this.btnWiki.addEventListener(MouseEvent.CLICK,this.onBtnWiki,false,0,true);
         this.btnWiki.addEventListener(MouseEvent.MOUSE_OVER,this.onWikiTTOver,false,0,true);
         this.btnWiki.addEventListener(MouseEvent.MOUSE_OUT,this.onWikiTTOut,false,0,true);
         this.btnDelete.addEventListener(MouseEvent.CLICK,this.onBtnDeleteClick,false,0,true);
         this.btnDelete.addEventListener(MouseEvent.MOUSE_OVER,this.onDeleteTTOver,false,0,true);
         this.btnDelete.addEventListener(MouseEvent.MOUSE_OUT,this.onDeleteTTOut,false,0,true);
         this.mcCoin.addEventListener(MouseEvent.MOUSE_OVER,this.onCoinTTOver,false,0,true);
         this.mcCoin.addEventListener(MouseEvent.MOUSE_OUT,this.onCoinTTOut,false,0,true);
         this.mcUpgrade.addEventListener(MouseEvent.MOUSE_OVER,this.onUpgradeTTOver,false,0,true);
         this.mcUpgrade.addEventListener(MouseEvent.MOUSE_OUT,this.onUpgradeTTOut,false,0,true);
      }
      
      private function ensureAssetLoader() : void
      {
         if(this.assetLoader == null)
         {
            this.assetLoader = new PreviewAssetLoader(this.mcPreview,this.rootClass,false);
         }
      }
      
      private function startKillStackProcessing() : void
      {
         if(!this.efActive)
         {
            this.efActive = true;
            addEventListener(Event.ENTER_FRAME,this.onEF,false,0,true);
         }
      }
      
      private function stopKillStackProcessing() : void
      {
         if(Boolean(this.efActive) && this.assetLoader != null && !this.assetLoader.hasKillStackItems)
         {
            this.efActive = false;
            removeEventListener(Event.ENTER_FRAME,this.onEF);
         }
      }
      
      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.ensureAssetLoader();
         positionBy(param1.r);
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         this.fDraw();
         getLayout().registerForEvents(this,eventTypes);
      }
      
      override public function fClose() : void
      {
         this.btnWiki.removeEventListener(MouseEvent.CLICK,this.onBtnWiki);
         this.btnWiki.removeEventListener(MouseEvent.MOUSE_OVER,this.onWikiTTOver);
         this.btnWiki.removeEventListener(MouseEvent.MOUSE_OUT,this.onWikiTTOut);
         this.btnTry.removeEventListener(MouseEvent.CLICK,this.onBtnTryClick);
         this.btnTry.removeEventListener(MouseEvent.MOUSE_OVER,this.onTryTTOver);
         this.btnTry.removeEventListener(MouseEvent.MOUSE_OUT,this.onTryTTOut);
         this.btnMGender.removeEventListener(MouseEvent.CLICK,this.onBtnGender);
         this.btnMGender.removeEventListener(MouseEvent.MOUSE_OVER,this.onGenderTTOver);
         this.btnMGender.removeEventListener(MouseEvent.MOUSE_OUT,this.onGenderTTOut);
         this.btnFGender.removeEventListener(MouseEvent.CLICK,this.onBtnGender);
         this.btnFGender.removeEventListener(MouseEvent.MOUSE_OVER,this.onGenderTTOver);
         this.btnFGender.removeEventListener(MouseEvent.MOUSE_OUT,this.onGenderTTOut);
         this.btnDelete.removeEventListener(MouseEvent.CLICK,this.onBtnDeleteClick);
         this.btnDelete.removeEventListener(MouseEvent.MOUSE_OVER,this.onDeleteTTOver);
         this.btnDelete.removeEventListener(MouseEvent.MOUSE_OUT,this.onDeleteTTOut);
         this.mcCoin.removeEventListener(MouseEvent.MOUSE_OVER,this.onCoinTTOver);
         this.mcCoin.removeEventListener(MouseEvent.MOUSE_OUT,this.onCoinTTOut);
         this.mcUpgrade.removeEventListener(MouseEvent.MOUSE_OVER,this.onUpgradeTTOver);
         this.mcUpgrade.removeEventListener(MouseEvent.MOUSE_OUT,this.onUpgradeTTOut);
         if(this.efActive)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEF);
            this.efActive = false;
         }
         if(this.assetLoader != null)
         {
            this.assetLoader.dispose();
            this.assetLoader = null;
         }
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      protected function onBtnTryClick(param1:MouseEvent) : void
      {
         if(!this.iSel)
         {
            return;
         }
         this.rootClass.xTryMe(this.iSel);
         if(this.rootClass.ui.mcPopup.currentLabel == "MergeShop")
         {
            this.rootClass.ui.mcPopup.getChildByName("mcShop").fClose();
         }
         else
         {
            this.rootClass.ui.mcPopup.getChildByName("mcShop").previewPanel.visible = false;
         }
         this.rootClass.ui.ToolTip.close();
      }
      
      protected function onBtnWiki(param1:MouseEvent) : void
      {
         if(!this.iSel)
         {
            return;
         }
         navigateToURL(new URLRequest("http://aqwwiki.wikidot.com/" + this.iSel.sName),"_blank");
      }
      
      protected function onBtnGender(param1:MouseEvent) : void
      {
         if(Boolean(this.preventSpam) || !this.iSel)
         {
            return;
         }
         this.clearPreview();
         var _loc2_:String = param1.currentTarget.name == "btnMGender" ? "F" : "M";
         this.btnMGender.visible = _loc2_ == "M";
         this.btnFGender.visible = _loc2_ == "F";
         this.sLinkArmor = this.iSel.sLink;
         this.ensureAssetLoader();
         this.assetLoader.loadAsset(Game.serverFilePath + "classes/" + _loc2_ + "/" + this.iSel.sFile,this.iSel.sLink,"armor",this.onLoadArmorComplete,this.onLoadError);
         this.preventSpam = true;
      }
      
      protected function fDraw() : void
      {
         this.btnDelete.visible = false;
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:String = "#00CCFF";
         var _loc4_:Object = this.iSel;
         if(_loc4_ != null)
         {
            this.btnDelete.visible = true;
            this.tInfo.htmlText = this.rootClass.getItemInfoStringB(_loc4_);
            this.tInfo.y = this.tInfo.textHeight >= 109.8 ? int(this.btnDelete.y + this.btnDelete.height - this.tInfo.height + 10) : int(this.btnDelete.y + this.btnDelete.height - this.tInfo.textHeight - 3);
            this.mcUpgrade.visible = false;
            this.mcCoin.visible = false;
            if(_loc4_.bUpg == 1)
            {
               this.mcUpgrade.visible = true;
            }
            if(_loc4_.bCoins == 1)
            {
               this.mcUpgrade.visible = false;
               this.mcCoin.visible = true;
            }
            this.loadPreview(_loc4_);
         }
         else
         {
            this.tInfo.htmlText = "Please select an item to preview.";
            while(this.mcPreview.numChildren > 0)
            {
               this.mcPreview.removeChildAt(0);
            }
            this.clearPreview();
         }
         this.btnDelete.visible = true;
         if(getLayout().sMode.toLowerCase().indexOf("shop") > -1)
         {
            this.btnDelete.visible = false;
         }
         if(_loc4_ != null)
         {
            if(!this.btnDelete.visible && _loc4_.sType != "Enhancement")
            {
               switch(_loc4_.sES)
               {
                  case "Weapon":
                  case "he":
                  case "ba":
                  case "pe":
                  case "ar":
                  case "co":
                  case "mi":
                     if(_loc4_.bUpg == 1)
                     {
                        if(!this.rootClass.world.myAvatar.isUpgraded())
                        {
                           this.btnTry.visible = false;
                           break;
                        }
                     }
                     this.btnTry.visible = true;
                     break;
                  case "ho":
                  case "hi":
                  default:
                     this.btnTry.visible = false;
               }
            }
            if(_loc4_.sType != "Enhancement")
            {
               switch(_loc4_.sES)
               {
                  case "ar":
                  case "co":
                     if(this.rootClass.world.myAvatar.objData.strGender == "M")
                     {
                        this.btnFGender.visible = false;
                        this.btnMGender.visible = true;
                     }
                     else
                     {
                        this.btnFGender.visible = true;
                        this.btnMGender.visible = false;
                     }
                     break;
                  default:
                     this.btnFGender.visible = false;
                     this.btnMGender.visible = false;
               }
            }
            if(!this.btnFGender.visible && !this.btnMGender.visible)
            {
               this.btnWiki.y = this.btnMGender.y;
            }
            else
            {
               this.btnWiki.y = 121;
            }
            if(!this.btnTry.visible && !this.btnDelete.visible)
            {
               this.btnWiki.y = this.btnTry.y;
            }
            this.btnWiki.visible = true;
         }
      }
      
      override public function notify(param1:Object) : void
      {
         this.iSel = null;
         if(param1.fData.eSel != null)
         {
            this.iSel = param1.fData.eSel;
         }
         if(param1.fData.iSel != null)
         {
            this.iSel = param1.fData.iSel;
         }
         this.fDraw();
      }
      
      protected function onBtnDeleteClick(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.rootClass.mixer.playSound("Click");
         if(this.iSel.bEquip && this.iSel.sType != "Wall Item" && this.iSel.sType != "Floor Item" || this.iSel.bEquip >= this.iSel.iQty)
         {
            if(this.iSel.sType == "Wall Item" || this.iSel.sType == "Floor Item")
            {
               this.rootClass.MsgBox.notify("Item is currently placed in your house!");
            }
            else
            {
               this.rootClass.MsgBox.notify("Item is currently equipped!");
            }
         }
         else
         {
            _loc2_ = new ModalMC();
            _loc3_ = {};
            _loc3_.params = {};
            if(this.iSel.bCoins != null && this.iSel.bCoins == 1 && (this.iSel.iQty > 0 || this.iSel.sES == "ar"))
            {
               _loc3_.strBody = "<font color=\'#FF0000\'><b>AC items can not be deleted!</b></font>\n\nYou may sell the item if you really want, but there is no limit on AC item storage!";
               _loc3_.btns = "mono";
            }
            else
            {
               if(this.iSel.sES == "ar")
               {
                  _loc3_.strBody = "Are you sure you want to delete \'" + this.iSel.sName + "\' and the rank associated with it?";
               }
               else
               {
                  _loc3_.strBody = "Are you sure you want to delete \'" + this.iSel.sName + "\'?";
               }
               _loc3_.callback = this.deleteRequest;
               _loc4_ = this.iSel.iQty != null ? int(this.iSel.iQty) : 1;
               if(this.iSel.sES == "ar")
               {
                  _loc4_ = 1;
               }
               if(_loc4_ > 1)
               {
                  if(this.iSel.sType == "Wall Item" || this.iSel.sType == "Floor Item")
                  {
                     _loc5_ = int(this.iSel.iQty) - int(this.iSel.bEquip);
                     if(_loc5_ > 1)
                     {
                        _loc3_.qtySel = {
                           "min":1,
                           "max":_loc5_
                        };
                     }
                  }
                  else
                  {
                     _loc3_.qtySel = {
                        "min":1,
                        "max":_loc4_
                     };
                  }
               }
            }
            _loc3_.glow = "white,medium";
            _loc3_.greedy = true;
            this.rootClass.ui.ModalStack.addChild(_loc2_);
            _loc2_.init(_loc3_);
         }
      }
      
      protected function deleteRequest(param1:Object) : void
      {
         if(param1.accept)
         {
            if(param1.iQty != null)
            {
               this.rootClass.world.sendRemoveItemRequest(this.iSel,param1.iQty);
            }
            else
            {
               this.rootClass.world.sendRemoveItemRequest(this.iSel);
            }
         }
      }
      
      protected function loadPreview(param1:Object) : void
      {
         this.ensureAssetLoader();
         if(param1.sType.toLowerCase() != "enhancement")
         {
            if(this.curItem != param1)
            {
               this.curItem = param1;
               switch(param1.sES)
               {
                  case "Weapon":
                     this.loadWeapon(param1.sFile,param1.sLink);
                     break;
                  case "he":
                     this.loadHelm(param1.sFile,param1.sLink);
                     break;
                  case "ba":
                     this.loadCape(param1.sFile,param1.sLink);
                     break;
                  case "pe":
                     this.loadPet(param1.sFile,param1.sLink);
                     break;
                  case "ar":
                  case "co":
                     this.loadArmor(param1.sFile,param1.sLink);
                     break;
                  case "ho":
                     this.loadHouse(param1.sFile);
                     break;
                  case "hi":
                     this.loadHouseItem(param1.sFile,param1.sLink);
                     break;
                  case "mi":
                     this.loadMisc(param1.sFile,param1.sLink);
                     break;
                  default:
                     if(param1.sType.toLowerCase() == "item" && String(param1.sLink).toLowerCase() != "none")
                     {
                        this.loadBag(param1);
                     }
                     else if(param1.sES == "am")
                     {
                        this.loadBag(param1,true);
                     }
                     else if(param1.sType.toLowerCase() == "serveruse" || param1.sType.toLowerCase() == "clientuse")
                     {
                        this.loadBag(param1);
                     }
                     else
                     {
                        this.clearPreview();
                     }
               }
            }
         }
         else
         {
            this.loadEnhancement(param1);
         }
      }
      
      protected function clearPreview() : void
      {
         this.ensureAssetLoader();
         this.assetLoader.clearPreview();
         this.startKillStackProcessing();
         this.curItem = null;
      }
      
      protected function loadEnhancement(param1:*) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var item:* = param1;
         this.clearPreview();
         try
         {
            AssetClass = this.rootClass.world.getClass("iidesign") as Class;
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            trace("[UI] ERR loadEnhancement: iidesign class: " + err.message);
         }
         mc.scaleX = mc.scaleY = 3;
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }
      
      protected function loadBag(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         this.clearPreview();
         var _loc4_:Class = this.rootClass.world.getClass("iibag") as Class;
         if(param2 || (param1 == null || !("sFile" in param1) || String(param1.sFile).length < 1 || this.rootClass.world.getClass(param1.sFile) == null))
         {
            _loc4_ = this.rootClass.world.getClass(param1.sIcon) as Class;
         }
         else if(param1 != null && "sFile" in param1 && String(param1.sFile).length > 0 && this.rootClass.world.getClass(param1.sFile) != null)
         {
            _loc4_ = this.rootClass.world.getClass(param1.sFile) as Class;
         }
         try
         {
            _loc3_ = new _loc4_();
            _loc3_.scaleX = _loc3_.scaleY = 3;
            this.mcPreview.addChild(_loc3_);
            this.addGlow(_loc3_);
         }
         catch(e:Error)
         {
         }
      }
      
      protected function loadMisc(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkMisc = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"misc",this.onLoadMiscComplete,this.onLoadError);
      }
      
      protected function loadWeapon(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkWeapon = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"weapon",this.onLoadWeaponComplete,this.onLoadError);
      }
      
      protected function loadCape(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkCape = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"cape",this.onLoadCapeComplete,this.onLoadError);
      }
      
      protected function loadHelm(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkHelm = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"helm",this.onLoadHelmComplete,this.onLoadError);
      }
      
      protected function loadPet(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkPet = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"pet",this.onLoadPetComplete,this.onLoadError);
      }
      
      protected function loadHouse(param1:String) : void
      {
         this.clearPreview();
         var _loc2_:String = param1.substring(0,param1.length - 4);
         var _loc3_:* = "maps/" + _loc2_ + "_preview.swf";
         this.previewArgs.sFile = param1;
         this.assetLoader.loadAsset(Game.serverFilePath + _loc3_,"","house",this.onLoadHouseComplete,this.onLoadError);
      }
      
      protected function onLoadHouseComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc8_:* = undefined;
         var _loc4_:String = this.previewArgs.sFile.substring(0,this.previewArgs.sFile.length - 4);
         var _loc5_:int = this.previewArgs.sFile.lastIndexOf("/") + 1;
         var _loc6_:* = _loc4_.substr(_loc5_).split("-").join("_") + "_preview";
         var _loc7_:Class = this.assetLoader.getDefinition(_loc6_);
         if(_loc7_ != null)
         {
            _loc8_ = new _loc7_();
            this.mcPreview.addChild(_loc8_);
            this.addGlow(_loc8_);
         }
      }
      
      protected function loadArmor(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkArmor = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + "classes/" + this.rootClass.world.myAvatar.objData.strGender + "/" + param1,param2,"armor",this.onLoadArmorComplete,this.onLoadError);
      }
      
      protected function onLoadMiscComplete(param1:Event, param2:String, param3:String) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var e:Event = param1;
         var linkage:String = param2;
         var type:String = param3;
         try
         {
            AssetClass = this.assetLoader.getDefinition(this.sLinkMisc);
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            mc = e.target.content;
         }
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }
      
      protected function onLoadWeaponComplete(param1:Event, param2:String, param3:String) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var e:Event = param1;
         var linkage:String = param2;
         var type:String = param3;
         try
         {
            AssetClass = this.assetLoader.getDefinition(this.sLinkWeapon);
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            mc = e.target.content;
         }
         mc.scaleX = mc.scaleY = 0.3;
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }
      
      protected function onLoadCapeComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc4_:Class = null;
         var _loc5_:* = undefined;
         try
         {
            _loc4_ = this.assetLoader.getDefinition(this.sLinkCape);
            _loc5_ = new _loc4_();
            _loc5_.scaleX = _loc5_.scaleY = 0.5;
            this.mcPreview.addChild(_loc5_);
            this.addGlow(_loc5_);
         }
         catch(e:Error)
         {
         }
      }
      
      protected function onLoadHelmComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc4_:Class = null;
         var _loc5_:* = undefined;
         var _loc6_:Class = null;
         var _loc7_:* = undefined;
         try
         {
            _loc4_ = this.assetLoader.getDefinition(this.sLinkHelm);
            _loc5_ = new _loc4_();
            _loc5_.scaleX = _loc5_.scaleY = 0.8;
            this.mcPreview.addChild(_loc5_);
            try
            {
               _loc6_ = this.assetLoader.getDefinition(this.sLinkHelm + "_backhair");
               if(_loc6_ != null)
               {
                  _loc7_ = new _loc6_();
                  _loc7_.x = _loc5_.getChildAt(0).x + 1;
                  _loc7_.y = _loc5_.getChildAt(0).y - 28;
                  _loc7_.scaleX = _loc7_.scaleY = 3.2;
                  _loc5_.addChild(_loc7_);
                  _loc5_.setChildIndex(_loc7_,0);
               }
            }
            catch(e0:Error)
            {
            }
            this.addGlow(_loc5_);
         }
         catch(e:Error)
         {
         }
      }
      
      protected function onLoadArmorComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc4_:* = this.mcPreview.addChild(new AvatarMC());
         _loc4_.visible = false;
         _loc4_.strGender = this.rootClass.world.myAvatar.objData.strGender;
         if(this.btnMGender.visible || this.btnFGender.visible)
         {
            _loc4_.strGender = this.btnMGender.visible ? "M" : "F";
         }
         var _loc5_:Avatar = new Avatar(this.rootClass);
         _loc5_.isCharPage = true;
         _loc5_.objData = this.rootClass.copyObj(this.rootClass.world.myAvatar.objData);
         _loc4_.pAV = _loc5_;
         _loc4_.pAV.pMC = _loc4_;
         _loc4_.world = MovieClip(Game.root).world;
         _loc4_.hideHPBar();
         _loc4_.name = "previewMCB";
         this.addGlow(_loc4_.mcChar,false);
         _loc4_.loadArmorPiecesFromDomain(this.sLinkArmor,this.assetLoader.applicationDomain);
         _loc4_.visible = true;
         this.preventSpam = false;
      }
      
      protected function onLoadPetComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc5_:* = undefined;
         var _loc4_:Class = this.assetLoader.getDefinition(this.sLinkPet);
         if(_loc4_ != null)
         {
            _loc5_ = new _loc4_();
            _loc5_.scaleX = _loc5_.scaleY = 2;
            this.mcPreview.addChild(_loc5_);
            this.addGlow(_loc5_);
         }
      }
      
      protected function addGlow(param1:MovieClip, param2:Boolean = true) : void
      {
         param1.filters = [WHITE_GLOW];
         if(param2)
         {
            this.repositionPreview(param1);
         }
      }
      
      public function repositionPreview(param1:MovieClip) : void
      {
         var _loc2_:Rectangle = param1.getBounds(this);
         if(_loc2_.height > 175)
         {
            param1.scaleX *= 175 / _loc2_.height;
            param1.scaleY *= 175 / _loc2_.height;
         }
         param1.x -= int(param1.getBounds(this).x + param1.getBounds(this).width / 2 - this.width / 2);
         param1.y = int(param1.y - param1.getBounds(this).y);
      }
      
      protected function loadHouseItem(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.previewArgs.sLink = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"houseitem",this.onloadHouseItemComplete,this.onLoadError);
      }
      
      protected function onloadHouseItemComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc5_:* = undefined;
         var _loc4_:Class = this.assetLoader.getDefinition(this.previewArgs.sLink);
         if(_loc4_ != null)
         {
            _loc5_ = new _loc4_();
            this.mcPreview.addChild(_loc5_);
            this.addGlow(_loc5_);
         }
      }
      
      protected function onLoadError(param1:String) : void
      {
         trace("[Load] ERR LPFFrameItemPreview load: " + param1);
      }
      
      protected function onWikiTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Search on Wiki"});
      }
      
      protected function onWikiTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
      
      protected function onGenderTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Switch Gender"});
      }
      
      protected function onGenderTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
      
      protected function onTryTTOver(param1:MouseEvent) : void
      {
         if(Boolean(this.rootClass.world.myAvatar.objData.eqp[this.iSel.sES]) && this.iSel.sFile == this.rootClass.world.myAvatar.objData.eqp[this.iSel.sES].sFile)
         {
            this.rootClass.ui.ToolTip.openWith({"str":"Revert Try Me"});
         }
         else
         {
            this.rootClass.ui.ToolTip.openWith({"str":"Try Me!"});
         }
      }
      
      protected function onTryTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
      
      protected function onDeleteTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Delete item"});
      }
      
      protected function onDeleteTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
      
      protected function onCoinTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"This item requires Adventure Coins to purchase."});
      }
      
      protected function onCoinTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
      
      protected function onUpgradeTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"This item is exclusive to upgraded members."});
      }
      
      protected function onUpgradeTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
      
      protected function onEF(param1:Event) : void
      {
         if(this.assetLoader != null)
         {
            this.assetLoader.processKillStack();
            this.stopKillStackProcessing();
         }
      }
   }
}

