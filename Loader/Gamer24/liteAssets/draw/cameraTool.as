package liteAssets.draw
{
   import fl.data.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class cameraTool extends MovieClip
   {
      public var background:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var btnExpand:SimpleButton;
      
      public var btnExpandTxt:TextField;
      
      public var btnLeft:SimpleButton;
      
      public var btnRight:SimpleButton;
      
      public var cameratoolUI:MovieClip;
      
      public var dummyMC:MovieClip;
      
      public var txtLeft:TextField;
      
      public var txtRight:TextField;
      
      public var weaponUI:MovieClip;
      
      private var playerGlowFilter:GlowFilter;
      
      private var mainGlowFilter:GlowFilter;
      
      private var offGlowFilter:GlowFilter;
      
      public var AvatarDisplay:AvatarMC;
      
      internal var rootClass:MovieClip;
      
      private var op:Point;
      
      private var tp:Point;
      
      private var walkTS:*;
      
      private var walkD:*;
      
      public var mcCharHidden:Boolean;
      
      public var mcCharOptions:Object;
      
      public var scaleAvt:Number = 3;
      
      public var weaponDeattached:Boolean;
      
      public var deattachedMain:MovieClip;
      
      public var deattachedOff:MovieClip;
      
      public var weaponFocus:int = 0;
      
      public var isMirrored:Boolean;
      
      public var isMirroredOff:Boolean;
      
      public var isFrozen:Boolean;
      
      public var isStoned:Boolean;
      
      public var isHit:Boolean;
      
      public var glowMain:Boolean;
      
      public var glowOff:Boolean;
      
      public var glowPlayer:Boolean;
      
      internal var oldX:int;
      
      internal var oldY:int;
      
      public function cameraTool(param1:MovieClip)
      {
         this.playerGlowFilter = new GlowFilter(16777215,1,8,8,2,1,false,false);
         this.mainGlowFilter = new GlowFilter(16777215,1,8,8,2,1,false,false);
         this.offGlowFilter = new GlowFilter(16777215,1,8,8,2,1,false,false);
         this.op = new Point();
         this.tp = new Point();
         this.mcCharOptions = {
            "backhair":false,
            "robe":false,
            "backrobe":false
         };
         super();
         this.rootClass = param1;
         this.btnExpandTxt.mouseEnabled = false;
         this.weaponUI.visible = false;
         this.dummyMC.visible = false;
         this.cameratoolUI.secondary.visible = false;
         this.btnExpand.addEventListener(MouseEvent.CLICK,this.onBtnExpand,false,0,true);
         this.AvatarDisplay = new AvatarMC();
         this.AvatarDisplay.world = this.rootClass.world;
         this.copyTo(this.AvatarDisplay.mcChar);
         this.AvatarDisplay.x = 650;
         this.AvatarDisplay.y = 450;
         this.AvatarDisplay.hideHPBar();
         this.AvatarDisplay.gotoAndPlay("in2");
         this.AvatarDisplay.mcChar.gotoAndPlay("Idle");
         this.addChild(this.AvatarDisplay);
         this.AvatarDisplay.scale(this.scaleAvt);
         this.AvatarDisplay.shadow.visible = false;
         this.cameratoolUI.primary.txtClassName.text = this.rootClass.world.myAvatar.objData.strClassName;
         this.background.mouseEnabled = true;
         this.background.addEventListener(MouseEvent.CLICK,this.onWalk,false,0,true);
         this.cameratoolUI.primary.colBG.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.onColBG,false,0,true);
         this.cameratoolUI.primary.colBG.addEventListener(Event.CLOSE,this.onColBG,false,0,true);
         var _loc2_:Array = [{"label":"Idle"},{"label":"Walk"},{"label":"Dance"},{"label":"Laugh"},{"label":"Point"},{"label":"Use"},{"label":"Stern"},{"label":"SternLoop"},{"label":"Salute"},{"label":"Cheer"},{"label":"Facepalm"},{"label":"Airguitar"},{"label":"Backflip"},{"label":"Sleep"},{"label":"Jump"},{"label":"Punt"},{"label":"Dance2"},{"label":"Swordplay"},{"label":"Feign"},{"label":"Dead"},{"label":"Wave"},{"label":"Bow"},{"label":"Rest"},{"label":"Cry"},{"label":"Unsheath"},{"label":"Fight"},{"label":"Attack1"},{"label":"Attack2"},{"label":"Attack3"},{"label":"Attack4"},{"label":"Hit"},{"label":"Knockout"},{"label":"Getup"},{"label":"Stab"},{"label":"Thrash"},{"label":"Castgood"},{"label":"Cast1"},{"label":"Cast2"},{"label":"Cast3"},{"label":"Sword/ShieldFight"},{"label":"Sword/ShieldAttack1"},{"label":"Sword/ShieldAttack2"},{"label":"ShieldBlock"},{"label":"DuelWield/DaggerFight"},{"label":"DuelWield/DaggerAttack1"},{"label":"DuelWield/DaggerAttack2"},{"label":"FistweaponFight"},{"label":"FistweaponAttack1"}
         ,{"label":"FistweaponAttack2"},{"label":"PolearmFight"},{"label":"PolearmAttack1"},{"label":"PolearmAttack2"},{"label":"RangedFight"},{"label":"UnarmedFight"},{"label":"UnarmedAttack1"},{"label":"UnarmedAttack2"},{"label":"KickAttack"},{"label":"FlipAttack"},{"label":"Dodge"},{"label":"Powerup"},{"label":"Kneel"},{"label":"Jumpcheer"},{"label":"Salute2"},{"label":"Cry2"},{"label":"Spar"},{"label":"Samba"},{"label":"Stepdance"},{"label":"Headbang"},{"label":"Dazed"},{"label":"Psychic1"},{"label":"Psychic2"},{"label":"Danceweapon"},{"label":"Useweapon"},{"label":"Throw"},{"label":"FireBreath"}];
         _loc2_.sortOn("label");
         this.cameratoolUI.primary.cbEmotes.dataProvider = new DataProvider(_loc2_);
         this.cameratoolUI.primary.btnEmote.addEventListener(MouseEvent.CLICK,this.onBtnEmote,false,0,true);
         this.cameratoolUI.primary.btnClass1.addEventListener(MouseEvent.CLICK,this.onBtnClass,false,0,true);
         this.cameratoolUI.primary.btnClass2.addEventListener(MouseEvent.CLICK,this.onBtnClass,false,0,true);
         this.cameratoolUI.primary.btnClass3.addEventListener(MouseEvent.CLICK,this.onBtnClass,false,0,true);
         this.cameratoolUI.primary.btnClass4.addEventListener(MouseEvent.CLICK,this.onBtnClass,false,0,true);
         this.cameratoolUI.primary.btnClass5.addEventListener(MouseEvent.CLICK,this.onBtnClass,false,0,true);
         this.cameratoolUI.primary.btnToggleDummy.addEventListener(MouseEvent.CLICK,this.onBtnToggleDummy,false,0,true);
         this.dummyMC.addEventListener(MouseEvent.MOUSE_DOWN,this.onDummyDown,false,0,true);
         this.dummyMC.addEventListener(MouseEvent.MOUSE_UP,this.onDummyUp,false,0,true);
         var _loc3_:Array = [{"label":"Mainhand"},{"label":"Offhand"},{"label":"Cape"},{"label":"Helmet"},{"label":"Player"},{"label":"Shadow"},{"label":"Head"},{"label":"Robe"},{"label":"Back Robe"},{"label":"Misc"},{"label":"Backhair"}];
         _loc3_.sortOn("label");
         this.cameratoolUI.primary.cbVisibility.dataProvider = new DataProvider(_loc3_);
         this.cameratoolUI.primary.btnVisibility.addEventListener(MouseEvent.CLICK,this.onBtnVisibility,false,0,true);
         this.cameratoolUI.primary.numScaling.addEventListener(Event.CHANGE,this.onNumScaling,false,0,true);
         this.cameratoolUI.primary.btnDeattach.addEventListener(MouseEvent.CLICK,this.onBtnDeattach,false,0,true);
         this.cameratoolUI.primary.btnShowDeattach.addEventListener(MouseEvent.CLICK,this.onBtnShowDeattach,false,0,true);
         this.weaponUI.background.addEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponUIDown,false,0,true);
         this.weaponUI.background.addEventListener(MouseEvent.MOUSE_UP,this.onWeaponUIUp,false,0,true);
         this.weaponUI.txtFocus.mouseEnabled = false;
         this.weaponUI.btnSetFocus.addEventListener(MouseEvent.CLICK,this.onBtnSetFocus,false,0,true);
         this.weaponUI.sldrRotation.addEventListener(SliderEvent.CHANGE,this.onSldrRotation,false,0,true);
         this.weaponUI.btnAddLayer.addEventListener(MouseEvent.CLICK,this.onBtnAddLayer,false,0,true);
         this.weaponUI.btnDelLayer.addEventListener(MouseEvent.CLICK,this.onBtnDelLayer,false,0,true);
         this.weaponUI.numWepScale.addEventListener(Event.CHANGE,this.onNumWepScale,false,0,true);
         this.weaponUI.btnMirror.addEventListener(MouseEvent.CLICK,this.onBtnMirror,false,0,true);
         this.weaponUI.btnInCombat.addEventListener(MouseEvent.CLICK,this.onBtnInCombat,false,0,true);
         this.cameratoolUI.primary.btnFreezePlayer.addEventListener(MouseEvent.CLICK,this.onBtnFreezePlayer,false,0,true);
         this.cameratoolUI.primary.btnStonePlayer.addEventListener(MouseEvent.CLICK,this.onBtnStonePlayer,false,0,true);
         this.cameratoolUI.primary.btnHitPlayer.addEventListener(MouseEvent.CLICK,this.onBtnHitPlayer,false,0,true);
         this.cameratoolUI.primary.btnResetPlayer.addEventListener(MouseEvent.CLICK,this.onBtnResetPlayer,false,0,true);
         this.cameratoolUI.primary.colGlow.addEventListener(Event.CLOSE,this.onColGlow,false,0,true);
         this.cameratoolUI.primary.colGlow.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.onColGlow,false,0,true);
         this.cameratoolUI.primary.colGlowMain.addEventListener(Event.CLOSE,this.onColGlowMain,false,0,true);
         this.cameratoolUI.primary.colGlowMain.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.onColGlowMain,false,0,true);
         this.cameratoolUI.primary.colGlowOff.addEventListener(Event.CLOSE,this.onColGlowOff,false,0,true);
         this.cameratoolUI.primary.colGlowOff.addEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.onColGlowOff,false,0,true);
         this.cameratoolUI.primary.btnGlowMain.addEventListener(MouseEvent.CLICK,this.onBtnGlowMain,false,0,true);
         this.cameratoolUI.primary.btnGlowOff.addEventListener(MouseEvent.CLICK,this.onBtnGlowOff,false,0,true);
         this.cameratoolUI.primary.btnGlowPlayer.addEventListener(MouseEvent.CLICK,this.onBtnGlowPlayer,false,0,true);
         this.cameratoolUI.secondary.btnGender.addEventListener(MouseEvent.CLICK,this.onBtnGender,false,0,true);
         this.cameratoolUI.secondary.btnTurnHead.addEventListener(MouseEvent.CLICK,this.onBtnTurnHead,false,0,true);
         this.txtLeft.mouseEnabled = false;
         this.txtRight.mouseEnabled = false;
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onBtnClose,false,0,true);
         this.btnLeft.addEventListener(MouseEvent.CLICK,this.onBtnLeft,false,0,true);
         this.btnRight.addEventListener(MouseEvent.CLICK,this.onBtnRight,false,0,true);
      }
      
      public function onBtnLeft(param1:MouseEvent) : void
      {
         this.cameratoolUI.primary.visible = !this.cameratoolUI.primary.visible;
         this.cameratoolUI.secondary.visible = !this.cameratoolUI.secondary.visible;
      }
      
      public function onBtnRight(param1:MouseEvent) : void
      {
         this.cameratoolUI.primary.visible = !this.cameratoolUI.primary.visible;
         this.cameratoolUI.secondary.visible = !this.cameratoolUI.secondary.visible;
      }
      
      public function copyTo(param1:MovieClip) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = undefined;
         this.AvatarDisplay.pAV = this.rootClass.world.myAvatar;
         this.AvatarDisplay.pAV.isCameraTool = true;
         this.AvatarDisplay.strGender = this.AvatarDisplay.pAV.objData.strGender;
         var _loc3_:* = ["cape","backhair","robe","backrobe"];
         for(_loc2_ in _loc3_)
         {
            if(typeof param1[_loc3_[_loc2_]] != undefined)
            {
               param1[_loc3_[_loc2_]].visible = false;
            }
         }
         if(!this.AvatarDisplay.pAV.dataLeaf.showHelm || !("he" in this.AvatarDisplay.pAV.objData.eqp) && this.AvatarDisplay.pAV.objData.eqp.he == null)
         {
            this.AvatarDisplay.loadHair();
         }
         for(_loc4_ in this.rootClass.world.myAvatar.objData.eqp)
         {
            switch(_loc4_)
            {
               case "Weapon":
                  this.AvatarDisplay.loadWeapon(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,null);
                  break;
               case "he":
                  if(this.AvatarDisplay.pAV.dataLeaf.showHelm)
                  {
                     this.AvatarDisplay.loadHelm(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,null);
                  }
                  break;
               case "ba":
                  if(this.AvatarDisplay.pAV.dataLeaf.showCloak)
                  {
                     this.AvatarDisplay.loadCape(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,null);
                  }
                  break;
               case "ar":
                  if(this.rootClass.world.myAvatar.objData.eqp.co == null)
                  {
                     this.AvatarDisplay.loadClass(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,null);
                  }
                  break;
               case "co":
                  this.AvatarDisplay.loadArmor(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,this.AvatarDisplay.pAV.objData.eqp[_loc4_].sLink);
                  break;
               case "mi":
                  this.AvatarDisplay.loadMisc(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,this.AvatarDisplay.pAV.objData.eqp[_loc4_].sLink);
                  break;
            }
         }
      }
      
      public function loadWeaponOff(param1:*, param2:*) : void
      {
         this.rootClass.world.queueLoad({
            "strFile":this.rootClass.world.rootClass.getFilePath() + param1,
            "callBackA":this.onLoadWeaponOffComplete,
            "avt":this.AvatarDisplay.pAV,
            "sES":"weapon"
         });
      }
      
      public function onLoadWeaponOffComplete(param1:Event) : void
      {
         var AssetClass:Class = null;
         this.AvatarDisplay.pAV.updateLoaded();
         this.AvatarDisplay.mcChar.weaponOff.removeChildAt(0);
         try
         {
            AssetClass = this.rootClass.world.getClass(this.AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class;
            this.AvatarDisplay.mcChar.weaponOff.addChild(new AssetClass());
         }
         catch(err:Error)
         {
            AvatarDisplay.mcChar.weaponOff.addChild(param1.target.content);
         }
         this.AvatarDisplay.mcChar.weaponOff.visible = true;
      }
      
      public function onBtnClose(param1:MouseEvent) : void
      {
         this.rootClass.world.visible = true;
         this.AvatarDisplay.pAV.isCameraTool = false;
         this.cleanup();
         this.parent.removeChild(this);
         this.rootClass.stage.focus = null;
      }
      
      private function cleanup() : void
      {
         this.btnExpand.removeEventListener(MouseEvent.CLICK,this.onBtnExpand);
         this.background.removeEventListener(MouseEvent.CLICK,this.onWalk);
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.onBtnClose);
         this.btnLeft.removeEventListener(MouseEvent.CLICK,this.onBtnLeft);
         this.btnRight.removeEventListener(MouseEvent.CLICK,this.onBtnRight);
         if(this.cameratoolUI != null && this.cameratoolUI.primary != null)
         {
            this.cameratoolUI.primary.colBG.removeEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.onColBG);
            this.cameratoolUI.primary.colBG.removeEventListener(Event.CLOSE,this.onColBG);
            this.cameratoolUI.primary.btnEmote.removeEventListener(MouseEvent.CLICK,this.onBtnEmote);
            this.cameratoolUI.primary.btnClass1.removeEventListener(MouseEvent.CLICK,this.onBtnClass);
            this.cameratoolUI.primary.btnClass2.removeEventListener(MouseEvent.CLICK,this.onBtnClass);
            this.cameratoolUI.primary.btnClass3.removeEventListener(MouseEvent.CLICK,this.onBtnClass);
            this.cameratoolUI.primary.btnClass4.removeEventListener(MouseEvent.CLICK,this.onBtnClass);
            this.cameratoolUI.primary.btnClass5.removeEventListener(MouseEvent.CLICK,this.onBtnClass);
            this.cameratoolUI.primary.btnToggleDummy.removeEventListener(MouseEvent.CLICK,this.onBtnToggleDummy);
            this.cameratoolUI.primary.btnVisibility.removeEventListener(MouseEvent.CLICK,this.onBtnVisibility);
            this.cameratoolUI.primary.numScaling.removeEventListener(Event.CHANGE,this.onNumScaling);
            this.cameratoolUI.primary.btnDeattach.removeEventListener(MouseEvent.CLICK,this.onBtnDeattach);
            this.cameratoolUI.primary.btnShowDeattach.removeEventListener(MouseEvent.CLICK,this.onBtnShowDeattach);
            this.cameratoolUI.primary.btnFreezePlayer.removeEventListener(MouseEvent.CLICK,this.onBtnFreezePlayer);
            this.cameratoolUI.primary.btnStonePlayer.removeEventListener(MouseEvent.CLICK,this.onBtnStonePlayer);
            this.cameratoolUI.primary.btnHitPlayer.removeEventListener(MouseEvent.CLICK,this.onBtnHitPlayer);
            this.cameratoolUI.primary.btnResetPlayer.removeEventListener(MouseEvent.CLICK,this.onBtnResetPlayer);
            this.cameratoolUI.primary.colGlow.removeEventListener(Event.CLOSE,this.onColGlow);
            this.cameratoolUI.primary.colGlow.removeEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.onColGlow);
            this.cameratoolUI.primary.colGlowMain.removeEventListener(Event.CLOSE,this.onColGlowMain);
            this.cameratoolUI.primary.colGlowMain.removeEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.onColGlowMain);
            this.cameratoolUI.primary.colGlowOff.removeEventListener(Event.CLOSE,this.onColGlowOff);
            this.cameratoolUI.primary.colGlowOff.removeEventListener(ColorPickerEvent.ITEM_ROLL_OVER,this.onColGlowOff);
            this.cameratoolUI.primary.btnGlowMain.removeEventListener(MouseEvent.CLICK,this.onBtnGlowMain);
            this.cameratoolUI.primary.btnGlowOff.removeEventListener(MouseEvent.CLICK,this.onBtnGlowOff);
            this.cameratoolUI.primary.btnGlowPlayer.removeEventListener(MouseEvent.CLICK,this.onBtnGlowPlayer);
         }
         if(this.cameratoolUI != null && this.cameratoolUI.secondary != null)
         {
            this.cameratoolUI.secondary.btnGender.removeEventListener(MouseEvent.CLICK,this.onBtnGender);
            this.cameratoolUI.secondary.btnTurnHead.removeEventListener(MouseEvent.CLICK,this.onBtnTurnHead);
         }
         if(this.weaponUI != null)
         {
            this.weaponUI.background.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponUIDown);
            this.weaponUI.background.removeEventListener(MouseEvent.MOUSE_UP,this.onWeaponUIUp);
            this.weaponUI.btnSetFocus.removeEventListener(MouseEvent.CLICK,this.onBtnSetFocus);
            this.weaponUI.sldrRotation.removeEventListener(SliderEvent.CHANGE,this.onSldrRotation);
            this.weaponUI.btnAddLayer.removeEventListener(MouseEvent.CLICK,this.onBtnAddLayer);
            this.weaponUI.btnDelLayer.removeEventListener(MouseEvent.CLICK,this.onBtnDelLayer);
            this.weaponUI.numWepScale.removeEventListener(Event.CHANGE,this.onNumWepScale);
            this.weaponUI.btnMirror.removeEventListener(MouseEvent.CLICK,this.onBtnMirror);
            this.weaponUI.btnInCombat.removeEventListener(MouseEvent.CLICK,this.onBtnInCombat);
         }
         if(this.dummyMC != null)
         {
            this.dummyMC.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDummyDown);
            this.dummyMC.removeEventListener(MouseEvent.MOUSE_UP,this.onDummyUp);
         }
         if(this.AvatarDisplay != null)
         {
            this.AvatarDisplay.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            if(this.AvatarDisplay.mcChar != null)
            {
               this.AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onAvatarDown);
               this.AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_UP,this.onAvatarUp);
            }
         }
         if(this.deattachedMain != null)
         {
            this.deattachedMain.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponDownDrag);
            this.deattachedMain.removeEventListener(MouseEvent.MOUSE_UP,this.onWeaponUpDrag);
         }
         if(this.deattachedOff != null)
         {
            this.deattachedOff.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponOffDownDrag);
            this.deattachedOff.removeEventListener(MouseEvent.MOUSE_UP,this.onWeaponOffUpDrag);
         }
         this.rootClass = null;
      }
      
      public function onWalk(param1:MouseEvent) : void
      {
         if(this.isFrozen)
         {
            return;
         }
         this.walkTo(param1.stageX,param1.stageY,16);
      }
      
      public function walkTo(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         param1 = param1;
         param2 = param2;
         param3 = param3;
         this.op.x = this.AvatarDisplay.x;
         this.op.y = this.AvatarDisplay.y;
         this.tp.x = param1;
         this.tp.y = param2;
         _loc4_ = Number(Point.distance(this.op,this.tp));
         this.walkTS = new Date().getTime();
         this.walkD = Math.round(1000 * (_loc4_ / (param3 * 22)));
         if(this.walkD > 0)
         {
            _loc5_ = this.op.x - this.tp.x;
            if(_loc5_ < 0)
            {
               this.AvatarDisplay.turn("right");
            }
            else
            {
               this.AvatarDisplay.turn("left");
            }
            if(!this.AvatarDisplay.mcChar.onMove)
            {
               this.AvatarDisplay.mcChar.onMove = true;
               if(this.AvatarDisplay.mcChar.currentLabel != "Walk")
               {
                  this.AvatarDisplay.mcChar.gotoAndPlay("Walk");
               }
            }
            this.AvatarDisplay.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
            this.AvatarDisplay.addEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk,false,0,true);
         }
      }
      
      public function onEnterFrameWalk(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:Boolean = false;
         var _loc7_:Point = null;
         var _loc8_:Rectangle = null;
         _loc2_ = Number(new Date().getTime());
         _loc3_ = (_loc2_ - this.walkTS) / this.walkD;
         if(_loc3_ > 1)
         {
            _loc3_ = 1;
         }
         if(Point.distance(this.op,this.tp) > 0.5 && this.AvatarDisplay.mcChar.onMove)
         {
            _loc4_ = this.AvatarDisplay.x;
            _loc5_ = this.AvatarDisplay.y;
            this.AvatarDisplay.x = Point.interpolate(this.tp,this.op,_loc3_).x;
            this.AvatarDisplay.y = Point.interpolate(this.tp,this.op,_loc3_).y;
            if(Math.round(_loc4_) == Math.round(this.AvatarDisplay.x) && Math.round(_loc5_) == Math.round(this.AvatarDisplay.y) && _loc2_ > this.walkTS + 50)
            {
               this.stopWalking();
            }
         }
         else
         {
            this.stopWalking();
         }
      }
      
      public function stopWalking() : void
      {
         if(this.AvatarDisplay.mcChar.onMove)
         {
            this.AvatarDisplay.removeEventListener(Event.ENTER_FRAME,this.onEnterFrameWalk);
         }
         this.AvatarDisplay.mcChar.onMove = false;
         this.AvatarDisplay.mcChar.gotoAndPlay("Idle");
      }
      
      public function onBtnExpand(param1:MouseEvent) : void
      {
         if(this.cameratoolUI.visible)
         {
            this.cameratoolUI.visible = false;
            this.weaponUI.visible = false;
            this.btnLeft.visible = false;
            this.btnRight.visible = false;
            this.txtLeft.visible = false;
            this.txtRight.visible = false;
            this.btnExpandTxt.text = "+";
         }
         else
         {
            this.cameratoolUI.visible = true;
            this.btnLeft.visible = true;
            this.btnRight.visible = true;
            this.txtLeft.visible = true;
            this.txtRight.visible = true;
            this.btnExpandTxt.text = "-";
         }
      }
      
      public function onColBG(param1:*) : void
      {
         var _loc2_:* = new ColorTransform();
         _loc2_.color = "0x" + param1.currentTarget.hexValue;
         this.background.transform.colorTransform = _loc2_;
      }
      
      public function onBtnEmote(param1:MouseEvent) : void
      {
         if(this.cameratoolUI.primary.cbEmotes.selectedItem.label == "Walk")
         {
            this.AvatarDisplay.mcChar.onMove = true;
         }
         else
         {
            this.AvatarDisplay.mcChar.onMove = false;
         }
         this.AvatarDisplay.mcChar.gotoAndPlay(this.cameratoolUI.primary.cbEmotes.selectedItem.label);
      }
      
      public function onBtnClass(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         switch(param1.currentTarget.name)
         {
            case "btnClass1":
               _loc2_ = this.rootClass.world.actions.active[0].anim;
               _loc3_ = this.rootClass.world.actions.active[0];
               break;
            case "btnClass2":
               _loc2_ = this.rootClass.world.actions.active[1].anim;
               _loc3_ = this.rootClass.world.actions.active[1];
               break;
            case "btnClass3":
               _loc2_ = this.rootClass.world.actions.active[2].anim;
               _loc3_ = this.rootClass.world.actions.active[2];
               break;
            case "btnClass4":
               _loc2_ = this.rootClass.world.actions.active[3].anim;
               _loc3_ = this.rootClass.world.actions.active[3];
               break;
            case "btnClass5":
               _loc2_ = this.rootClass.world.actions.active[4].anim;
               _loc3_ = this.rootClass.world.actions.active[4];
         }
         if(_loc2_.indexOf(",") > -1)
         {
            _loc2_ = _loc2_.split(",")[Math.round(Math.random() * (_loc2_.split(",").length - 1))];
         }
         this.AvatarDisplay.spFX.strl = _loc3_.strl;
         this.AvatarDisplay.spFX.fx = _loc3_.fx;
         this.AvatarDisplay.spFX.tgt = _loc3_.tgt;
         this.AvatarDisplay.mcChar.gotoAndPlay(_loc2_);
      }
      
      public function init_func() : void
      {
      }
      
      public function castSpellFX(param1:* = null) : *
      {
         var _loc3_:* = undefined;
         if(param1 == null)
         {
            param1 = this.AvatarDisplay.spFX;
         }
         var _loc2_:Class = this.rootClass.world.getClass(param1.strl) as Class;
         if(_loc2_ != null)
         {
            _loc3_ = new _loc2_();
            _loc3_.spellDur = 0;
            this.addChild(_loc3_);
            _loc3_.scaleX *= this.scaleAvt;
            _loc3_.scaleY *= this.scaleAvt;
            _loc3_.mouseEnabled = false;
            _loc3_.mouseChildren = false;
            _loc3_.visible = true;
            _loc3_.world = this;
            _loc3_.strl = param1.strl;
            if(Boolean(param1.tgt) && param1.tgt == "s")
            {
               _loc3_.tMC = this.AvatarDisplay;
            }
            else
            {
               if(!this.dummyMC.mcChar)
               {
                  this.dummyMC.mcChar = {"height":122};
               }
               _loc3_.tMC = this.dummyMC;
            }
            switch(param1.fx)
            {
               case "w":
                  _loc3_.x = _loc3_.tMC.x;
                  _loc3_.y = _loc3_.tMC.y + 3;
                  _loc3_.scaleX *= _loc3_.tMC.x < this.AvatarDisplay.x ? -1 : 1;
                  break;
               case "p":
                  _loc3_.x = this.AvatarDisplay.x;
                  _loc3_.y = this.AvatarDisplay.y - this.AvatarDisplay.mcChar.height * 0.5;
                  _loc3_.dir = _loc3_.tMC.x - this.AvatarDisplay.x >= 0 ? 1 : -1;
            }
         }
         else
         {
            trace("[Load] ERR cameraTool: could not load class " + param1.strl);
         }
      }
      
      public function showSpellFXHit(param1:*) : *
      {
         var _loc2_:* = {};
         switch(param1.strl)
         {
            case "sp_ice1":
               _loc2_.strl = "sp_ice2";
               break;
            case "sp_el3":
               _loc2_.strl = "sp_el2";
               break;
            case "sp_ed3":
               _loc2_.strl = "sp_ed1";
               break;
            case "sp_ef1":
            case "sp_ef6":
               _loc2_.strl = "sp_ef2";
         }
         _loc2_.fx = "w";
         _loc2_.avts = [param1.tMC];
         this.castSpellFX(_loc2_);
      }
      
      public function onBtnToggleDummy(param1:MouseEvent) : void
      {
         this.dummyMC.visible = !this.dummyMC.visible;
      }
      
      public function onDummyDown(param1:MouseEvent) : void
      {
         this.dummyMC.startDrag();
      }
      
      public function onDummyUp(param1:MouseEvent) : void
      {
         this.dummyMC.stopDrag();
      }
      
      public function get isCharHidden() : Boolean
      {
         return this.mcCharHidden;
      }
      
      public function onBtnVisibility(param1:MouseEvent) : void
      {
         switch(this.cameratoolUI.primary.cbVisibility.selectedItem.label)
         {
            case "Mainhand":
               this.AvatarDisplay.mcChar.weapon.visible = !this.AvatarDisplay.mcChar.weapon.visible;
               break;
            case "Offhand":
               this.AvatarDisplay.mcChar.weaponOff.visible = !this.AvatarDisplay.mcChar.weaponOff.visible;
               break;
            case "Cape":
               this.AvatarDisplay.mcChar.cape.visible = !this.AvatarDisplay.mcChar.cape.visible;
               break;
            case "Helmet":
               this.AvatarDisplay.mcChar.head.helm.visible = !this.AvatarDisplay.mcChar.head.helm.visible;
               this.AvatarDisplay.mcChar.head.hair.visible = !this.AvatarDisplay.mcChar.head.helm.visible;
               break;
            case "Player":
               this.mcCharHidden = !this.mcCharHidden;
               if(!this.mcCharHidden)
               {
                  this.AvatarDisplay.mcChar.head.visible = true;
                  this.AvatarDisplay.mcChar.chest.visible = true;
                  this.AvatarDisplay.mcChar.frontshoulder.visible = true;
                  this.AvatarDisplay.mcChar.backshoulder.visible = true;
                  this.AvatarDisplay.mcChar.fronthand.visible = true;
                  this.AvatarDisplay.mcChar.backhand.visible = true;
                  this.AvatarDisplay.mcChar.frontthigh.visible = true;
                  this.AvatarDisplay.mcChar.backthigh.visible = true;
                  this.AvatarDisplay.mcChar.frontshin.visible = true;
                  this.AvatarDisplay.mcChar.backshin.visible = true;
                  this.AvatarDisplay.mcChar.idlefoot.visible = true;
                  this.AvatarDisplay.mcChar.backfoot.visible = true;
                  this.AvatarDisplay.mcChar.hip.visible = true;
                  this.AvatarDisplay.mcChar.robe.visible = this.mcCharOptions["robe"];
                  this.AvatarDisplay.mcChar.backrobe.visible = this.mcCharOptions["backrobe"];
                  this.AvatarDisplay.mcChar.backhair.visible = this.mcCharOptions["backhair"];
               }
               else
               {
                  this.AvatarDisplay.mcChar.head.visible = false;
                  this.AvatarDisplay.mcChar.chest.visible = false;
                  this.AvatarDisplay.mcChar.frontshoulder.visible = false;
                  this.AvatarDisplay.mcChar.backshoulder.visible = false;
                  this.AvatarDisplay.mcChar.fronthand.visible = false;
                  this.AvatarDisplay.mcChar.backhand.visible = false;
                  this.AvatarDisplay.mcChar.frontthigh.visible = false;
                  this.AvatarDisplay.mcChar.backthigh.visible = false;
                  this.AvatarDisplay.mcChar.frontshin.visible = false;
                  this.AvatarDisplay.mcChar.backshin.visible = false;
                  this.AvatarDisplay.mcChar.idlefoot.visible = false;
                  this.AvatarDisplay.mcChar.backfoot.visible = false;
                  this.AvatarDisplay.mcChar.hip.visible = false;
                  if(this.AvatarDisplay.mcChar.robe.visible)
                  {
                     this.AvatarDisplay.mcChar.robe.visible = false;
                     this.mcCharOptions["robe"] = true;
                  }
                  if(this.AvatarDisplay.mcChar.backrobe.visible)
                  {
                     this.AvatarDisplay.mcChar.backrobe.visible = false;
                     this.mcCharOptions["backrobe"] = true;
                  }
                  if(this.AvatarDisplay.mcChar.backhair.visible)
                  {
                     this.AvatarDisplay.mcChar.backhair.visible = false;
                     this.mcCharOptions["backhair"] = true;
                  }
               }
               break;
            case "Shadow":
               this.AvatarDisplay.shadow.visible = !this.AvatarDisplay.shadow.visible;
               break;
            case "Head":
               this.AvatarDisplay.mcChar.head.visible = !this.AvatarDisplay.mcChar.head.visible;
               break;
            case "Robe":
               this.AvatarDisplay.mcChar.robe.visible = !this.AvatarDisplay.mcChar.robe.visible;
               break;
            case "Back Robe":
               this.AvatarDisplay.mcChar.backrobe.visible = !this.AvatarDisplay.mcChar.backrobe.visible;
               break;
            case "Misc":
               this.AvatarDisplay.cShadow.visible = !this.AvatarDisplay.cShadow.visible;
               break;
            case "Backhair":
               this.AvatarDisplay.mcChar.backhair.visible = !this.AvatarDisplay.mcChar.backhair.visible;
         }
      }
      
      public function onNumScaling(param1:Event) : void
      {
         this.scaleAvt = this.cameratoolUI.primary.numScaling.textField.text;
         this.AvatarDisplay.scale(this.scaleAvt);
      }
      
      public function onBtnDeattach(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(this.weaponDeattached)
         {
            this.weaponDeattached = false;
            this.isMirrored = false;
            this.isMirroredOff = false;
            this.cameratoolUI.primary.txtDeattached.text = "Weapon Deattachment: OFF";
            this.deattachedMain.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponDownDrag);
            this.deattachedMain.removeEventListener(MouseEvent.MOUSE_UP,this.onWeaponUpDrag);
            this.AvatarDisplay.mcChar.weapon.visible = true;
            _loc2_ = this.AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
            if(_loc2_ != null && _loc2_.sType != null)
            {
               if(_loc2_.sType == "Dagger")
               {
                  this.AvatarDisplay.mcChar.weaponOff.visible = true;
                  this.deattachedOff.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponOffDownDrag);
                  this.deattachedOff.removeEventListener(MouseEvent.MOUSE_UP,this.onWeaponOffUpDrag);
               }
            }
            this.AvatarDisplay.mcChar.removeChild(this.deattachedMain);
            this.AvatarDisplay.mcChar.removeChild(this.deattachedOff);
            this.deattachedMain = null;
            this.deattachedOff = null;
         }
         else
         {
            this.weaponDeattached = true;
            this.cameratoolUI.primary.txtDeattached.text = "Weapon Deattachment: ON";
            this.rootClass.world.queueLoad({
               "strFile":this.rootClass.world.rootClass.getFilePath() + this.AvatarDisplay.pAV.objData.eqp.Weapon.sFile,
               "callBackA":this.onLoadWeaponClones,
               "avt":this.AvatarDisplay.pAV,
               "sES":"weapon"
            });
            this.AvatarDisplay.mcChar.weapon.visible = false;
            this.AvatarDisplay.mcChar.weaponOff.visible = false;
         }
      }
      
      public function onLoadWeaponClones(param1:*) : void
      {
         var wItem:Object;
         var e:* = param1;
         var AssetClass:Class = null;
         try
         {
            AssetClass = this.rootClass.world.getClass(this.AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class;
            this.deattachedMain = new AssetClass();
         }
         catch(err:Error)
         {
            deattachedMain = MovieClip(e.target.content);
         }
         this.AvatarDisplay.mcChar.addChild(this.deattachedMain);
         this.deattachedMain.addEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponDownDrag,false,0,true);
         this.deattachedMain.addEventListener(MouseEvent.MOUSE_UP,this.onWeaponUpDrag,false,0,true);
         this.deattachedMain.scaleX = this.deattachedMain.scaleY = 0.222;
         wItem = this.AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
         if(wItem != null && wItem.sType != null)
         {
            if(wItem.sType == "Dagger")
            {
               this.rootClass.world.queueLoad({
                  "strFile":this.rootClass.world.rootClass.getFilePath() + this.AvatarDisplay.pAV.objData.eqp.Weapon.sFile,
                  "callBackA":this.onLoadWeaponOffClones,
                  "avt":this.AvatarDisplay.pAV,
                  "sES":"weapon"
               });
            }
         }
      }
      
      public function onLoadWeaponOffClones(param1:*) : void
      {
         var e:* = param1;
         var AssetClass:Class = null;
         try
         {
            AssetClass = this.rootClass.world.getClass(this.AvatarDisplay.pAV.objData.eqp.Weapon.sLink) as Class;
            this.deattachedOff = new AssetClass();
         }
         catch(err:Error)
         {
            deattachedOff = MovieClip(e.target.content);
         }
         this.AvatarDisplay.mcChar.addChild(this.deattachedOff);
         this.deattachedOff.scaleX = this.deattachedOff.scaleY = 0.222;
         this.deattachedOff.addEventListener(MouseEvent.MOUSE_UP,this.onWeaponOffUpDrag,false,0,true);
         this.deattachedOff.addEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponOffDownDrag,false,0,true);
      }
      
      public function onWeaponUpDrag(param1:MouseEvent) : void
      {
         this.deattachedMain.stopDrag();
      }
      
      public function onWeaponDownDrag(param1:MouseEvent) : void
      {
         this.deattachedMain.startDrag();
      }
      
      public function onWeaponOffUpDrag(param1:MouseEvent) : void
      {
         this.deattachedOff.stopDrag();
      }
      
      public function onWeaponOffDownDrag(param1:MouseEvent) : void
      {
         this.deattachedOff.startDrag();
      }
      
      public function onBtnShowDeattach(param1:MouseEvent) : void
      {
         if(!this.weaponDeattached)
         {
            this.weaponUI.visible = false;
            return;
         }
         this.weaponUI.visible = !this.weaponUI.visible;
         if(this.weaponUI.visible)
         {
            this.setChildIndex(this.weaponUI,this.numChildren - 1);
         }
      }
      
      public function onBtnSetFocus(param1:MouseEvent) : void
      {
         if(!this.deattachedOff)
         {
            this.weaponFocus = 0;
            this.weaponUI.txtFocus.text = "Mainhand";
            return;
         }
         ++this.weaponFocus;
         if(this.weaponFocus >= 3)
         {
            this.weaponFocus = 0;
         }
         switch(this.weaponFocus)
         {
            case 0:
               this.weaponUI.txtFocus.text = "Mainhand";
               break;
            case 1:
               this.weaponUI.txtFocus.text = "Offhand";
               break;
            case 2:
               this.weaponUI.txtFocus.text = "Both";
         }
      }
      
      public function onSldrRotation(param1:Event) : void
      {
         switch(this.weaponFocus)
         {
            case 0:
               this.deattachedMain.rotation = this.weaponUI.sldrRotation.value;
               break;
            case 1:
               this.deattachedOff.rotation = this.weaponUI.sldrRotation.value;
               break;
            case 2:
               this.deattachedMain.rotation = this.weaponUI.sldrRotation.value;
               this.deattachedOff.rotation = this.weaponUI.sldrRotation.value;
         }
      }
      
      public function onBtnAddLayer(param1:MouseEvent) : void
      {
         switch(this.weaponFocus)
         {
            case 0:
               if(this.AvatarDisplay.mcChar.getChildIndex(this.deattachedMain) >= this.AvatarDisplay.mcChar.numChildren - 2)
               {
                  return;
               }
               this.AvatarDisplay.mcChar.setChildIndex(this.deattachedMain,this.AvatarDisplay.mcChar.getChildIndex(this.deattachedMain) + 1);
               break;
            case 1:
               if(this.AvatarDisplay.mcChar.getChildIndex(this.deattachedOff) >= this.AvatarDisplay.mcChar.numChildren - 2)
               {
                  return;
               }
               this.AvatarDisplay.mcChar.setChildIndex(this.deattachedOff,this.AvatarDisplay.mcChar.getChildIndex(this.deattachedOff) + 1);
               break;
            case 2:
               if(this.AvatarDisplay.mcChar.getChildIndex(this.deattachedMain) >= this.AvatarDisplay.mcChar.numChildren - 2 || this.AvatarDisplay.mcChar.getChildIndex(this.deattachedOff) == this.AvatarDisplay.mcChar.numChildren - 2)
               {
                  return;
               }
               this.AvatarDisplay.mcChar.setChildIndex(this.deattachedMain,this.AvatarDisplay.mcChar.getChildIndex(this.deattachedMain) + 1);
               this.AvatarDisplay.mcChar.setChildIndex(this.deattachedOff,this.AvatarDisplay.mcChar.getChildIndex(this.deattachedOff) + 1);
               break;
         }
      }
      
      public function onBtnDelLayer(param1:MouseEvent) : void
      {
         switch(this.weaponFocus)
         {
            case 0:
               if(this.AvatarDisplay.mcChar.getChildIndex(this.deattachedMain) <= 0)
               {
                  return;
               }
               this.AvatarDisplay.mcChar.setChildIndex(this.deattachedMain,this.AvatarDisplay.mcChar.getChildIndex(this.deattachedMain) - 1);
               break;
            case 1:
               if(this.AvatarDisplay.mcChar.getChildIndex(this.deattachedOff) <= 0)
               {
                  return;
               }
               this.AvatarDisplay.mcChar.setChildIndex(this.deattachedOff,this.AvatarDisplay.mcChar.getChildIndex(this.deattachedOff) - 1);
               break;
            case 2:
               if(this.AvatarDisplay.mcChar.getChildIndex(this.deattachedMain) <= 0 || this.AvatarDisplay.mcChar.getChildIndex(this.deattachedOff) <= 0)
               {
                  return;
               }
               this.AvatarDisplay.mcChar.setChildIndex(this.deattachedMain,this.AvatarDisplay.mcChar.getChildIndex(this.deattachedMain) - 1);
               this.AvatarDisplay.mcChar.setChildIndex(this.deattachedOff,this.AvatarDisplay.mcChar.getChildIndex(this.deattachedOff) - 1);
               break;
         }
      }
      
      public function onNumWepScale(param1:Event) : void
      {
         switch(this.weaponFocus)
         {
            case 0:
               this.deattachedMain.scaleX = this.deattachedMain.scaleY = this.weaponUI.numWepScale.textField.text * (this.isMirrored ? -1 : 1);
               break;
            case 1:
               this.deattachedOff.scaleX = this.deattachedOff.scaleY = this.weaponUI.numWepScale.textField.text * (this.isMirroredOff ? -1 : 1);
               break;
            case 2:
               this.deattachedMain.scaleX = this.deattachedMain.scaleY = this.weaponUI.numWepScale.textField.text * (this.isMirrored ? -1 : 1);
               this.deattachedOff.scaleX = this.deattachedOff.scaleY = this.weaponUI.numWepScale.textField.text * (this.isMirroredOff ? -1 : 1);
         }
      }
      
      public function onBtnMirror(param1:MouseEvent) : void
      {
         switch(this.weaponFocus)
         {
            case 0:
               this.isMirrored = !this.isMirrored;
               this.deattachedMain.scaleX *= -1;
               break;
            case 1:
               this.isMirroredOff = !this.isMirroredOff;
               this.deattachedOff.scaleX *= -1;
               break;
            case 2:
               this.isMirrored = !this.isMirrored;
               this.isMirroredOff = !this.isMirroredOff;
               this.deattachedMain.scaleX *= -1;
               this.deattachedOff.scaleX *= -1;
         }
      }
      
      public function onBtnInCombat(param1:MouseEvent) : void
      {
         switch(this.weaponFocus)
         {
            case 0:
               if(this.deattachedMain.bAttack == true && this.deattachedMain.currentLabel != "Attack")
               {
                  this.deattachedMain.gotoAndPlay("Attack");
               }
               else
               {
                  this.deattachedMain.gotoAndPlay("Idle");
               }
               break;
            case 1:
               if(this.deattachedOff.bAttack == true && this.deattachedOff.currentLabel != "Attack")
               {
                  this.deattachedOff.gotoAndPlay("Attack");
               }
               else
               {
                  this.deattachedOff.gotoAndPlay("Idle");
               }
               break;
            case 2:
               if(this.deattachedMain.bAttack == true && this.deattachedMain.currentLabel != "Attack")
               {
                  this.deattachedMain.gotoAndPlay("Attack");
               }
               else
               {
                  this.deattachedMain.gotoAndPlay("Idle");
               }
               if(this.deattachedOff.bAttack == true && this.deattachedOff.currentLabel != "Attack")
               {
                  this.deattachedOff.gotoAndPlay("Attack");
               }
               else
               {
                  this.deattachedOff.gotoAndPlay("Idle");
               }
         }
      }
      
      public function onWeaponUIDown(param1:MouseEvent) : void
      {
         this.weaponUI.startDrag();
      }
      
      public function onWeaponUIUp(param1:MouseEvent) : void
      {
         this.weaponUI.stopDrag();
      }
      
      public function onAvatarDown(param1:MouseEvent) : void
      {
         this.AvatarDisplay.startDrag();
      }
      
      public function onAvatarUp(param1:MouseEvent) : void
      {
         this.AvatarDisplay.stopDrag();
      }
      
      public function onBtnFreezePlayer(param1:MouseEvent) : void
      {
         if(!this.isFrozen)
         {
            this.isFrozen = true;
            this.AvatarDisplay.mcChar.stop();
            this.AvatarDisplay.mcChar.addEventListener(MouseEvent.MOUSE_DOWN,this.onAvatarDown,false,0,true);
            this.AvatarDisplay.mcChar.addEventListener(MouseEvent.MOUSE_UP,this.onAvatarUp,false,0,true);
         }
         else
         {
            this.isFrozen = false;
            this.AvatarDisplay.mcChar.play();
            this.AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onAvatarDown);
            this.AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_UP,this.onAvatarUp);
         }
      }
      
      public function onBtnStonePlayer(param1:MouseEvent) : void
      {
         if(!this.isStoned)
         {
            this.isStoned = true;
            this.AvatarDisplay.modulateColor(new ColorTransform(-1.3,-1.3,-1.3,0,100,100,100,0),"+");
         }
         else
         {
            this.isStoned = false;
            this.AvatarDisplay.modulateColor(new ColorTransform(-1.3,-1.3,-1.3,0,100,100,100,0),"-");
         }
      }
      
      public function onBtnHitPlayer(param1:MouseEvent) : void
      {
         if(!this.isHit)
         {
            this.isHit = true;
            this.AvatarDisplay.modulateColor(new ColorTransform(0,0,0,0,255,255,255,0),"+");
         }
         else
         {
            this.isHit = false;
            this.AvatarDisplay.modulateColor(new ColorTransform(0,0,0,0,255,255,255,0),"-");
         }
      }
      
      public function onBtnResetPlayer(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         if(this.isFrozen)
         {
            this.isFrozen = false;
            this.AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onAvatarDown);
            this.AvatarDisplay.mcChar.removeEventListener(MouseEvent.MOUSE_UP,this.onAvatarUp);
         }
         this.isStoned = false;
         this.isHit = false;
         this.glowPlayer = false;
         this.glowMain = false;
         this.glowOff = false;
         this.isMirrored = false;
         this.isMirroredOff = false;
         this.mcCharHidden = false;
         this.mcCharOptions = {
            "backhair":false,
            "robe":false,
            "backrobe":false
         };
         if(this.weaponDeattached)
         {
            this.weaponDeattached = false;
            this.cameratoolUI.primary.txtDeattached.text = "Weapon Deattachment: OFF";
            this.deattachedMain.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponDownDrag);
            this.deattachedMain.removeEventListener(MouseEvent.MOUSE_UP,this.onWeaponUpDrag);
            this.AvatarDisplay.mcChar.weapon.visible = true;
            _loc2_ = this.AvatarDisplay.pAV.getItemByEquipSlot("Weapon");
            if(_loc2_ != null && _loc2_.sType != null)
            {
               if(_loc2_.sType == "Dagger")
               {
                  this.AvatarDisplay.mcChar.weaponOff.visible = true;
                  this.deattachedOff.removeEventListener(MouseEvent.MOUSE_DOWN,this.onWeaponOffDownDrag);
                  this.deattachedOff.removeEventListener(MouseEvent.MOUSE_UP,this.onWeaponOffUpDrag);
               }
            }
            this.AvatarDisplay.mcChar.removeChild(this.deattachedMain);
            this.AvatarDisplay.mcChar.removeChild(this.deattachedOff);
            this.deattachedMain = null;
            this.deattachedOff = null;
         }
         this.removeChild(this.AvatarDisplay);
         this.AvatarDisplay = new AvatarMC();
         this.AvatarDisplay.world = this.rootClass.world;
         this.copyTo(this.AvatarDisplay.mcChar);
         this.AvatarDisplay.x = 650;
         this.AvatarDisplay.y = 450;
         this.AvatarDisplay.hideHPBar();
         this.AvatarDisplay.gotoAndPlay("in2");
         this.AvatarDisplay.mcChar.gotoAndPlay("Idle");
         this.addChild(this.AvatarDisplay);
         this.AvatarDisplay.scale(this.scaleAvt);
      }
      
      public function onColGlow(param1:*) : void
      {
         if(!this.glowPlayer)
         {
            return;
         }
         this.playerGlowFilter.color = param1.currentTarget.selectedColor;
         this.AvatarDisplay.mcChar.filters = [this.playerGlowFilter];
      }
      
      public function onColGlowMain(param1:*) : void
      {
         if(!this.glowMain)
         {
            return;
         }
         this.mainGlowFilter.color = param1.currentTarget.selectedColor;
         if(this.weaponDeattached)
         {
            this.deattachedMain.filters = [this.mainGlowFilter];
         }
         else
         {
            this.AvatarDisplay.mcChar.weapon.filters = [this.mainGlowFilter];
         }
      }
      
      public function onColGlowOff(param1:*) : void
      {
         if(!this.glowOff)
         {
            return;
         }
         this.offGlowFilter.color = param1.currentTarget.selectedColor;
         if(this.weaponDeattached && Boolean(this.deattachedOff))
         {
            this.deattachedOff.filters = [this.offGlowFilter];
         }
         else
         {
            this.AvatarDisplay.mcChar.weaponOff.filters = [this.offGlowFilter];
         }
      }
      
      public function onBtnGlowMain(param1:MouseEvent) : void
      {
         this.mainGlowFilter.color = this.cameratoolUI.primary.colGlowMain.selectedColor;
         if(!this.glowMain)
         {
            this.glowMain = true;
            this.AvatarDisplay.mcChar.weapon.filters = [this.mainGlowFilter];
         }
         else
         {
            this.glowMain = false;
            this.AvatarDisplay.mcChar.weapon.filters = [];
         }
      }
      
      public function onBtnGlowOff(param1:MouseEvent) : void
      {
         this.offGlowFilter.color = this.cameratoolUI.primary.colGlowOff.selectedColor;
         if(!this.glowOff)
         {
            this.glowOff = true;
            this.AvatarDisplay.mcChar.weaponOff.filters = [this.offGlowFilter];
         }
         else
         {
            this.glowOff = false;
            this.AvatarDisplay.mcChar.weaponOff.filters = [];
         }
      }
      
      public function onBtnGlowPlayer(param1:MouseEvent) : void
      {
         this.playerGlowFilter.color = this.cameratoolUI.primary.colGlow.selectedColor;
         if(!this.glowPlayer)
         {
            this.glowPlayer = true;
            this.AvatarDisplay.mcChar.filters = [this.playerGlowFilter];
         }
         else
         {
            this.glowPlayer = false;
            this.AvatarDisplay.mcChar.filters = [];
         }
      }
      
      public function onBtnGender(param1:MouseEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = undefined;
         this.AvatarDisplay.pAV = this.rootClass.world.myAvatar;
         this.AvatarDisplay.strGender = this.AvatarDisplay.strGender == "M" ? "F" : "M";
         var _loc3_:* = ["cape","backhair","robe","backrobe"];
         for(_loc2_ in _loc3_)
         {
            if(typeof this.AvatarDisplay.mcChar[_loc3_[_loc2_]] != undefined)
            {
               this.AvatarDisplay.mcChar[_loc3_[_loc2_]].visible = false;
            }
         }
         if(!this.AvatarDisplay.pAV.dataLeaf.showHelm || !("he" in this.AvatarDisplay.pAV.objData.eqp) && this.AvatarDisplay.pAV.objData.eqp.he == null)
         {
            this.AvatarDisplay.loadHair();
         }
         for(_loc4_ in this.rootClass.world.myAvatar.objData.eqp)
         {
            switch(_loc4_)
            {
               case "Weapon":
                  this.AvatarDisplay.loadWeapon(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,null);
                  break;
               case "he":
                  if(this.AvatarDisplay.pAV.dataLeaf.showHelm)
                  {
                     this.AvatarDisplay.loadHelm(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,null);
                  }
                  break;
               case "ba":
                  if(this.AvatarDisplay.pAV.dataLeaf.showCloak)
                  {
                     this.AvatarDisplay.loadCape(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,null);
                  }
                  break;
               case "ar":
                  if(this.rootClass.world.myAvatar.objData.eqp.co == null)
                  {
                     this.AvatarDisplay.loadClass(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,null);
                  }
                  break;
               case "co":
                  this.AvatarDisplay.loadArmor(this.AvatarDisplay.pAV.objData.eqp[_loc4_].sFile,this.AvatarDisplay.pAV.objData.eqp[_loc4_].sLink);
                  break;
            }
         }
      }
      
      public function onBtnTurnHead(param1:MouseEvent) : void
      {
         if(!this.oldX)
         {
            this.oldX = this.AvatarDisplay.mcChar.head.x;
            this.oldY = this.AvatarDisplay.mcChar.head.y;
         }
         this.AvatarDisplay.mcChar.head.scaleX *= -1;
         if(this.AvatarDisplay.mcChar.head.scaleX < 0)
         {
            this.AvatarDisplay.mcChar.head.x -= 7;
         }
         else
         {
            this.AvatarDisplay.mcChar.head.x = this.oldX;
            this.AvatarDisplay.mcChar.head.y = this.oldY;
         }
      }
   }
}

