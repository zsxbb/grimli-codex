package
{
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import it.gotoandplay.smartfoxserver.*;
   import liteAssets.draw.*;
   import liteAssets.handlers.*;
   
   public class Game extends MovieClip
   {
      public static var root:DisplayObject;
      
      public static var serverName:String;
      
      public static var objLogin:Object;
      
      public static var mcUpgradeWindow:MovieClip;
      
      public static var mcACWindow:MovieClip;
      
      public static var strToken:String;
      
      public static var vParam:String = "4.361";
      
      public static var ISWEB:Boolean = true;
      
      public static var serverPort:int = 5588;
      
      public static var serverIP:String = "";
      
      public static var serverGamePath:String = "";
      
      public static var serverFilePath:String = "";
      
      public static var serverURL:String = "";
      
      public static var cLoginZone:String = "zone_master";
      
      public static var clientToken:String = "SPIDER#0001";
      
      public static var bPTR:Boolean = false;
      
      public static var loginInfo:Object = new Object();
      
      public static const ASSETS_LOADED:String = "main_assets_loaded";
      
      public static var ASSETS_READY:String = "";
      
      public static const FB_APP_NAME:String = "AQW";
      
      public static const FB_APP_URL:String = "www.aq.com";
      
      public static const FB_APP_ID:String = "51356733862";
      
      public static const FB_APP_SEC:String = "This should never be stored in the client";
      
      MovieClip.prototype.removeAllChildren = function():void
      {
         var _loc1_:* = this.numChildren - 1;
         while(_loc1_ >= 0)
         {
            this.removeChildAt(_loc1_);
            _loc1_--;
         }
      };
      
      public var MsgBox:MovieClip;
      
      public var ctr_watermark:MovieClip;
      
      public var mcAccount:MovieClip;
      
      public var mcExtSWF:MovieClip;
      
      public var mcLogin:MovieClip;
      
      public var ui:MovieClip;
      
      public var loader:mcLoader;
      
      public var csLoader:Loader;
      
      public var fileUrl:String;
      
      public var csbLoaded:Number;
      
      public var csbTotal:Number;
      
      public var clientVersion:Number;
      
      public var cVersion:String;
      
      public var sToken:String;
      
      public var failedServers:*;
      
      public var world:World;
      
      public var bagSpace:String = "interface/bagspace_2025.swf";
      
      public var iMaxBagSlots:* = 400;
      
      public var iMaxBankSlots:* = 450;
      
      public var iMaxHouseSlots:* = 250;
      
      public var iMaxFriends:* = 225;
      
      public var iMaxLoadoutSlots:* = 20;
      
      private var swfObj:String = "AQWGame";
      
      private var _colorCache:Dictionary;
      
      public var showFB:Boolean = false;
      
      public var fbL:fbLinkWindow;
      
      public var titleDomain:ApplicationDomain;
      
      public var mcO:MovieClip;
      
      private var rn:RandomNumber;
      
      public var elmType:String;
      
      public var assetsDomain:ApplicationDomain;
      
      public var assetsContext:LoaderContext;
      
      public var handleSessionEvent:Function;
      
      public var mixer:SoundFX;
      
      public var sfc:SmartFoxClient;
      
      public var chatF:*;
      
      public var sFilePath:String = "";
      
      public var params:Object;
      
      public var userPreference:SharedObject;
      
      public var litePreference:SharedObject;
      
      public var uoPref:Object;
      
      public var litePref:Array;
      
      public var loginLoader:URLLoader;
      
      public var objServerInfo:Object;
      
      public var sfcSocial:Boolean = false;
      
      public var ldrMC:LoaderMC;
      
      public var mcConnDetail:ConnDetailMC;
      
      public var querystring:Object;
      
      public var ts_login_server:Number;
      
      public var ts_login_client:Number;
      
      public var aaaloop:int = 0;
      
      public var totalPingTime:Number = 0;
      
      public var pingCount:int = 0;
      
      public var arrRanks:Vector.<int>;
      
      public var iRankMax:int = 10;
      
      public var arrHP:Vector.<int>;
      
      private var aswc:Apop;
      
      public var hasPreviewed:Boolean;
      
      public var intLevelCap:int;
      
      public var PCstBase:int;
      
      public var PCstRatio:Number;
      
      public var PCstGoal:int;
      
      public var GstBase:int;
      
      public var GstRatio:Number;
      
      public var GstGoal:int;
      
      public var PChpBase1:int;
      
      public var PChpBase100:int;
      
      public var PChpGoal1:int;
      
      public var PChpGoal100:int;
      
      public var PChpDelta:int;
      
      public var intHPperEND:int;
      
      public var intAPtoDPS:int;
      
      public var intSPtoDPS:int;
      
      public var bigNumberBase:int;
      
      public var resistRating:Number;
      
      public var modRating:Number;
      
      public var baseDodge:Number;
      
      public var baseBlock:Number;
      
      public var baseParry:Number;
      
      public var baseCrit:Number;
      
      public var baseHit:Number;
      
      public var baseHaste:Number;
      
      public var baseMiss:Number;
      
      public var baseResist:Number;
      
      public var baseCritValue:Number;
      
      public var baseBlockValue:Number;
      
      public var baseResistValue:Number;
      
      public var baseEventValue:Number;
      
      public var PCDPSMod:Number = 0.85;
      
      public var curveExponent:Number = 0.66;
      
      public var statsExponent:Number = 1.33;
      
      public var stats:Vector.<String>;
      
      public var orderedStats:Vector.<String>;
      
      public var ratiosBySlot:Object;
      
      public var I0pct:Number = 0.8;
      
      public var I2pct:Number = 1.25;
      
      public var classCatMap:Object;
      
      private var coreValues:Object;
      
      private var travelMapData:Object;
      
      private var WorldMapData:worldMap;
      
      private var skipR2:Boolean = false;
      
      private var apop_:apopCore;
      
      public var apopTree:Object;
      
      public var curID:String;
      
      public var serialCmdMode:Boolean = false;
      
      public var serialCmd:Object;
      
      private var conn:*;
      
      public var confirmTime:int = 0;
      
      public var quests:Boolean = false;
      
      public var bits:Vector.<uint>;
      
      private var fbc:MovieClip;
      
      public var mcGameMenu:MovieClip;
      
      public var firstMenu:Boolean = true;
      
      public var bPassword:Boolean = true;
      
      public var flushPendingSelfInitData:Function;
      
      public var pDash:Boolean;
      
      internal var cancelTargetTimer:Timer;
      
      public var keyDict:Dictionary;
      
      private var travelLoaderMC:*;
      
      public var TRAVEL_DATA_READY:Boolean = false;
      
      private var bLoaded:Number = 0;
      
      private var bTotal:Number = 0;
      
      private var weakPass:Array;
      
      private var gameMenuLoader:Loader;
      
      private var gameMenuURL:String;
      
      private var gameMenuRetried:Boolean = false;
      
      public var extCall:ExternalCalls;
      
      public var FBConnectCallback:Function;
      
      public var sBG:String = "generic2.swf";
      
      public var IsEU:Boolean = false;
      
      public var TempLoginName:* = "";
      
      public var TempLoginPass:* = "";
      
      public var mtcidNow:Number;
      
      public var intChatMode:int;
      
      public var serverPath:String;
      
      public var playerPollData:Object;
      
      private var characters:SharedObject;
      
      public var csShowServers:Boolean = false;
      
      public var mcCharSelect:*;
      
      private var pendingAssetsFile:String = "";
      
      private var assetsLoader:Loader;
      
      internal var interfaceQueue:Array;
      
      internal var visualLoader:*;
      
      public var interfaceRef:Object;
      
      internal var interfaceLoaded:Number = 0;
      
      internal var interfaceTotal:Number = 0;
      
      public var newInstance:Boolean = false;
      
      public var BOOK_DATA_READY:* = null;
      
      public var bolLoader:Loader;
      
      public var bolContent:MovieClip;
      
      public var equipPotionOnSeia:Boolean;
      
      public var lastPing:Number = 0;
      
      public var lastPingTime:uint = 0;
      
      public var lastPingValues:Array;
      
      public var bankFiltersMC:bankFilters;
      
      public var pLoggerUI:packetlogger;
      
      public var cMenuUI:cellMenu;
      
      public var cDropsUI:customDrops;
      
      public var pAurasUI:playerAuras;
      
      public var tAurasUI:targetAuras;
      
      public var bAnalyzer:battleAnalyzer;
      
      public var cameraToolMC:cameraTool;
      
      private var csFontName:String = null;
      
      private var csFontChecked:Boolean = false;
      
      internal var petDisable:Timer;
      
      public var portraitsCnt:Array;
      
      public var pinnedQuests:String;
      
      internal var disableTimer:Timer;
      
      public var regExLineSpace:RegExp;
      
      public var showServers:Boolean = false;
      
      public var baseClassStats:Object;
      
      private var statsNewClass:Boolean = false;
      
      private var mcStatsPanel:MovieClip;
      
      public function Game()
      {
         /*
          * Decompilation error
          * Timeout (1 minute) was reached
          * Instruction count: 1357
          */
         throw new flash.errors.IllegalOperationError("Not decompiled due to timeout");
      }
      
      public static function vurl(param1:String) : String
      {
         if(param1 == null || param1.length == 0 || param1.indexOf("file://") == 0 || param1.indexOf("?v=") >= 0 || param1.indexOf("&v=") >= 0)
         {
            return param1;
         }
         return param1 + (param1.indexOf("?") < 0 ? "?v=" : "&v=") + vParam;
      }
      
      public static function gTrace(param1:*) : *
      {
         if(Game.ISWEB)
         {
            if(!ExternalInterface.available)
            {
               return;
            }
            ExternalInterface.call("console.log",param1);
         }
         else
         {
            trace(param1);
         }
      }
      
      public static function trim(param1:String) : String
      {
         if(param1 == null)
         {
            return "";
         }
         return param1.replace(/^\s+|\s+$/g,"");
      }
      
      public static function XMLtoObject(param1:XML) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = {};
         for(_loc3_ in param1.attributes())
         {
            _loc2_[String(param1.attributes()[_loc3_].name())] = String(param1.attributes()[_loc3_]);
         }
         for(_loc4_ in param1.children())
         {
            _loc5_ = param1.children()[_loc4_].name();
            if(_loc2_[_loc5_] == undefined)
            {
               _loc2_[_loc5_] = [];
            }
            _loc2_[_loc5_].push(XMLtoObject(param1.children()[_loc4_]));
         }
         return _loc2_;
      }
      
      public static function convertXMLtoObject(param1:XML) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:XML = null;
         var _loc6_:* = undefined;
         var _loc2_:* = {};
         for(_loc3_ in param1.attributes())
         {
            _loc2_[String(param1.attributes()[_loc3_].name())] = String(param1.attributes()[_loc3_]);
         }
         for(_loc4_ in param1.children())
         {
            _loc5_ = param1.children()[_loc4_];
            if(_loc5_.nodeKind() == "text")
            {
               if(_loc5_ == parseFloat(_loc5_).toString())
               {
                  return parseFloat(_loc5_);
               }
               return _loc5_;
            }
            if(_loc5_.nodeKind() == "element")
            {
               _loc6_ = param1.children()[_loc4_].name();
               if(_loc2_[_loc6_] == null)
               {
                  _loc2_[_loc6_] = convertXMLtoObject(param1.children()[_loc4_]);
               }
               else
               {
                  if(!(_loc2_[_loc6_] is Array))
                  {
                     _loc2_[_loc6_] = [_loc2_[_loc6_]];
                  }
                  _loc2_[_loc6_].push(convertXMLtoObject(param1.children()[_loc4_]));
               }
            }
         }
         return _loc2_;
      }
      
      private static function makeGrayscale(param1:DisplayObject, param2:int = 0, param3:Number = 0.33) : void
      {
         var _loc6_:Color = null;
         if(param1 == null)
         {
            return;
         }
         var _loc4_:Array = [param3,param3,param3,0,0,param3,param3,param3,0,0,param3,param3,param3,0,0,param3,param3,param3,1,0];
         var _loc5_:ColorMatrixFilter = new ColorMatrixFilter(_loc4_);
         param1.filters = [_loc5_];
         if(param2 != 0)
         {
            _loc6_ = new Color();
            _loc6_.brightness = -(param2 / 100);
            param1.transform.colorTransform = _loc6_;
         }
      }
      
      private static function getCharStore() : SharedObject
      {
         try
         {
            return SharedObject.getLocal("AQWChars","/",true);
         }
         catch(e:Error)
         {
         }
         try
         {
            return SharedObject.getLocal("AQWChars","/");
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function loadAccountCreation(param1:String) : *
      {
         this.mcAccount.removeChildAt(0);
         var _loc2_:Loader = new Loader();
         trace("newchar " + Game.serverFilePath + param1);
         _loc2_.load(new URLRequest(Game.serverFilePath + param1),new LoaderContext(false,new ApplicationDomain(null)));
         this.mcAccount.addChild(_loc2_);
      }
      
      public function onCSComplete(param1:Event) : void
      {
         trace("Character select loaded");
         if(param1 == null || param1.currentTarget == null)
         {
            return;
         }
         this.mcCharSelect = param1.currentTarget.content as MovieClip;
         if(this.mcCharSelect != null)
         {
            this.addChildAt(this.mcCharSelect,1);
         }
         if(this.csLoader != null && this.csLoader.contentLoaderInfo != null)
         {
            this.csLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCSComplete);
            this.csLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onCSProgress);
            this.csLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onCSError);
         }
         if(this.loader != null && this.loader.parent != null)
         {
            this.loader.parent.removeChild(this.loader);
            this.loader = null;
         }
      }
      
      public function onCSProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         this.csbLoaded = param1.bytesLoaded;
         this.csbTotal = param1.bytesTotal;
         if(this.csbTotal > 0 && this.loader != null)
         {
            _loc2_ = int(this.csbLoaded / this.csbTotal * 100);
            if(this.loader.mcPct != null && Boolean(this.loader.mcPct.hasOwnProperty("text")))
            {
               this.loader.mcPct.text = _loc2_ + "%";
            }
         }
      }
      
      public function onCSError(param1:IOErrorEvent) : void
      {
         trace("Charselect load failed: " + (param1 != null ? String(param1) : "unknown error"));
         if(this.csLoader != null && this.csLoader.contentLoaderInfo != null)
         {
            this.csLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onCSComplete);
            this.csLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onCSProgress);
            this.csLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onCSError);
         }
         if(this.loader != null && this.loader.parent != null)
         {
            this.loader.parent.removeChild(this.loader);
            this.loader = null;
         }
         gotoAndPlay("Login");
      }
      
      public function vswf(param1:String) : String
      {
         return vurl(param1);
      }
      
      public function monsterTreeWrite(param1:int, param2:Object, param3:* = null) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         var _loc8_:Avatar = null;
         var _loc9_:Avatar = null;
         var _loc10_:Avatar = null;
         var _loc11_:Avatar = null;
         var _loc12_:MovieClip = null;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         var _loc18_:int = 0;
         var _loc19_:Object = null;
         var _loc20_:String = null;
         var _loc21_:Object = null;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
         var _loc4_:int = 0;
         var _loc13_:String = "";
         var _loc14_:Object = {};
         var _loc15_:Object = this.world.monTree[param1];
         if(_loc15_ != null)
         {
            _loc16_ = -1;
            if(_loc15_ != null && _loc15_.intState != null)
            {
               _loc16_ = int(_loc15_.intState);
            }
            for(_loc17_ in param2)
            {
               _loc6_ = _loc17_;
               _loc7_ = param2[_loc17_];
               _loc14_[_loc6_] = _loc7_;
               if(_loc6_.toLowerCase().indexOf("int") > -1)
               {
                  _loc7_ = Number(_loc7_);
               }
               if(_loc6_ == "react")
               {
                  _loc7_ = _loc7_.split(",");
                  _loc18_ = 0;
                  while(_loc18_ < _loc7_.length)
                  {
                     _loc7_[_loc18_] = Number(_loc7_[_loc18_]);
                     _loc18_++;
                  }
               }
               _loc15_[_loc6_] = _loc7_;
            }
            _loc13_ = "";
            for(_loc13_ in _loc14_)
            {
               _loc6_ = _loc13_;
               _loc7_ = _loc14_[_loc13_];
               if(_loc6_.toLowerCase().indexOf("evt:") < 0)
               {
                  _loc10_ = this.world.getMonster(param1);
                  if(_loc10_ != null)
                  {
                     if(_loc6_.toLowerCase().indexOf("hp") > -1)
                     {
                        if(_loc10_ != null && _loc10_.objData != null)
                        {
                           _loc7_ = Number(_loc7_);
                           _loc10_.objData[_loc13_] = _loc7_;
                           if(this.world.myAvatar.target == _loc10_)
                           {
                              this.world.updatePortrait(_loc10_);
                           }
                           if(this.world.objLock != null && (_loc6_ == "intHP" && _loc7_ <= 0))
                           {
                              ++this.world.intKillCount;
                              this.world.updatePadNames();
                           }
                           if(_loc10_.objData != null && _loc10_.objData.strFrame != undefined)
                           {
                              if(_loc10_.objData.strFrame == this.world.strFrame)
                              {
                                 if(_loc7_ <= 0)
                                 {
                                    if(Boolean(this.bAnalyzer) && (param3 || _loc14_["targets"] != null && _loc14_["targets"].length > 0))
                                    {
                                       if(this.bAnalyzer.isRunning())
                                       {
                                          for each(_loc20_ in !!param3 ? param3 : _loc14_["targets"])
                                          {
                                             if(this.world.myAvatar.objData.strUsername.toLowerCase() == _loc20_.toLowerCase())
                                             {
                                                this.bAnalyzer.addKill();
                                             }
                                          }
                                       }
                                    }
                                    if(this.litePreference.data.bDisSelfMAnim && this.world.myAvatar.target != null && this.world.myAvatar.target.dataLeaf.intState == 0)
                                    {
                                       this.world.cancelTarget();
                                    }
                                    _loc10_.pMC.stopWalking();
                                    this.world.removeAuraFX(_loc10_.pMC,"all");
                                    _loc10_.pMC.die();
                                    for each(_loc19_ in _loc15_.auras)
                                    {
                                       _loc19_.casterType = null;
                                       _loc19_.casterId = null;
                                    }
                                    _loc15_.auras = [];
                                    _loc15_.targets = {};
                                    _loc10_.target = null;
                                    if("eventTrigger" in MovieClip(this.world.map))
                                    {
                                       this.world.map.eventTrigger({
                                          "cmd":"monDeath",
                                          "args":param1,
                                          "targets":param2.targets
                                       });
                                    }
                                    if(this.world.myAvatar.dataLeaf.targets[_loc10_.objData.MonMapID] != null)
                                    {
                                       delete this.world.myAvatar.dataLeaf.targets[_loc10_.objData.MonMapID];
                                    }
                                    if(this.world.strMapName == "trickortreat" && this.world.strFrame == "Enter")
                                    {
                                       this.world.TrickOrTreatMonsterDead = true;
                                       this.world.loadPlayerNPC();
                                    }
                                    if(this.world.strMapName == "caroling" && this.world.strFrame == "Enter")
                                    {
                                       this.world.CarolingMonsterKillCount += 1;
                                       if(this.world.CarolingMonsterKillCount >= 5)
                                       {
                                          this.world.setTarget(null);
                                          this.world.loadPlayerNPC();
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                     if(_loc6_.toLowerCase().indexOf("state") > -1)
                     {
                        if(_loc10_ != null && _loc10_.objData != null)
                        {
                           _loc7_ = Number(_loc7_);
                           _loc10_.objData[_loc13_] = _loc7_;
                           if(_loc7_ != 2)
                           {
                              for each(_loc21_ in _loc10_.dataLeaf.auras)
                              {
                                 _loc21_.casterType = null;
                                 _loc21_.casterId = null;
                              }
                              _loc10_.dataLeaf.auras = [];
                           }
                           if(_loc10_.objData.strFrame != null && _loc10_.objData.strFrame == this.world.strFrame)
                           {
                              if(_loc7_ == 1 && _loc10_.pMC != null && (_loc10_.pMC.x != _loc10_.pMC.ox || _loc10_.pMC.y != _loc10_.pMC.oy))
                              {
                                 _loc10_.pMC.walkTo(_loc10_.pMC.ox,_loc10_.pMC.oy,this.world.WALKSPEED);
                              }
                           }
                           if(_loc7_ != 2)
                           {
                              _loc15_.targets = {};
                           }
                        }
                     }
                     if(_loc6_.toLowerCase().indexOf("dx") > -1)
                     {
                        _loc7_ = Number(_loc7_);
                        if(_loc10_.objData != null && _loc10_.objData.strFrame != null && _loc10_.objData.strFrame == this.world.strFrame)
                        {
                           _loc22_ = int(this.world.monTree[param1].dx);
                           _loc23_ = int(this.world.monTree[param1].dy);
                           _loc10_.pMC.walkTo(_loc22_,_loc23_,this.world.WALKSPEED);
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function userTreeWrite(param1:String, param2:Object) : void
      {
         var typ:String = null;
         var nam:String = null;
         var val:* = undefined;
         var monAvt:Avatar = null;
         var avtAvt:Avatar = null;
         var Mon:Avatar = null;
         var avt:Avatar = null;
         var pMC:MovieClip = null;
         var s:String = null;
         var intStateO:int = 0;
         var healIcon:MovieClip = null;
         var healIcon2:MovieClip = null;
         var uoName:String = param1;
         var uoLeafO:Object = param2;
         var i:int = 0;
         var prop:String = "";
         var updated:Object = {};
         var uoLeafSet:Object = {};
         var uoLeaf:Object = this.world.uoTree[uoName.toLowerCase()];
         avt = this.world.getAvatarByUserName(uoName);
         for(s in uoLeafO)
         {
            nam = s;
            val = uoLeafO[s];
            if(nam.toLowerCase().indexOf("int") > -1 || nam.toLowerCase() == "tx" || nam.toLowerCase() == "ty" || nam.toLowerCase() == "sp" || nam.toLowerCase() == "pvpTeam")
            {
               val = int(val);
            }
            if(this.sfcSocial && uoLeaf != null && this.world.myAvatar.dataLeaf != null && nam.toLowerCase() == "inthp" && uoName.toLowerCase() != this.sfc.myUserName && uoLeaf.strFrame == this.world.myAvatar.dataLeaf.strFrame && (!this.world.bPvP || uoLeaf.pvpTeam == this.world.myAvatar.dataLeaf.pvpTeam) && val > 0 && this.world.getFirstHeal() != null)
            {
               if(val <= uoLeaf.intHP && (uoLeaf.intHP - val >= uoLeaf.intHPMax * 0.15 || val <= uoLeaf.intHPMax * 0.5))
               {
                  try
                  {
                     avt.pMC.showHealIcon();
                  }
                  catch(e:Error)
                  {
                     trace("[Combat] ERR showHealIcon: " + e.message);
                  }
               }
               if(val > Math.round(uoLeaf.intHPMax * 0.5))
               {
                  try
                  {
                     healIcon = avt.pMC.getChildByName("HealIconMC") as MovieClip;
                     if(healIcon != null)
                     {
                        healIcon.fClose();
                     }
                  }
                  catch(e:Error)
                  {
                     trace("[Combat] ERR hideHealIcon: " + e.message);
                  }
               }
            }
            if(nam.toLowerCase() == "afk")
            {
               val = val == "true";
            }
            updated[nam] = val;
            uoLeafSet[nam] = val;
         }
         intStateO = -1;
         if(this.world.uoTree[uoName.toLowerCase()] != null)
         {
            intStateO = int(this.world.uoTree[uoName.toLowerCase()].intState);
         }
         this.world.uoTreeLeafSet(uoName,uoLeafSet);
         uoLeaf = this.world.uoTree[uoName.toLowerCase()];
         if(this.world.isPartyMember(uoName))
         {
            this.world.updatePartyFrame({"unm":uoLeaf.strUsername});
         }
         prop = "";
         for(prop in updated)
         {
            val = updated[prop];
            if(prop.toLowerCase() == "strframe")
            {
               this.world.manageAreaUser(uoName,"+");
               if(updated[prop] != this.world.strFrame)
               {
                  pMC = this.world.getMCByUserID(this.world.getUserByName(uoName).getId());
                  if(pMC != null && pMC.stage != null)
                  {
                     if(this.world.bPvP)
                     {
                        pMC.px = updated.px;
                        pMC.py = updated.py;
                        pMC.mvtd = updated.mvtd;
                        pMC.mvts = updated.mvts;
                        pMC.sp = updated.sp;
                        pMC.walkTo(updated.tx,updated.ty,updated.sp);
                     }
                     pMC.pAV.hideMC();
                     if(pMC.pAV == this.world.myAvatar.target)
                     {
                        this.world.setTarget(null);
                     }
                  }
               }
               else if(updated.sp != null)
               {
                  pMC = this.world.getMCByUserID(this.world.getUserByName(uoName).getId());
                  if(pMC != null)
                  {
                     pMC.walkTo(updated.tx,updated.ty,updated.sp);
                  }
               }
               else
               {
                  this.world.objectByID(uoLeaf.entID);
               }
            }
            if(prop.toLowerCase() == "sp")
            {
               if(updated.strFrame == this.world.strFrame)
               {
               }
            }
            if(avt != null)
            {
               if(prop.toLowerCase().indexOf("inthp") > -1 || prop.toLowerCase().indexOf("intmp") > -1)
               {
                  val = Number(val);
                  if(avt.objData != null)
                  {
                     avt.objData[prop] = val;
                  }
                  if(avt.isMyAvatar || this.world.myAvatar.target == avt)
                  {
                     this.world.updatePortrait(avt);
                  }
                  if(avt.isMyAvatar)
                  {
                     this.world.updateActBar();
                  }
                  if(avt.pMC != null && this.world.showHPBar)
                  {
                     avt.pMC.updateHPBar();
                  }
               }
               if(avt.isMyAvatar)
               {
                  if(prop.toLowerCase().indexOf("intsp") > -1)
                  {
                     val = Number(val);
                     if(avt.objData != null)
                     {
                        avt.objData[prop] = val;
                     }
                     if(avt.isMyAvatar || this.world.myAvatar.target == avt)
                     {
                        this.world.updatePortrait(avt);
                     }
                     if(avt.isMyAvatar)
                     {
                        this.world.updateActBar();
                     }
                     if(avt.pMC != null && this.world.showHPBar)
                     {
                        avt.pMC.updateHPBar();
                     }
                  }
               }
               if(prop.toLowerCase().indexOf("intlevel") > -1)
               {
                  val = Number(val);
                  if(avt.objData != null)
                  {
                     avt.objData[prop] = val;
                     if(!avt.isMyAvatar && this.world.myAvatar.target == avt)
                     {
                        this.showPortraitBox(avt,this.ui.mcPortraitTarget);
                     }
                  }
               }
               if(prop.toLowerCase().indexOf("intstate") > -1)
               {
                  val = int(val);
                  if(avt.objData != null && this.world.uoTree[uoName.toLowerCase()].strFrame == this.world.strFrame)
                  {
                     if(val == 1 && intStateO == 0)
                     {
                        avt.pMC.gotoAndStop("Idle");
                        avt.pMC.scale(this.world.SCALE);
                     }
                     if(val == 1 && intStateO == 2)
                     {
                        if("eventTrigger" in MovieClip(this.world.map))
                        {
                        }
                     }
                  }
                  if(avt.objData != null)
                  {
                     avt.objData[prop] = val;
                  }
                  if(val == 0 && this.world.uoTree[uoName.toLowerCase()].strFrame == this.world.strFrame && avt.pMC != null)
                  {
                     avt.pMC.stopWalking();
                     avt.pMC.mcChar.gotoAndPlay("Feign");
                     this.world.removeAuraFX(avt.pMC,"all");
                     healIcon2 = avt.pMC.getChildByName("HealIconMC") as MovieClip;
                     if(healIcon2 != null)
                     {
                        healIcon2.fClose();
                     }
                     if(avt.isMyAvatar)
                     {
                        this.world.cancelAutoAttack();
                        this.world.actionReady = false;
                        this.world.bitWalk = false;
                        this.world.map.transform.colorTransform = this.world.deathCT;
                        this.world.CHARS.transform.colorTransform = this.world.deathCT;
                        avt.pMC.transform.colorTransform = this.world.defaultCT;
                        this.world.showResCounter();
                     }
                  }
                  if(val != 2)
                  {
                     uoLeaf.targets = {};
                  }
               }
               if(prop.toLowerCase().indexOf("afk") > -1)
               {
                  if(avt.pMC != null)
                  {
                     avt.pMC.updateName();
                  }
               }
               if(prop == "showCloak")
               {
                  if(avt.pMC != null)
                  {
                     avt.pMC.setCloakVisibility(val);
                  }
               }
               if(prop == "showHelm")
               {
                  if(avt.pMC != null)
                  {
                     avt.pMC.setHelmVisibility(val);
                  }
               }
               if(prop.toLowerCase().indexOf("cast") > -1)
               {
                  if(avt.pMC != null)
                  {
                     if(val.t > -1)
                     {
                        avt.pMC.stopWalking();
                        avt.pMC.queueAnim("Use");
                     }
                     else
                     {
                        avt.pMC.endAction();
                        if(avt == this.world.myAvatar)
                        {
                           this.ui.mcCastBar.fClose();
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function doAnim(param1:Object, param2:Boolean = false, param3:* = null) : void
      {
         var anims:Array = null;
         var animIndex:uint = 0;
         var animStr:String = null;
         var pMC:MovieClip = null;
         var cLeaf:Object = null;
         var tLeaf:Object = null;
         var tAvt:Avatar = null;
         var cAvt:Avatar = null;
         var aura:Object = null;
         var sCat:String = null;
         var buffer:* = undefined;
         var xBuffer:* = undefined;
         var yBuffer:* = undefined;
         var animString:String = null;
         var anim:Object = param1;
         var isProc:Boolean = param2;
         var dur:* = param3;
         var i:int = 0;
         var cTyp:String = "";
         var cID:int = -1;
         var tTyp:String = "";
         var tID:int = -1;
         var tAvts:Array = [];
         var tInfA:Array = [];
         var strF:String = "";
         cAvt = null;
         tAvt = null;
         var cReg:Point = new Point(0,0);
         var tReg:Point = new Point(0,0);
         if(anim.cInf != null && anim.tInf != null)
         {
            cTyp = String(anim.cInf.split(":")[0]);
            cID = int(anim.cInf.split(":")[1]);
            switch(cTyp)
            {
               case "p":
                  cAvt = this.world.getAvatarByUserID(cID);
                  cLeaf = this.world.getUoLeafById(cID);
                  break;
               case "m":
                  cAvt = this.world.getMonster(cID);
                  cLeaf = this.world.monTree[cID];
                  if(anim.msg != null)
                  {
                     if(anim.msg.indexOf("<mon>") > -1)
                     {
                        anim.msg = anim.msg.split("<mon>").join(cAvt.objData.strMonName);
                     }
                     this.addUpdate(anim.msg);
                  }
            }
            tInfA = anim.tInf.split(",");
            i = 0;
            while(i < tInfA.length)
            {
               tTyp = String(tInfA[i].split(":")[0]);
               tID = int(tInfA[i].split(":")[1]);
               switch(tTyp)
               {
                  case "p":
                     tAvt = this.world.getAvatarByUserID(tID);
                     tLeaf = this.world.getUoLeafById(tID);
                     break;
                  case "m":
                     tAvt = this.world.getMonster(tID);
                     tLeaf = this.world.monTree[tID];
                     break;
               }
               tAvts.push(tAvt);
               i++;
            }
            if(tAvts[0] != null)
            {
               tAvt = tAvts[0];
            }
            if(tAvt != null)
            {
               tLeaf = tAvt.dataLeaf;
            }
            if(cAvt != null && cAvt.pMC != null && tAvt != null && tAvt.pMC != null && cLeaf != null && tLeaf != null)
            {
               aura = {};
               for each(aura in cLeaf.auras)
               {
                  try
                  {
                     sCat = this.world.auraCatOf(aura);
                     if(sCat == "stun" || sCat == "stone" || sCat == "paralyze" || sCat == "disable" || sCat == "disabled")
                     {
                        return;
                     }
                  }
                  catch(e:Error)
                  {
                     trace("[Combat] ERR doAnim: " + e.message);
                  }
               }
               animStr = anim.animStr;
               switch(cTyp)
               {
                  case "p":
                     if(cAvt.objData != null)
                     {
                        if(cAvt != this.world.myAvatar)
                        {
                           cAvt.target = tAvt;
                        }
                        strF = String(cLeaf.strFrame);
                        if(strF != null && strF == this.world.strFrame && cLeaf.intState > 0)
                        {
                           if(cAvt != tAvt)
                           {
                              if(tAvt.pMC.x - cAvt.pMC.x >= 0)
                              {
                                 cAvt.pMC.turn("right");
                              }
                              else
                              {
                                 cAvt.pMC.turn("left");
                              }
                           }
                           cAvt.pMC.queueSpFX({
                              "strl":anim.strl,
                              "fx":anim.fx,
                              "avts":tAvts
                           });
                           if(!isNaN(dur))
                           {
                              cAvt.pMC.spellDur = dur;
                           }
                           if(animStr != null)
                           {
                              if(animStr.indexOf(",") > -1)
                              {
                                 animStr = animStr.split(",")[Math.round(Math.random() * (animStr.split(",").length - 1))];
                              }
                              if(animStr != "Thrash" || cAvt.pMC.mcChar.currentLabel != "Thrash")
                              {
                                 cAvt.pMC.queueAnim(animStr);
                              }
                              if(isProc && Boolean(cAvt.pMC.mcChar.weapon.mcWeapon.isProc))
                              {
                                 cAvt.pMC.mcChar.weapon.mcWeapon.gotoAndPlay("Proc");
                              }
                           }
                        }
                     }
                     break;
                  case "m":
                     if(cAvt.objData != null)
                     {
                        if(cAvt != this.world.myAvatar)
                        {
                           cAvt.target = tAvt;
                        }
                        strF = String(cLeaf.strFrame);
                        cReg = cAvt.pMC.mcChar.localToGlobal(new Point(0,0));
                        tReg = tAvt.pMC.mcChar.localToGlobal(new Point(0,0));
                        cReg = this.world.CHARS.globalToLocal(cReg);
                        tReg = this.world.CHARS.globalToLocal(tReg);
                        if(strF != null && strF == this.world.strFrame && cLeaf.intState > 0)
                        {
                           if(cAvt != tAvt)
                           {
                              if(tReg.x - cReg.x >= 0)
                              {
                                 cAvt.pMC.turn("right");
                              }
                              else
                              {
                                 cAvt.pMC.turn("left");
                              }
                           }
                           if(anim.fx != "p" && anim.fx != "w" && anim.fx != "" && (Math.abs(cReg.x - tReg.x) * this.world.SCALE > 160 || Math.abs(cReg.y - tReg.y) * this.world.SCALE > 15))
                           {
                              buffer = int(110 + Math.random() * 50);
                              xBuffer = tReg.x - cReg.x >= 0 ? -buffer : buffer;
                              xBuffer = int(xBuffer * this.world.SCALE);
                              if(tReg.x + xBuffer < 0 || tReg.x + xBuffer > 960)
                              {
                                 xBuffer *= -1;
                              }
                              buffer = int(Math.random() * 30 - 15);
                              yBuffer = tReg.y - cReg.y >= 0 ? -buffer : buffer;
                              yBuffer = int(yBuffer * this.world.SCALE);
                              cAvt.pMC.walkTo(tReg.x + xBuffer,tReg.y + yBuffer,32);
                           }
                           if(cAvt.pMC.spFX != null)
                           {
                              cAvt.pMC.spFX.avt = cAvt.target;
                           }
                           cReg = cAvt.pMC.mcChar.localToGlobal(new Point(0,0));
                           tReg = tAvt.pMC.mcChar.localToGlobal(new Point(0,0));
                           if(cAvt != tAvt)
                           {
                              if(tReg.x - cReg.x >= 0)
                              {
                                 cAvt.pMC.turn("right");
                              }
                              else
                              {
                                 cAvt.pMC.turn("left");
                              }
                           }
                           if(this.litePreference.data.bDisMonAnim)
                           {
                              return;
                           }
                           if(animStr.length > 1)
                           {
                              if(animStr.indexOf(",") > -1)
                              {
                                 if(this.world.objExtra["bChar"] == 1)
                                 {
                                    animString = cAvt.pMC.Animation;
                                    MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animString);
                                 }
                                 else
                                 {
                                    anims = animStr.split(",");
                                    animIndex = Math.round(Math.random() * (anims.length - 1));
                                    MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(anims[animIndex]);
                                 }
                              }
                              else if(this.world.objExtra["bChar"] == 1)
                              {
                                 animString = cAvt.pMC.Animation;
                                 MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animString);
                              }
                              else
                              {
                                 MovieClip(cAvt.pMC.getChildAt(1)).gotoAndPlay(animStr);
                              }
                           }
                        }
                     }
               }
            }
         }
      }
      
      public function key_StageLogin(param1:KeyboardEvent) : *
      {
         if(param1.target == stage)
         {
            if(param1.keyCode == Keyboard.ENTER)
            {
               stage.focus = this.mcLogin.ni;
            }
         }
      }
      
      public function hasBankItem() : Boolean
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this.world.myAvatar.items)
         {
            if(_loc1_.sMeta != null && _loc1_.sMeta.length > 0 && _loc1_.sMeta.toLowerCase().indexOf("bank") > -1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function key_StageGame(param1:KeyboardEvent) : *
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:MovieClip = null;
         var _loc7_:int = 0;
         if(Boolean(param1.target) && param1.target.name == "btnSetKeybindActive")
         {
            return;
         }
         if(!(param1.target is TextField || param1.currentTarget is TextField))
         {
            if(param1.keyCode == Keyboard.ENTER || String.fromCharCode(param1.charCode) == "/")
            {
               this.chatF.openMsgEntry();
            }
            if(this.isNumpadKey(param1.keyCode))
            {
               param1.keyCode -= 48;
            }
            if(param1.keyCode == this.litePreference.data.keys["Target Random Monster"])
            {
               if(!this.isInputFocused())
               {
                  _loc2_ = this.world.getMonstersByCell(this.world.strFrame);
                  _loc3_ = this.world.strFrame;
                  if(_loc2_.length > 0)
                  {
                     _loc4_ = Math.round(Math.random() * (_loc2_.length - 1));
                     while(_loc2_.length > 1 && !_loc2_[_loc4_] && !_loc2_[_loc4_].pMC && _loc2_[_loc4_].dataLeaf.intState == 0 && this.world.myAvatar.target == _loc2_[_loc4_])
                     {
                        if(this.world.strFrame != _loc3_)
                        {
                           break;
                        }
                        _loc4_ = Math.round(Math.random() * (_loc2_.length - 1));
                     }
                     if(this.world.strFrame == _loc3_)
                     {
                        if(_loc2_[_loc4_] && _loc2_[_loc4_].pMC && _loc2_[_loc4_].dataLeaf.strFrame == this.world.strFrame && _loc2_[_loc4_].dataLeaf.intState != 0)
                        {
                           this.world.setTarget(_loc2_[_loc4_]);
                        }
                     }
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Travel Menu\'s Travel"])
            {
               if(!this.isInputFocused())
               {
                  if(this.ui.getChildByName("mcTravelMenu"))
                  {
                     (this.ui.getChildByName("mcTravelMenu") as MovieClip).dispatchTravel();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Camera Tool"])
            {
               if(!this.isInputFocused())
               {
                  if(Boolean(stage.getChildByName("worldCameraMC")) || Boolean(getChildByName("cameraToolMC")))
                  {
                     return;
                  }
                  _loc5_ = new cameraTool(this);
                  _loc5_.name = "cameraToolMC";
                  _loc5_.x = -7;
                  addChild(_loc5_);
                  this.world.visible = false;
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["World Camera"])
            {
               if(!this.isInputFocused())
               {
                  if(Boolean(stage.getChildByName("worldCameraMC")) || Boolean(getChildByName("cameraToolMC")))
                  {
                     if(stage.getChildByName("worldCameraMC"))
                     {
                        MovieClip(stage.getChildByName("worldCameraMC")).dispatchExit();
                     }
                     return;
                  }
                  _loc6_ = new worldCamera(this);
                  _loc6_.name = "worldCameraMC";
                  stage.addChild(_loc6_);
               }
            }
            if(String.fromCharCode(param1.charCode) == ">")
            {
               if(!this.isInputFocused())
               {
                  if(this.chatF.pmSourceA[0] != null && this.chatF.pmSourceA[0].length >= 1)
                  {
                     this.chatF.openPMsg(this.chatF.pmSourceA[0]);
                     if(this.intChatMode)
                     {
                        this.ui.mcInterface.ncText.text = "> ";
                     }
                     else
                     {
                        this.ui.mcInterface.te.text = "> ";
                     }
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Inventory"])
            {
               if(!this.isInputFocused())
               {
                  this.ui.mcInterface.mcMenu.toggleInventory();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Bank"] && (this.world.myAvatar.isStaff() || this.hasBankItem()))
            {
               if(!this.isInputFocused())
               {
                  this.world.toggleBank();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Quest Log"])
            {
               if(stage.focus != this.ui.mcInterface.te && stage.focus != this.ui.mcInterface.ncText && stage.focus != this.ui.mcInterface.ncText)
               {
                  this.world.toggleQuestLog();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Friends List"])
            {
               if(!this.isInputFocused())
               {
                  if(this.ui.mcOFrame.isOpen)
                  {
                     this.ui.mcOFrame.fClose();
                  }
                  else
                  {
                     this.world.showFriendsList();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Character Panel"])
            {
               if(!this.isInputFocused())
               {
                  this.toggleCharpanel("overview");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Player HP Bar"])
            {
               if(!this.isInputFocused())
               {
                  this.world.toggleHPBar();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Options"])
            {
               if(!this.isInputFocused())
               {
                  if(this.ui.mcPopup.currentLabel == "Option")
                  {
                     this.ui.mcPopup.onClose();
                  }
                  else
                  {
                     this.ui.mcPopup.fOpen("Option");
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Area List"])
            {
               if(!this.isInputFocused())
               {
                  if(!this.ui.mcOFrame.isOpen)
                  {
                     this.world.sendWhoRequest();
                  }
                  else
                  {
                     this.ui.mcOFrame.fClose();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Jump"])
            {
               if(stage.focus != this.ui.mcInterface.te && stage.focus != this.ui.mcInterface.ncText)
               {
                  this.world.myAvatar.pMC.mcChar.gotoAndPlay("Jump");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Rest"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  this.world.rest();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Hide Monsters"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  this.world.toggleMonsters();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Hide Players"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  optionHandler.cmd(MovieClip(this),"Hide Players");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Cancel Target"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(this.cancelTargetTimer.running)
                  {
                     return;
                  }
                  if(this.world.autoActionTimer != null && Boolean(this.world.autoActionTimer.running))
                  {
                     this.world.cancelAutoAttack();
                     this.world.myAvatar.pMC.mcChar.gotoAndStop("Idle");
                  }
                  if(this.world.myAvatar.target != null)
                  {
                     this.world.setTarget(null);
                  }
                  if(!this.cancelTargetTimer.hasEventListener(TimerEvent.TIMER))
                  {
                     this.cancelTargetTimer.addEventListener(TimerEvent.TIMER,this.hasCanceledAlready,false,0,true);
                  }
                  _loc7_ = int(parseInt(this.world.getActionByRef(String(this.world.actionMap[0])).cd));
                  this.cancelTargetTimer.delay = _loc7_ < 2000 ? 2000 : _loc7_;
                  this.cancelTargetTimer.start();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Hide UI"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  optionHandler.cmd(MovieClip(this),"Hide UI");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Battle Analyzer"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  optionHandler.cmd(MovieClip(this),"Battle Analyzer");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Decline All Drops"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  optionHandler.cmd(MovieClip(this),"Decline All Drops");
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Stats Overview"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  this.toggleStatspanel();
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Battle Analyzer Toggle"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(this.bAnalyzer)
                  {
                     this.bAnalyzer.toggle();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Custom Drops UI"])
            {
               if(param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(Boolean(this.ui.mcPortrait.iconDrops) && Boolean(this.ui.mcPortrait.iconDrops.visible))
                  {
                     this.ui.mcPortrait.iconDrops.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["@ Debugger - Cell Menu"])
            {
               if(this.ui && this.ui.mcInterface && this.ui.mcInterface.te && param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(this.cMenuUI)
                  {
                     this.cMenuUI.toggle();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["@ Debugger - Packet Logger"])
            {
               if(this.ui && this.ui.mcInterface && this.ui.mcInterface.te && param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(Boolean(this.pLoggerUI) && Boolean(this.litePreference.data.dOptions["debugPacket"]))
                  {
                     this.pLoggerUI.visible = !this.pLoggerUI.visible;
                     this.pLoggerUI.toggle();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Dash"])
            {
               if(this.ui && this.ui.mcInterface && this.ui.mcInterface.te && param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(!this.world.uoTree[this.world.myAvatar.pnm].sta.$dsh)
                  {
                     this.world.uoTree[this.world.myAvatar.pnm].sta.$dsh = 100;
                  }
                  if(this.world.myAvatar.dataLeaf.intSP >= this.world.uoTree[this.world.myAvatar.pnm].sta.$dsh)
                  {
                     this.pDash = true;
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Outfits"])
            {
               if(this.ui && this.ui.mcInterface && this.ui.mcInterface.te && param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(!this.getInterface("outfitSets"))
                  {
                     this.toggleOutfits();
                  }
               }
            }
            if(param1.keyCode == this.litePreference.data.keys["Friendships UI"])
            {
               if(this.ui && this.ui.mcInterface && this.ui.mcInterface.te && param1.target != this.ui.mcInterface.te && param1.target != this.ui.mcInterface.ncText)
               {
                  if(!this.getInterface("Friendships UI"))
                  {
                     this.showFriendshipUI();
                  }
               }
            }
         }
      }
      
      private function hasCanceledAlready(param1:TimerEvent) : void
      {
         this.cancelTargetTimer.removeEventListener(TimerEvent.TIMER,this.hasCanceledAlready);
         stage.focus = null;
      }
      
      public function key_TextLogin(param1:KeyboardEvent) : *
      {
         if(param1.target != stage)
         {
            if(param1.keyCode == Keyboard.ENTER)
            {
               this.onLoginClick(null);
            }
         }
      }
      
      public function key_ChatEntry(param1:KeyboardEvent) : *
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.chatF.submitMsg(!!this.intChatMode ? this.ui.mcInterface.ncText.text : this.ui.mcInterface.te.text,this.chatF.chn.cur.typ,this.chatF.pmNm);
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.chatF.closeMsgEntry();
         }
      }
      
      public function talk(param1:*) : *
      {
         if(param1.accept)
         {
            this.chatF.submitMsg(param1.emote1,"emote",this.sfc.myUserName);
         }
         else
         {
            this.chatF.submitMsg(param1.emote2,"emote",this.sfc.myUserName);
         }
      }
      
      public function isNumpadKey(param1:uint) : Boolean
      {
         return param1 >= 96 && param1 <= 105;
      }
      
      public function key_actBar(param1:KeyboardEvent) : *
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         if(Boolean(param1.target) && param1.target.name == "btnSetKeybindActive")
         {
            return;
         }
         if(!this.isInputFocused())
         {
            if(this.isNumpadKey(param1.keyCode))
            {
               param1.keyCode -= 48;
            }
            switch(param1.keyCode)
            {
               case this.litePreference.data.keys["Auto Attack"]:
                  _loc2_ = 0;
                  if(this.world.actionMap[_loc2_] != null)
                  {
                     _loc4_ = this.world.getActionByRef(String(this.world.actionMap[_loc2_]));
                     if(_loc4_.auto != null && _loc4_.auto == true)
                     {
                        this.world.approachTarget();
                     }
                     else
                     {
                        this.world.testAction(_loc4_);
                     }
                  }
                  return;
               case this.litePreference.data.keys["Skill 1"]:
                  _loc2_ = 1;
                  if(this.world.actionMap[_loc2_] != null)
                  {
                     _loc4_ = this.world.getActionByRef(String(this.world.actionMap[_loc2_]));
                     if(_loc4_.isOK)
                     {
                        this.world.testAction(_loc4_);
                     }
                  }
                  break;
               case this.litePreference.data.keys["Skill 2"]:
                  _loc2_ = 2;
                  if(this.world.actionMap[_loc2_] != null)
                  {
                     _loc4_ = this.world.getActionByRef(String(this.world.actionMap[_loc2_]));
                     if(_loc4_.isOK)
                     {
                        this.world.testAction(_loc4_);
                     }
                  }
                  break;
               case this.litePreference.data.keys["Skill 3"]:
                  _loc2_ = 3;
                  if(this.world.actionMap[_loc2_] != null)
                  {
                     _loc4_ = this.world.getActionByRef(String(this.world.actionMap[_loc2_]));
                     if(_loc4_.isOK)
                     {
                        this.world.testAction(_loc4_);
                     }
                  }
                  break;
               case this.litePreference.data.keys["Skill 4"]:
                  _loc2_ = 4;
                  if(this.world.actionMap[_loc2_] != null)
                  {
                     _loc4_ = this.world.getActionByRef(String(this.world.actionMap[_loc2_]));
                     if(_loc4_.isOK)
                     {
                        this.world.testAction(_loc4_);
                     }
                  }
                  break;
               case this.litePreference.data.keys["Skill 5"]:
                  _loc2_ = 5;
                  if(this.world.actionMap[_loc2_] != null)
                  {
                     _loc4_ = this.world.getActionByRef(String(this.world.actionMap[_loc2_]));
                     if(_loc4_.isOK)
                     {
                        this.world.testAction(_loc4_);
                     }
                  }
            }
         }
      }
      
      public function isInputFocused() : Boolean
      {
         return stage.focus != null && "text" in stage.focus;
      }
      
      public function getKeyboardDict() : Dictionary
      {
         var _loc6_:String = null;
         var _loc1_:XML = describeType(Keyboard);
         var _loc2_:XMLList = _loc1_.constant.@name;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:int = int(_loc2_.length());
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc2_[_loc5_];
            if(_loc2_[_loc5_].indexOf("NUMBER_") > -1 || _loc2_[_loc5_].indexOf("STRING_") > -1 || _loc2_[_loc5_].indexOf("KEYNAME_") > -1)
            {
               _loc6_ = _loc2_[_loc5_].split("_")[1];
            }
            _loc3_[Keyboard[_loc2_[_loc5_]]] = _loc6_;
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function decHex(param1:*) : *
      {
         return param1.toString(16);
      }
      
      public function hexDec(param1:*) : *
      {
         return parseInt(param1,16);
      }
      
      public function modColor(param1:*, param2:*, param3:*) : String
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc4_:* = "";
         var _loc8_:* = 0;
         while(_loc8_ < 3)
         {
            _loc5_ = this.hexDec(param1.substr(_loc8_ * 2,2));
            _loc6_ = this.hexDec(param2.substr(_loc8_ * 2,2));
            switch(param3)
            {
               case "-":
               default:
                  _loc7_ = _loc5_ - _loc6_;
                  if(_loc7_ < 0)
                  {
                     _loc7_ = 0;
                  }
                  break;
               case "+":
                  _loc7_ = _loc5_ + _loc6_;
                  if(_loc7_ > 255)
                  {
                     _loc7_ = 255;
                  }
                  _loc7_ = this.decHex(_loc7_);
                  break;
            }
            _loc7_ = this.decHex(_loc7_);
            _loc4_ += String(_loc7_.length < 2 ? "0" + _loc7_ : _loc7_);
            _loc8_++;
         }
         return _loc4_;
      }
      
      internal function replaceString(param1:String, param2:String, param3:String) : String
      {
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:String = "";
         while(true)
         {
            _loc4_ = Number(param1.indexOf(param2,_loc4_));
            if(_loc4_ == -1)
            {
               break;
            }
            _loc6_ += param1.substring(_loc5_,_loc4_) + param3;
            _loc5_ = _loc4_ = _loc4_ + param2.length;
         }
         return _loc6_ == "" ? param1 : _loc6_;
      }
      
      public function stripWhite(param1:String) : String
      {
         param1 = param1.split("\r").join("");
         param1 = param1.split("\t").join("");
         return param1.split(" ").join("");
      }
      
      public function stripWhiteStrict(param1:String) : String
      {
         param1 = this.stripWhite(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this.chatF.strictComparisonChars.length)
         {
            param1 = param1.split(this.chatF.strictComparisonChars.substr(_loc2_,1)).join("");
            _loc2_++;
         }
         return param1;
      }
      
      public function stripWhiteStrictB(param1:String) : String
      {
         param1 = this.stripWhite(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this.chatF.strictComparisonCharsB.length)
         {
            param1 = param1.split(this.chatF.strictComparisonCharsB.substr(_loc2_,1)).join("");
            _loc2_++;
         }
         return param1;
      }
      
      public function stripMarks(param1:String) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.chatF.markChars.length)
         {
            param1 = param1.split(this.chatF.markChars.substr(_loc2_,1)).join("");
            _loc2_++;
         }
         return param1;
      }
      
      public function stripDuplicateVowels(param1:String) : String
      {
         param1 = param1.replace(this.chatF.regExpA,"a");
         param1 = param1.replace(this.chatF.regExpE,"e");
         param1 = param1.replace(this.chatF.regExpI,"i");
         param1 = param1.replace(this.chatF.regExpO,"o");
         param1 = param1.replace(this.chatF.regExpU,"u");
         return param1.replace(this.chatF.regExpSPACE," ");
      }
      
      public function maskStringBetween(param1:String, param2:Array) : String
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc3_:* = "";
         if(param2.length > 0 && param2.length % 2 == 0)
         {
            _loc4_ = 0;
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               if(_loc5_ >= param2[_loc4_] && _loc5_ <= param2[_loc4_ + 1])
               {
                  if(param1.charAt(_loc5_) == " ")
                  {
                     _loc3_ += " ";
                  }
                  else
                  {
                     _loc3_ += "*";
                  }
                  if(_loc5_ == param2[_loc4_ + 1])
                  {
                     _loc4_ += 2;
                  }
               }
               else
               {
                  _loc3_ += param1.charAt(_loc5_);
               }
               _loc5_++;
            }
         }
         else
         {
            trace("[Game] ERR maskStringBetween: malformed indeces array");
         }
         return _loc3_;
      }
      
      public function arraySort(param1:String, param2:String) : int
      {
         if(param1 > param2)
         {
            return 1;
         }
         if(param1 < param2)
         {
            return -1;
         }
         return 0;
      }
      
      public function convertBubbleText(param1:String) : String
      {
         var _loc2_:String = null;
         _loc2_ = this.world.myAvatar.objData.strUsername;
         if(param1.indexOf("@name"))
         {
            param1 = param1.split("@name").join(_loc2_);
         }
         _loc2_ = String(this.world.myAvatar.objData.intLevel);
         if(param1.indexOf("@level"))
         {
            param1 = param1.split("@level").join(_loc2_);
         }
         _loc2_ = this.world.myAvatar.objData.strClassName;
         if(param1.indexOf("@class"))
         {
            param1 = param1.split("@class").join(_loc2_);
         }
         _loc2_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "Mr." : "Mrs.";
         if(param1.indexOf("@prefix"))
         {
            param1 = param1.split("@prefix").join(_loc2_);
         }
         _loc2_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "He" : "She";
         if(param1.indexOf("@He"))
         {
            param1 = param1.split("@prefix").join(_loc2_);
         }
         _loc2_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "Him" : "Her";
         if(param1.indexOf("@Him"))
         {
            param1 = param1.split("@prefix").join(_loc2_);
         }
         _loc2_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "His" : "Her";
         if(param1.indexOf("@His"))
         {
            param1 = param1.split("@prefix").join(_loc2_);
         }
         _loc2_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "he" : "she";
         if(param1.indexOf("@he"))
         {
            param1 = param1.split("@prefix").join(_loc2_);
         }
         _loc2_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "him" : "her";
         if(param1.indexOf("@him"))
         {
            param1 = param1.split("@prefix").join(_loc2_);
         }
         _loc2_ = this.world.myAvatar.objData.strGender.toLowerCase() == "m" ? "his" : "her";
         if(param1.indexOf("@his"))
         {
            param1 = param1.split("@prefix").join(_loc2_);
         }
         return param1;
      }
      
      public function strToProperCase(param1:String) : String
      {
         return param1.slice(0,1).toUpperCase() + param1.slice(1,param1.length).toLowerCase();
      }
      
      public function strSetCharAt(param1:String, param2:int, param3:String) : String
      {
         return param1.substring(0,param2) + param3 + param1.substring(param2 + 1,param1.length);
      }
      
      public function strNumWithCommas(param1:Number) : String
      {
         var _loc2_:String = "";
         var _loc3_:String = param1.toString();
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = _loc3_.length - 1;
         while(_loc4_ > -1)
         {
            if(_loc5_ == 3)
            {
               _loc5_ = 0;
               _loc2_ = _loc3_.charAt(_loc4_) + "," + _loc2_;
            }
            else
            {
               _loc2_ = _loc3_.charAt(_loc4_) + _loc2_;
            }
            _loc5_++;
            _loc4_--;
         }
         return _loc2_;
      }
      
      public function numToStr(param1:Number, param2:int = 2) : String
      {
         var _loc3_:* = param1.toString();
         if(_loc3_.indexOf(".") == -1)
         {
            _loc3_ += ".";
         }
         var _loc4_:Array = _loc3_.split(".");
         while(_loc4_[1].length < param2)
         {
            _loc4_[1] += "0";
         }
         if(_loc4_[1].length > param2)
         {
            _loc4_[1] = _loc4_[1].substr(0,param2);
         }
         if(param2 > 0)
         {
            _loc3_ = _loc4_[0] + "." + _loc4_[1];
         }
         else
         {
            _loc3_ = _loc4_[0];
         }
         return _loc3_;
      }
      
      public function copyObj(param1:Object) : Object
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      public function copyConstructor(param1:*) : *
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject() as Class;
      }
      
      public function distanceO(param1:*, param2:*) : Number
      {
         return Math.sqrt(Math.pow(int(param2.x - param1.x),2) + Math.pow(int(param2.y - param1.y),2));
      }
      
      public function distanceP(param1:*, param2:*, param3:*, param4:*) : Number
      {
         return Math.sqrt(Math.pow(param3 - param1,2) + Math.pow(param4 - param2,2));
      }
      
      public function distanceXY(param1:*, param2:*, param3:*, param4:*) : Object
      {
         return {
            "dx":param3 - param1,
            "dy":param4 - param2
         };
      }
      
      public function isHouseItem(param1:Object) : Boolean
      {
         return param1.sType == "House" || param1.sType == "Floor Item" || param1.sType == "Wall Item";
      }
      
      internal function validateArmor(param1:*) : *
      {
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc2_:Array = [];
         var _loc3_:Object = {};
         var _loc4_:int = 0;
         var _loc5_:int = 10;
         var _loc6_:Boolean = true;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:int = int(param1.ItemID);
         switch(_loc9_)
         {
            case 319:
            case 2083:
               _loc7_ = true;
               _loc2_ = [16,15654,407,20,15651,409];
               break;
            case 409:
               _loc8_ = true;
               _loc2_ = [20,15651];
               break;
            case 408:
               _loc8_ = true;
               _loc2_ = [17,15653];
               break;
            case 410:
               _loc8_ = true;
               _loc2_ = [18,15652];
               break;
            case 407:
               _loc8_ = true;
               _loc2_ = [16,15654];
         }
         if(_loc7_)
         {
            _loc10_ = 0;
            while(_loc10_ < _loc2_.length)
            {
               if(this.world.myAvatar.getCPByID(_loc2_[_loc10_]) < 302500)
               {
                  _loc6_ = false;
               }
               else
               {
                  _loc6_ = true;
                  if(_loc10_ < 2)
                  {
                     _loc10_ = 2;
                  }
                  if(_loc10_ < 5 && _loc10_ > 2)
                  {
                     break;
                  }
               }
               _loc10_++;
            }
            return _loc6_;
         }
         if(_loc8_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc2_.length)
            {
               if(this.world.myAvatar.getCPByID(_loc2_[_loc11_]) >= param1.iReqCP)
               {
                  return true;
               }
               _loc11_++;
            }
            return false;
         }
         return !(Number(param1.iClass) > 0 && this.world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP);
      }
      
      public function getItemInfoString(param1:Object) : String
      {
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc2_:* = "<font size=\'14\'><b>" + param1.sName + "</b></font><br>";
         if(!this.validateArmor(param1) && param1.iClass > 0)
         {
            _loc2_ += "<font size=\'11\' color=\'#CC0000\'>";
            _loc3_ = this.getRankFromPoints(param1.iReqCP);
            _loc4_ = param1.iReqCP - this.arrRanks[_loc3_ - 1];
            if(_loc4_ > 0)
            {
               _loc2_ += "Requires " + _loc4_ + " Class Points on " + param1.sClass + ", Rank " + _loc3_ + ".";
            }
            else
            {
               _loc2_ += "Requires " + param1.sClass + ", Rank " + _loc3_ + ".";
            }
            _loc2_ += "</font><br>";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc2_ += "<font size=\'11\' color=\'#CC0000\'>";
            _loc5_ = this.getRankFromPoints(param1.iReqRep);
            _loc6_ = param1.iReqRep - this.arrRanks[_loc5_ - 1];
            if(_loc6_ > 0)
            {
               _loc2_ += "Requires " + _loc6_ + " Reputation on " + param1.sFaction + ", Rank " + _loc5_ + ".";
            }
            else
            {
               _loc2_ += "Requires " + param1.sFaction + ", Rank " + _loc5_ + ".";
            }
            _loc2_ += "</font><br>";
         }
         if(param1.iQSindex >= 0 && this.world.getQuestValue(param1.iQSindex) < int(param1.iQSvalue))
         {
            _loc2_ += "<font size=\'11\' color=\'#CC0000\'>Requires completion of quest \"" + param1.sQuest + "\".</font><br>";
         }
         _loc2_ += "<font color=\'#009900\'><b>" + this.getDisplaysType(param1);
         if(param1.sES != "None" && param1.sES != "co" && param1.sES != "mi")
         {
            if(param1.EnhID > 0)
            {
               _loc2_ += ", Lvl " + param1.EnhLvl;
               if(param1.sES == "Weapon")
               {
                  _loc7_ = this.getBaseHPByLevel(param1.EnhLvl);
                  _loc8_ = 20;
                  _loc9_ = 1;
                  _loc10_ = param1.iRng / 100;
                  _loc11_ = 2;
                  _loc12_ = Math.round(_loc7_ / _loc8_ * _loc9_);
                  _loc13_ = Math.round(_loc12_ * _loc11_);
                  _loc14_ = Math.floor(_loc13_ - _loc13_ * _loc10_);
                  _loc15_ = Math.ceil(_loc13_ + _loc13_ * _loc10_);
                  _loc2_ += "<br>" + _loc14_ + " - " + _loc15_ + " " + param1.sElmt;
               }
            }
            else
            {
               _loc2_ += " Design";
            }
         }
         param1.sDesc = param1.sDesc.replace(this.regExLineSpace,"\n");
         return _loc2_ + ("</b></font>" + (!!this.litePreference.data.bDebugger ? "Item ID: " + param1.ItemID + "<br>" : "") + "<br>" + param1.sDesc + "<br>");
      }
      
      public function getItemInfoStringB(param1:Object) : String
      {
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc2_:int = param1.iRty == 0 ? 25 : int(param1.iRty);
         var _loc3_:* = "<font size=\'12\'><b>" + param1.sName + "</b></font><br>";
         if(!this.validateArmor(param1) && param1.iClass > 0)
         {
            _loc3_ += "<font size=\'10\' color=\'#CC0000\'>";
            _loc4_ = this.getRankFromPoints(param1.iReqCP);
            _loc5_ = param1.iReqCP - this.arrRanks[_loc4_ - 1];
            if(_loc5_ > 0)
            {
               _loc3_ += "Requires " + _loc5_ + " Class Points on " + param1.sClass + ", Rank " + _loc4_ + ".";
            }
            else
            {
               _loc3_ += "Requires " + param1.sClass + ", Rank " + _loc4_ + ".";
            }
            _loc3_ += "</font><br>";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc3_ += "<font size=\'10\' color=\'#CC0000\'>";
            _loc6_ = this.getRankFromPoints(param1.iReqRep);
            _loc7_ = param1.iReqRep - this.arrRanks[_loc6_ - 1];
            if(_loc7_ > 0)
            {
               _loc3_ += "Requires " + _loc7_ + " Reputation on " + param1.sFaction + ", Rank " + _loc6_ + ".";
            }
            else
            {
               _loc3_ += "Requires " + param1.sFaction + ", Rank " + _loc6_ + ".";
            }
            _loc3_ += "</font><br>";
         }
         if(param1.iQSindex >= 0 && this.world.getQuestValue(param1.iQSindex) < int(param1.iQSvalue))
         {
            _loc3_ += "<font size=\'11\' color=\'#CC0000\'>Requires completion of quest \"" + param1.sQuest + "\".</font><br>";
         }
         if(param1.sMeta != null && this.getDisplaysType(param1) == "Pet" && param1.sMeta.indexOf("Necromancer") > -1)
         {
            _loc3_ += "<font color=\'#00CCFF\'><b>Battle " + this.getDisplaysType(param1);
         }
         else
         {
            _loc3_ += "<font color=\'#00CCFF\'><b>" + this.getDisplaysType(param1);
         }
         if(param1.sType.toLowerCase() == "enhancement")
         {
            _loc3_ += ", Level " + param1.iLvl;
         }
         if(param1.sES != "None" && param1.sES != "co" && param1.sES != "pe" && param1.sES != "mi")
         {
            if(param1.EnhID > 0)
            {
               _loc3_ += ", Level " + param1.EnhLvl;
               if(param1.sES == "ar")
               {
                  _loc3_ += "<br>Rank " + this.getRankFromPoints(param1.iQty);
               }
            }
            else if(param1.sType.toLowerCase() != "enhancement")
            {
               _loc3_ += " Design";
            }
         }
         if(param1.iStk > 1)
         {
            _loc3_ += " - " + param1.iQty + "/" + param1.iStk;
         }
         if(param1.sES == "Weapon" || param1.sES == "co" || param1.sES == "he" || param1.sES == "ba" || param1.sES == "pe" || param1.sES == "am" || param1.sES == "mi" || param1.sES == "hi" || param1.sES == "ho")
         {
            if(param1.sType.toLowerCase() != "enhancement")
            {
               _loc3_ += "<br>" + this.getRarityString(_loc2_) + " Rarity";
            }
         }
         if(param1.sType.toLowerCase() != "enhancement")
         {
            param1.sDesc = param1.sDesc.replace(this.regExLineSpace,"\n");
            _loc3_ += "</b></font><br><font size=\'10\' color=\'#FFFFFF\'>" + (!!this.litePreference.data.bDebugger ? "Item ID: " + param1.ItemID + "<br>" : "") + param1.sDesc + "<br></font>";
         }
         else
         {
            _loc3_ += "</b></font><br><font size=\'10\' color=\'#FFFFFF\'>";
            _loc3_ += "Enhancements are special items which can apply stats to your weapons and armor. Select a weapon or armor item from the list on the right, and click the <font color=\'#00CCFF\'>\"Enhancements\"</font> button that appears below its preview.";
         }
         return _loc3_;
      }
      
      public function getIconByType(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1.toLowerCase())
         {
            case "axe":
            case "bow":
            case "dagger":
            case "gun":
            case "mace":
            case "polearm":
            case "staff":
            case "sword":
            case "wand":
            case "armor":
               _loc2_ = "iw" + param1.toLowerCase();
               break;
            case "cape":
            case "helm":
            case "pet":
            case "class":
               _loc2_ = "ii" + param1.toLowerCase();
               break;
            default:
               _loc2_ = "iibag";
         }
         return _loc2_;
      }
      
      public function getIconBySlot(param1:String) : String
      {
         var _loc2_:String = "";
         switch(param1.toLowerCase())
         {
            case "weapon":
               _loc2_ = "iwsword";
               break;
            case "back":
            case "ba":
               _loc2_ = "iicape";
               break;
            case "head":
            case "he":
               _loc2_ = "iihelm";
               break;
            case "armor":
            case "ar":
               _loc2_ = "iiclass";
               break;
            case "class":
               _loc2_ = "iiclass";
               break;
            case "pet":
            case "pe":
               _loc2_ = "iipet";
               break;
            default:
               _loc2_ = "iibag";
         }
         return _loc2_;
      }
      
      public function getDisplaysType(param1:Object) : *
      {
         var _loc2_:String = param1.sType != null ? param1.sType : "Unknown";
         var _loc3_:String = _loc2_.toLowerCase();
         if(_loc3_ == "clientuse" || _loc3_ == "serveruse")
         {
            _loc2_ = "Item";
         }
         if(_loc3_ == "misc")
         {
            _loc2_ = "Ground";
         }
         return _loc2_;
      }
      
      public function stringToDate(param1:String) : Date
      {
         var _loc2_:* = Number(param1.substr(0,4));
         var _loc3_:* = Number(param1.substr(5,2)) - 1;
         var _loc4_:* = Number(param1.substr(8,2));
         var _loc5_:* = Number(param1.substr(11,2));
         var _loc6_:* = Number(param1.substr(14,2));
         var _loc7_:* = Number(param1.substr(17));
         return new Date(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
      }
      
      internal function traceObject(param1:*, param2:* = 1) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc3_:* = "";
         while(_loc3_.length < param2)
         {
            _loc3_ += " ";
         }
         param2++;
         if(typeof param1 == "object" && param1.length != null)
         {
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               trace(_loc3_ + _loc4_ + ": " + param1[_loc4_]);
               _loc4_++;
            }
         }
         else
         {
            for(_loc5_ in param1)
            {
               trace(_loc3_ + _loc5_ + ": " + param1[_loc5_]);
               if(typeof param1[_loc5_] == "object")
               {
                  this.traceObject(param1[_loc5_],param2);
               }
            }
         }
      }
      
      public function max(param1:int, param2:int) : int
      {
         if(param1 > param2)
         {
            return param1;
         }
         return param2;
      }
      
      public function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public function isValidEmail(param1:String) : Boolean
      {
         return Boolean(param1.match(this.EMAIL_REGEX));
      }
      
      public function closeToolTip() : void
      {
         var _loc1_:* = undefined;
         try
         {
            _loc1_ = MovieClip(stage.getChildAt(0)).ui.ToolTip;
            _loc1_.close();
         }
         catch(e:Error)
         {
         }
      }
      
      public function updateIcons(param1:Array, param2:Array, param3:Object = null) : *
      {
         var _loc6_:MovieClip = null;
         var _loc7_:Class = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc6_ = param1[_loc4_];
            _loc6_.cnt.removeChildAt(0);
            _loc6_.item = param3;
            if(_loc6_.item == null)
            {
               _loc6_.tQty.visible = false;
            }
            while(_loc5_ < param2.length)
            {
               _loc7_ = this.world.getClass(param2[_loc5_]) as Class;
               _loc8_ = new _loc7_();
               _loc9_ = _loc6_.cnt.addChild(_loc8_);
               _loc10_ = int(42 - 8 + 4 * _loc5_);
               _loc11_ = int(39 - 8 + 4 * _loc5_);
               _loc12_ = _loc9_.width;
               _loc13_ = _loc9_.height;
               if(_loc12_ > _loc13_)
               {
                  _loc9_.scaleX = _loc9_.scaleY = _loc10_ / _loc12_;
               }
               else
               {
                  _loc9_.scaleX = _loc9_.scaleY = _loc11_ / _loc13_;
               }
               _loc9_.x = _loc6_.bg.width / 2 - _loc9_.width / 2;
               _loc9_.y = _loc6_.bg.height / 2 - _loc9_.height / 2;
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      public function updateItemSkill() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.world.actions.active.length)
         {
            if(Boolean(this.world.actions.active[_loc1_]) && this.world.actions.active[_loc1_].ref == "i1")
            {
               this.updateActionObjIcon(this.world.actions.active[_loc1_]);
               break;
            }
            _loc1_++;
         }
      }
      
      public function updateActionObjIcon(param1:Object) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Array = this.world.getActIcons(param1);
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc5_];
            _loc4_ = _loc3_.item;
            if(_loc4_ != null)
            {
               _loc6_ = 0;
               while(_loc7_ < this.world.myAvatar.items.length)
               {
                  if(this.world.myAvatar.items[_loc7_].ItemID == _loc4_.ItemID)
                  {
                     _loc6_ = int(this.world.myAvatar.items[_loc7_].iQty);
                  }
                  _loc7_++;
               }
               if(_loc6_ > 0)
               {
                  _loc3_.tQty.visible = true;
                  _loc3_.tQty.text = _loc6_;
               }
               else
               {
                  this.world.unequipUseableItem(_loc4_);
               }
            }
            _loc5_++;
         }
      }
      
      public function drawChainsSmooth(param1:Array, param2:int, param3:MovieClip) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Point = null;
         var _loc12_:Array = null;
         var _loc13_:MovieClip = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         _loc6_ = 1;
         while(_loc6_ < param1.length)
         {
            _loc4_ = new Point(0,0);
            _loc5_ = new Point(0,0);
            _loc4_ = param1[_loc6_ - 1].localToGlobal(_loc4_);
            _loc5_ = param1[_loc6_].localToGlobal(_loc5_);
            _loc7_ = [];
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = Math.ceil(Point.distance(_loc4_,_loc5_) / param2);
            if(_loc10_ % 2 == 1)
            {
               _loc10_ += 1;
            }
            _loc11_ = new Point();
            _loc12_ = [param3.fx0,param3.fx1,param3.fx2];
            _loc14_ = -1;
            _loc8_ = 0;
            while(_loc8_ < _loc12_.length)
            {
               _loc7_ = [];
               _loc14_ = Math.random() > 0.5 ? 1 : -1;
               _loc15_ = 0;
               _loc9_ = 1;
               while(_loc9_ < _loc10_)
               {
                  _loc11_ = Point.interpolate(_loc4_,_loc5_,1 - _loc9_ / _loc10_);
                  if(++_loc15_ % 2 == 1)
                  {
                     _loc11_.x += _loc14_ * Math.round(Math.random() * 30);
                     _loc11_.y += _loc14_ * Math.round(Math.random() * 30);
                     _loc14_ = -_loc14_;
                  }
                  _loc7_.push(_loc11_);
                  _loc9_++;
               }
               _loc7_.push(_loc5_);
               _loc13_ = _loc12_[_loc8_];
               _loc13_.graphics.lineStyle(2,16777215,1);
               _loc13_.graphics.moveTo(_loc4_.x,_loc4_.y);
               _loc9_ = 0;
               while(_loc9_ < _loc7_.length)
               {
                  _loc13_.graphics.curveTo(_loc7_[_loc9_].x,_loc7_[_loc9_].y,_loc7_[_loc9_ + 1].x,_loc7_[_loc9_ + 1].y);
                  _loc9_ += 2;
               }
               _loc8_++;
            }
            _loc6_++;
         }
      }
      
      public function drawChainsLinear(param1:Array, param2:int, param3:MovieClip) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Point = null;
         var _loc14_:Array = null;
         var _loc15_:MovieClip = null;
         _loc8_ = 1;
         while(_loc8_ < param1.length)
         {
            _loc6_ = param1[_loc8_ - 1];
            _loc7_ = param1[_loc8_];
            _loc4_ = new Point(0,-_loc6_.height * 0.5);
            _loc5_ = new Point(0,-_loc7_.height * 0.5);
            _loc4_ = _loc6_.localToGlobal(_loc4_);
            _loc5_ = _loc7_.localToGlobal(_loc5_);
            _loc9_ = [];
            _loc10_ = 0;
            _loc11_ = 0;
            _loc12_ = Math.ceil(Point.distance(_loc4_,_loc5_) / param2);
            _loc13_ = new Point();
            _loc14_ = [param3.fx0,param3.fx1,param3.fx2];
            _loc10_ = 0;
            while(_loc10_ < _loc14_.length)
            {
               _loc9_ = [];
               _loc11_ = 1;
               while(_loc11_ < _loc12_)
               {
                  _loc13_ = Point.interpolate(_loc4_,_loc5_,1 - _loc11_ / (_loc12_ + 1));
                  _loc13_.x += Math.round(Math.random() * 25 - 13);
                  _loc13_.y += Math.round(Math.random() * 25 - 13);
                  _loc9_.push(_loc13_);
                  _loc11_++;
               }
               _loc15_ = _loc14_[_loc10_];
               _loc15_.graphics.clear();
               _loc15_.graphics.lineStyle(5,16777215,1);
               _loc15_.graphics.moveTo(_loc4_.x,_loc4_.y);
               _loc11_ = 0;
               while(_loc11_ < _loc9_.length)
               {
                  _loc15_.graphics.lineTo(_loc9_[_loc11_].x,_loc9_[_loc11_].y);
                  _loc11_++;
               }
               _loc15_.graphics.lineTo(_loc5_.x,_loc5_.y);
               _loc10_++;
            }
            _loc8_++;
         }
      }
      
      public function drawFunnel(param1:Array, param2:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         param2.numLines = 3;
         param2.lineThickness = 3;
         param2.lineColors = [10027178,0,2228326];
         param2.glowColors = [0];
         param2.glowStrength = 4;
         param2.glowSize = 4;
         param2.dur = 500;
         param2.del = 100;
         param2.p1StartingValue = 0.12;
         param2.p2StartingValue = 0.24;
         param2.p3StartingValue = 0.36;
         param2.p1EndingValue = 0.66;
         param2.p2EndingValue = 0.825;
         param2.p3EndingValue = 0.99;
         param2.p1ScaleFactor = 0.5;
         param2.p3ScaleFactor = 0.5;
         param2.easingExponent = 1.5;
         param2.targetMCs = param1;
         param2.filterArr = [];
         param2.fxArr = [];
         param2.ts = new Date().getTime();
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param2.glowColors.length)
         {
            param2.filterArr.push([new GlowFilter(param2.glowColors[_loc4_],1,param2.glowSize,param2.glowSize,param2.glowStrength,1,false,false)]);
            _loc4_++;
         }
         _loc4_ = 0;
         _loc5_ = 0;
         var _loc6_:int = 0;
         while(_loc6_ < param2.numLines)
         {
            _loc3_ = param2.addChild(new MovieClip()) as MovieClip;
            _loc3_.filters = param2.filterArr[_loc4_];
            if(++_loc4_ >= param2.glowColors.length)
            {
               _loc4_ = 0;
            }
            _loc3_.lineColor = param2.lineColors[_loc5_];
            if(++_loc5_ >= param2.lineColors.length)
            {
               _loc5_ = 0;
            }
            param2.fxArr.push(_loc3_);
            _loc6_++;
         }
         param2.addEventListener(Event.ENTER_FRAME,this.funnelEF,false,0,true);
      }
      
      internal function funnelEF(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc17_:Point = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         var _loc20_:Point = null;
         var _loc21_:Point = null;
         var _loc22_:Point = null;
         var _loc26_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         var _loc4_:Number = Number(new Date().getTime());
         var _loc5_:Point = new Point();
         var _loc6_:Point = new Point();
         var _loc7_:Point = new Point();
         var _loc10_:int = 1;
         var _loc11_:MovieClip = _loc2_.targetMCs[0];
         var _loc12_:MovieClip = _loc2_.targetMCs[1];
         var _loc13_:Point = _loc11_.localToGlobal(new Point(0,-_loc11_.height / 2));
         var _loc14_:Point = _loc12_.localToGlobal(new Point(0,-_loc12_.height / 2));
         var _loc15_:* = _loc12_.width;
         var _loc16_:* = _loc12_.height;
         var _loc23_:int = -1;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc27_:Number = Math.atan2(_loc13_.y - _loc14_.y,_loc13_.x - _loc14_.x);
         _loc27_ = _loc27_ - Math.PI / 2;
         var _loc28_:int = 0;
         while(_loc28_ < _loc2_.fxArr.length)
         {
            _loc3_ = _loc2_.fxArr[_loc28_];
            _loc9_ = Number(_loc2_.ts);
            _loc8_ = _loc4_ - _loc28_ * _loc2_.del;
            if(_loc8_ > _loc9_ + _loc2_.dur)
            {
               if(_loc3_.visible)
               {
                  _loc3_.visible = false;
                  _loc3_.graphics.clear();
               }
               if(_loc28_ == _loc2_.fxArr.length - 1)
               {
                  _loc2_.removeEventListener(Event.ENTER_FRAME,this.funnelEF);
                  if(_loc2_.parent != null)
                  {
                     _loc2_.parent.removeChild(_loc2_);
                  }
               }
            }
            else if(_loc8_ >= _loc2_.ts)
            {
               _loc29_ = (_loc8_ - _loc9_) / _loc2_.dur;
               _loc29_ = Math.pow(1 - _loc29_,_loc2_.easingExponent);
               _loc10_ = _loc28_ % 2 == 0 ? 1 : -1;
               _loc17_ = new Point(Point.interpolate(_loc13_,_loc14_,_loc2_.p1StartingValue).x + Point.polar(_loc10_ * (_loc12_.height / _loc2_.p1ScaleFactor),_loc27_).x,Point.interpolate(_loc13_,_loc14_,_loc2_.p1StartingValue).y + Point.polar(_loc10_ * (_loc12_.height / _loc2_.p1ScaleFactor),_loc27_).y);
               _loc18_ = new Point(Point.interpolate(_loc13_,_loc14_,_loc2_.p1EndingValue).x,Point.interpolate(_loc13_,_loc14_,_loc2_.p1EndingValue).y);
               _loc19_ = new Point(Point.interpolate(_loc13_,_loc14_,_loc2_.p2StartingValue).x,_loc14_.y);
               _loc20_ = new Point(Point.interpolate(_loc13_,_loc14_,_loc2_.p2EndingValue).x,Point.interpolate(_loc13_,_loc14_,_loc2_.p2EndingValue).y);
               _loc21_ = new Point(Point.interpolate(_loc13_,_loc14_,_loc2_.p3StartingValue).x + Point.polar(-_loc10_ * (_loc12_.height / _loc2_.p3ScaleFactor),_loc27_).x,Point.interpolate(_loc13_,_loc14_,_loc2_.p3StartingValue).y + Point.polar(-_loc10_ * (_loc12_.height / _loc2_.p3ScaleFactor),_loc27_).y);
               _loc22_ = new Point(Point.interpolate(_loc13_,_loc14_,_loc2_.p3EndingValue).x,Point.interpolate(_loc13_,_loc14_,_loc2_.p3EndingValue).y);
               _loc5_ = Point.interpolate(_loc17_,_loc18_,_loc29_);
               _loc6_ = Point.interpolate(_loc19_,_loc20_,_loc29_);
               _loc7_ = Point.interpolate(_loc21_,_loc22_,_loc29_);
               _loc26_ = Number(_loc3_.lineColor);
               _loc3_.graphics.clear();
               _loc3_.graphics.lineStyle(_loc2_.lineThickness,_loc26_,1);
               _loc3_.graphics.moveTo(_loc14_.x,_loc14_.y);
               _loc3_.graphics.curveTo(_loc5_.x,_loc5_.y,_loc6_.x,_loc6_.y);
               _loc3_.graphics.curveTo(_loc7_.x,_loc7_.y,_loc13_.x,_loc13_.y);
               _loc30_ = Math.cos((_loc8_ - _loc9_) / _loc2_.dur * Math.PI * 2);
               _loc30_ = _loc30_ / 2 + 0.5;
               _loc30_ = 1 - _loc30_;
               _loc3_.alpha = _loc30_;
            }
            _loc28_++;
         }
      }
      
      public function updateCoreValues(param1:Object) : void
      {
         if(param1.intLevelCap != null)
         {
            this.intLevelCap = param1.intLevelCap;
         }
         if(param1.PCstBase != null)
         {
            this.PCstBase = param1.PCstBase;
         }
         if(param1.PCstRatio != null)
         {
            this.PCstRatio = param1.PCstRatio;
         }
         if(param1.PCstGoal != null)
         {
            this.PCstGoal = param1.PCstGoal;
         }
         if(param1.GstBase != null)
         {
            this.GstBase = param1.GstBase;
         }
         if(param1.GstRatio != null)
         {
            this.GstRatio = param1.GstRatio;
         }
         if(param1.GstGoal != null)
         {
            this.GstGoal = param1.GstGoal;
         }
         if(param1.PChpBase1 != null)
         {
            this.PChpBase1 = param1.PChpBase1;
         }
         if(param1.PChpBase100 != null)
         {
            this.PChpBase100 = param1.PChpBase100;
         }
         if(param1.PChpGoal1 != null)
         {
            this.PChpGoal1 = param1.PChpGoal1;
         }
         if(param1.PChpGoal100 != null)
         {
            this.PChpGoal100 = param1.PChpGoal100;
         }
         if(param1.PChpDelta != null)
         {
            this.PChpDelta = param1.PChpDelta;
         }
         if(param1.intHPperEND != null)
         {
            this.intHPperEND = param1.intHPperEND;
         }
         if(param1.intAPtoDPS != null)
         {
            this.intAPtoDPS = param1.intAPtoDPS;
         }
         if(param1.intSPtoDPS != null)
         {
            this.intSPtoDPS = param1.intSPtoDPS;
         }
         if(param1.bigNumberBase != null)
         {
            this.bigNumberBase = param1.bigNumberBase;
         }
         if(param1.resistRating != null)
         {
            this.resistRating = param1.resistRating;
         }
         if(param1.modRating != null)
         {
            this.modRating = param1.modRating;
         }
         if(param1.baseDodge != null)
         {
            this.baseDodge = param1.baseDodge;
         }
         if(param1.baseBlock != null)
         {
            this.baseBlock = param1.baseBlock;
         }
         if(param1.baseParry != null)
         {
            this.baseParry = param1.baseParry;
         }
         if(param1.baseCrit != null)
         {
            this.baseCrit = param1.baseCrit;
         }
         if(param1.baseHit != null)
         {
            this.baseHit = param1.baseHit;
         }
         if(param1.baseHaste != null)
         {
            this.baseHaste = param1.baseHaste;
         }
         if(param1.baseMiss != null)
         {
            this.baseMiss = param1.baseMiss;
         }
         if(param1.baseResist != null)
         {
            this.baseResist = param1.baseResist;
         }
         if(param1.baseCritValue != null)
         {
            this.baseCritValue = param1.baseCritValue;
         }
         if(param1.baseBlockValue != null)
         {
            this.baseBlockValue = param1.baseBlockValue;
         }
         if(param1.baseResistValue != null)
         {
            this.baseResistValue = param1.baseResistValue;
         }
         if(param1.baseEventValue != null)
         {
            this.baseEventValue = param1.baseEventValue;
         }
         if(param1.PCDPSMod != null)
         {
            this.PCDPSMod = param1.PCDPSMod;
         }
         if(param1.curveExponent != null)
         {
            this.curveExponent = param1.curveExponent;
         }
         if(param1.statsExponent != null)
         {
            this.statsExponent = param1.statsExponent;
         }
      }
      
      internal function spaceBy(param1:int, param2:int) : String
      {
         var _loc3_:* = String(param1);
         while(_loc3_.length < param2)
         {
            _loc3_ += " ";
         }
         return _loc3_;
      }
      
      internal function spaceNumBy(param1:Number, param2:int) : String
      {
         var _loc3_:* = param1.toString();
         _loc3_ = _loc3_.substr(0,param2);
         while(_loc3_.length < param2)
         {
            _loc3_ += " ";
         }
         return _loc3_;
      }
      
      internal function showRatings() : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc1_:* = this.world.myAvatar.dataLeaf;
         var _loc2_:* = "";
         var _loc3_:* = 1;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         _loc3_ = 1;
         while(_loc3_ <= 35)
         {
            if(_loc3_ == 0)
            {
               _loc3_ = 1;
            }
            _loc6_ = this.getInnateStats(_loc3_);
            _loc7_ = this.getIBudget(_loc3_,1);
            _loc8_ = -1;
            _loc9_ = -1;
            _loc10_ = -1;
            _loc11_ = -1;
            _loc12_ = _loc1_.sCat;
            _loc13_ = this.copyObj(_loc1_.sta);
            this.resetTableValues(_loc13_);
            _loc14_ = this.getBaseHPByLevel(_loc3_);
            _loc15_ = _loc14_ / 20 * 0.7;
            _loc16_ = 2.25 * _loc15_ / (100 / this.intAPtoDPS) / 2;
            _loc4_ = 0;
            while(_loc4_ < this.stats.length)
            {
               _loc2_ = this.stats[_loc4_];
               _loc11_ = _loc13_["$" + _loc2_];
               switch(_loc2_)
               {
                  case "STR":
                     _loc8_ = _loc16_;
                     _loc13_.$ap += _loc11_ * 2;
                     _loc13_.$tcr += _loc11_ / _loc8_ / 100 * 0.4;
                     break;
               }
               _loc4_++;
            }
            _loc3_ += 1;
         }
      }
      
      public function applyCoreStatRatings(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 1;
         var _loc4_:* = 100;
         var _loc5_:Object = this.world.myAvatar.getEquippedItemBySlot("Weapon");
         if(_loc5_ != null)
         {
            if(_loc5_.EnhLvl != null)
            {
               _loc3_ = int(_loc5_.EnhLvl);
            }
            if(_loc5_.EnhDPS != null)
            {
               _loc4_ = Number(_loc5_.EnhDPS);
            }
            if(_loc4_ == 0)
            {
               _loc4_ = 100;
            }
         }
         _loc4_ /= 100;
         var _loc6_:int = int(param2.intLevel);
         var _loc7_:String = "";
         var _loc8_:int = this.getInnateStats(_loc6_);
         var _loc9_:Number = -1;
         var _loc10_:Number = -1;
         var _loc11_:Number = -1;
         var _loc12_:int = -1;
         var _loc13_:String = this.world.myAvatar.objData.sClassCat;
         var _loc14_:int = this.getBaseHPByLevel(_loc6_);
         var _loc15_:int = 20;
         var _loc16_:* = _loc14_ / 20 * 0.7;
         var _loc17_:Number = 2.25 * _loc16_ / (100 / this.intAPtoDPS) / 2;
         this.resetTableValues(param1);
         var _loc18_:int = 0;
         while(_loc18_ < this.stats.length)
         {
            _loc7_ = this.stats[_loc18_];
            _loc12_ = param1["_" + _loc7_] + param1["^" + _loc7_];
            switch(_loc7_)
            {
               case "STR":
                  _loc9_ = _loc17_;
                  if(_loc13_ == "M1")
                  {
                     param1.$sbm -= _loc12_ / _loc9_ / 100 * 0.3;
                  }
                  if(_loc13_ == "S1")
                  {
                     param1.$ap += Math.round(_loc12_ * 1.4);
                  }
                  else
                  {
                     param1.$ap += _loc12_ * 2;
                  }
                  if(_loc13_ == "M1" || _loc13_ == "M2" || _loc13_ == "M3" || _loc13_ == "M4" || _loc13_ == "S1")
                  {
                     if(_loc13_ == "M4")
                     {
                        param1.$tcr += _loc12_ / _loc9_ / 100 * 0.7;
                     }
                     else
                     {
                        param1.$tcr += _loc12_ / _loc9_ / 100 * 0.4;
                     }
                  }
                  break;
               case "INT":
                  _loc9_ = _loc17_;
                  param1.$cmi -= _loc12_ / _loc9_ / 100;
                  if(_loc13_.substr(0,1) == "C" || _loc13_ == "M3")
                  {
                     param1.$cmo += _loc12_ / _loc9_ / 100;
                  }
                  if(_loc13_ == "S1")
                  {
                     param1.$sp += Math.round(_loc12_ * 1.4);
                  }
                  else
                  {
                     param1.$sp += _loc12_ * 2;
                  }
                  if(_loc13_ == "C1" || _loc13_ == "C2" || _loc13_ == "C3" || _loc13_ == "M3" || _loc13_ == "S1")
                  {
                     if(_loc13_ == "C2")
                     {
                        param1.$tha += _loc12_ / _loc9_ / 100 * 0.5;
                     }
                     else
                     {
                        param1.$tha += _loc12_ / _loc9_ / 100 * 0.3;
                     }
                  }
                  break;
               case "DEX":
                  _loc9_ = _loc17_;
                  if(_loc13_ == "M1" || _loc13_ == "M2" || _loc13_ == "M3" || _loc13_ == "M4" || _loc13_ == "S1")
                  {
                     if(_loc13_.substr(0,1) != "C")
                     {
                        param1.$thi += _loc12_ / _loc9_ / 100 * 0.2;
                     }
                     if(_loc13_ == "M2" || _loc13_ == "M4")
                     {
                        param1.$tha += _loc12_ / _loc9_ / 100 * 0.5;
                     }
                     else
                     {
                        param1.$tha += _loc12_ / _loc9_ / 100 * 0.3;
                     }
                     if(_loc13_ == "M1")
                     {
                        if(param1._tbl > 0.01)
                        {
                           param1.$tbl += _loc12_ / _loc9_ / 100 * 0.5;
                        }
                     }
                  }
                  if(_loc13_ != "M2" && _loc13_ != "M3")
                  {
                     param1.$tdo += _loc12_ / _loc9_ / 100 * 0.3;
                  }
                  else
                  {
                     param1.$tdo += _loc12_ / _loc9_ / 100 * 0.5;
                  }
                  break;
               case "WIS":
                  _loc9_ = _loc17_;
                  if(_loc13_ == "C1" || _loc13_ == "C2" || _loc13_ == "C3" || _loc13_ == "S1")
                  {
                     if(_loc13_ == "C1")
                     {
                        param1.$tcr += _loc12_ / _loc9_ / 100 * 0.7;
                     }
                     else
                     {
                        param1.$tcr += _loc12_ / _loc9_ / 100 * 0.4;
                     }
                     param1.$thi += _loc12_ / _loc9_ / 100 * 0.2;
                  }
                  param1.$tdo += _loc12_ / _loc9_ / 100 * 0.3;
                  break;
               case "LCK":
                  _loc9_ = _loc17_;
                  param1.$sem += _loc12_ / _loc9_ / 100 * 2;
                  if(_loc13_ == "S1")
                  {
                     param1.$ap += Math.round(_loc12_ * 1);
                     param1.$sp += Math.round(_loc12_ * 1);
                     param1.$tcr += _loc12_ / _loc9_ / 100 * 0.3;
                     param1.$thi += _loc12_ / _loc9_ / 100 * 0.1;
                     param1.$tha += _loc12_ / _loc9_ / 100 * 0.3;
                     param1.$tdo += _loc12_ / _loc9_ / 100 * 0.25;
                     param1.$scm += _loc12_ / _loc9_ / 100 * 2.5;
                  }
                  else
                  {
                     if(_loc13_ == "M1" || _loc13_ == "M2" || _loc13_ == "M3" || _loc13_ == "M4")
                     {
                        param1.$ap += Math.round(_loc12_ * 0.7);
                     }
                     if(_loc13_ == "C1" || _loc13_ == "C2" || _loc13_ == "C3" || _loc13_ == "M3")
                     {
                        param1.$sp += Math.round(_loc12_ * 0.7);
                     }
                     param1.$tcr += _loc12_ / _loc9_ / 100 * 0.2;
                     param1.$thi += _loc12_ / _loc9_ / 100 * 0.1;
                     param1.$tha += _loc12_ / _loc9_ / 100 * 0.1;
                     param1.$tdo += _loc12_ / _loc9_ / 100 * 0.1;
                     param1.$scm += _loc12_ / _loc9_ / 100 * 5;
                  }
                  break;
            }
            _loc18_++;
         }
         param1.wDPS = Math.round(this.getBaseHPByLevel(_loc3_) / _loc15_ * _loc4_ * this.PCDPSMod) + Math.round(param1.$ap / this.intAPtoDPS);
         param1.mDPS = Math.round(this.getBaseHPByLevel(_loc3_) / _loc15_ * _loc4_ * this.PCDPSMod) + Math.round(param1.$sp / this.intSPtoDPS);
      }
      
      public function coeffToPct(param1:Number) : String
      {
         return Number(param1 * 100).toFixed(2);
      }
      
      public function getIBudget(param1:int, param2:int) : int
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 > this.intLevelCap)
         {
            param1 = this.intLevelCap;
         }
         if(param2 < 1)
         {
            param2 = 1;
         }
         param1 = Math.round(param1 + param2 - 1);
         return int(Math.round(this.GstBase + Math.pow((param1 - 1) / (this.intLevelCap - 1),this.statsExponent) * (this.GstGoal - this.GstBase)));
      }
      
      public function getInnateStats(param1:int) : int
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 > this.intLevelCap)
         {
            param1 = this.intLevelCap;
         }
         return Math.round(this.PCstBase + Math.pow((param1 - 1) / (this.intLevelCap - 1),this.statsExponent) * (this.PCstGoal - this.PCstBase));
      }
      
      public function getBaseHPByLevel(param1:*) : *
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         if(param1 > this.intLevelCap)
         {
            param1 = this.intLevelCap;
         }
         return Math.round(this.PChpBase1 + Math.pow((param1 - 1) / (this.intLevelCap - 1),this.curveExponent) * this.PChpDelta);
      }
      
      public function catCodeToName(param1:String) : String
      {
         switch(param1)
         {
            case "M1":
               return "Fighter";
            case "M2":
               return "Thief";
            case "M3":
               return "Hybrid";
            case "M4":
               return "Armsman";
            case "C1":
               return "Wizard";
            case "C2":
               return "Healer";
            case "C3":
               return "spellbreaker";
            case "S1":
               return "Lucky";
            default:
               return null;
         }
      }
      
      public function resetTableValues(param1:Object) : void
      {
         param1._ap = 0;
         param1.$ap = 0;
         param1._sp = 0;
         param1.$sp = 0;
         param1._tbl = 0;
         param1._tpa = 0;
         param1._tdo = 0;
         param1._tcr = 0;
         param1._thi = 0;
         param1._tha = 0;
         param1._tre = 0;
         param1.$tbl = this.baseBlock;
         param1.$tpa = this.baseParry;
         param1.$tdo = this.baseDodge;
         param1.$tcr = this.baseCrit;
         param1.$thi = this.baseHit;
         param1.$tha = this.baseHaste;
         param1.$tre = this.baseResist;
         param1._cpo = 1;
         param1._cpi = 1;
         param1._cao = 1;
         param1._cai = 1;
         param1._cmo = 1;
         param1._cmi = 1;
         param1._cdo = 1;
         param1._cdi = 1;
         param1._cho = 1;
         param1._chi = 1;
         param1._cmc = 1;
         param1.$cpo = 1;
         param1.$cpi = 1;
         param1.$cao = 1;
         param1.$cai = 1;
         param1.$cmo = 1;
         param1.$cmi = 1;
         param1.$cdo = 1;
         param1.$cdi = 1;
         param1.$cho = 1;
         param1.$chi = 1;
         param1.$cmc = 1;
         param1._scm = this.baseCritValue;
         param1._sbm = this.baseBlockValue;
         param1._srm = this.baseResistValue;
         param1._sem = this.baseEventValue;
         param1.$scm = this.baseCritValue;
         param1.$sbm = this.baseBlockValue;
         param1.$srm = this.baseResistValue;
         param1.$sem = this.baseEventValue;
         param1._shb = 0;
         param1._smb = 0;
         param1.$shb = 0;
         param1.$smb = 0;
      }
      
      public function getCategoryStats(param1:String, param2:int) : Object
      {
         var _loc3_:* = this.getInnateStats(param2);
         var _loc4_:* = this.classCatMap[param1].ratios;
         var _loc5_:* = {};
         var _loc6_:* = "";
         var _loc7_:int = 0;
         while(_loc7_ < this.stats.length)
         {
            _loc6_ = this.stats[_loc7_];
            _loc5_[_loc6_] = Math.round(_loc4_[_loc7_] * _loc3_);
            _loc7_++;
         }
         return _loc5_;
      }
      
      public function applyAuraEffect(param1:*, param2:*) : *
      {
         switch(param1.typ)
         {
            case "+":
               param2["$" + param1.sta] += Number(param1.val);
               break;
            case "-":
               param2["$" + param1.sta] -= Number(param1.val);
               break;
            case "*":
               param2["$" + param1.sta] = Math.round(param2["$" + param1.sta] * Number(param1.val));
         }
      }
      
      public function removeAuraEffect(param1:*, param2:*) : *
      {
         switch(param1.typ)
         {
            case "+":
               param2["$" + param1.sta] -= Number(param1.val);
               break;
            case "-":
               param2["$" + param1.sta] += Number(param1.val);
               break;
            case "*":
               param2["$" + param1.sta] = Math.round(param2["$" + param1.sta] / Number(param1.val));
         }
      }
      
      public function getStatsA(param1:Object, param2:String) : Object
      {
         var _loc6_:Object = null;
         var _loc3_:int = param1.sType.toLowerCase() == "enhancement" ? int(param1.iLvl) : int(param1.EnhLvl);
         var _loc4_:int = param1.sType.toLowerCase() == "enhancement" ? int(param1.iRty) : int(param1.EnhRty);
         var _loc5_:int = Math.round(this.getIBudget(_loc3_,_loc4_) * this.ratiosBySlot[param2]);
         var _loc7_:* = -1;
         var _loc8_:* = ["iEND","iSTR","iINT","iDEX","iWIS","iLCK"];
         var _loc9_:* = 0;
         var _loc10_:* = "";
         var _loc11_:* = {};
         var _loc12_:* = 0;
         var _loc13_:int = 0;
         var _loc14_:Object = {};
         this.world.initPatternTree();
         if(param1.PatternID != null)
         {
            _loc6_ = this.world.enhPatternTree[param1.PatternID];
         }
         if(param1.EnhPatternID != null)
         {
            _loc6_ = this.world.enhPatternTree[param1.EnhPatternID];
         }
         if(_loc6_ != null)
         {
            _loc13_ = 0;
            while(_loc13_ < this.stats.length)
            {
               _loc10_ = "i" + this.stats[_loc13_];
               if(_loc6_[_loc10_] != null)
               {
                  _loc11_[_loc10_] = Math.round(_loc5_ * _loc6_[_loc10_] / 100);
                  _loc12_ += _loc11_[_loc10_];
               }
               _loc13_++;
            }
            _loc9_ = 0;
            while(_loc12_ < _loc5_)
            {
               _loc10_ = _loc8_[_loc9_];
               if(_loc11_[_loc10_] != null)
               {
                  ++_loc11_[_loc10_];
                  _loc12_++;
               }
               if(++_loc9_ > _loc8_.length - 1)
               {
                  _loc9_ = 0;
               }
            }
            _loc13_ = 0;
            while(_loc13_ < this.stats.length)
            {
               _loc7_ = _loc11_["i" + this.stats[_loc13_]];
               if(_loc7_ != null && _loc7_ != "0")
               {
                  _loc14_["$" + this.stats[_loc13_]] = _loc7_;
               }
               _loc13_++;
            }
         }
         return _loc14_;
      }
      
      public function getDisplayEnhName(param1:Object) : String
      {
         if(Boolean(param1) && Boolean(param1.hasOwnProperty("DIS")))
         {
            switch(param1.sName)
            {
               case "Vim":
               case "Examen":
               case "Pneuma":
               case "Anima":
                  return param1.sName;
               case "Hearty":
                  return "Grimskull";
               default:
                  return "Forge";
            }
         }
         else
         {
            if(param1)
            {
               return param1.sName;
            }
            return "";
         }
      }
      
      public function getDisplayEnhTraitName(param1:Object) : String
      {
         switch(param1.sName)
         {
            case "Vim":
            case "Examen":
               return "Ether";
            case "Pneuma":
            case "Anima":
               return "Clairvoyance";
            default:
               return param1.sName;
         }
      }
      
      public function getFullStatName(param1:String) : String
      {
         var _loc2_:String = "";
         param1 = param1.toLowerCase();
         if(param1.indexOf("str") > -1)
         {
            _loc2_ = "Strength";
         }
         if(param1.indexOf("int") > -1)
         {
            _loc2_ = "Intellect";
         }
         if(param1.indexOf("dex") > -1)
         {
            _loc2_ = "Dexterity";
         }
         if(param1.indexOf("wis") > -1)
         {
            _loc2_ = "Wisdom";
         }
         if(param1.indexOf("end") > -1)
         {
            _loc2_ = "Endurance";
         }
         if(param1.indexOf("lck") > -1)
         {
            _loc2_ = "Luck";
         }
         if(param1.indexOf("tha") > -1)
         {
            _loc2_ = "Haste";
         }
         if(param1.indexOf("thi") > -1)
         {
            _loc2_ = "Hit";
         }
         if(param1.indexOf("tcr") > -1)
         {
            _loc2_ = "Critcal Hit";
         }
         if(param1.indexOf("tcm") > -1)
         {
            _loc2_ = "Crit Value";
         }
         if(param1.indexOf("tdo") > -1)
         {
            _loc2_ = "Evasion";
         }
         return _loc2_;
      }
      
      public function getRarityString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
            case 10:
               return "Unknown";
            case 1:
               return "Enhancement +0";
            case 2:
               return "Enhancement +1";
            case 3:
               return "Enhancement +2";
            case 4:
               return "Enhancement +3";
            case 5:
               return "Enhancement +4";
            case 6:
               return "Enhancement +5";
            case 7:
               return "Enhancement +6";
            case 8:
               return "Enhancement +100";
            case 9:
               return "Enhancement +200";
            case 11:
               return "Common";
            case 12:
               return "Weird";
            case 13:
               return "Awesome";
            case 14:
               return "1% Drop";
            case 15:
               return "5% Drop";
            case 16:
               return "Boss Drop";
            case 17:
               return "Hidden Secret";
            case 18:
               return "Junk";
            case 19:
               return "Impossible";
            case 20:
               return "Artifact";
            case 21:
               return "Limited Time Drop";
            case 23:
               return "Crazy";
            case 24:
               return "Expensive";
            case 25:
               return "Placeholder";
            case 30:
               return "Rare";
            case 35:
               return "Epic";
            case 36:
               return "Champion";
            case 40:
               return "Verification Shop";
            case 50:
               return "Seasonal";
            case 55:
               return "Seasonal Rare";
            case 60:
               return "Event";
            case 65:
               return "Event Rare";
            case 67:
               return "Infinity";
            case 68:
               return "New Collection Chest";
            case 70:
               return "Limited Rare";
            case 75:
               return "Collector";
            case 80:
               return "Promo";
            case 81:
               return "Founder";
            case 88:
               return "Benevolent";
            case 90:
               return "Ultra Rare";
            case 91:
               return "Achievement Tracker";
            case 92:
               return "Upgrade Pack";
            case 93:
               return "Limited Quantity";
            case 94:
               return "Frostval Gifting";
            case 95:
               return "Super Ultra Rare";
            case 96:
               return "Kickstarter Backer";
            case 99:
               return "Custom Item";
            case 100:
               return "Legendary";
            default:
               return "Unknown";
         }
      }
      
      public function toggleItemEquip(param1:Object) : Boolean
      {
         var _loc2_:* = this.world.getUoLeafById(this.world.myAvatar.uid);
         var _loc3_:Boolean = false;
         if(_loc2_.intState != 1)
         {
            this.MsgBox.notify("Action cannot be performed during combat!");
         }
         else if(this.world.bPvP)
         {
            this.MsgBox.notify("Items may not be equipped or unequipped during a PvP match!");
         }
         else if(param1.bEquip == 1)
         {
            if(param1.sES == "Weapon" || param1.sES == "ar")
            {
               this.MsgBox.notify("Selected Item cannot be unequipped!");
            }
            else
            {
               _loc3_ = true;
               if(param1.sType.toLowerCase() != "item")
               {
                  this.world.sendUnequipItemRequest(param1);
               }
               else
               {
                  this.world.unequipUseableItem(param1);
               }
            }
         }
         else if(param1.bUpg == 1 && !this.world.myAvatar.isUpgraded())
         {
            this.showUpgradeWindow();
         }
         else if(int(param1.EnhLvl) > int(this.world.myAvatar.objData.intLevel))
         {
            this.MsgBox.notify("Level requirement not met!");
         }
         else if(param1.sType.toLowerCase() != "item" && (param1.sES != "mi" && param1.sES != "co" && param1.sES != "pe" && param1.sES != "am" && param1.EnhID <= 0))
         {
            this.MsgBox.notify("Selected item requires enhancement!");
         }
         else if(param1.sType.toLowerCase() != "item")
         {
            _loc3_ = this.world.sendEquipItemRequest(param1);
         }
         else
         {
            _loc3_ = true;
            this.world.equipUseableItem(param1);
         }
         return _loc3_;
      }
      
      public function tryEnhance(param1:Array, param2:Object, param3:Boolean = false) : void
      {
         if(param1 != null && param2 != null)
         {
            if(param2.iLvl > this.world.myAvatar.objData.intLevel)
            {
               this.MsgBox.notify("Level requirement not met!");
            }
            else if(param1.EnhID == param2.ItemID)
            {
               this.MsgBox.notify("Selected Enhancement already applied to item!");
            }
            else if(param3)
            {
               this.world.sendEnhItemRequestShop(param1,param2);
            }
            else
            {
               this.world.sendEnhItemRequestLocal(param1,param2);
            }
         }
      }
      
      public function doIHaveEnhancements() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.world.myAvatar.items)
         {
            if(_loc1_.sType.toLowerCase() == "enhancement")
            {
               return true;
            }
         }
         return false;
      }
      
      public function isItemEnhanceable(param1:Object) : Boolean
      {
         return ["Weapon","he","ba","pe","ar"].indexOf(param1.sES) >= 0;
      }
      
      public function resetInvTreeByItemID(param1:int) : *
      {
         var item:Object = null;
         var ItemID:int = param1;
         try
         {
            item = this.world.invTree[ItemID];
            if("EnhID" in item)
            {
               item.EnhID = -1;
            }
            if("EnhRty" in item)
            {
               item.EnhRty = -1;
            }
            if("EnhDPS" in item)
            {
               item.EnhDPS = -1;
            }
            if("EnhRng" in item)
            {
               item.EnhRng = -1;
            }
            if("EnhLvl" in item)
            {
               item.EnhLvl = -1;
            }
            if("EnhPatternID" in item)
            {
               item.EnhPatternID = -1;
            }
         }
         catch(e:Error)
         {
            trace("[Game] ERR resetInvTreeByItemID: " + e.message);
         }
      }
      
      public function isMergeShop(param1:Object) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1.items)
         {
            if("turnin" in _loc2_)
            {
               return true;
            }
         }
         return false;
      }
      
      public function recursiveStop(param1:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:MovieClip = null;
         var _loc2_:Array = [param1];
         while(_loc2_.length > 0)
         {
            _loc3_ = _loc2_.pop();
            _loc4_ = 0;
            while(_loc4_ < _loc3_.numChildren)
            {
               _loc5_ = _loc3_.getChildAt(_loc4_);
               if(_loc5_ is MovieClip)
               {
                  _loc6_ = MovieClip(_loc5_);
                  if(_loc6_.totalFrames > 1)
                  {
                     _loc6_.gotoAndStop(_loc6_.totalFrames);
                  }
                  else
                  {
                     _loc6_.stop();
                  }
                  _loc2_.push(_loc6_);
               }
               _loc4_++;
            }
         }
      }
      
      public function recursiveStopSafe(param1:MovieClip) : void
      {
         var current:MovieClip = null;
         var i:int = 0;
         var child:DisplayObject = null;
         var mc:MovieClip = param1;
         var stack:Array = [mc];
         while(stack.length > 0)
         {
            current = stack.pop();
            try
            {
               current.stop();
            }
            catch(e:Error)
            {
            }
            i = current.numChildren - 1;
            for(; i >= 0; i--)
            {
               child = null;
               try
               {
                  child = current.getChildAt(i);
               }
               catch(e2:Error)
               {
                  continue;
               }
               if(child is MovieClip)
               {
                  stack.push(MovieClip(child));
               }
            }
         }
      }
      
      public function getTravelMapData() : void
      {
         if(this.ui.getChildByName("travelLoaderMC"))
         {
            return;
         }
         this.travelLoaderMC = new (this.world.getClass("mcLoader") as Class)();
         this.travelLoaderMC.x = 400;
         this.travelLoaderMC.y = 211;
         this.travelLoaderMC.name = "travelLoaderMC";
         this.ui.addChild(this.travelLoaderMC);
         var _loc1_:String = "api/data/travelmap?v=" + this.world.objInfo["sVersion"];
         var _loc2_:URLLoader = new URLLoader();
         if(this.loaderInfo.url.toLowerCase().indexOf("file://") >= 0 || this.loaderInfo.url.toLowerCase().indexOf("cdn.aq.com") >= 0 || this.loaderInfo.url.toLowerCase().indexOf("aqworldscdn.aq.com") >= 0)
         {
            _loc1_ = "https://game.aq.com/game/" + _loc1_;
         }
         else
         {
            _loc1_ = this.params.sURL + _loc1_;
         }
         var _loc3_:URLRequest = new URLRequest(_loc1_);
         _loc3_.method = URLRequestMethod.GET;
         _loc2_.addEventListener(Event.COMPLETE,this.onTravelMapComplete,false,0,true);
         _loc2_.addEventListener(ProgressEvent.PROGRESS,this.onTravelMapProgress,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onTravelError,false,0,true);
         _loc2_.load(_loc3_);
      }
      
      private function onTravelMapComplete(param1:Event) : void
      {
         var _loc2_:String = String(param1.target.data);
         var _loc3_:Object = JSON.parse(_loc2_);
         this.travelMapData = _loc3_;
         this.WorldMapData = new worldMap(this.travelMapData);
         this.TRAVEL_DATA_READY = true;
         this.ui.mcPopup.mcMap.removeChildAt(0);
         var _loc4_:Loader = new Loader();
         _loc4_.load(new URLRequest(vurl(serverFilePath + this.world.objInfo.sMap)),new LoaderContext(false,ApplicationDomain.currentDomain));
         this.ui.mcPopup.mcMap.addChild(_loc4_);
      }
      
      private function onTravelMapProgress(param1:ProgressEvent) : void
      {
         this.bLoaded = param1.bytesLoaded;
         this.bTotal = param1.bytesTotal;
         var _loc2_:int = this.bLoaded / this.bTotal * 100;
         var _loc3_:Number = this.bLoaded / this.bTotal;
         this.travelLoaderMC.mcPct.text = _loc2_ + "%";
         if(this.bLoaded >= this.bTotal)
         {
            this.travelLoaderMC.parent.removeChild(this.travelLoaderMC);
            this.travelLoaderMC = null;
         }
      }
      
      private function onTravelError(param1:IOErrorEvent) : void
      {
         trace("[Load] ERR travel map load failed: " + param1.text);
         if(this.travelLoaderMC)
         {
            this.travelLoaderMC.parent.removeChild(this.travelLoaderMC);
            this.travelLoaderMC = null;
         }
      }
      
      public function checkPasswordStrength(param1:String) : int
      {
         var _loc2_:Number = 0;
         var _loc3_:Array = param1.split("");
         var _loc4_:Array = [];
         var _loc5_:uint = 0;
         var _loc6_:String = _loc3_[0];
         var _loc7_:Boolean = false;
         var _loc8_:String = param1.toLowerCase();
         var _loc9_:uint = 0;
         while(_loc9_ < this.weakPass.length)
         {
            if(_loc8_ == this.weakPass[_loc9_])
            {
               return -1;
            }
            _loc9_++;
         }
         var _loc10_:uint = 0;
         while(_loc10_ < _loc3_.length)
         {
            if(!_loc7_ && _loc6_ != _loc3_[_loc10_])
            {
               _loc7_ = true;
            }
            if(_loc10_ == 0)
            {
               _loc2_ += 4;
               _loc4_.push(_loc3_[_loc10_]);
            }
            else if(_loc10_ < 8)
            {
               if(!this.isRepeat(_loc4_,_loc3_[_loc10_]))
               {
                  _loc4_.push(_loc3_[_loc10_]);
                  _loc2_ += 2;
               }
               else
               {
                  _loc2_ += 2;
               }
            }
            else if(_loc10_ < 21)
            {
               if(!this.isRepeat(_loc4_,_loc3_[_loc10_]))
               {
                  _loc4_.push(_loc3_[_loc10_]);
                  _loc2_ += 1.5;
               }
               else
               {
                  _loc2_ += 1.5;
               }
            }
            else if(!this.isRepeat(_loc4_,_loc3_[_loc10_]))
            {
               _loc4_.push(_loc3_[_loc10_]);
               _loc2_ += 1;
            }
            else
            {
               _loc2_ += 1;
            }
            if(_loc5_ < 6 && !this.isAlphaChar(_loc3_[_loc10_]))
            {
               _loc2_++;
               _loc5_++;
            }
            _loc10_++;
         }
         return _loc7_ ? int(_loc2_) : -1;
      }
      
      private function isAlphaChar(param1:String) : Boolean
      {
         var _loc2_:uint = uint(param1.charCodeAt(0));
         return _loc2_ >= 65 && _loc2_ < 123 || _loc2_ >= 48 && _loc2_ < 58 ? true : false;
      }
      
      private function isRepeat(param1:Array, param2:String) : Boolean
      {
         var _loc3_:uint = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function loadGameMenu() : void
      {
         if(this.gameMenuLoader != null || this.mcGameMenu != null)
         {
            return;
         }
         if(this.world == null || this.world.objInfo == null || this.world.objInfo.gMenu == null)
         {
            return;
         }
         this.gameMenuURL = vurl(serverFilePath + this.world.objInfo.gMenu);
         this.gameMenuRetried = false;
         this.startGameMenuLoad(this.gameMenuURL);
      }
      
      private function startGameMenuLoad(param1:String) : void
      {
         var sURL:String = param1;
         trace("[UI] loadGameMenu: " + sURL);
         this.gameMenuLoader = new Loader();
         this.gameMenuLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.gameMenuCallBack,false,0,true);
         this.gameMenuLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.gameMenuErrorHandler,false,0,true);
         this.gameMenuLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.gameMenuErrorHandler,false,0,true);
         try
         {
            this.gameMenuLoader.load(new URLRequest(sURL),this.assetsContext);
         }
         catch(e:Error)
         {
            trace("[UI] ERR loadGameMenu: " + e.message);
            gameMenuLoader = null;
         }
      }
      
      private function buildGameMenuInstance() : void
      {
         try
         {
            if(this.mcGameMenu != null && this.mcGameMenu.parent != null)
            {
               this.mcGameMenu.parent.removeChild(this.mcGameMenu);
            }
         }
         catch(eR:Error)
         {
         }
         this.mcGameMenu = null;
         if(this.ui == null || this.world == null)
         {
            return;
         }
         if(!this.assetsDomain.hasDefinition("GameMenu"))
         {
            trace("[Load] ERR missing linkage GameMenu");
            return;
         }
         try
         {
            if(this.world.objInfo != null)
            {
               delete this.world.objInfo["gameNewsJSON"];
               delete this.world.objInfo["gameNewsVersion"];
            }
         }
         catch(eN:Error)
         {
         }
         var _loc1_:* = this.assetsDomain.getDefinition("GameMenu") as Class;
         this.mcGameMenu = MovieClip(new _loc1_());
         this.mcGameMenu.name = "gameMenu";
         this.mcGameMenu.visible = this.world.strMapName != "reenstest";
         this.mcGameMenu.x = 750;
         this.ui.addChild(this.mcGameMenu);
      }
      
      private function gameMenuReady() : Boolean
      {
         if(this.mcGameMenu == null)
         {
            return false;
         }
         if(!("menuBG" in this.mcGameMenu))
         {
            return true;
         }
         return this.mcGameMenu.menuBG != null && this.mcGameMenu.menuBG.getChildByName("mc") != null;
      }
      
      public function resetGameMenu() : void
      {
         if(this.gameMenuLoader != null)
         {
            try
            {
               this.gameMenuLoader.close();
            }
            catch(eC:Error)
            {
            }
            this.gameMenuLoader = null;
         }
         this.gameMenuURL = null;
         try
         {
            if(this.mcGameMenu != null && this.mcGameMenu.parent != null)
            {
               this.mcGameMenu.parent.removeChild(this.mcGameMenu);
            }
         }
         catch(eR:Error)
         {
         }
         this.mcGameMenu = null;
      }
      
      public function MenuShow() : void
      {
         try
         {
            if(this.mcGameMenu == null)
            {
               this.loadGameMenu();
               return;
            }
            if(this.mcGameMenu.currentLabel == "Open")
            {
               if(this.mcGameMenu.visible && Boolean(this.gameMenuReady()))
               {
                  this.mcGameMenu.gotoAndPlay("Close");
               }
               else
               {
                  this.buildGameMenuInstance();
               }
            }
            else
            {
               this.mcGameMenu.gotoAndStop("Open");
            }
         }
         catch(e:Error)
         {
            trace("[UI] ERR MenuShow: " + e.message);
         }
      }
      
      private function gameMenuCallBack(param1:Event) : void
      {
         this.gameMenuLoader = null;
         this.buildGameMenuInstance();
      }
      
      private function gameMenuErrorHandler(param1:ErrorEvent) : void
      {
         trace("[UI] ERR gameMenu load failed: " + param1.text);
         this.gameMenuLoader = null;
         if(!this.gameMenuRetried && this.gameMenuURL != null)
         {
            this.gameMenuRetried = true;
            this.startGameMenuLoad(this.gameMenuURL + (this.gameMenuURL.indexOf("?") < 0 ? "?r=" : "&r=") + getTimer());
         }
      }
      
      public function menuClose() : void
      {
         try
         {
            if(this.firstMenu)
            {
               this.firstMenu = false;
            }
            else
            {
               if(this.mcGameMenu == null || !this.gameMenuReady())
               {
                  return;
               }
               if(this.mcGameMenu.currentLabel != "Close")
               {
                  this.mcGameMenu.gotoAndPlay("Close");
               }
            }
         }
         catch(e:Error)
         {
            trace("[UI] ERR menuClose: " + e.message);
         }
      }
      
      public function openMenu() : void
      {
         try
         {
            if(this.mcGameMenu == null)
            {
               this.loadGameMenu();
               return;
            }
            if(this.mcGameMenu.currentLabel == "Open")
            {
               if(!this.mcGameMenu.visible || !this.gameMenuReady())
               {
                  this.buildGameMenuInstance();
               }
            }
            else
            {
               this.mcGameMenu.gotoAndStop("Open");
            }
         }
         catch(e:Error)
         {
            trace("[UI] ERR openMenu: " + e.message);
         }
      }
      
      public function getFilePath() : String
      {
         return serverFilePath;
      }
      
      public function getGamePath() : String
      {
         return serverGamePath;
      }
      
      public function initWorld() : void
      {
         if(this.world != null)
         {
            this.world.killTimers();
            this.world.killListeners();
            this.world.clearLoaders(true);
            this.world.clearMonstersAndProps();
            this.world.destroyAllAvatars();
            this.removeChild(this.world);
            this.world = null;
         }
         this.world = new World(MovieClip(this));
         if(this.ui != null && this.ui.parent == this)
         {
            this.addChildAt(this.world,getChildIndex(this.ui));
         }
         else
         {
            this.addChild(this.world);
         }
      }
      
      public function grayAll(param1:DisplayObjectContainer) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1 is MovieClip && param1 != this)
         {
            (param1 as MovieClip).stop();
         }
         if(param1.numChildren)
         {
            _loc4_ = param1.numChildren;
            while(_loc3_ < _loc4_)
            {
               if(param1.getChildAt(_loc3_) is DisplayObjectContainer)
               {
                  _loc2_ = param1.getChildAt(_loc3_) as DisplayObjectContainer;
                  if(_loc2_.numChildren)
                  {
                     makeGrayscale(_loc2_);
                  }
                  else if(_loc2_ is MovieClip)
                  {
                     makeGrayscale(_loc2_ as MovieClip);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      public function testJSCallback() : void
      {
         trace("[Game] testJSCallback: callback received from webpage");
      }
      
      public function onAddedToStage(param1:Event) : void
      {
         Game.root = this;
         this.registerErrorSuppression();
         this.stage.showDefaultContextMenu = false;
         stage.stageFocusRect = false;
         this.mcConnDetail = new ConnDetailMC(this);
         serverFilePath = this.loaderInfo.url.substring(0,this.loaderInfo.url.lastIndexOf("/") + 1);
         serverGamePath = serverFilePath.slice(0,serverFilePath.lastIndexOf("/gamefiles")) + "/";
         this.sFilePath = serverFilePath;
         trace("[Game] serverFilePath: " + serverFilePath);
         gotoAndPlay(this.charCount() > 0 && Boolean(this.litePreference.data.bCharSelect) ? "Select" : "Login");
         if(this.userPreference.data.quality != "AUTO")
         {
            stage.quality = this.userPreference.data.quality;
         }
      }
      
      public function init() : void
      {
         var _loc1_:* = undefined;
         ISWEB = this.params.isWeb;
         this.extCall = new ExternalCalls(true,this.params.strSourceID,this as MovieClip);
         for(_loc1_ in this.params)
         {
         }
         if(this.MsgBox)
         {
            this.MsgBox.visible = false;
         }
         this.IsEU = this.params.isEU;
         this.readQueryString();
         if(Boolean(this.mcLogin) && Boolean(this.mcLogin.fbConnect))
         {
            this.mcLogin.fbConnect.visible = this.showFB;
         }
         this.extCall.setGameObject(this.swfObj);
         if(this.params.sURL == null)
         {
            this.params.sURL = "https://www.aq.com/game/";
         }
         this.serverPath = this.params.sURL;
         FacebookConnect.RegisterGame(this);
         if(this.params.doSignup)
         {
            this.params.doSignup = false;
            gotoAndPlay("Account");
         }
      }
      
      public function FBMessage(param1:*, param2:*) : *
      {
         trace("[Game] FBMessage: " + param1 + " retVal: " + param2);
         FacebookConnect.handleFBMessage(param1,param2);
      }
      
      public function SendMessage(param1:*, param2:*) : *
      {
      }
      
      public function FB_showFeedDialog(param1:String, param2:String, param3:String) : void
      {
         if(ISWEB)
         {
            this.extCall.showFeedDialog(param1,param2,param3);
         }
      }
      
      public function toggleFullScreen() : void
      {
         var screenRectangle:Rectangle = null;
         if(stage["displayState"] == StageDisplayState.NORMAL)
         {
            screenRectangle = new Rectangle(0,0,960,550);
            try
            {
               stage["fullScreenSourceRect"] = screenRectangle;
               stage["displayState"] = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            catch(error:Error)
            {
               try
               {
                  stage["displayState"] = StageDisplayState.FULL_SCREEN;
               }
               catch(errFS:Error)
               {
               }
            }
         }
         else
         {
            stage["displayState"] = StageDisplayState.NORMAL;
         }
      }
      
      public function showBallyhooAd(param1:String) : void
      {
         stage["displayState"] = StageDisplayState.NORMAL;
         this.extCall.showIt(param1);
      }
      
      public function callJSFunction(param1:String) : void
      {
         this.extCall.callJSFunction(param1);
      }
      
      private function readQueryString() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         try
         {
            _loc1_ = "";
            if(ISWEB)
            {
               _loc1_ = this.extCall.getQueryString();
            }
            if(_loc1_)
            {
               _loc2_ = _loc1_.split("&");
               _loc3_ = 0;
               _loc4_ = -1;
               while(_loc3_ < _loc2_.length)
               {
                  _loc5_ = _loc2_[_loc3_];
                  _loc4_ = _loc5_.indexOf("=");
                  if(_loc4_ > 0)
                  {
                     _loc6_ = _loc5_.substring(0,_loc4_);
                     _loc7_ = _loc5_.substring(_loc4_ + 1);
                     this.querystring[_loc6_] = _loc7_;
                  }
                  _loc3_++;
               }
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function initLogin() : void
      {
         var curTS:Number = NaN;
         var iDiff:Number = NaN;
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.key_StageLogin);
         this.mcLogin.ni.tabIndex = 1;
         this.mcLogin.pi.tabIndex = 2;
         this.mcLogin.ni.removeEventListener(FocusEvent.FOCUS_IN,this.onUserFocus);
         this.mcLogin.ni.removeEventListener(KeyboardEvent.KEY_DOWN,this.key_TextLogin);
         this.mcLogin.pi.removeEventListener(KeyboardEvent.KEY_DOWN,this.key_TextLogin);
         this.mcLogin.btnLogin.removeEventListener(MouseEvent.CLICK,this.onLoginClick);
         this.mcLogin.btnFBLogin.removeEventListener(MouseEvent.CLICK,this.onFBLoginClick);
         this.mcLogin.mcForgotPassword.removeEventListener(MouseEvent.CLICK,this.onForgotPassword);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.key_StageLogin);
         this.mcLogin.ni.addEventListener(FocusEvent.FOCUS_IN,this.onUserFocus);
         this.mcLogin.ni.addEventListener(KeyboardEvent.KEY_DOWN,this.key_TextLogin);
         this.mcLogin.pi.addEventListener(KeyboardEvent.KEY_DOWN,this.key_TextLogin);
         this.mcLogin.btnLogin.addEventListener(MouseEvent.CLICK,this.onLoginClick);
         this.mcLogin.btnFBLogin.addEventListener(MouseEvent.CLICK,this.onFBLoginClick);
         this.mcLogin.mcForgotPassword.addEventListener(MouseEvent.CLICK,this.onForgotPassword);
         this.mcLogin.mcManageAccount.addEventListener(MouseEvent.CLICK,this.onManageClick);
         this.loadUserPreference();
         this.mcLogin.warning.s = String("Sorry! You have been disconnected. \n You will be able to login after $s seconds.");
         this.mcLogin.warning.visible = false;
         this.mcLogin.warning.alpha = 0;
         if(this.params.sURL != null)
         {
            this.mcLogin.mcLogo.txtTitle.htmlText = "<font color=\"#FFB231\">New Release:</font> " + this.params.sTitle;
         }
         if("logoutWarningTS" in this.userPreference.data)
         {
            curTS = Number(new Date().getTime());
            iDiff = this.userPreference.data.logoutWarningTS + this.userPreference.data.logoutWarningDur * 1000 - curTS;
            if(iDiff > 60000)
            {
               this.userPreference.data.logoutWarningDur = 60;
               this.userPreference.data.logoutWarningTS = curTS;
               try
               {
                  this.userPreference.flush();
               }
               catch(e:Error)
               {
                  trace("[Game] ERR userPreference flush: " + e.message);
               }
            }
            if(iDiff > 1000)
            {
               this.initLoginWarning();
            }
         }
      }
      
      public function onBtnDn(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         _loc2_ = !!this.params.test ? "https://www.aq.com/gamedesignnotes/AQW-Spider-OMGClient-PatchNotess-8456" : "https://www.aq.com/gamedesignnotes/AQW-Spider-AQWClient2-PatchNotes-8484";
         navigateToURL(new URLRequest(_loc2_),"_blank");
      }
      
      public function loadTitle() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         _loc1_ = "Generic2.swf";
         _loc2_ = "The Skyguard";
         _loc3_ = "https://www.aq.com/game/";
         if(this.params.sURL != null)
         {
            _loc3_ = this.params.sURL;
            _loc1_ = this.params.sBG;
            _loc2_ = this.params.sTitle;
         }
         else
         {
            this.params.sURL = _loc3_;
         }
         trace("[Load] LoadBG: sURL: " + _loc3_ + " sBG: " + _loc1_);
         BGLoader.LoadBG(_loc3_,this.mcLogin,_loc1_,_loc2_);
         this.mcLogin.testClientAssets.visible = false;
         this.mcLogin.testClientAssets.cVersion.text = "Version " + this.cVersion;
         this.mcLogin.testClientAssets.dnBtn.addEventListener(MouseEvent.CLICK,this.onBtnDn,false,0,true);
         this.mcLogin.testClientAssets.banner.visible = this.params.test as Boolean;
      }
      
      private function initLoginWarning() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         _loc1_ = this.mcLogin.warning as MovieClip;
         _loc1_.visible = true;
         _loc1_.alpha = 100;
         this.mcLogin.btnLogin.visible = false;
         this.mcLogin.mcOr.visible = false;
         this.mcLogin.btnFBLogin.visible = false;
         this.mcLogin.mcForgotPassword.visible = false;
         this.mcLogin.mcPassword.visible = false;
         _loc2_ = Number(new Date().getTime());
         _loc3_ = Number(this.userPreference.data.logoutWarningTS);
         _loc4_ = Number(this.userPreference.data.logoutWarningDur);
         _loc1_.n = Math.round((_loc3_ + _loc4_ * 1000 - _loc2_) / 1000);
         _loc1_.ti.text = _loc1_.s.split("$s")[0] + _loc1_.n + _loc1_.s.split("$s")[1];
         _loc1_.timer = new Timer(1000);
         _loc1_.timer.addEventListener(TimerEvent.TIMER,this.loginWarningTimer,false,0,true);
         _loc1_.timer.start();
      }
      
      private function loginWarningTimer(param1:TimerEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = this.mcLogin.warning as MovieClip;
         if(_loc2_.n-- < 1)
         {
            _loc2_.visible = false;
            _loc2_.alpha = 0;
            this.mcLogin.mcPassword.visible = true;
            this.mcLogin.btnLogin.visible = true;
            this.mcLogin.mcOr.visible = true;
            this.mcLogin.btnFBLogin.visible = true;
            this.mcLogin.mcForgotPassword.visible = true;
            _loc2_.timer.removeEventListener(TimerEvent.TIMER,this.loginWarningTimer);
         }
         else
         {
            _loc2_.ti.text = _loc2_.s.split("$s")[0] + _loc2_.n + _loc2_.s.split("$s")[1];
            _loc2_.timer.reset();
            _loc2_.timer.start();
         }
      }
      
      private function onStageLeave(param1:Event) : void
      {
         stage.focus = null;
      }
      
      private function initInterface() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         this.updateCoreValues(this.coreValues);
         if(this.ctr_watermark != null)
         {
            this.ctr_watermark.visible = false;
            this.ctr_watermark.mouseEnabled = this.ctr_watermark.mouseChildren = false;
         }
         if(this.ui == null)
         {
            trace("[UI] ERR initInterface: ui is null");
            return;
         }
         if(this.world != null && this.world.parent == this && this.ui.parent == this && getChildIndex(this.world) > getChildIndex(this.ui))
         {
            setChildIndex(this.world,getChildIndex(this.ui));
         }
         if(this.ui.mcFPS != null)
         {
            this.ui.mcFPS.visible = false;
         }
         if(this.ui.mcRes != null)
         {
            this.ui.mcRes.visible = false;
         }
         if(this.ui.mcPopup != null)
         {
            this.ui.mcPopup.visible = false;
         }
         if(this.ui.mcPortrait != null)
         {
            this.ui.mcPortrait.visible = false;
            if(this.ui.mcPortrait.iconBoostXP != null)
            {
               this.ui.mcPortrait.iconBoostXP.visible = false;
            }
            if(this.ui.mcPortrait.iconBoostG != null)
            {
               this.ui.mcPortrait.iconBoostG.visible = false;
            }
            if(this.ui.mcPortrait.iconBoostRep != null)
            {
               this.ui.mcPortrait.iconBoostRep.visible = false;
            }
            if(this.ui.mcPortrait.iconBoostCP != null)
            {
               this.ui.mcPortrait.iconBoostCP.visible = false;
            }
         }
         this.hidePortraitTarget();
         this.ui.visible = false;
         if(this.ui.mcInterface != null)
         {
            if(this.ui.mcInterface.mcXPBar != null && this.ui.mcInterface.mcXPBar.mcXP != null)
            {
               this.ui.mcInterface.mcXPBar.mcXP.scaleX = 0;
            }
            if(this.ui.mcInterface.mcRepBar != null && this.ui.mcInterface.mcRepBar.mcRep != null)
            {
               this.ui.mcInterface.mcRepBar.mcRep.scaleX = 0;
            }
         }
         if(this.ui.mcUpdates != null)
         {
            if(this.ui.mcUpdates.uproto != null)
            {
               this.ui.mcUpdates.uproto.visible = false;
               this.ui.mcUpdates.uproto.y = -400;
            }
            this.ui.mcUpdates.mouseChildren = this.ui.mcUpdates.mouseEnabled = false;
         }
         this.hideMCPVPQueue();
         if(stage != null)
         {
            stage.removeEventListener(Event.MOUSE_LEAVE,this.onStageLeave);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.key_actBar);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.key_StageGame);
         }
         if(this.ui.mcInterface != null)
         {
            if(this.ui.mcInterface.mcXPBar != null)
            {
               this.ui.mcInterface.mcXPBar.removeEventListener(MouseEvent.MOUSE_OVER,this.xpBarMouseOver);
               this.ui.mcInterface.mcXPBar.removeEventListener(MouseEvent.MOUSE_OUT,this.xpBarMouseOut);
            }
            if(this.ui.mcInterface.mcRepBar != null)
            {
               this.ui.mcInterface.mcRepBar.removeEventListener(MouseEvent.MOUSE_OVER,this.onRepBarMouseOver);
               this.ui.mcInterface.mcRepBar.removeEventListener(MouseEvent.MOUSE_OUT,this.onRepBarMouseOut);
            }
         }
         if(this.ui.mcPortraitTarget != null)
         {
            this.ui.mcPortraitTarget.removeEventListener(MouseEvent.CLICK,this.portraitClick);
         }
         if(this.ui.mcPortrait != null)
         {
            this.ui.mcPortrait.removeEventListener(MouseEvent.CLICK,this.portraitClick);
            if(this.ui.mcPortrait.iconBoostXP != null)
            {
               this.ui.mcPortrait.iconBoostXP.removeEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostXPOver);
               this.ui.mcPortrait.iconBoostXP.removeEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut);
            }
            if(this.ui.mcPortrait.iconBoostG != null)
            {
               this.ui.mcPortrait.iconBoostG.removeEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostGoldOver);
               this.ui.mcPortrait.iconBoostG.removeEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut);
            }
            if(this.ui.mcPortrait.iconBoostRep != null)
            {
               this.ui.mcPortrait.iconBoostRep.removeEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostRepOver);
               this.ui.mcPortrait.iconBoostRep.removeEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut);
            }
            if(this.ui.mcPortrait.iconBoostCP != null)
            {
               this.ui.mcPortrait.iconBoostCP.removeEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostCPOver);
               this.ui.mcPortrait.iconBoostCP.removeEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut);
            }
         }
         if(this.ui.btnTargetPortraitClose != null)
         {
            this.ui.btnTargetPortraitClose.removeEventListener(MouseEvent.CLICK,this.onTargetPortraitCloseClick);
         }
         if(this.ui.btnMonster != null)
         {
            this.ui.btnMonster.removeEventListener(MouseEvent.CLICK,this.onBtnMonsterClick);
         }
         if(this.ui.mcPVPQueue != null)
         {
            this.ui.mcPVPQueue.removeEventListener(MouseEvent.CLICK,this.onMCPVPQueueClick);
         }
         if(this.ui.mcInterface != null && this.ui.mcInterface.tl != null)
         {
            this.ui.mcInterface.tl.mouseEnabled = false;
         }
         if(this.chatF != null)
         {
            this.chatF.init();
         }
         if(stage != null)
         {
            stage.addEventListener(Event.MOUSE_LEAVE,this.onStageLeave,false,0,true);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.key_actBar,false,0,true);
         }
         if(this.ui.mcInterface != null)
         {
            if(this.ui.mcInterface.mcXPBar != null)
            {
               if(this.ui.mcInterface.mcXPBar.strXP != null)
               {
                  this.ui.mcInterface.mcXPBar.strXP.visible = false;
               }
               this.ui.mcInterface.mcXPBar.addEventListener(MouseEvent.MOUSE_OVER,this.xpBarMouseOver,false,0,true);
               this.ui.mcInterface.mcXPBar.addEventListener(MouseEvent.MOUSE_OUT,this.xpBarMouseOut,false,0,true);
            }
            if(this.ui.mcInterface.mcRepBar != null)
            {
               if(this.ui.mcInterface.mcRepBar.strRep != null)
               {
                  this.ui.mcInterface.mcRepBar.strRep.visible = false;
               }
               this.ui.mcInterface.mcRepBar.addEventListener(MouseEvent.MOUSE_OVER,this.onRepBarMouseOver,false,0,true);
               this.ui.mcInterface.mcRepBar.addEventListener(MouseEvent.MOUSE_OUT,this.onRepBarMouseOut,false,0,true);
            }
         }
         if(this.ui.mcPortraitTarget != null)
         {
            this.ui.mcPortraitTarget.addEventListener(MouseEvent.CLICK,this.portraitClick,false,0,true);
         }
         if(this.ui.mcPortrait != null)
         {
            this.ui.mcPortrait.addEventListener(MouseEvent.CLICK,this.portraitClick,false,0,true);
            if(this.ui.mcPortrait.iconBoostXP != null)
            {
               this.ui.mcPortrait.iconBoostXP.addEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostXPOver,false,0,true);
               this.ui.mcPortrait.iconBoostXP.addEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut,false,0,true);
            }
            if(this.ui.mcPortrait.iconBoostG != null)
            {
               this.ui.mcPortrait.iconBoostG.addEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostGoldOver,false,0,true);
               this.ui.mcPortrait.iconBoostG.addEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut,false,0,true);
            }
            if(this.ui.mcPortrait.iconBoostRep != null)
            {
               this.ui.mcPortrait.iconBoostRep.addEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostRepOver,false,0,true);
               this.ui.mcPortrait.iconBoostRep.addEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut,false,0,true);
            }
            if(this.ui.mcPortrait.iconBoostCP != null)
            {
               this.ui.mcPortrait.iconBoostCP.addEventListener(MouseEvent.MOUSE_OVER,this.oniconBoostCPOver,false,0,true);
               this.ui.mcPortrait.iconBoostCP.addEventListener(MouseEvent.MOUSE_OUT,this.oniconBoostOut,false,0,true);
            }
         }
         if(this.ui.btnTargetPortraitClose != null)
         {
            this.ui.btnTargetPortraitClose.addEventListener(MouseEvent.CLICK,this.onTargetPortraitCloseClick,false,0,true);
         }
         if(this.ui.btnMonster != null)
         {
            this.ui.btnMonster.addEventListener(MouseEvent.CLICK,this.onBtnMonsterClick,false,0,true);
         }
         if(this.ui.mcPVPQueue != null)
         {
            this.ui.mcPVPQueue.addEventListener(MouseEvent.CLICK,this.onMCPVPQueueClick,false,0,true);
         }
         if(this.ui.iconQuest != null)
         {
            this.ui.iconQuest.visible = false;
            this.ui.iconQuest.buttonMode = true;
            this.ui.iconQuest.addEventListener(MouseEvent.CLICK,this.oniconQuestClick,false,0,true);
         }
         if(this.ui.mcInterface != null)
         {
            if(this.ui.mcInterface.tl != null)
            {
               this.ui.mcInterface.tl.mouseEnabled = false;
            }
            if(this.ui.mcInterface.areaList != null)
            {
               this.ui.mcInterface.areaList.mouseEnabled = false;
               if(this.ui.mcInterface.areaList.title != null)
               {
                  this.ui.mcInterface.areaList.title.mouseEnabled = false;
                  if(this.ui.mcInterface.areaList.title.bMinMax != null)
                  {
                     this.ui.mcInterface.areaList.title.bMinMax.addEventListener(MouseEvent.CLICK,this.areaListClick,false,0,true);
                  }
               }
            }
         }
         if(this.litePreference.data.bCustomDrops)
         {
            if(this.cDropsUI)
            {
               this.cDropsUI.cleanup();
            }
            this.cDropsUI = new customDrops(this);
         }
         if(this.litePreference.data.bDebugger)
         {
            if(this.cMenuUI)
            {
               this.cMenuUI.cleanup();
            }
            this.cMenuUI = new cellMenu(this);
            if(this.pLoggerUI)
            {
               this.pLoggerUI.cleanup();
            }
            if(this.litePreference.data.dOptions["debugPacket"])
            {
               this.pLoggerUI = new packetlogger(this);
            }
         }
         if(Boolean(this.litePreference.data.bAuras) && !this.ui.mcInterface.getChildByName("playerAuras"))
         {
            this.pAurasUI = new playerAuras(this);
            this.ui.mcPortrait.addChild(this.pAurasUI);
            this.tAurasUI = new targetAuras(this);
            this.ui.mcPortraitTarget.addChild(this.tAurasUI);
         }
         if(this.intChatMode)
         {
            this.ui.mcInterface.bMinMax.visible = false;
            this.ui.mcInterface.bShortTall.visible = false;
            this.ui.mcInterface.bCannedChat.visible = false;
            this.ui.mcInterface.tt.visible = false;
            this.ui.mcInterface.tebg.visible = false;
            this.ui.mcInterface.bsend.visible = false;
            this.ui.nc.visible = true;
            this.ui.mcInterface.ncModeChat.visible = true;
            this.ui.mcInterface.ncCannedChat.visible = true;
            this.ui.mcInterface.ncHistory.visible = true;
            this.ui.mcInterface.ncTxtBG.visible = true;
            this.ui.mcInterface.ncPrefix.visible = true;
            this.ui.mcInterface.ncText.visible = true;
            this.ui.mcInterface.ncSendText.visible = true;
         }
         else
         {
            this.ui.mcInterface.bMinMax.visible = true;
            this.ui.mcInterface.bShortTall.visible = true;
            this.ui.mcInterface.bCannedChat.visible = true;
            this.ui.mcInterface.tt.visible = true;
            this.ui.mcInterface.tebg.visible = true;
            this.ui.mcInterface.bsend.visible = true;
            this.ui.nc.visible = false;
            this.ui.mcInterface.ncModeChat.visible = false;
            this.ui.mcInterface.ncCannedChat.visible = false;
            this.ui.mcInterface.ncHistory.visible = false;
            this.ui.mcInterface.ncTxtBG.visible = false;
            this.ui.mcInterface.ncPrefix.visible = false;
            this.ui.mcInterface.ncText.visible = false;
            this.ui.mcInterface.ncSendText.visible = false;
         }
         this.keyDict = this.getKeyboardDict();
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = this.ui.mcInterface.getChildByName("keyA" + _loc1_);
            if(_loc1_ == 0)
            {
               _loc2_.text = !this.litePreference.data.keys["Auto Attack"] ? " " : this.keyDict[this.litePreference.data.keys["Auto Attack"]];
            }
            else
            {
               _loc2_.text = !this.litePreference.data.keys["Skill " + _loc1_] ? " " : this.keyDict[this.litePreference.data.keys["Skill " + _loc1_]];
            }
            _loc2_.mouseEnabled = false;
            _loc1_++;
         }
         if(this.world != null && this.world.myAvatar != null && this.world.myAvatar.objData != null)
         {
            this.updateXPBar();
            this.updateRepBar();
            this.setGoldDisplay(this.world.myAvatar.objData.intGold);
         }
      }
      
      public function traceHack(param1:String) : void
      {
         this.chatF.pushMsg("server",param1,"SERVER","",0);
      }
      
      private function onUserFocus(param1:FocusEvent) : *
      {
         if(this.mcLogin.ni.text == "click here")
         {
            this.mcLogin.ni.text = "";
         }
      }
      
      private function loadUserPreference() : *
      {
         if(this.userPreference.data.bitCheckedUsername)
         {
            this.mcLogin.ni.text = this.TempLoginName != "" ? this.TempLoginName : this.userPreference.data.strUsername;
            this.mcLogin.chkUserName.bitChecked = true;
         }
         if(this.userPreference.data.bitCheckedPassword)
         {
            this.mcLogin.pi.text = this.TempLoginPass != "" ? this.TempLoginPass : this.userPreference.data.strPassword;
            this.mcLogin.chkPassword.bitChecked = true;
         }
         this.mcLogin.chkUserName.checkmark.visible = this.mcLogin.chkUserName.bitChecked;
         this.mcLogin.chkPassword.checkmark.visible = this.mcLogin.chkPassword.bitChecked;
      }
      
      private function saveUserPreference() : *
      {
         this.userPreference.data.bitCheckedUsername = this.mcLogin.chkUserName.bitChecked;
         this.userPreference.data.bitCheckedPassword = this.mcLogin.chkPassword.bitChecked;
         if(this.mcLogin.chkUserName.bitChecked)
         {
            this.userPreference.data.strUsername = this.mcLogin.ni.text;
         }
         else
         {
            this.userPreference.data.strUsername = "";
         }
         if(this.mcLogin.chkPassword.bitChecked)
         {
            this.userPreference.data.strPassword = this.mcLogin.pi.text;
         }
         else
         {
            this.userPreference.data.strPassword = "";
         }
         try
         {
            this.userPreference.flush();
         }
         catch(e:Error)
         {
            trace("[Game] ERR saveUserPreference: flush: " + e.message);
         }
      }
      
      private function onCreateNewAccount(param1:MouseEvent) : void
      {
         this.mixer.playSound("Click");
         gotoAndPlay("Account");
      }
      
      private function onForgotPassword(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/Login/Forgot"));
      }
      
      private function onManageClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/"));
      }
      
      private function onAccountRecovery(param1:MouseEvent) : void
      {
         this.mixer.playSound("Click");
         navigateToURL(new URLRequest("https://www.aq.com/help/aw-account-recovery.asp"));
      }
      
      private function onLoginClick(param1:MouseEvent) : void
      {
         if("btnLogin" in this.mcLogin && Boolean(this.mcLogin.btnLogin.visible))
         {
            if(this.mcLogin.ni.text != "" && this.mcLogin.pi.text != "")
            {
               try
               {
                  this.saveUserPreference();
               }
               catch(e:*)
               {
               }
               if(FacebookConnect.isLoggedIn)
               {
                  FacebookConnect.Logout();
               }
               this.login(this.mcLogin.ni.text.toLowerCase(),this.mcLogin.pi.text);
            }
         }
      }
      
      public function CallFBConnect(param1:Function) : void
      {
         this.addEventListener(FacebookConnectEvent.ONCONNECT,this.FBLoginCreate);
         this.FBConnectCallback = param1;
         FacebookConnect.RequestFBConnect();
      }
      
      public function GetFBMe() : Object
      {
         return FacebookConnect.Me;
      }
      
      public function isFBLoggedIn() : Boolean
      {
         return FacebookConnect.isLoggedIn;
      }
      
      public function FBIP() : String
      {
         return FacebookConnect.IPAddr;
      }
      
      public function GetFBToken() : String
      {
         return FacebookConnect.AccessToken;
      }
      
      private function onFBLoginClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://account.aq.com/login/facebookinfo"),"_blank");
      }
      
      public function FBLogin(param1:FacebookConnectEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:URLRequest = null;
         var _loc4_:URLVariables = null;
         var _loc5_:URLLoader = null;
         this.removeEventListener(FacebookConnectEvent.ONCONNECT,this.FBLogin);
         if(param1.params.success)
         {
            this.params.FBID = FacebookConnect.Me.id;
            this.params.token = FacebookConnect.AccessToken;
            _loc2_ = Number(this.rn.rand());
            this.mcConnDetail.showConn("Loading Server List...");
            _loc3_ = new URLRequest(this.params.loginURL);
            _loc4_ = new URLVariables();
            _loc4_.fbid = FacebookConnect.Me.id;
            _loc4_.fbtoken = FacebookConnect.AccessToken;
            FacebookConnect.isLoggedIn = true;
            _loc3_.data = _loc4_;
            _loc3_.method = URLRequestMethod.POST;
            _loc5_ = new URLLoader();
            _loc5_.addEventListener(Event.COMPLETE,this.onLoginComplete);
            _loc5_.load(_loc3_);
         }
         else
         {
            this.mcConnDetail.showError(param1.params.message);
         }
      }
      
      public function FBLoginCreate(param1:FacebookConnectEvent) : void
      {
         var fbevt:FacebookConnectEvent = param1;
         this.removeEventListener(FacebookConnectEvent.ONCONNECT,this.FBLoginCreate);
         if(this.FBConnectCallback != null)
         {
            try
            {
               this.FBConnectCallback();
            }
            catch(e:Error)
            {
               trace("[Game] ERR FBConnectCallback: " + e.message);
            }
         }
         this.FBConnectCallback = null;
      }
      
      public function getFBUser() : void
      {
         if(ISWEB)
         {
            this.extCall.getFBUser();
         }
      }
      
      public function login(param1:String, param2:String) : *
      {
         var rand:Number = NaN;
         var url:String = null;
         var request:URLRequest = null;
         var variables:URLVariables = null;
         var strUsername:String = param1;
         var strPassword:String = param2;
         var arrAllowLocal:Array = new Array("zhoom","ztest00","ztest01","ztest02","iterator","zdhz","yorumi");
         this.mcConnDetail.showConn("Authenticating Account Info...");
         loginInfo.strUsername = strUsername;
         loginInfo.strPassword = strPassword;
         rand = Number(this.rn.rand());
         url = "cf-userlogin.asp?ran=" + rand;
         url = this.params.loginURL + "?ran=" + rand;
         trace("[Game] LoginURL: " + url);
         request = new URLRequest(url);
         variables = new URLVariables();
         variables.user = strUsername;
         variables.pass = strPassword;
         variables.option = ISWEB ? "0" : "1";
         if(this.checkPasswordStrength(strPassword) < 18)
         {
            this.bPassword = false;
         }
         if(this.params.strSourceID == "FACEBOOK")
         {
            variables.strSourceID = this.params.strSourceID;
            variables.fbid = this.params.FBID;
            variables.fbtoken = this.params.token;
         }
         else if(this.params.strSourceID == "TAGGED")
         {
            variables.strSourceID = this.params.strSourceID;
            variables.SrcUserID = this.params.SrcUserID;
            variables.token = this.params.token;
         }
         request.data = variables;
         request.method = URLRequestMethod.POST;
         this.loginLoader.removeEventListener(Event.COMPLETE,this.onLoginComplete);
         this.loginLoader.addEventListener(Event.COMPLETE,this.onLoginComplete);
         this.loginLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoginError,false,0,true);
         try
         {
            this.loginLoader.load(request);
         }
         catch(error:Error)
         {
            trace("[Game] ERR login: unable to load URL: " + error.message);
         }
      }
      
      public function onLoginError(param1:Event) : void
      {
         trace("[Game] ERR onLoginError: " + param1);
      }
      
      public function onLoginComplete(param1:Event) : void
      {
         var _obj:Object = null;
         var event:Event = param1;
         trace("[Game] LoginComplete");
         try
         {
            _obj = JSON.parse(event.target.data);
            if(_obj.login)
            {
               objLogin = _obj.login;
               objLogin.servers = _obj.servers;
               this.playerPollData = _obj.polldata;
            }
            else
            {
               objLogin = _obj;
            }
            this.loginLoader.removeEventListener(Event.COMPLETE,this.onLoginComplete);
            if(objLogin.bSuccess == 1)
            {
               try
               {
                  loginInfo.strUsername = objLogin.unm.toLowerCase();
               }
               catch(e:*)
               {
                  trace("[Game] ERR LoginComplete: loginInfo.strUsername null");
               }
               if(loginInfo.strUsername != null)
               {
                  if(loginInfo.strUsername.toLowerCase() == "iterator" || loginInfo.strUsername.toLowerCase() == "iterator2" || loginInfo.strUsername.toLowerCase() == "iterator3" || loginInfo.strUsername.toLowerCase() == "iterator4")
                  {
                     this.serialCmdMode = true;
                  }
                  else
                  {
                     this.serialCmdMode = false;
                  }
               }
               else
               {
                  this.serialCmdMode = false;
               }
               if(objLogin.FBID != null)
               {
                  if(FacebookConnect.Me == null)
                  {
                     FacebookConnect.Me = new Object();
                  }
                  FacebookConnect.Me.id = objLogin.FBID;
                  if(objLogin.FBName != null)
                  {
                     FacebookConnect.Me.name = objLogin.FBName;
                  }
               }
               if(this.fbL != null)
               {
                  this.fbL.destroy();
               }
               if(ISWEB)
               {
                  this.extCall.getFBUser();
               }
               this.mcConnDetail.hideConn();
               loginInfo.strToken = objLogin.sToken;
               this.sToken = loginInfo.strToken;
               strToken = loginInfo.strToken;
               if(ISWEB)
               {
                  this.extCall.setToken(loginInfo);
               }
               if(this.serialCmdMode)
               {
                  this.mcLogin.testClientAssets.visible = false;
                  this.mcLogin.gotoAndStop("Iterator");
               }
               else
               {
                  this.mcLogin.gotoAndStop("Servers");
               }
            }
            else if(objLogin.sMsg.indexOf("Facebook") > -1)
            {
               this.mcConnDetail.hideConn();
               this.fbL = new fbLinkWindow(this.mcLogin.fbConnect,this as MovieClip);
               this.mcLogin.fbConnect.visible = true;
            }
            else
            {
               this.mcConnDetail.showError(objLogin.sMsg);
            }
         }
         catch(e:*)
         {
            trace("[Game] ERR LoginComplete: " + e);
         }
         this.resetsOnNewSession();
      }
      
      public function resetsOnNewSession() : void
      {
         if(this.extCall == null)
         {
            this.init();
         }
         if(Boolean(this.litePreference.data.bDebugger) && objLogin.iAccess < 30)
         {
            optionHandler.cmd(MovieClip(this),"@ Debugger");
         }
      }
      
      public function deepCopy(param1:*, param2:*) : void
      {
         var _loc3_:* = undefined;
         for(var _loc6_ in param2)
         {
            _loc3_ = _loc6_;
            _loc6_;
            if(typeof (param2 as Object)[_loc3_] == "object")
            {
               (param1 as Object)[_loc3_] = new Object();
               this.deepCopy((param1 as Object)[_loc3_],(param2 as Object)[_loc3_]);
            }
            else if((param2 as Object)[_loc3_])
            {
               (param1 as Object)[_loc3_] = (param2 as Object)[_loc3_];
            }
         }
      }
      
      public function deepCopyArr(param1:*, param2:*) : void
      {
         var _loc3_:* = undefined;
         for each(var _loc6_ in param2)
         {
            _loc3_ = _loc6_;
            _loc6_;
            param1.push(_loc3_);
         }
      }
      
      public function saveChar() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         if(this.characters == null || FacebookConnect.isLoggedIn || !this.litePreference.data.bCharSelect)
         {
            return;
         }
         _loc1_ = new Object();
         _loc1_["strGender"] = this.world.myAvatar.objData.strGender;
         _loc1_["strHairFilename"] = this.world.myAvatar.objData.strHairFilename;
         _loc1_["strHairName"] = this.world.myAvatar.objData.strHairName;
         _loc1_["eqp"] = {};
         this.deepCopy(_loc1_["eqp"],this.world.myAvatar.objData.eqp);
         _loc1_["intGold"] = this.world.myAvatar.objData.intGold;
         _loc1_["intCoins"] = this.world.myAvatar.objData.intCoins;
         _loc1_["strClassName"] = this.world.myAvatar.objData.strClassName;
         _loc1_["iCP"] = this.world.myAvatar.objData.iCP;
         _loc1_["intLevel"] = this.world.myAvatar.objData.intLevel;
         _loc1_["strUsername"] = this.world.myAvatar.objData.strUsername;
         _loc1_["intAccessLevel"] = this.world.myAvatar.objData.intAccessLevel;
         _loc1_["iUpgDays"] = this.world.myAvatar.objData.iUpgDays;
         _loc1_["intColorSkin"] = this.world.myAvatar.objData.intColorSkin;
         _loc1_["intColorHair"] = this.world.myAvatar.objData.intColorHair;
         _loc1_["intColorEye"] = this.world.myAvatar.objData.intColorEye;
         _loc1_["intColorBase"] = this.world.myAvatar.objData.intColorBase;
         _loc1_["intColorTrim"] = this.world.myAvatar.objData.intColorTrim;
         _loc1_["intColorAccessory"] = this.world.myAvatar.objData.intColorAccessory;
         if(this.world.myAvatar.objData.guild != null)
         {
            _loc1_["guild"] = {};
            _loc1_["guild"]["Name"] = this.world.myAvatar.objData.guild.Name;
         }
         _loc1_["showHelm"] = this.world.myAvatar.dataLeaf.showHelm;
         _loc1_["showCloak"] = this.world.myAvatar.dataLeaf.showCloak;
         if(Boolean(this.characters.data.users) && Boolean(this.characters.data.users[this.world.myAvatar.pnm.toLowerCase()]))
         {
            (this.characters.data.users[this.world.myAvatar.pnm.toLowerCase()] as Object).data = _loc1_;
            (this.characters.data.users[this.world.myAvatar.pnm.toLowerCase()] as Object).server = this.objServerInfo.sName;
         }
         else
         {
            _loc2_ = 0;
            for(var _loc7_ in this.characters.data.users)
            {
               _loc3_ = _loc7_;
               _loc7_;
               _loc2_++;
            }
            if(_loc2_ >= 5)
            {
               return;
            }
            (loginInfo as Object).bAsk = false;
            _loc4_ = new Object();
            this.deepCopy(_loc4_,loginInfo);
            this.characters.data.users[this.world.myAvatar.pnm.toLowerCase()] = {
               "index":-1,
               "data":_loc1_,
               "server":this.objServerInfo.sName,
               "loginInfo":_loc4_
            };
         }
         this.characters.flush();
      }
      
      public function charCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         if(this.characters == null)
         {
            return 0;
         }
         if(!this.characters.data.users)
         {
            this.characters.data.users = new Object();
            this.characters.data.retro = true;
            this.characters.flush();
            return 0;
         }
         _loc1_ = 0;
         for(var _loc5_ in this.characters.data.users)
         {
            _loc2_ = _loc5_;
            _loc5_;
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function retroLowercase() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         if(this.charCount() == 0)
         {
            return;
         }
         if(this.characters.data.retro)
         {
            return;
         }
         trace("[Game] retroLowercase: migrating saved char names");
         _loc1_ = false;
         for(var _loc6_ in this.characters.data.users)
         {
            _loc2_ = _loc6_;
            _loc6_;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_.charAt(_loc3_) != _loc2_.charAt(_loc3_).toLowerCase())
               {
                  _loc1_ = true;
                  break;
               }
               _loc3_++;
            }
            if(_loc1_)
            {
               break;
            }
         }
         if(_loc1_)
         {
            this.resetChars();
         }
         else
         {
            this.characters.data.retro = true;
         }
      }
      
      public function resetChars() : void
      {
         if(this.characters == null)
         {
            return;
         }
         this.characters.data.users = null;
         delete this.characters.data.users;
         this.characters.flush();
      }
      
      private function loadExternalAssets() : void
      {
         var _loc1_:String = null;
         var _loc2_:* = undefined;
         trace("[Load] loadExternalAssets");
         this.mcConnDetail.showConn("Initializing Client...");
         this.assetsLoader = new Loader();
         _loc1_ = this.world != null && this.world.objInfo != null && this.world.objInfo["sAssets"] != null ? String(this.world.objInfo["sAssets"]) : "Assets_20260702.swf";
         this.pendingAssetsFile = _loc1_;
         _loc2_ = new URLRequest(vurl(serverFilePath + "interface/Assets/" + _loc1_));
         this.assetsLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.assetsLoaderCallback,false,0,true);
         this.assetsLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.assetsLoaderErrorHandler,false,0,true);
         this.assetsLoader.load(_loc2_,this.assetsContext);
      }
      
      private function assetsLoaderCallback(param1:Event) : void
      {
         var _loc2_:LoaderInfo = null;
         trace("[Load] external assets loaded");
         _loc2_ = param1.currentTarget as LoaderInfo;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.assetsLoaderCallback);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.assetsLoaderErrorHandler);
         }
         this.assetsLoader = null;
         ASSETS_READY = this.pendingAssetsFile;
         this.resumeOnLoginResponse();
      }
      
      private function resumeOnLoginResponse() : void
      {
         var _loc1_:int = 0;
         this.mcConnDetail.showConn("Joining Lobby..");
         this.sfc.sendXtMessage("zm","firstJoin",[],"str",1);
         if(this.chatF.ignoreList.data.users.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.chatF.ignoreList.data.users.length)
            {
               if(this.chatF.ignoreList.data.users[_loc1_].toLowerCase() == loginInfo.strUsername.toLowerCase())
               {
                  this.chatF.ignoreList.data.users.splice(_loc1_,1);
                  break;
               }
               _loc1_++;
            }
            this.sfc.sendXtMessage("zm","cmd",["ignoreList",this.chatF.ignoreList.data.users],"str",1);
         }
         else
         {
            this.sfc.sendXtMessage("zm","cmd",["ignoreList","$clearAll"],"str",1);
         }
      }
      
      private function assetsLoaderErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = null;
         _loc2_ = param1.currentTarget as LoaderInfo;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.assetsLoaderCallback);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.assetsLoaderErrorHandler);
         }
         this.assetsLoader = null;
         trace("[Load] ERR external assets failed: " + param1.text);
         this.mcConnDetail.showError("Client Initialization Failed!");
      }
      
      public function connectTo(param1:String, param2:int = 5588) : *
      {
         trace("[Game] connectTo: " + param1);
         serverIP = param1;
         this.mixer.playSound("ClickBig");
         this.mcConnDetail.showConn("Connecting to game server...");
         if(this.sfc.isConnected)
         {
            this.sfc.disconnect();
         }
         this.sfc.connect(param1,param2);
         gotoAndPlay("Game");
      }
      
      public function displayCharPage(param1:String) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = new _loc2_(this,param1);
         this.ui.addChild(_loc2_);
      }
      
      public function togglePolls() : void
      {
         this.requestInterface("polls/pollingsystem.swf","pollingSystem");
      }
      
      public function requestInterface(param1:String, param2:String) : void
      {
         this.removeDeadInterfaces();
         this.interfaceQueue.push({
            "nam":param2,
            "intrf":param1
         });
         if(this.interfaceQueue.length == 1)
         {
            this.checkInterfaceQueue();
         }
      }
      
      public function checkInterfaceQueue() : void
      {
         var _loc1_:Loader = null;
         if(this.interfaceQueue.length < 1)
         {
            return;
         }
         this.visualLoader = new mcLoader();
         this.visualLoader.x = 400;
         this.visualLoader.y = 211;
         this.addChild(this.visualLoader);
         _loc1_ = new Loader();
         _loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onInterfaceComplete,false,0,true);
         _loc1_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onInterfaceProgress,false,0,true);
         _loc1_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onInterfaceError,false,0,true);
         _loc1_.load(new URLRequest(vurl(this.getFilePath() + "interface/" + this.interfaceQueue[0].intrf)),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
      }
      
      public function onInterfaceComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         _loc2_ = param1.currentTarget as LoaderInfo;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.onInterfaceComplete);
            _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.onInterfaceProgress);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onInterfaceError);
         }
         _loc3_ = new MovieClip();
         _loc3_.addChild(param1.currentTarget.content);
         _loc3_.name = this.interfaceQueue[0].nam;
         _loc4_ = this.addChild(_loc3_);
         if(this.interfaceRef.hasOwnProperty(this.interfaceQueue[0].nam))
         {
            if(this.interfaceRef[this.interfaceQueue[0].nam])
            {
               if(this.interfaceRef[this.interfaceQueue[0].nam].parent)
               {
                  MovieClip(this.interfaceRef[this.interfaceQueue[0].nam].parent).removeChild(this.interfaceRef[this.interfaceQueue[0].nam]);
               }
            }
         }
         this.interfaceRef[this.interfaceQueue[0].nam] = _loc4_;
         this.interfaceQueue.shift();
         this.checkInterfaceQueue();
         this.setChildIndex(this.MsgBox,numChildren - 1);
         if(_loc3_.name == "pony_engine")
         {
            this.world.myAvatar.swapMorphs(true);
         }
      }
      
      public function cleanupInterfaces() : void
      {
         var _loc1_:* = undefined;
         for each(var _loc4_ in this.interfaceRef)
         {
            _loc1_ = _loc4_;
            _loc4_;
            if(_loc1_)
            {
               if(_loc1_.parent)
               {
                  MovieClip(_loc1_.parent).removeChild(_loc1_);
               }
            }
         }
         this.interfaceRef = new Object();
      }
      
      public function removeDeadInterfaces() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         _loc2_ = [];
         for(var _loc6_ in this.interfaceRef)
         {
            _loc1_ = _loc6_;
            _loc6_;
            _loc3_ = this.interfaceRef[_loc1_];
            if(_loc3_)
            {
               if(!_loc3_.parent)
               {
                  _loc2_.push(_loc1_);
               }
            }
         }
         for each(_loc6_ in _loc2_)
         {
            _loc1_ = _loc6_;
            _loc6_;
            delete this.interfaceRef[_loc1_];
         }
      }
      
      public function getInterface(param1:String) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = this.interfaceRef[param1];
         if(_loc2_)
         {
            if(_loc2_.parent)
            {
               return _loc2_;
            }
            delete this.interfaceRef[param1];
         }
         return null;
      }
      
      public function onInterfaceProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = 0;
         this.interfaceLoaded = param1.bytesLoaded;
         this.interfaceTotal = param1.bytesTotal;
         _loc2_ = this.interfaceLoaded / this.interfaceTotal * 100;
         var _loc3_:Number = this.interfaceLoaded / this.interfaceTotal;
         this.visualLoader.mcPct.text = _loc2_ + "%";
         if(this.interfaceLoaded >= this.interfaceTotal)
         {
            this.visualLoader.parent.removeChild(this.visualLoader);
            this.visualLoader = null;
         }
      }
      
      public function onInterfaceError(param1:IOErrorEvent) : void
      {
         var _loc2_:LoaderInfo = null;
         _loc2_ = param1.currentTarget as LoaderInfo;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.onInterfaceComplete);
            _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.onInterfaceProgress);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onInterfaceError);
         }
         trace("[Load] ERR interface load failed: " + param1.text);
      }
      
      public function requestAPI(param1:String, param2:*, param3:*, param4:*, param5:Boolean = false) : void
      {
         var _loc6_:URLLoader = null;
         var _loc7_:Array = null;
         var _loc8_:URLVariables = null;
         var _loc9_:URLRequest = null;
         var _loc10_:* = undefined;
         _loc6_ = new URLLoader();
         _loc6_.addEventListener(Event.COMPLETE,param3,false,0,true);
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,param4,false,0,true);
         _loc7_ = [new URLRequestHeader("ccid",this.world.myAvatar.objData.CharID),new URLRequestHeader("token",loginInfo.strToken)];
         _loc8_ = new URLVariables();
         if(param2 != null)
         {
            for(var _loc13_ in param2)
            {
               _loc10_ = _loc13_;
               _loc13_;
               _loc8_[_loc10_] = _loc10_ == "layout" ? JSON.stringify(param2[_loc10_]) : param2[_loc10_];
            }
         }
         _loc9_ = new URLRequest(serverGamePath + "api/char/" + param1 + (param5 ? "?v=" + Math.random() : ""));
         _loc9_.requestHeaders = _loc7_;
         if(param2 != null)
         {
            _loc9_.data = _loc8_;
         }
         _loc9_.method = URLRequestMethod.POST;
         _loc6_.load(_loc9_);
      }
      
      public function getBank() : void
      {
         this.requestAPI("bank",{"layout":{"cat":"all"}},this.onBankComplete,this.onBankError,true);
      }
      
      public function onBankComplete(param1:Event) : void
      {
         trace("[Load] bank data loaded");
         this.world.addItemsToBank(JSON.parse(param1.target.data) as Array);
      }
      
      public function onBankError(param1:IOErrorEvent) : void
      {
         this.mcConnDetail.showConn("Error loading bank information");
      }
      
      public function retrieveInfo(param1:Array) : void
      {
         var _loc2_:URLLoader = null;
         var _loc3_:* = undefined;
         if(this.world == null)
         {
            this.initWorld();
         }
         if(serverGamePath.indexOf("content.aq") == -1)
         {
            for each(var _loc6_ in param1)
            {
               _loc3_ = _loc6_;
               _loc6_;
               this.world.objInfo[_loc3_.split("=")[0]] = _loc3_.substr(_loc3_.indexOf("=") + 1);
            }
            this.iMaxBagSlots = Number(this.world.objInfo["iMaxBagSlots"]);
            this.iMaxBankSlots = Number(this.world.objInfo["iMaxBankSlots"]);
            this.iMaxHouseSlots = Number(this.world.objInfo["iMaxHouseSlots"]);
            this.iMaxFriends = Number(this.world.objInfo["iMaxFriends"]);
            this.iMaxLoadoutSlots = Number(this.world.objInfo["iMaxLoadoutSlots"]);
            if(ASSETS_READY == this.world.objInfo["sAssets"])
            {
               this.BOOK_DATA_READY = null;
               this.resumeOnLoginResponse();
            }
            else
            {
               this.BOOK_DATA_READY = null;
               this.loadExternalAssets();
            }
            return;
         }
         _loc2_ = new URLLoader();
         _loc2_.addEventListener(Event.COMPLETE,this.onInfoComplete,false,0,true);
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,this.onInfoError,false,0,true);
         _loc2_.load(new URLRequest(serverGamePath + "api/data/clientvars?v=" + Math.random()));
      }
      
      public function retrieveBook() : void
      {
         var _loc1_:URLLoader = null;
         if(this.ui.getChildByName("travelLoaderMC"))
         {
            return;
         }
         this.travelLoaderMC = new (this.world.getClass("mcLoader") as Class)();
         this.travelLoaderMC.x = 400;
         this.travelLoaderMC.y = 211;
         this.travelLoaderMC.name = "travelLoaderMC";
         this.ui.addChild(this.travelLoaderMC);
         _loc1_ = new URLLoader();
         _loc1_.addEventListener(Event.COMPLETE,this.onBoLComplete,false,0,true);
         _loc1_.addEventListener(ProgressEvent.PROGRESS,this.onBoLProgress,false,0,true);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onBoLError,false,0,true);
         _loc1_.load(new URLRequest(serverGamePath + "api/data/booklore?v=" + this.world.objInfo["sVersion"]));
      }
      
      public function onInfoComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = null;
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         _loc2_ = param1.target as URLLoader;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.onInfoComplete);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onInfoError);
         }
         if(this.world == null)
         {
            this.initWorld();
         }
         _loc3_ = JSON.parse(param1.target.data);
         for(var _loc7_ in _loc3_)
         {
            _loc4_ = _loc7_;
            _loc7_;
            this.world.objInfo[_loc4_] = _loc3_[_loc4_];
         }
         this.iMaxBagSlots = Number(_loc3_["iMaxBagSlots"]);
         this.iMaxBankSlots = Number(_loc3_["iMaxBankSlots"]);
         this.iMaxHouseSlots = Number(_loc3_["iMaxHouseSlots"]);
         this.iMaxFriends = Number(_loc3_["iMaxFriends"]);
         this.iMaxLoadoutSlots = Number(_loc3_["iMaxLoadoutSlots"]);
         if(ASSETS_READY == _loc3_["sAssets"])
         {
            this.BOOK_DATA_READY = null;
            this.resumeOnLoginResponse();
         }
         else
         {
            this.BOOK_DATA_READY = null;
            this.loadExternalAssets();
         }
      }
      
      public function onInfoError(param1:IOErrorEvent) : void
      {
         var _loc2_:URLLoader = null;
         _loc2_ = param1.target as URLLoader;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.onInfoComplete);
            _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onInfoError);
         }
         this.mcConnDetail.showConn("Error loading client vars");
      }
      
      public function onBoLComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = null;
         var _loc3_:Object = null;
         _loc2_ = param1.target as URLLoader;
         if(_loc2_ != null)
         {
            _loc2_.removeEventListener(Event.COMPLETE,this.onBoLComplete);
            _loc2_.removeEventListener(ProgressEvent.PROGRESS,this.onBoLProgress);
         }
         _loc3_ = JSON.parse(param1.target.data);
         this.world.bookData = _loc3_;
         this.BOOK_DATA_READY = _loc3_;
         this.ui.mcPopup.mcBook.removeChildAt(0);
         if(this.bolContent)
         {
            if(this.newInstance)
            {
               this.newInstance = false;
               this.bolContent.gotoAndStop("NavMenu");
            }
            this.ui.mcPopup.mcBook.addChild(this.bolContent);
            return;
         }
         this.bolLoader = new Loader();
         this.bolLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onBoLContentComplete,false,0,true);
         this.bolLoader.load(new URLRequest(vurl(Game.serverFilePath + this.world.objInfo.sBook)),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
      }
      
      public function onBoLContentComplete(param1:Event) : void
      {
         trace("[Load] BoL content loaded");
         if(this.bolLoader != null)
         {
            this.bolLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onBoLContentComplete);
         }
         this.bolContent = param1.currentTarget.content;
         this.ui.mcPopup.mcBook.addChild(this.bolContent);
      }
      
      private function onBoLProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = 0;
         this.bLoaded = param1.bytesLoaded;
         this.bTotal = param1.bytesTotal;
         _loc2_ = this.bLoaded / this.bTotal * 100;
         var _loc3_:Number = this.bLoaded / this.bTotal;
         this.travelLoaderMC.mcPct.text = _loc2_ + "%";
         if(this.bLoaded >= this.bTotal)
         {
            this.travelLoaderMC.parent.removeChild(this.travelLoaderMC);
            this.travelLoaderMC = null;
         }
      }
      
      private function onBoLError(param1:IOErrorEvent) : void
      {
         trace("[Load] ERR BoL load failed: " + param1.text);
         if(this.travelLoaderMC)
         {
            this.travelLoaderMC.parent.removeChild(this.travelLoaderMC);
            this.travelLoaderMC = null;
         }
      }
      
      public function serialCmdInit(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc2_ = this.mcLogin.il;
         _loc3_ = _loc2_.cmd;
         _loc3_.btnUnselectAll.visible = false;
         _loc3_.btnSelectAll.visible = false;
         _loc3_.btnGo.visible = false;
         this.serialCmd.si = 0;
         this.serialCmd.cmd = param1;
         this.serialCmd.active = true;
         this.serialCmdNext();
      }
      
      private function serialCmdNext() : void
      {
         var _loc1_:Date = null;
         var _loc2_:* = undefined;
         var _loc4_:* = undefined;
         _loc1_ = new Date();
         _loc2_ = this.mcLogin.il.iClass;
         var _loc3_:* = this.mcLogin.il.cmd;
         if(this.serialCmd.si > 0)
         {
            _loc4_ = _loc2_.getServerItemByIP(this.serialCmd.servers[this.serialCmd.si - 1].sIP,this.serialCmd.servers[this.serialCmd.si - 1].iPort);
            if(_loc4_ != null)
            {
               _loc2_.serverOn(_loc4_);
               _loc4_.t3.text = (_loc1_.getTime() - this.serialCmd.ts) / 1000 + " s";
               _loc4_.t3.visible = true;
            }
         }
         if(this.serialCmd.si < this.serialCmd.servers.length)
         {
            trace("[Game] serial connecting to: " + this.serialCmd.servers[this.serialCmd.si].sName);
            this.sfc.connect(this.serialCmd.servers[this.serialCmd.si].sIP,this.serialCmd.servers[this.serialCmd.si].iPort);
            this.serialCmd.si++;
            this.serialCmd.ts = _loc1_.getTime();
         }
         else
         {
            this.serialCmdDone();
         }
      }
      
      private function serialCmdDone() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = this.mcLogin.il;
         _loc2_ = _loc1_.cmd;
         _loc2_.btnUnselectAll.visible = true;
         _loc2_.btnSelectAll.visible = true;
         _loc2_.btnGo.visible = true;
         this.serialCmd.active = false;
      }
      
      public function readIA1Preferences() : void
      {
         this.uoPref.bCloak = this.world.getAchievement("ia1",0) == 0;
         this.uoPref.bHelm = this.world.getAchievement("ia1",1) == 0;
         this.uoPref.bPet = this.world.getAchievement("ia1",2) == 0;
         this.uoPref.bWAnim = this.world.getAchievement("ia1",3) == 0;
         this.uoPref.bGoto = this.world.getAchievement("ia1",4) == 0;
         this.uoPref.bMusicOn = this.world.getAchievement("ia1",6) == 0;
         this.uoPref.bFriend = this.world.getAchievement("ia1",7) == 0;
         this.uoPref.bParty = this.world.getAchievement("ia1",8) == 0;
         this.uoPref.bGuild = this.world.getAchievement("ia1",9) == 0;
         this.uoPref.bWhisper = this.world.getAchievement("ia1",10) == 0;
         this.uoPref.bTT = this.world.getAchievement("ia1",11) == 0;
         this.uoPref.bFBShare = this.world.getAchievement("ia1",12) == 1;
         this.uoPref.bDuel = this.world.getAchievement("ia1",13) == 0;
         this.world.hideAllCapes = this.world.getAchievement("ia1",14) == 1;
         this.world.hideOtherPets = this.world.getAchievement("ia1",15) == 1;
         this.world.showAnimations = this.world.getAchievement("ia1",17) == 0;
         this.uoPref.bProf = this.world.getAchievement("ia1",18) == 0;
         this.uoPref.bFBShard = false;
         this.mixer.stf = new SoundTransform(this.litePreference.data.dOptions["iSoundFX"] != null ? Number(this.litePreference.data.dOptions["iSoundFX"]) : 1);
         SoundMixer.soundTransform = new SoundTransform(this.litePreference.data.dOptions["iSoundAll"] != null ? Number(this.litePreference.data.dOptions["iSoundAll"]) : 1);
      }
      
      public function inituoPref() : void
      {
         this.uoPref.bCloak = true;
         this.uoPref.bHelm = true;
         this.uoPref.bPet = true;
         this.uoPref.bWAnim = true;
         this.uoPref.bGoto = true;
         this.uoPref.bMusicOn = true;
         this.uoPref.bFriend = true;
         this.uoPref.bParty = true;
         this.uoPref.bGuild = true;
         this.uoPref.bWhisper = true;
         this.uoPref.bTT = true;
         this.uoPref.bFBShare = false;
         this.uoPref.bDuel = true;
      }
      
      public function initKeybindPref(param1:Boolean = false) : void
      {
         if(Boolean(this.litePreference.data.keys) && !this.litePreference.data.keys["Dash"])
         {
            this.litePreference.data.keys["Dash"] = 32;
            this.litePreference.data.keys["Jump"] = null;
         }
         if(Boolean(this.litePreference.data.keys) && !param1)
         {
            return;
         }
         this.litePreference.data.keys = {};
         this.litePreference.data.keys["Camera Tool"] = 219;
         this.litePreference.data.keys["World Camera"] = 221;
         this.litePreference.data.keys["Target Random Monster"] = 84;
         this.litePreference.data.keys["Inventory"] = 73;
         this.litePreference.data.keys["Bank"] = 66;
         this.litePreference.data.keys["Quest Log"] = 76;
         this.litePreference.data.keys["Friends List"] = 70;
         this.litePreference.data.keys["Character Panel"] = 67;
         this.litePreference.data.keys["Player HP Bar"] = 86;
         this.litePreference.data.keys["Options"] = 79;
         this.litePreference.data.keys["Area List"] = 85;
         this.litePreference.data.keys["Jump"] = null;
         this.litePreference.data.keys["Auto Attack"] = 49;
         this.litePreference.data.keys["Skill 1"] = 50;
         this.litePreference.data.keys["Skill 2"] = 51;
         this.litePreference.data.keys["Skill 3"] = 52;
         this.litePreference.data.keys["Skill 4"] = 53;
         this.litePreference.data.keys["Skill 5"] = 54;
         this.litePreference.data.keys["Travel Menu\'s Travel"] = 89;
         this.litePreference.data.keys["World Camera\'s Hide"] = 72;
         this.litePreference.data.keys["Rest"] = 88;
         this.litePreference.data.keys["Hide Monsters"] = null;
         this.litePreference.data.keys["Hide Players"] = null;
         this.litePreference.data.keys["Cancel Target"] = 27;
         this.litePreference.data.keys["Hide UI"] = null;
         this.litePreference.data.keys["Battle Analyzer"] = null;
         this.litePreference.data.keys["Decline All Drops"] = null;
         this.litePreference.data.keys["Stats Overview"] = null;
         this.litePreference.data.keys["Battle Analyzer Toggle"] = null;
         this.litePreference.data.keys["Custom Drops UI"] = null;
         this.litePreference.data.keys["@ Debugger - Cell Menu"] = 192;
         this.litePreference.data.keys["@ Debugger - Packet Logger"] = null;
         this.litePreference.data.keys["Dash"] = 32;
         this.litePreference.data.keys["Outfits"] = null;
         this.litePreference.data.keys["Friendships UI"] = null;
      }
      
      public function debugMessage(param1:String) : void
      {
         if(!this.litePreference.data.bDebugger)
         {
            return;
         }
         this.chatF.pushMsg("warning",param1,"SERVER","",0);
      }
      
      private function registerErrorSuppression() : void
      {
         var _loc1_:LoaderInfo = null;
         this.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtError);
         try
         {
            if(this.parent is Loader)
            {
               Loader(this.parent).uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtError);
            }
         }
         catch(e1:Error)
         {
         }
         try
         {
            _loc1_ = DisplayObject(stage.getChildAt(0)).loaderInfo;
            if(_loc1_ != null && _loc1_ != this.loaderInfo)
            {
               _loc1_.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onUncaughtError);
            }
         }
         catch(e2:Error)
         {
         }
      }
      
      private function uncaughtText(param1:*) : String
      {
         var _loc2_:Error = null;
         var _loc3_:String = null;
         _loc2_ = param1 as Error;
         if(_loc2_ == null)
         {
            return String(param1);
         }
         _loc3_ = _loc2_.getStackTrace();
         if(_loc3_ == null)
         {
            return _loc2_.message;
         }
         return _loc3_;
      }
      
      private function onUncaughtError(param1:UncaughtErrorEvent) : void
      {
         var _loc2_:String = null;
         param1.preventDefault();
         param1.stopImmediatePropagation();
         _loc2_ = "uncaught";
         try
         {
            _loc2_ = this.uncaughtText(param1.error);
         }
         catch(e3:Error)
         {
         }
         trace("[Game] ERR uncaught: " + _loc2_);
         try
         {
            this.debugMessage("suppressed error: " + _loc2_);
         }
         catch(e4:Error)
         {
         }
      }
      
      public function initlitePref() : void
      {
         if(this.litePreference.data.dOptions == null)
         {
            this.litePreference.data.dOptions = {};
         }
         if(this.litePreference.data.dOptions["termsAgree"] == null)
         {
            this.litePreference.data.dOptions["termsAgree"] = true;
         }
         this.litePref = [{
            "strName":"@ Debugger",
            "bEnabled":this.litePreference.data.bDebugger,
            "sDesc":"Debug Mode!\nPress ` (Changeable in Keybinds) to hide/show the cell & pads menu!",
            "minAccess":30,
            "extra":[{
               "strName":"Disable Linkage Errors",
               "bEnabled":this.litePreference.data.dOptions["debugLinkage"],
               "sDesc":"Avoid receiving linkage error messages"
            },{
               "strName":"Disable Color Coded Items",
               "bEnabled":this.litePreference.data.dOptions["debugColor"],
               "sDesc":"Prevents color coding of item entries\nRed item = costs 0 ac/gold\nRed item = item is AC and > 12k\nYellow item = is staff"
            },{
               "strName":"Packet Logger",
               "bEnabled":this.litePreference.data.dOptions["debugPacket"],
               "sDesc":"View all packets sent to the client.\nMust be enabled to use.\nSet a keybind to hide/show the packet logger window."
            }]
         },{
            "strName":"Allow Quest Log Turn-Ins",
            "bEnabled":this.litePreference.data.bQuestLog,
            "sDesc":"Allows you to turn-in quests using your quest log on the bottom right screen!"
         },{
            "strName":"Auto-Untarget Dead Targets",
            "bEnabled":this.litePreference.data.bUntargetDead,
            "sDesc":"This will untarget targets that are dead."
         },{
            "strName":"Auto-Untarget Self",
            "bEnabled":this.litePreference.data.bUntargetSelf,
            "sDesc":"This will prevent you from targetting yourself."
         },{
            "strName":"Battle Analyzer",
            "extra":"btn",
            "sDesc":"This will allow you to monitor your damage dealt, gold earned, and many more!"
         },{
            "strName":"Battlepets",
            "bEnabled":this.litePreference.data.bBattlepet,
            "sDesc":"Allows your battlepet to fight alongside you without a battlepet class equipped."
         },{
            "strName":"Static Player Art",
            "bEnabled":this.litePreference.data.bCachePlayers,
            "sDesc":"Reduces the graphics of other players. \n!WARNING! Having this enabled may or may not show some of the other player\'s colors. You will not be able to see their equipment changes with this enabled either.\nYou must change rooms after turning this feature off in order for changes to take effect"
         },{
            "strName":"Char Page",
            "special":1,
            "sDesc":"Search Character Pages"
         },{
            "strName":"Character Select Screen",
            "bEnabled":this.litePreference.data.bCharSelect,
            "sDesc":"Allows you to replace the login screen with a character select screen."
         },{
            "strName":"Comic Sans Font",
            "bEnabled":this.litePreference.data.bComicSans,
            "sDesc":"Displays all player nameplates (name + guild) and monster nameplates (name + race) in Comic Sans MS."
         },{
            "strName":"Chat Settings",
            "bEnabled":this.litePreference.data.bChatFilter,
            "sDesc":"Allow the customization of the game\'s chat window with the options below!",
            "extra":[{
               "strName":"Timestamps",
               "bEnabled":this.litePreference.data.dOptions["timeStamps"],
               "sDesc":"Adding timestamps to chat messages (Server Time)\nOnly works on the old chat ui!"
            },{
               "strName":"Disable Red Messages",
               "bEnabled":this.litePreference.data.dOptions["disRed"],
               "sDesc":"Avoid receiving combat warning messages in chat"
            }]
         },{
            "strName":"Chat UI",
            "bEnabled":this.litePreference.data.bChatUI,
            "sDesc":"If enabled, you will switch to the new Chat UI.",
            "extra":[{
               "strName":"Minimal Mode",
               "bEnabled":this.litePreference.data.dOptions["chatMinimal"],
               "sDesc":"Less intrusive on your gameplay!\nHover over the message box to make the messages visible\nScroll over the message box to scroll!"
            },{
               "strName":"Disable AutoScroll to Bottom",
               "bEnabled":this.litePreference.data.dOptions["chatScroll"],
               "sDesc":"The Chat UI will not automatically scroll to the bottom on a new message"
            }]
         },{
            "strName":"Class Actives/Auras UI",
            "bEnabled":this.litePreference.data.bAuras,
            "sDesc":"Work in Progress. No proper stack limit and icons yet.\nAllows you to view your buffs/auras underneath your player portrait and for your enemies as well!",
            "extra":[{
               "strName":"Disable ToolTips",
               "bEnabled":this.litePreference.data.dOptions["disAuraTips"],
               "sDesc":"Prevents you from seeing tooltips when hovering over an aura."
            },{
               "strName":"Disable Aura Text",
               "bEnabled":this.litePreference.data.dOptions["disAuraText"],
               "sDesc":"Prevents you from seeing the yellow aura text on you or other players."
            }]
         },{
            "strName":"Color Sets",
            "bEnabled":this.litePreference.data.bColorSets,
            "sDesc":"Save your colors with this tool that appears when you go customizing your hair or armor colors!"
         },{
            "strName":"Custom Drops UI",
            "bEnabled":this.litePreference.data.bCustomDrops,
            "sDesc":"Shift+Click to block an item drop!\nYour bank items must be loaded to detect if you already have an item",
            "extra":[{
               "strName":"Invert Menu",
               "bEnabled":this.litePreference.data.dOptions["invertMenu"],
               "sDesc":"The drop menu will appear at the top of the screen rather than appearing at the bottom"
            },{
               "strName":"Warn When Declining A Drop",
               "bEnabled":this.litePreference.data.dOptions["warnDecline"],
               "sDesc":"A confirmation box will appear to confirm if you want to decline an item drop"
            },{
               "strName":"Hide Drop Notifications",
               "bEnabled":this.litePreference.data.dOptions["hideDrop"],
               "sDesc":"This will hide regular drop notifications"
            },{
               "strName":"Hide Temporary Drop Notifications",
               "bEnabled":this.litePreference.data.dOptions["hideTemp"],
               "sDesc":"This will hide temporary drop notifications"
            },{
               "strName":"Opened Menu",
               "bEnabled":this.litePreference.data.dOptions["openMenu"],
               "sDesc":"The Custom Drops UI will start up opened rather than closed"
            },{
               "strName":"Draggable Mode",
               "bEnabled":this.litePreference.data.dOptions["dragMode"],
               "sDesc":"The Custom Drops UI will be draggable rather than being attached to the screen"
            },{
               "strName":"Lock Position",
               "bEnabled":this.litePreference.data.dOptions["lockMode"],
               "sDesc":"The draggable Custom Drops UI will not be moved from where it was last placed"
            },{
               "strName":"Reset Position",
               "extra":"btn",
               "sDesc":"If the Drop UI somehow goes off-screen and you can\'t see it, then use this to get it back!\nWorks only for \"Draggable Mode\""
            },{
               "strName":"Quantity Warnings",
               "bEnabled":this.litePreference.data.dOptions["termsAgree"],
               "sDesc":"By disabling this feature you understand help from player support for unaccepted drops will be limited"
            }]
         },{
            "strName":"Disable Chat Scrolling",
            "bEnabled":this.litePreference.data.bDisChatScroll,
            "sDesc":"Prevents you from scrolling the chat\nOnly works on the old chat ui!"
         },{
            "strName":"Disable Damage Numbers",
            "bEnabled":this.litePreference.data.bDisDmgDisplay,
            "sDesc":"Disables all damage numbers from showing as well as the white flash/strobe effect"
         },{
            "strName":"Disable Damage Strobe",
            "bEnabled":this.litePreference.data.bDisDmgStrobe,
            "sDesc":"Prevents the white flash/strobe effect whenever a monster or player is damaged!"
         },{
            "strName":"Disable Monster Animations",
            "bEnabled":this.litePreference.data.bDisMonAnim,
            "sDesc":"Disables monster animations with the benefit of performance"
         },{
            "strName":"Disable Self Animations",
            "bEnabled":this.litePreference.data.bDisSelfMAnim,
            "sDesc":"Disables your player\'s movement animations except for walking for the benefit of performance"
         },{
            "strName":"Disable Skill Animations",
            "bEnabled":this.litePreference.data.bDisSkillAnim,
            "sDesc":"There are two types of animations: Class Skill Animations & Player Movement Animations\nThis feature disables Class Skill Animations only while the regular \"Animations\" setting will disable both Class Skill Animations & Player Movement Animations",
            "extra":[{
               "strName":"Show Your Skill Animations Only",
               "bEnabled":this.litePreference.data.dOptions["animSelf"],
               "sDesc":"Only works if \"Disable Skill Animations\" is enabled!\nAdds an exception to \"Disable Skill Animations\" to show your skill animations only"
            }]
         },{
            "strName":"Disable Quest Popup",
            "bEnabled":this.litePreference.data.bDisQPopup,
            "sDesc":"Prevent the Quest Complete Popup if it becomes too intrusive"
         },{
            "strName":"Disable Quest Tracker",
            "bEnabled":this.litePreference.data.bDisQTracker,
            "sDesc":"Prevent the Quest Tracker from opening"
         },{
            "strName":"Disable Weapon Animations",
            "bEnabled":this.litePreference.data.bDisWepAnim,
            "sDesc":"Disables weapon animations\nYou can disable a specific player\'s weapon animations by targetting them and clicking on their portrait!",
            "extra":[{
               "strName":"Keep Your Weapon Animations Only",
               "bEnabled":this.litePreference.data.dOptions["wepSelf"],
               "sDesc":"Only works if \"Disable Weapon Animation\" is enabled!\nHaving this enabled will allow your weapon animations to continue working while others have theirs disabled"
            }]
         },{
            "strName":"Decline All Drops",
            "extra":"btn",
            "sDesc":"Declines all the drops on your screen"
         },{
            "strName":"Display FPS",
            "extra":"btn",
            "sDesc":"Toggles the Frames Per Second Display"
         },{
            "strName":"Draggable Drops",
            "bEnabled":this.litePreference.data.bDraggable,
            "sDesc":"Allows you to drag, or move around, the drops on your screen\nToggling this on with drops already on your screen will not make those drops draggable\nOnly works if \"Custom Drops UI\" is not enabled"
         },{
            "strName":"Freeze / Lock Monster Position",
            "bEnabled":this.litePreference.data.bFreezeMons,
            "sDesc":"This will freeze monsters on the map in place to prevent players from luring/dragging monsters all over the map"
         },{
            "strName":"Invisible Monsters",
            "bEnabled":this.litePreference.data.bHideMons,
            "sDesc":"Make monsters invisible. You can target them by clicking on their shadow"
         },{
            "strName":"Hide Players",
            "bEnabled":this.litePreference.data.bHidePlayers,
            "sDesc":"This will hide players on the map\nYou can hide specific players by clicking on their portraits (targetting them)!",
            "extra":[{
               "strName":"Show Name Tags",
               "bEnabled":this.litePreference.data.dOptions["showNames"],
               "sDesc":"Only works if \"Hide Players\" is enabled!\nHaving this enabled will allow you to still see name tags of players even though they\'re hidden."
            },{
               "strName":"Show Shadows",
               "bEnabled":this.litePreference.data.dOptions["showShadows"],
               "sDesc":"Only works if \"Hide Players\" is enabled!\nHaving this enabled will allow you to still see player shadows and clicking on the shadows will target them."
            }]
         },{
            "strName":"Hide Player Names",
            "bEnabled":this.litePreference.data.bHideNames,
            "sDesc":"Hides player names\nHover over a player to reveal their name & guild",
            "extra":[{
               "strName":"Hide Guild Names Only",
               "bEnabled":this.litePreference.data.dOptions["hideGuild"],
               "sDesc":"Player names will be visible, and guild names will be hidden"
            },{
               "strName":"Hide Your Name Only",
               "bEnabled":this.litePreference.data.dOptions["hideSelf"],
               "sDesc":"Only your name will be hidden.\nEnabling this setting will not make \"Hide Guild Names Only\" work."
            }]
         },{
            "strName":"Hide UI",
            "bEnabled":this.litePreference.data.bHideUI,
            "sDesc":"Hides player & target portraits located on the top left as well as the map name & area list located on the bottom right"
         },{
            "strName":"Item Drops Block List",
            "extra":"btn",
            "sDesc":"Shift+Click dropped items while using \"Custom Drops UI\" to add items to block!"
         },{
            "strName":"Keybinds",
            "extra":"btn",
            "sDesc":"Customize game keybinds.\nYou can not bind ENTER or /.\nUse BACKSPACE to delete a bind."
         },{
            "strName":"Reaccept Quest After Turn-In",
            "bEnabled":this.litePreference.data.bReaccept,
            "sDesc":"After turning in a quest, it will try to reaccept the quest if possible"
         },{
            "strName":"Show Monster Type",
            "bEnabled":this.litePreference.data.bMonsType,
            "sDesc":"Display the monster\'s type as a tag under their name"
         },{
            "strName":"Travel Menu",
            "extra":"btn",
            "sDesc":"Jump between multiple maps with a press of a button!\nThe keybind to jump maps is rebindable within \"Keybinds\"!"
         },{
            "strName":"Quest Pinner",
            "bEnabled":this.litePreference.data.bQuestPin,
            "sDesc":"1. Open quests from any NPC\n2. Press the \"Pin Quests\" button (left)\n3. You can now access it from anywhere by clicking on the yellow (!) quest log icon at the top left!\nShift+Click the yellow (!) quest log icon to open the Quest Tracker!\nShift+Click the quest pinner icon to clear your pinned quests!"
         },{
            "strName":"Quest Progress Notifications",
            "bEnabled":this.litePreference.data.bQuestNotif,
            "sDesc":"Quest Progress will continue to notify/update you even when you\'ve completed the quest"
         },{
            "strName":"Visual Skill CDs",
            "bEnabled":this.litePreference.data.bSkillCD,
            "sDesc":"Visual skill cooldowns!"
         },{
            "strName":"Hide Ground Items",
            "bEnabled":this.litePreference.data.bDisGround,
            "sDesc":"Hides the item type \'Ground\' from other players",
            "extra":[{
               "strName":"Show Your Ground Item Only",
               "bEnabled":this.litePreference.data.dOptions["groundSelf"],
               "sDesc":"Other players\' ground items will be hidden, while yours remains visible"
            }]
         },{
            "strName":"Hide Healing Bubbles",
            "bEnabled":this.litePreference.data.bDisHealBubble,
            "sDesc":"Hides the green healing bubbles above players when they\'re low on health"
         },{
            "strName":"Disable Aura Animations",
            "bEnabled":this.litePreference.data.bDisAuraAnim,
            "sDesc":"Disables all animations that activate on aura that some classes have from showing",
            "extra":[{
               "strName":"Show Your Aura Animation Only",
               "bEnabled":this.litePreference.data.dOptions["auraAnimSelf"],
               "sDesc":"Other players\' aura animations will be hidden, while yours remains visible. Recommended to leave on."
            }]
         }];
      }
      
      public function isTestClient() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         _loc1_ = ["Dev Grotto","Dev04"];
         for each(var _loc5_ in _loc1_)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(this.objServerInfo.sName.toLowerCase() == _loc2_.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }
      
      public function castSpellFX(param1:*, param2:*, param3:*, param4:*) : *
      {
         this.cameraToolMC.castSpellFX();
      }
      
      public function movieClipStopAll(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc2_) is MovieClip)
            {
               try
               {
                  (param1.getChildAt(_loc2_) as MovieClip).gotoAndStop(0);
                  this.movieClipStopAll(param1.getChildAt(_loc2_) as MovieClip);
               }
               catch(exception:*)
               {
               }
            }
            _loc2_++;
         }
      }
      
      public function rasterizePart(param1:DisplayObject) : Bitmap
      {
         var _loc2_:Matrix = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Point = null;
         var _loc5_:BitmapData = null;
         var _loc6_:Bitmap = null;
         _loc2_ = param1.transform.matrix;
         _loc3_ = param1.getBounds(param1.parent);
         _loc4_ = new Point(param1.x - _loc3_.left,param1.y - _loc3_.top);
         _loc2_.tx = _loc4_.x;
         _loc2_.ty = _loc4_.y;
         _loc5_ = new BitmapData(_loc3_.width,_loc3_.height,true,0);
         _loc5_.draw(param1,_loc2_,param1.transform.colorTransform,null,null,true);
         _loc6_ = new Bitmap(_loc5_);
         _loc6_.smoothing = true;
         _loc6_.x = _loc6_.x - _loc4_.x;
         _loc6_.y = _loc6_.y - _loc4_.y;
         return _loc6_;
      }
      
      public function rasterize(param1:MovieClip) : void
      {
         this.movieClipRasterizeInner(param1);
      }
      
      public function fixInputHeight(param1:*) : void
      {
         var _loc2_:Number = NaN;
         if(param1 == null)
         {
            return;
         }
         try
         {
            _loc2_ = param1.getLineMetrics(0).height + 4;
            if(param1.height < _loc2_)
            {
               param1.height = _loc2_;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function setGoldDisplay(param1:*) : void
      {
         var _loc2_:* = undefined;
         try
         {
            _loc2_ = this.ui.mcInterface.mcGold.strGold;
            _loc2_.text = String(param1);
            this.fixInputHeight(_loc2_);
            if(_loc2_.width < _loc2_.textWidth + 4)
            {
               _loc2_.width = _loc2_.textWidth + 4;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function findComicSansEmbedded() : String
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Font = null;
         if(this.csFontChecked)
         {
            return this.csFontName;
         }
         this.csFontChecked = true;
         _loc1_ = Font.enumerateFonts(false);
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_.fontType == FontType.EMBEDDED)
            {
               if(_loc3_.fontName == "Comic Sans MS" && _loc3_.fontStyle == FontStyle.REGULAR)
               {
                  this.csFontName = _loc3_.fontName;
                  return this.csFontName;
               }
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_.fontType == FontType.EMBEDDED)
            {
               if(_loc3_.fontName.toLowerCase().indexOf("comic") > -1)
               {
                  this.csFontName = _loc3_.fontName;
                  return this.csFontName;
               }
            }
            _loc2_++;
         }
         trace("[UI] Comic Sans: no embedded font found, falling back to device font");
         return null;
      }
      
      public function applyComicSansPname(param1:*, param2:Boolean) : void
      {
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         var _loc8_:TextFormat = null;
         var _loc9_:TextFormat = null;
         var _loc10_:TextFormat = null;
         var _loc11_:Object = null;
         var _loc12_:TextFormat = null;
         var _loc13_:TextFormat = null;
         if(!param1)
         {
            return;
         }
         _loc3_ = param2 ? this.findComicSansEmbedded() : null;
         _loc4_ = ["ti","tg","typ"];
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = param1[_loc4_[_loc5_]];
            if(_loc6_)
            {
               _loc7_ = "_csOrig_" + _loc4_[_loc5_];
               if(param2)
               {
                  if(param1[_loc7_] == null)
                  {
                     _loc10_ = _loc6_.defaultTextFormat;
                     param1[_loc7_] = {
                        "font":_loc10_.font,
                        "bold":_loc10_.bold,
                        "italic":_loc10_.italic,
                        "embed":_loc6_.embedFonts
                     };
                  }
                  _loc6_.embedFonts = _loc3_ != null;
                  _loc8_ = _loc6_.defaultTextFormat;
                  _loc8_.font = _loc3_ != null ? _loc3_ : "Comic Sans MS";
                  _loc8_.bold = false;
                  _loc8_.italic = false;
                  _loc6_.defaultTextFormat = _loc8_;
                  _loc9_ = new TextFormat();
                  _loc9_.font = _loc8_.font;
                  _loc9_.bold = false;
                  _loc9_.italic = false;
                  _loc6_.setTextFormat(_loc9_);
                  this.fixInputHeight(_loc6_);
               }
               else if(param1[_loc7_] != null)
               {
                  _loc11_ = param1[_loc7_];
                  _loc6_.embedFonts = _loc11_.embed == true;
                  _loc12_ = _loc6_.defaultTextFormat;
                  _loc12_.font = _loc11_.font;
                  _loc12_.bold = _loc11_.bold;
                  _loc12_.italic = _loc11_.italic;
                  _loc6_.defaultTextFormat = _loc12_;
                  _loc13_ = new TextFormat();
                  _loc13_.font = _loc11_.font;
                  _loc13_.bold = _loc11_.bold;
                  _loc13_.italic = _loc11_.italic;
                  _loc6_.setTextFormat(_loc13_);
                  this.fixInputHeight(_loc6_);
               }
            }
            _loc5_++;
         }
      }
      
      public function movieClipRasterizeInner(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:* = undefined;
         _loc2_ = 0;
         while(_loc2_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc2_) is MovieClip)
            {
               try
               {
                  _loc3_ = param1.getChildAt(_loc2_) as MovieClip;
                  if(_loc3_.visible != false)
                  {
                     _loc3_.getChildAt(0).visible = false;
                     _loc4_ = new Sprite();
                     _loc4_.addChild(this.rasterizePart(_loc3_.getChildAt(0)));
                     _loc5_ = _loc3_.addChildAt(_loc4_,0);
                     this.movieClipRasterizeInner(param1.getChildAt(_loc2_) as MovieClip);
                  }
               }
               catch(exception:*)
               {
               }
            }
            _loc2_++;
         }
      }
      
      public function getQuestValidationString(param1:Object) : String
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = undefined;
         if(param1.sField != null && this.world.getAchievement(param1.sField,param1.iIndex) != 0)
         {
            if(param1.sField == "im0")
            {
               return "Monthly Quests are only available once per month.";
            }
            if(param1.sField == "iw0")
            {
               return "Weekly Quests are only available once per week.";
            }
            return "Daily Quests are only available once per day.";
         }
         if(param1.bUpg == 1 && !this.world.myAvatar.isUpgraded())
         {
            return "Upgrade is required for this quest!";
         }
         if(param1.iSlot >= 0 && this.world.getQuestValue(param1.iSlot) < param1.iValue - 1)
         {
            return "Quest has not been unlocked!";
         }
         if(param1.iLvl > this.world.myAvatar.objData.intLevel)
         {
            return "Unlocks at Level " + param1.iLvl + ".";
         }
         if(param1.iClass > 0 && this.world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP)
         {
            _loc2_ = this.getRankFromPoints(param1.iReqCP);
            _loc3_ = param1.iReqCP - this.arrRanks[_loc2_ - 1];
            if(_loc3_ > 0)
            {
               return "Requires " + _loc3_ + " Class Points on " + param1.sClass + ", Rank " + _loc2_ + ".";
            }
            return "Requires " + param1.sClass + ", Rank " + _loc2_ + ".";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc4_ = this.getRankFromPoints(param1.iReqRep);
            _loc5_ = param1.iReqRep - this.arrRanks[_loc4_ - 1];
            if(_loc5_ > 0)
            {
               return "Requires " + _loc5_ + " Reputation for " + param1.sFaction + ", Rank " + _loc4_ + ".";
            }
            return "Requires " + param1.sFaction + ", Rank " + _loc4_ + ".";
         }
         if(param1.reqd != null && !this.hasRequiredItemsForQuest(param1))
         {
            _loc6_ = "Required Item(s): ";
            _loc7_ = 0;
            while(_loc7_ < param1.reqd.length)
            {
               _loc8_ = this.world.invTree[param1.reqd[_loc7_].ItemID];
               _loc9_ = int(param1.reqd[_loc7_].iQty);
               if(_loc8_.sES == "ar")
               {
                  _loc10_ = this.getRankFromPoints(_loc9_);
                  _loc11_ = _loc9_ - this.arrRanks[_loc10_ - 1];
                  if(_loc11_ > 0)
                  {
                     _loc6_ = _loc6_ + (_loc11_ + " Class Points on ");
                  }
                  _loc6_ = _loc6_ + (_loc8_.sName + ", Rank " + _loc10_);
               }
               else
               {
                  _loc6_ = _loc6_ + _loc8_.sName;
                  if(_loc9_ > 1)
                  {
                     _loc6_ = _loc6_ + ("x" + _loc9_);
                  }
               }
               _loc6_ = _loc6_ + ", ";
               _loc7_++;
            }
            return _loc6_.substr(0,_loc6_.length - 2) + ".";
         }
         return "";
      }
      
      private function hasRequiredItemsForQuest(param1:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         if(param1.reqd != null && param1.reqd.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.reqd.length)
            {
               _loc3_ = param1.reqd[_loc2_].ItemID;
               _loc4_ = int(param1.reqd[_loc2_].iQty);
               if(this.world.invTree[_loc3_] == null || int(this.world.invTree[_loc3_].iQty) < _loc4_)
               {
                  return false;
               }
               _loc2_++;
            }
         }
         return true;
      }
      
      public function xTryMe(param1:Object) : *
      {
         var _loc2_:String = null;
         switch(param1.sES)
         {
            case "Weapon":
            case "he":
            case "ba":
            case "pe":
            case "ar":
            case "co":
            case "mi":
               _loc2_ = param1.sES;
               _loc2_ = _loc2_ == "ar" ? "co" : _loc2_;
               if(_loc2_ == "pe")
               {
                  if(this.world.myAvatar.objData.eqp["pe"])
                  {
                     this.world.myAvatar.unloadPet();
                  }
               }
               if(!this.world.myAvatar.objData.eqp[_loc2_])
               {
                  this.world.myAvatar.objData.eqp[_loc2_] = {};
                  this.world.myAvatar.objData.eqp[_loc2_].wasCreated = true;
               }
               if(Boolean(this.world.myAvatar.objData.eqp[_loc2_].isPreview) || Boolean(this.world.myAvatar.objData.eqp[_loc2_].wasCreated))
               {
                  if(this.world.myAvatar.objData.eqp[_loc2_].sFile == param1.sFile && this.world.myAvatar.objData.eqp[_loc2_].sType == param1.sType)
                  {
                     if(this.world.myAvatar.objData.eqp[_loc2_].wasCreated)
                     {
                        delete this.world.myAvatar.objData.eqp[_loc2_];
                        this.world.myAvatar.unloadMovieAtES(_loc2_);
                     }
                     else if(this.world.myAvatar.objData.eqp[_loc2_].isPreview)
                     {
                        if(_loc2_ == "pe")
                        {
                           if(this.world.myAvatar.objData.eqp["pe"])
                           {
                              this.world.myAvatar.unloadPet();
                           }
                        }
                        this.world.myAvatar.objData.eqp[_loc2_].sType = this.world.myAvatar.objData.eqp[_loc2_].oldType;
                        this.world.myAvatar.objData.eqp[_loc2_].sFile = this.world.myAvatar.objData.eqp[_loc2_].oldFile;
                        this.world.myAvatar.objData.eqp[_loc2_].sLink = this.world.myAvatar.objData.eqp[_loc2_].oldLink;
                        this.world.myAvatar.loadMovieAtES(_loc2_,this.world.myAvatar.objData.eqp[_loc2_].oldFile,this.world.myAvatar.objData.eqp[_loc2_].oldLink);
                        this.world.myAvatar.objData.eqp[_loc2_].isPreview = null;
                     }
                     return;
                  }
               }
               if(!this.world.myAvatar.objData.eqp[_loc2_].isPreview)
               {
                  this.world.myAvatar.objData.eqp[_loc2_].isPreview = true;
                  if(!this.world.myAvatar.objData.eqp[_loc2_].isShowable)
                  {
                     if("sType" in param1)
                     {
                        this.world.myAvatar.objData.eqp[_loc2_].oldType = this.world.myAvatar.objData.eqp[_loc2_].sType;
                     }
                     this.world.myAvatar.objData.eqp[_loc2_].oldFile = this.world.myAvatar.objData.eqp[_loc2_].sFile;
                     this.world.myAvatar.objData.eqp[_loc2_].oldLink = this.world.myAvatar.objData.eqp[_loc2_].sLink;
                  }
               }
               if("sType" in param1)
               {
                  this.world.myAvatar.objData.eqp[_loc2_].sType = param1.sType;
               }
               this.world.myAvatar.objData.eqp[_loc2_].sFile = param1.sFile == "undefined" ? "" : param1.sFile;
               this.world.myAvatar.objData.eqp[_loc2_].sLink = param1.sLink;
               this.world.myAvatar.loadMovieAtES(_loc2_,param1.sFile,param1.sLink);
               if(_loc2_ == "pe" && param1.sName.indexOf("Bank Pet") != -1)
               {
                  this.petDisable.addEventListener(TimerEvent.TIMER,this.onPetDisable,false,0,true);
                  this.petDisable.start();
               }
               this.hasPreviewed = true;
         }
      }
      
      internal function onPetDisable(param1:TimerEvent) : void
      {
         if(!this.world.myAvatar.petMC.mcChar)
         {
            return;
         }
         this.world.myAvatar.petMC.mcChar.mouseEnabled = false;
         this.world.myAvatar.petMC.mcChar.mouseChildren = false;
         this.world.myAvatar.petMC.mcChar.enabled = false;
         this.petDisable.reset();
         this.petDisable.removeEventListener(TimerEvent.TIMER,this.onPetDisable);
      }
      
      public function showPortrait(param1:Avatar) : *
      {
         if(this.litePreference.data.bHideUI)
         {
            return;
         }
         this.showPortraitBox(param1,this.ui.mcPortrait);
         this.world.updatePortrait(param1);
         this.ui.iconQuest.visible = true;
         this.ui.monsterIcon.visible = true;
      }
      
      public function hidePortrait() : void
      {
         this.ui.monsterIcon.visible = false;
         this.ui.mcPortrait.visible = false;
         this.ui.iconQuest.visible = false;
      }
      
      public function showPortraitTarget(param1:Avatar) : *
      {
         if(this.litePreference.data.bHideUI)
         {
            return;
         }
         this.showPortraitBox(Number(this.world.objExtra["bChar"]) == 1 ? this.world.myAvatar : param1,this.ui.mcPortraitTarget);
         this.ui.mcPortraitTarget.pvpIcon.visible = this.world.bPvP;
         this.world.updatePortrait(param1);
         this.ui.btnTargetPortraitClose.visible = true;
      }
      
      public function hidePortraitTarget() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:DisplayObject = null;
         _loc1_ = this.ui.mcPortraitTarget.mcHead as MovieClip;
         _loc2_ = _loc1_.head.getChildByName("face");
         if(_loc2_ != null)
         {
            _loc1_.head.removeChild(_loc2_);
         }
         while(_loc1_.backhair.numChildren > 0)
         {
            _loc1_.backhair.removeChildAt(0);
         }
         while(_loc1_.head.hair.numChildren > 0)
         {
            _loc1_.head.hair.removeChildAt(0);
         }
         while(_loc1_.head.helm.numChildren > 0)
         {
            _loc1_.head.helm.removeChildAt(0);
         }
         this.ui.mcPortraitTarget.visible = false;
         this.ui.btnTargetPortraitClose.visible = false;
      }
      
      public function showPortraitBox(param1:Avatar, param2:MovieClip) : *
      {
         var AssetClass:Class = null;
         var mc:MovieClip = null;
         var child:DisplayObject = null;
         var bBackHair:Boolean = false;
         var sSkinLink:String = null;
         var AssetClass2:Class = null;
         var avt:Avatar = param1;
         var mcPortraitBox:MovieClip = param2;
         mc = mcPortraitBox.mcHead as MovieClip;
         bBackHair = false;
         mcPortraitBox.pAV = avt;
         if(avt.npcType == "monster")
         {
            AssetClass = this.world.getClass("mcHead" + avt.objData.strLinkage);
            child = mc.head.getChildByName("face");
            if(child != null)
            {
               mc.head.removeChild(child);
            }
            mc.head.addChildAt(new AssetClass(),0).name = "face";
            mc.head.hair.visible = false;
            mc.head.helm.visible = false;
            mc.backhair.visible = false;
         }
         else
         {
            try
            {
               sSkinLink = avt.objData.eqp.ar.sLink;
               if(avt.objData.eqp.co != null)
               {
                  sSkinLink = avt.objData.eqp.co.sLink;
               }
               AssetClass = this.world.getClass(sSkinLink + avt.objData.strGender + "Head");
               child = mc.head.getChildByName("face");
               if(child != null)
               {
                  mc.head.removeChild(child);
               }
               mc.head.addChildAt(new AssetClass(),0).name = "face";
            }
            catch(err:Error)
            {
               AssetClass = world.getClass("mcHead" + avt.objData.strGender);
               child = mc.head.getChildByName("face");
               if(child != null)
               {
                  mc.head.removeChild(child);
               }
               mc.head.addChildAt(new AssetClass(),0).name = "face";
            }
            AssetClass = this.world.getClass(avt.objData.strHairName + avt.objData.strGender + "Hair");
            while(mc.head.hair.numChildren > 0)
            {
               mc.head.hair.removeChildAt(0);
            }
            try
            {
               mc.head.hair.addChild(new AssetClass());
            }
            catch(e:Error)
            {
            }
            mc.head.hair.visible = true;
            try
            {
               AssetClass = this.world.getClass(avt.objData.strHairName + avt.objData.strGender + "HairBack");
               while(mc.backhair.numChildren > 0)
               {
                  mc.backhair.removeChildAt(0);
               }
               mc.backhair.addChild(new AssetClass());
               mc.backhair.visible = true;
               bBackHair = true;
            }
            catch(err:Error)
            {
               mc.backhair.visible = false;
            }
            if(avt.objData.eqp.he != null && avt.objData.eqp.he.sLink != null)
            {
               try
               {
                  AssetClass = this.world.getClass(avt.objData.eqp.he.sLink);
                  AssetClass2 = this.world.getClass(avt.objData.eqp.he.sLink + "_backhair") as Class;
                  while(mc.head.helm.numChildren > 0)
                  {
                     mc.head.helm.removeChildAt(0);
                  }
                  mc.head.helm.addChild(new AssetClass());
                  mc.head.helm.visible = avt.dataLeaf.showHelm;
                  mc.head.hair.visible = !mc.head.helm.visible;
                  if(AssetClass2 != null)
                  {
                     if(avt.dataLeaf.showHelm)
                     {
                        if(mc.backhair.numChildren > 0)
                        {
                           mc.backhair.removeChildAt(0);
                        }
                        mc.backhair.visible = true;
                        mc.backhair.addChild(new AssetClass2());
                     }
                  }
                  else
                  {
                     mc.backhair.visible = mc.head.hair.visible && bBackHair;
                  }
               }
               catch(err:Error)
               {
                  mc.head.helm.visible = false;
               }
            }
            else
            {
               mc.head.helm.visible = false;
            }
         }
         mcPortraitBox.visible = true;
         this.ui.mcPortrait.iconDrops.initRoot(this);
         this.ui.mcPortrait.iconDrops.visible = this.litePreference.data.bCustomDrops;
      }
      
      public function oniconQuestClick(param1:MouseEvent) : void
      {
         if(this.litePreference.data.bQuestPin)
         {
            if(param1.shiftKey)
            {
               this.ui.mcQTracker.toggle();
               return;
            }
            this.world.showQuests(this.pinnedQuests,"q");
         }
         else
         {
            this.ui.mcQTracker.toggle();
         }
      }
      
      public function manageXPBoost(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.ui.mcPortrait.iconBoostXP.visible = param1.op == "+";
         if(param1.op == "+")
         {
            this.world.myAvatar.objData.iBoostXP = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostXP.boostTS = new Date().getTime();
            this.ui.mcPortrait.iconBoostXP.iBoostXP = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostXP.bShowShop = param1.bShowShop;
            this.addUpdate("You have activated the Experience Boost!  All Experience rewards are doubled while the effect holds.");
            this.chatF.pushMsg("server","You have activated the Experience Boost!  All Experience rewards are doubled while the effect holds. " + Math.ceil(param1.iSecsLeft / 60) + " minute(s) remaining.","SERVER","",0);
         }
         else
         {
            delete this.world.myAvatar.objData.iBoostXP;
            delete this.ui.mcPortrait.iconBoostXP.boostTS;
            delete this.ui.mcPortrait.iconBoostXP.iBoostXP;
            this.addUpdate("The Experience Boost has faded!  Experience rewards are no longer doubled.");
            this.chatF.pushMsg("server","The Experience Boost has faded!  Experience rewards are no longer doubled.","SERVER","",0);
            if(this.ui.mcPortrait.iconBoostXP.bShowShop != null && Boolean(this.ui.mcPortrait.iconBoostXP.bShowShop))
            {
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Your Experience Boost has faded!\tExperience rewards are no longer doubled.  Would you like to purchase a new Experience Boost?";
               _loc3_.params = {};
               _loc3_.callback = this.openExpBoostStore;
               _loc3_.glow = "red,medium";
               this.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
            }
         }
      }
      
      public function manageGBoost(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.ui.mcPortrait.iconBoostG.visible = param1.op == "+";
         if(param1.op == "+")
         {
            this.world.myAvatar.objData.iBoostG = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostG.boostTS = new Date().getTime();
            this.ui.mcPortrait.iconBoostG.iBoostG = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostG.bShowShop = param1.bShowShop;
            this.addUpdate("You have activated the Gold Boost!  All Gold rewards are doubled while the effect holds.");
            this.chatF.pushMsg("server","You have activated the Gold Boost!  All Gold rewards are doubled while the effect holds. " + Math.ceil(param1.iSecsLeft / 60) + " minute(s) remaining.","SERVER","",0);
         }
         else
         {
            delete this.world.myAvatar.objData.iBoostG;
            delete this.ui.mcPortrait.iconBoostG.boostTS;
            delete this.ui.mcPortrait.iconBoostG.iBoostG;
            this.addUpdate("The Gold Boost has faded!  Gold rewards are no longer doubled.");
            this.chatF.pushMsg("server","The Gold Boost has faded!  Gold rewards are no longer doubled.","SERVER","",0);
            if(this.ui.mcPortrait.iconBoostG.bShowShop != null && Boolean(this.ui.mcPortrait.iconBoostG.bShowShop))
            {
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Your Gold Boost has faded!  Gold rewards are no longer doubled.  Would you like to purchase a new Gold Boost?";
               _loc3_.params = {};
               _loc3_.callback = this.openExpBoostStore;
               _loc3_.glow = "red,medium";
               this.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
            }
         }
      }
      
      public function manageRepBoost(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.ui.mcPortrait.iconBoostRep.visible = param1.op == "+";
         if(param1.op == "+")
         {
            this.world.myAvatar.objData.iBoostRep = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostRep.boostTS = new Date().getTime();
            this.ui.mcPortrait.iconBoostRep.iBoostRep = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostRep.bShowShop = param1.bShowShop;
            this.addUpdate("You have activated the Reputation Boost!  All Reputation rewards are doubled while the effect holds.");
            this.chatF.pushMsg("server","You have activated the Reputation Boost!  All Reputation rewards are doubled while the effect holds. " + Math.ceil(param1.iSecsLeft / 60) + " minute(s) remaining.","SERVER","",0);
         }
         else
         {
            delete this.world.myAvatar.objData.iBoostRep;
            delete this.ui.mcPortrait.iconBoostRep.boostTS;
            delete this.ui.mcPortrait.iconBoostRep.iBoostRep;
            this.addUpdate("The Reputation Boost has faded!  Reputation rewards are no longer doubled.");
            this.chatF.pushMsg("server","The Reputation Boost has faded!  Reputation rewards are no longer doubled.","SERVER","",0);
            if(this.ui.mcPortrait.iconBoostRep.bShowShop != null && Boolean(this.ui.mcPortrait.iconBoostRep.bShowShop))
            {
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Your Reputation Boost has faded!\tReputation rewards are no longer doubled.  Would you like to purchase a new Reputation Boost?";
               _loc3_.params = {};
               _loc3_.callback = this.openExpBoostStore;
               _loc3_.glow = "red,medium";
               this.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
            }
         }
      }
      
      public function manageCPBoost(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.ui.mcPortrait.iconBoostCP.visible = param1.op == "+";
         if(param1.op == "+")
         {
            this.world.myAvatar.objData.iBoostCP = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostCP.boostTS = new Date().getTime();
            this.ui.mcPortrait.iconBoostCP.iBoostCP = param1.iSecsLeft;
            this.ui.mcPortrait.iconBoostCP.bShowShop = param1.bShowShop;
            this.addUpdate("You have activated the ClassPoint Boost!  All ClassPoint rewards are doubled while the effect holds.");
            this.chatF.pushMsg("server","You have activated the ClassPoint Boost!  All ClassPoint rewards are doubled while the effect holds. " + Math.ceil(param1.iSecsLeft / 60) + " minute(s) remaining.","SERVER","",0);
         }
         else
         {
            delete this.world.myAvatar.objData.iBoostCP;
            delete this.ui.mcPortrait.iconBoostCP.boostTS;
            delete this.ui.mcPortrait.iconBoostCP.iBoostCP;
            this.addUpdate("The ClassPoint Boost has faded!  ClassPoint rewards are no longer doubled.");
            this.chatF.pushMsg("server","The ClassPoint Boost has faded!  ClassPoint rewards are no longer doubled.","SERVER","",0);
            if(this.ui.mcPortrait.iconBoostCP.bShowShop != null && Boolean(this.ui.mcPortrait.iconBoostCP.bShowShop))
            {
               _loc2_ = new ModalMC();
               _loc3_ = {};
               _loc3_.strBody = "Your ClassPoint Boost has faded!\tClassPoint rewards are no longer doubled.  Would you like to purchase a new ClassPoint Boost?";
               _loc3_.params = {};
               _loc3_.callback = this.openExpBoostStore;
               _loc3_.glow = "red,medium";
               this.ui.ModalStack.addChild(_loc2_);
               _loc2_.init(_loc3_);
            }
         }
      }
      
      public function oniconBoostXPOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc2_ = MovieClip(param1.currentTarget);
         _loc3_ = Number(new Date().getTime());
         _loc4_ = Math.max(_loc2_.boostTS + _loc2_.iBoostXP * 1000 - _loc3_,0);
         _loc5_ = 0;
         _loc6_ = "All Experience gains are doubled.\n";
         if(_loc4_ < 120000)
         {
            _loc5_ = Math.floor(_loc4_ / 60000);
            _loc6_ = _loc6_ + String(_loc5_ + " minute(s), ");
            _loc5_ = Math.round(_loc4_ % 60000 / 1000);
            _loc6_ = _loc6_ + String(_loc5_ + " second(s) remaining.");
         }
         else
         {
            _loc5_ = Math.round(_loc4_ / 60000);
            _loc6_ = _loc6_ + String(_loc5_ + " minutes remaining.");
         }
         this.ui.ToolTip.openWith({"str":_loc6_});
      }
      
      public function oniconBoostGoldOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc2_ = MovieClip(param1.currentTarget);
         _loc3_ = Number(new Date().getTime());
         _loc4_ = Math.max(_loc2_.boostTS + _loc2_.iBoostG * 1000 - _loc3_,0);
         _loc5_ = 0;
         _loc6_ = "All Gold gains are doubled.\n";
         if(_loc4_ < 120000)
         {
            _loc5_ = Math.floor(_loc4_ / 60000);
            _loc6_ = _loc6_ + String(_loc5_ + " minute(s), ");
            _loc5_ = Math.round(_loc4_ % 60000 / 1000);
            _loc6_ = _loc6_ + String(_loc5_ + " second(s) remaining.");
         }
         else
         {
            _loc5_ = Math.round(_loc4_ / 60000);
            _loc6_ = _loc6_ + String(_loc5_ + " minutes remaining.");
         }
         this.ui.ToolTip.openWith({"str":_loc6_});
      }
      
      public function oniconBoostRepOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc2_ = MovieClip(param1.currentTarget);
         _loc3_ = Number(new Date().getTime());
         _loc4_ = Math.max(_loc2_.boostTS + _loc2_.iBoostRep * 1000 - _loc3_,0);
         _loc5_ = 0;
         _loc6_ = "All Reputation gains are doubled.\n";
         if(_loc4_ < 120000)
         {
            _loc5_ = Math.floor(_loc4_ / 60000);
            _loc6_ = _loc6_ + String(_loc5_ + " minute(s), ");
            _loc5_ = Math.round(_loc4_ % 60000 / 1000);
            _loc6_ = _loc6_ + String(_loc5_ + " second(s) remaining.");
         }
         else
         {
            _loc5_ = Math.round(_loc4_ / 60000);
            _loc6_ = _loc6_ + String(_loc5_ + " minutes remaining.");
         }
         this.ui.ToolTip.openWith({"str":_loc6_});
      }
      
      public function oniconBoostCPOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         _loc2_ = MovieClip(param1.currentTarget);
         _loc3_ = Number(new Date().getTime());
         _loc4_ = Math.max(_loc2_.boostTS + _loc2_.iBoostCP * 1000 - _loc3_,0);
         _loc5_ = 0;
         _loc6_ = "All ClassPoint gains are doubled.\n";
         if(_loc4_ < 120000)
         {
            _loc5_ = Math.floor(_loc4_ / 60000);
            _loc6_ = _loc6_ + String(_loc5_ + " minute(s), ");
            _loc5_ = Math.round(_loc4_ % 60000 / 1000);
            _loc6_ = _loc6_ + String(_loc5_ + " second(s) remaining.");
         }
         else
         {
            _loc5_ = Math.round(_loc4_ / 60000);
            _loc6_ = _loc6_ + String(_loc5_ + " minutes remaining.");
         }
         this.ui.ToolTip.openWith({"str":_loc6_});
      }
      
      public function openExpBoostStore(param1:Object) : void
      {
         if(param1.accept)
         {
            this.world.sendLoadShopRequest(184);
         }
      }
      
      public function oniconBoostOut(param1:MouseEvent) : void
      {
         this.ui.ToolTip.close();
      }
      
      public function updateXPBar() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.ui == null || this.ui.mcInterface == null || this.world == null || this.world.myAvatar == null || this.world.myAvatar.objData == null)
         {
            return;
         }
         _loc1_ = this.world.myAvatar.objData.intExp / this.world.myAvatar.objData.intExpToLevel;
         this.ui.mcInterface.mcXPBar.mcXP.scaleX = _loc1_ > 1 ? 1 : _loc1_;
         _loc2_ = this.world.myAvatar.objData;
         _loc3_ = _loc2_.intExp;
         _loc4_ = _loc2_.intExpToLevel;
         _loc5_ = int(_loc3_ / _loc4_ * 100);
         if(_loc5_ >= 100)
         {
            _loc5_ = 100;
         }
         this.ui.mcInterface.mcXPBar.strXP.text = "Level " + this.world.myAvatar.objData.intLevel + " : " + _loc3_ + " / " + _loc4_ + "  (" + _loc5_ + "%)";
         this.fixInputHeight(this.ui.mcInterface.mcXPBar.strXP);
      }
      
      public function xpBarMouseOver(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).strXP.visible = true;
      }
      
      public function xpBarMouseOut(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).strXP.visible = false;
      }
      
      public function updateRepBar() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.ui == null || this.ui.mcInterface == null || this.world == null || this.world.myAvatar == null || this.world.myAvatar.objData == null)
         {
            return;
         }
         _loc1_ = this.world.myAvatar.objData.iCurCP;
         _loc2_ = this.world.myAvatar.objData.iCPToRank;
         if(_loc2_ <= 0)
         {
            this.ui.mcInterface.mcRepBar.mcRep.scaleX = 0.1;
            this.ui.mcInterface.mcRepBar.mcRep.visible = false;
            this.ui.mcInterface.mcRepBar.strRep.text = this.world.myAvatar.objData.strClassName + ", Rank " + this.world.myAvatar.objData.iRank;
         }
         else
         {
            _loc3_ = int(_loc1_ / _loc2_ * 100);
            if(_loc3_ >= 100)
            {
               _loc3_ = 100;
            }
            this.ui.mcInterface.mcRepBar.mcRep.scaleX = _loc1_ / _loc2_;
            this.ui.mcInterface.mcRepBar.mcRep.visible = true;
            this.ui.mcInterface.mcRepBar.strRep.text = this.world.myAvatar.objData.strClassName + ", Rank " + this.world.myAvatar.objData.iRank + " : " + _loc1_ + "/" + _loc2_ + "  (" + _loc3_ + "%)";
         }
      }
      
      public function onRepBarMouseOver(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).strRep.visible = true;
      }
      
      public function onRepBarMouseOut(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).strRep.visible = false;
      }
      
      public function disabledDelay(param1:TimerEvent) : void
      {
      }
      
      public function actIconClick(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = MovieClip(param1.currentTarget).actObj;
         if(_loc2_.auto != null && _loc2_.auto == true)
         {
            this.world.approachTarget();
         }
         else
         {
            this.world.testAction(_loc2_);
         }
      }
      
      public function determineIndex(param1:Number) : Number
      {
         var _loc2_:Number = NaN;
         _loc2_ = 10;
         if(param1 <= 3)
         {
            _loc2_ = param1;
         }
         else if(param1 == 4)
         {
            _loc2_ = 5;
         }
         else if(param1 <= 6)
         {
            _loc2_ = 4;
         }
         return _loc2_;
      }
      
      public function actIconOver(param1:MouseEvent) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:* = undefined;
         var _loc4_:* = null;
         _loc2_ = MovieClip(param1.currentTarget);
         if(Boolean(this.uoPref.bTT) || this.world.myAvatar.dataLeaf.intState != 2)
         {
            if(_loc2_.item == null)
            {
               _loc3_ = _loc2_.actObj;
               if(_loc3_ != null)
               {
                  _loc3_.desc = _loc3_.desc.replace(this.regExLineSpace,"\n");
                  _loc4_ = "<b>" + _loc3_.nam + "</b>\n";
                  if(!_loc3_.isOK)
                  {
                     _loc4_ = _loc4_ + ("<font color=\'#FF0000\'>Unlocks at Rank " + String(this.determineIndex(_loc2_.actionIndex)) + "!</font>\n");
                  }
                  if(_loc3_.typ != "passive")
                  {
                     if(_loc3_.mp > 0)
                     {
                        _loc4_ = _loc4_ + ("<font color=\'#0033AA\'>" + _loc3_.mp + "</font> mana, ");
                     }
                     _loc4_ = _loc4_ + ("<font color=\'#AA3300\'>" + _loc3_.cd / 1000 + "</font> sec cooldown" + "\n");
                  }
                  switch(_loc3_.typ)
                  {
                     case "p":
                     case "ph":
                     case "aa":
                        _loc4_ = _loc4_ + "Physical";
                        break;
                     case "m":
                        _loc4_ = _loc4_ + "Magical";
                        break;
                     case "ma":
                        _loc4_ = _loc4_ + "True Damage";
                        break;
                     case "pm":
                     case "mp":
                        _loc4_ = _loc4_ + "Hybrid";
                        break;
                     case "passive":
                        _loc4_ = _loc4_ + "<font color=\'#0033AA\'>Passive Ability</font>";
                  }
                  _loc4_ = _loc4_ + "\n";
                  if(_loc3_.typ != "passive")
                  {
                     if(_loc3_.range <= 301)
                     {
                        _loc4_ = _loc4_ + "A <font color=\'#AA3300\'>short range</font> ";
                     }
                     else if(_loc3_.range >= 3000)
                     {
                        _loc4_ = _loc4_ + "An <font color=\'#0033AA\'>infinite range</font> ";
                     }
                     else if(_loc3_.range >= 808)
                     {
                        _loc4_ = _loc4_ + "A <font color=\'#0033AA\'>long range</font> ";
                     }
                     else
                     {
                        _loc4_ = _loc4_ + "A <font color=\'#AA3300\'>medium range</font> ";
                     }
                     if(!_loc3_.damage)
                     {
                        _loc4_ = _loc4_ + "status skill that applies to ";
                     }
                     else
                     {
                        _loc4_ = _loc4_ + ((_loc3_.damage < 0 ? "skill" : "attack") + " that " + (_loc3_.damage < 0 ? "heals " : "deals damage to "));
                     }
                     if(_loc3_.tgt == "f")
                     {
                        _loc4_ = _loc4_ + ("<font color=\'#0033AA\'>" + (_loc3_.tgtMax || 1));
                        _loc4_ = _loc4_ + (_loc3_.tgtMax > 1 ? " friendly targets.</font>" : " target.</font>");
                     }
                     else if(_loc3_.tgt == "s")
                     {
                        _loc4_ = _loc4_ + "<font color=\'#0033AA\'>yourself.</font>";
                     }
                     else
                     {
                        _loc4_ = _loc4_ + ("<font color=\'#AA3300\'>" + (_loc3_.tgtMax || 1));
                        _loc4_ = _loc4_ + (_loc3_.tgtMax > 1 ? " hostile targets.</font>" : " target.</font>");
                     }
                     _loc4_ = _loc4_ + "\n\n";
                  }
                  if(_loc3_.sArg2 != "")
                  {
                     _loc4_ = _loc4_ + _loc3_.sArg2;
                  }
                  else
                  {
                     _loc4_ = _loc4_ + _loc3_.desc;
                  }
                  this.ui.ToolTip.openWith({
                     "str":_loc4_,
                     "lowerright":true
                  });
               }
            }
            else
            {
               this.ui.ToolTip.openWith({
                  "str":_loc2_.item.sName + "\n" + "<font color=\'#AA3300\'>" + _loc2_.actObj.cd / 1000 + "</font> sec cooldown\n" + _loc2_.item.sDesc,
                  "lowerright":true
               });
            }
         }
      }
      
      public function actIconOut(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = MovieClip(stage.getChildAt(0)).ui.ToolTip;
         _loc2_.close();
      }
      
      public function portraitClick(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc2_ = MovieClip(param1.currentTarget);
         if(_loc2_.pAV.npcType == "player")
         {
            _loc3_ = {};
            _loc3_.ID = _loc2_.pAV.objData.CharID;
            _loc3_.strUsername = _loc2_.pAV.objData.strUsername;
            if(_loc2_.pAV != this.world.myAvatar)
            {
               this.ui.cMenu.fOpenWith("user",_loc3_);
            }
            else
            {
               this.ui.cMenu.fOpenWith("self",_loc3_);
            }
         }
         else if(_loc2_.pAV.npcType == "monster")
         {
            _loc3_ = {};
            _loc3_.ID = _loc2_.pAV.objData.MonMapID;
            _loc3_.strUsername = _loc2_.pAV.objData.strMonName;
            _loc3_.target = this.world.getMonster(_loc3_.ID).pMC;
            this.ui.cMenu.fOpenWith("mons",_loc3_);
         }
      }
      
      private function onTargetPortraitCloseClick(param1:MouseEvent) : void
      {
         this.world.cancelTarget();
      }
      
      private function onBtnMonsterClick(param1:MouseEvent) : void
      {
         this.world.toggleMonsters();
      }
      
      public function showMap() : void
      {
         this.ui.mcInterface.mcMenu.mcMenuButtons.visible = true;
         this.ui.mcPopup.fOpen("Map");
      }
      
      public function logout() : void
      {
         try
         {
            if(Boolean(this.intChatMode) && Boolean(this.chatF.bTall))
            {
               this.ui.mcInterface.ncModeChat.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
         }
         catch(eLO:Error)
         {
            trace("[Game] ERR logout pre-send: " + eLO.message);
         }
         try
         {
            if(this.litePreference.data.bCharSelect)
            {
               this.saveChar();
            }
         }
         catch(eLO2:Error)
         {
            trace("[Game] ERR logout saveChar: " + eLO2.message);
         }
         trace("[Game] logout called");
         this.sfc.sendXtMessage("zm","cmd",["logout"],"str",1);
      }
      
      public function showServerList() : void
      {
         try
         {
            if(Boolean(this.intChatMode) && Boolean(this.chatF.bTall))
            {
               this.ui.mcInterface.ncModeChat.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
         }
         catch(eSL:Error)
         {
            trace("[Game] ERR showServerList pre-send: " + eSL.message);
         }
         try
         {
            if(this.litePreference.data.bCharSelect)
            {
               this.saveChar();
            }
         }
         catch(eSL2:Error)
         {
            trace("[Game] ERR showServerList saveChar: " + eSL2.message);
         }
         this.showServers = true;
         this.sfc.sendXtMessage("zm","cmd",["logout"],"str",1);
      }
      
      public function showUpgradeWindow(param1:Object = null) : void
      {
         var _loc2_:MovieClip = null;
         if(mcUpgradeWindow == null)
         {
            mcUpgradeWindow = new MCUpgradeWindow();
         }
         _loc2_ = mcUpgradeWindow as MovieClip;
         var _loc3_:* = param1 != null ? param1 : this.world.myAvatar.objData;
         _loc2_.btnClose.addEventListener(MouseEvent.CLICK,this.hideUpgradeWindow,false,0,true);
         _loc2_.btnClose2.addEventListener(MouseEvent.CLICK,this.hideUpgradeWindow,false,0,true);
         _loc2_.btnBuy.addEventListener(MouseEvent.CLICK,this.onUpgradeClick,false,0,true);
         addChild(mcUpgradeWindow);
         try
         {
            this.ui.mouseChildren = false;
            this.world.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
         try
         {
            this.mcLogin.sl.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
      }
      
      public function hideUpgradeWindow(param1:MouseEvent) : void
      {
         removeChild(mcUpgradeWindow);
         try
         {
            this.ui.mouseChildren = true;
            this.world.mouseChildren = true;
         }
         catch(e:Error)
         {
         }
         try
         {
            this.mcLogin.sl.mouseChildren = true;
         }
         catch(e:Error)
         {
         }
      }
      
      public function onUpgradeClick(param1:Event) : void
      {
         var _loc2_:String = null;
         this.mixer.playSound("Click");
         if(ISWEB)
         {
            this.extCall.setUpPayment(this.sToken);
         }
         else
         {
            _loc2_ = "https://www.aq.com/order-now/direct/default.asp?cid=" + this.world.myAvatar.objData.CharID + "&token=" + loginInfo.strToken;
            navigateToURL(new URLRequest(_loc2_),"_blank");
         }
      }
      
      public function showACWindow() : void
      {
         var _loc1_:MovieClip = null;
         if(mcACWindow == null)
         {
            mcACWindow = new MCACWindow();
         }
         _loc1_ = mcACWindow as MovieClip;
         _loc1_.btnClose.addEventListener(MouseEvent.CLICK,this.hideACWindow,false,0,true);
         _loc1_.btnClose2.addEventListener(MouseEvent.CLICK,this.hideACWindow,false,0,true);
         _loc1_.btnBuy.addEventListener(MouseEvent.CLICK,this.onUpgradeClick,false,0,true);
         _loc1_.btnUpgrade.addEventListener(MouseEvent.CLICK,this.onUpgradeClick,false,0,true);
         addChild(mcACWindow);
         try
         {
            this.ui.mouseChildren = false;
            this.world.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
         try
         {
            this.mcLogin.sl.mouseChildren = false;
         }
         catch(e:Error)
         {
         }
      }
      
      public function hideACWindow(param1:MouseEvent) : void
      {
         removeChild(mcACWindow);
         try
         {
            this.ui.mouseChildren = true;
            this.world.mouseChildren = true;
         }
         catch(e:Error)
         {
         }
         try
         {
            this.mcLogin.sl.mouseChildren = true;
         }
         catch(e:Error)
         {
         }
      }
      
      public function initArrHP() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:* = undefined;
         _loc1_ = 100;
         _loc2_ = 550;
         _loc3_ = 275;
         _loc4_ = 0.8;
         _loc5_ = 720;
         _loc6_ = 200;
         _loc7_ = 0.92;
         _loc8_ = 350;
         _loc9_ = 3650;
         _loc10_ = 1.1;
         _loc11_ = 0;
         while(_loc11_ < _loc1_)
         {
            if(_loc11_ > 19)
            {
               this.arrHP.push(Math.round(_loc8_ + Math.pow(_loc11_ / _loc1_,_loc10_) * _loc9_));
            }
            else if(_loc11_ > 7)
            {
               this.arrHP.push(Math.round(_loc5_ + Math.pow(_loc11_ / 20,_loc7_) * _loc6_));
            }
            else
            {
               this.arrHP.push(Math.round(_loc2_ + Math.pow(_loc11_ / 8,_loc4_) * _loc3_));
            }
            _loc11_++;
         }
      }
      
      public function initArrRep() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         _loc1_ = 0;
         _loc2_ = 1;
         while(_loc2_ < 10)
         {
            _loc1_ = Math.pow(_loc2_ + 1,3) * 100;
            if(_loc2_ > 1)
            {
               this.arrRanks.push(_loc1_ + this.arrRanks[_loc2_ - 1]);
            }
            else
            {
               this.arrRanks.push(_loc1_ + 100);
            }
            _loc2_++;
         }
      }
      
      public function getRankFromPoints(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         _loc2_ = 1;
         if(param1 < 0)
         {
            param1 = 0;
         }
         _loc3_ = 1;
         while(_loc3_ < this.arrRanks.length)
         {
            if(param1 < this.arrRanks[_loc3_])
            {
               return _loc2_;
            }
            _loc2_++;
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function attachOnModalStack(param1:String) : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Class = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         _loc3_ = this.world.getClass(param1) as Class;
         _loc4_ = true;
         if(this.ui.ModalStack.numChildren)
         {
            _loc2_ = MovieClip(this.ui.ModalStack.getChildAt(0));
            _loc5_ = _loc2_.constructor as Class;
            if(_loc5_ == _loc3_)
            {
               _loc4_ = false;
            }
         }
         if(_loc4_)
         {
            this.clearModalStack();
            _loc2_ = MovieClip(this.ui.ModalStack.addChild(new _loc3_()));
            this.ui.ModalStack.mouseChildren = true;
         }
         return _loc2_;
      }
      
      public function getInstanceFromModalStack(param1:String) : MovieClip
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.ui.ModalStack.numChildren)
         {
            if(getQualifiedClassName(this.ui.ModalStack.getChildAt(_loc2_) == param1))
            {
               return this.ui.ModalStack.getChildAt(_loc2_);
            }
            _loc2_++;
         }
         return null;
      }
      
      public function isDialoqueUp() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < this.world.FG.numChildren)
         {
            _loc2_ = this.world.FG.getChildAt(_loc1_);
            _loc3_ = String(_loc2_ as MovieClip);
            if(_loc3_.indexOf("dlg_") > -1)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function clearModalStack() : Boolean
      {
         var _loc1_:int = 0;
         if(this.isGreedyModalInStack())
         {
            return false;
         }
         _loc1_ = 0;
         while(this.ui.ModalStack.numChildren > 0 && _loc1_ < 100)
         {
            _loc1_++;
            this.ui.ModalStack.removeChildAt(0);
         }
         stage.focus = null;
         return true;
      }
      
      public function closeModalByStrBody(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = 0;
         _loc2_ = 0;
         while(_loc2_ < this.ui.ModalStack.numChildren)
         {
            _loc3_ = this.ui.ModalStack.getChildAt(_loc2_) as MovieClip;
            if(_loc3_.cnt.strBody.htmlText.indexOf(param1) > -1 && _loc3_.currentLabel != "out")
            {
               _loc3_.fClose();
            }
            _loc2_++;
         }
      }
      
      public function isGreedyModalInStack() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < this.ui.ModalStack.numChildren)
         {
            _loc2_ = this.ui.ModalStack.getChildAt(_loc1_) as MovieClip;
            if("greedy" in _loc2_ && _loc2_.greedy != null && _loc2_.greedy == true)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function clearPopups(param1:Array = null) : void
      {
         if(this.ui.mcPopup.currentLabel == "House")
         {
            this.ui.mcPopup.mcHouseMenu.hideItemHandle();
         }
         if(param1 == null || param1.indexOf(this.ui.mcPopup.currentLabel) < 0)
         {
            this.ui.mcPopup.onClose();
         }
         this.world.removeMovieFront();
         this.clearModalStack();
      }
      
      public function clearPopupsQ() : void
      {
         if(this.ui.mcPopup.currentLabel != "House" && this.ui.mcPopup.currentLabel != "HouseShop")
         {
            this.ui.mcPopup.onClose();
         }
      }
      
      public function addUpdate(param1:String, param2:Boolean = false) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         _loc3_ = this.ui.mcUpdates;
         _loc4_ = _loc3_.addChildAt(new uProto(),1) as MovieClip;
         _loc4_.y = 0;
         _loc4_.x = _loc3_.uproto.x;
         _loc4_.t1.ti.text = param1;
         if(param2)
         {
            _loc4_.t1.ti.textColor = 16711680;
         }
         _loc4_.gotoAndPlay("in");
         _loc5_ = 2;
         if(_loc3_.numChildren > 2)
         {
            _loc5_ = 2;
            while(_loc5_ < _loc3_.numChildren)
            {
               if(_loc5_ < 4)
               {
                  _loc3_.getChildAt(_loc5_).y = _loc3_.getChildAt(_loc5_).y - 18;
               }
               else
               {
                  MovieClip(_loc3_.getChildAt(_loc5_)).stop();
                  _loc3_.removeChildAt(_loc5_);
                  _loc5_--;
               }
               _loc5_++;
            }
         }
      }
      
      public function clearUpdates() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = this.ui.mcUpdates;
         while(_loc1_.numChildren > 1)
         {
            _loc1_.removeChildAt(1);
         }
      }
      
      public function showItemDrop(param1:*, param2:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:DFrame2MC = null;
         if(Boolean(this.litePreference.data.bCustomDrops) && (param1.bTemp == 0 && param2))
         {
            this.cDropsUI.showItem(param1);
            return;
         }
         if(Boolean(this.litePreference.data.dOptions["hideDrop"]) && Boolean(this.litePreference.data.bCustomDrops) && param1.bTemp == 0)
         {
            return;
         }
         if(Boolean(this.litePreference.data.dOptions["hideTemp"]) && Boolean(this.litePreference.data.bCustomDrops) && param1.bTemp != 0)
         {
            return;
         }
         if(Boolean(this.litePreference.data.bCustomDrops) && (param1.bTemp == 0 && !param2))
         {
            _loc3_ = new DFrameMC(param1);
            this.ui.dropStack.addChild(_loc3_);
            _loc3_.init();
            _loc3_.fY = _loc3_.y = -(_loc3_.fHeight + 8);
            _loc3_.fX = _loc3_.x = -(_loc3_.fWidth / 2);
            this.cleanDropStack();
            return;
         }
         if(param1.bTemp != 0 || !param2)
         {
            _loc3_ = new DFrameMC(param1);
         }
         else
         {
            _loc4_ = this.findExistingDropFrame(param1.ItemID);
            if(_loc4_ != null)
            {
               _loc4_.addQuantity(int(param1.iQty));
               this.ui.dropStack.setChildIndex(_loc4_,this.ui.dropStack.numChildren - 1);
               _loc4_.fY = _loc4_.y = -(_loc4_.fHeight + 8);
               _loc4_.fX = _loc4_.x = -(_loc4_.fWidth / 2);
               this.cleanDropStack();
               return;
            }
            _loc3_ = new DFrame2MC(param1);
         }
         this.ui.dropStack.addChild(_loc3_);
         _loc3_.init();
         _loc3_.fY = _loc3_.y = -(_loc3_.fHeight + 8);
         _loc3_.fX = _loc3_.x = -(_loc3_.fWidth / 2);
         this.cleanDropStack();
      }
      
      private function findExistingDropFrame(param1:*) : DFrame2MC
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         _loc2_ = this.ui.dropStack;
         _loc3_ = _loc2_.numChildren - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = _loc2_.getChildAt(_loc3_);
            if(_loc4_ is DFrame2MC && !_loc4_.isClosing && _loc4_.fData != null && _loc4_.fData.ItemID == param1)
            {
               return _loc4_ as DFrame2MC;
            }
            _loc3_--;
         }
         return null;
      }
      
      public function cleanDropStack() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:* = undefined;
         _loc1_ = null;
         _loc2_ = null;
         _loc3_ = this.ui.dropStack.numChildren - 2;
         while(_loc3_ > -1)
         {
            _loc1_ = this.ui.dropStack.getChildAt(_loc3_) as MovieClip;
            _loc2_ = this.ui.dropStack.getChildAt(_loc3_ + 1) as MovieClip;
            _loc1_.fY = _loc1_.y = _loc2_.fY - (_loc2_.fHeight + 8);
            _loc3_--;
         }
      }
      
      public function dropStackBoost() : void
      {
         this.ui.dropStack.y = 438;
      }
      
      public function dropStackReset() : void
      {
         this.ui.dropStack.y = 493;
      }
      
      public function showAchievement(param1:String, param2:int) : void
      {
         var _loc3_:mcAchievement = null;
         var _loc4_:MovieClip = null;
         _loc3_ = new mcAchievement();
         _loc4_ = this.ui.dropStack.addChild(_loc3_) as MovieClip;
         _loc4_.cnt.tBody.text = param1;
         _loc4_.cnt.tPts.text = param2;
         _loc4_.fWidth = 348;
         _loc4_.fHeight = 90;
         _loc4_.fX = _loc4_.x = -(_loc4_.fWidth / 2);
         _loc4_.fY = _loc4_.y = -(_loc4_.fHeight + 8);
         this.cleanDropStack();
      }
      
      public function showQuestpopup(param1:Object) : void
      {
         var _loc2_:mcQuestpopup = null;
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         if(this.litePreference.data.bDisQPopup)
         {
            return;
         }
         _loc2_ = new mcQuestpopup();
         _loc2_.cnt.mcAC.visible = false;
         _loc3_ = this.ui.dropStack.addChild(_loc2_) as MovieClip;
         _loc3_.cnt.tName.text = param1.sName;
         _loc3_.cnt.rewards.tRewards.htmlText = "";
         _loc4_ = "";
         _loc5_ = param1.rewardObj;
         if("intCoins" in _loc5_ && _loc5_.intCoins > 0)
         {
            _loc4_ = "<font color=\'#FFFFFF\'>" + _loc5_.intCoins + "</font>";
            _loc4_ = _loc4_ + "<font color=\'#FFCC00\'>ac</font>";
         }
         if("intGold" in _loc5_ && _loc5_.intGold > 0)
         {
            if(_loc4_.length > 0)
            {
               _loc4_ = _loc4_ + "<font color=\'#FFFFFF\'>, </font>";
            }
            _loc4_ = _loc4_ + ("<font color=\'#FFFFFF\'>" + _loc5_.intGold + "</font>");
            _loc4_ = _loc4_ + "<font color=\'#FFCC00\'>g</font>";
         }
         if("intExp" in _loc5_ && _loc5_.intExp > 0)
         {
            if(_loc4_.length > 0)
            {
               _loc4_ = _loc4_ + "<font color=\'#FFFFFF\'>, </font>";
            }
            _loc4_ = _loc4_ + ("<font color=\'#FFFFFF\'>" + _loc5_.intExp + "</font>");
            _loc4_ = _loc4_ + "<font color=\'#FF00FF\'>xp</font>";
         }
         if("iRep" in _loc5_ && _loc5_.iRep > 0)
         {
            if(_loc4_.length > 0)
            {
               _loc4_ = _loc4_ + "<font color=\'#FFFFFF\'>, </font>";
            }
            _loc4_ = _loc4_ + ("<font color=\'#FFFFFF\'>" + _loc5_.iRep + "</font>");
            _loc4_ = _loc4_ + "<font color=\'#00CCFF\'>rep</font>";
         }
         if("guildRep" in _loc5_ && _loc5_.guildRep > 0)
         {
            if(_loc4_.length > 0)
            {
               _loc4_ = _loc4_ + "<font color=\'#FFFFFF\'>, </font>";
            }
            _loc4_ = _loc4_ + ("<font color=\'#FFFFFF\'>" + _loc5_.guildRep + "</font>");
            _loc4_ = _loc4_ + "<font color=\'#00CCFF\'>guild rep</font>";
         }
         _loc3_.cnt.rewards.tRewards.htmlText = _loc4_;
         _loc3_.fWidth = 240;
         _loc3_.fHeight = 70;
         _loc6_ = _loc3_.cnt.rewards.tRewards.x + _loc3_.cnt.rewards.tRewards.textWidth;
         _loc3_.cnt.rewards.x = Math.round(_loc3_.fWidth / 2 - _loc6_ / 2);
         _loc3_.fX = _loc3_.x = -(_loc3_.fWidth / 2);
         _loc3_.fY = _loc3_.y = -(_loc3_.fHeight + 8);
         this.mixer.playSound("Good");
         this.cleanDropStack();
      }
      
      public function toggleCharpanel(param1:String = "") : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = this.ui.mcPopup;
         if(!this.isGreedyModalInStack())
         {
            if(_loc2_.currentLabel != "Charpanel")
            {
               this.clearPopups();
               this.clearPopupsQ();
               _loc2_.fData = {"typ":param1};
               _loc2_.visible = true;
               _loc2_.gotoAndPlay("Charpanel");
            }
            else
            {
               _loc2_.mcCharpanel.fClose();
            }
         }
      }
      
      public function toggleStatspanel(param1:String = "") : void
      {
         if(this.ui.getChildByName("mcStatsPanel"))
         {
            this.mcStatsPanel.cleanup();
            this.mcStatsPanel = null;
            return;
         }
         this.mcStatsPanel = new statsPanel(this);
         this.ui.addChild(this.mcStatsPanel);
         this.mcStatsPanel.name = "mcStatsPanel";
         this.mcStatsPanel.x = 474;
         this.mcStatsPanel.y = 240;
      }
      
      public function toggleOutfits(param1:String = "") : void
      {
         if(this.world.myAvatar.dataLeaf.intState != 1)
         {
            return;
         }
         if(this.world.bPvP)
         {
            return;
         }
         this.requestInterface("OutfitSets/outfitsetsr2.swf","outfitSets");
      }
      
      public function showFriendshipUI(param1:String = "") : void
      {
         if(!this.world.coolDown("friendshipStats"))
         {
            return;
         }
         this.requestInterface("friendship/friendship_ui.swf","friendship_ui");
      }
      
      public function togglePVPPanel(param1:String = "") : void
      {
         var mc:MovieClip = null;
         var typ:String = param1;
         mc = this.ui.mcPopup;
         if(!this.isGreedyModalInStack())
         {
            if(mc.currentLabel != "PVPPanel")
            {
               this.clearPopups();
               this.clearPopupsQ();
               mc.fData = {"typ":typ};
               mc.visible = true;
               mc.gotoAndPlay("PVPPanel");
            }
            else if(typ == "results" && mc.mcPVPPanel != null)
            {
               try
               {
                  mc.fData = {"typ":typ};
                  mc.visible = true;
                  mc.mcPVPPanel.openWith({"typ":typ});
               }
               catch(ePv:Error)
               {
                  mc.onClose();
               }
            }
            else
            {
               mc.onClose();
            }
         }
      }
      
      public function showPVPScore() : void
      {
         var bar:MovieClip = null;
         var i:int = 0;
         var o:Object = null;
         var a:Array = null;
         var bx:int = 0;
         this.ui.mcPVPScore.visible = true;
         this.ui.mcPVPScore.y = 2;
         i = 0;
         a = [{"sName":"Team A"},{"sName":"Team B"}];
         bx = 200;
         if(this.world.PVPFactions.length > 0)
         {
            a = this.world.PVPFactions;
         }
         i = 0;
         while(i < a.length)
         {
            o = a[i];
            try
            {
               bar = this.ui.mcPVPScore.getChildByName("bar" + i);
               bar.tTeam.text = o.sName;
               if(bar.tTeam.x + bar.tTeam.width - bar.tTeam.textWidth - 6 < bx)
               {
                  bx = Math.round(bar.tTeam.x + bar.tTeam.width - bar.tTeam.textWidth - 6);
               }
            }
            catch(e:Error)
            {
               trace("[UI] ERR PvP faction data could not be found or set: " + e.message);
            }
            i++;
         }
         i = 0;
         while(i < a.length)
         {
            o = a[i];
            try
            {
               bar = this.ui.mcPVPScore.getChildByName("bar" + i);
               bar.cap.x = bx;
            }
            catch(e:Error)
            {
            }
            i++;
         }
      }
      
      public function hidePVPScore() : void
      {
         this.ui.mcPVPScore.visible = false;
         this.ui.mcPVPScore.y = -300;
      }
      
      public function showMCPVPQueue() : void
      {
         var _loc1_:Object = null;
         _loc1_ = this.world.getWarzoneByWarzoneName(this.world.PVPQueue.warzone);
         this.ui.mcPVPQueue.t1.text = _loc1_.nam;
         this.ui.mcPVPQueue.removeEventListener(Event.ENTER_FRAME,this.MCPVPQueueEF);
         this.ui.mcPVPQueue.t2label.visible = false;
         this.ui.mcPVPQueue.t2.visible = false;
         if(this.world.PVPQueue.avgWait > -1)
         {
            this.ui.mcPVPQueue.t2label.visible = true;
            this.ui.mcPVPQueue.t2.visible = true;
            this.ui.mcPVPQueue.addEventListener(Event.ENTER_FRAME,this.MCPVPQueueEF,false,0,true);
         }
         this.ui.mcPVPQueue.visible = true;
         this.ui.mcPVPQueue.y = 84;
      }
      
      public function hideMCPVPQueue() : void
      {
         this.ui.mcPVPQueue.removeEventListener(Event.ENTER_FRAME,this.MCPVPQueueEF);
         this.ui.mcPVPQueue.visible = false;
         this.ui.mcPVPQueue.y = -300;
      }
      
      public function onMCPVPQueueClick(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = {};
         try
         {
            _loc2_.strUsername = this.world.myAvatar.objData.strUsername;
            this.ui.cMenu.fOpenWith("pvpqueue",_loc2_);
         }
         catch(e:Error)
         {
         }
      }
      
      public function MCPVPQueueEF(param1:Event) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:* = undefined;
         _loc2_ = Number(new Date().getTime());
         _loc3_ = Math.ceil((this.world.PVPQueue.avgWait * 1000 - (_loc2_ - this.world.PVPQueue.ts)) / 1000 / 60);
         this.ui.mcPVPQueue.t2.htmlText = "<font color=\"#FFFFFF\"" + _loc3_ + "</font><font color=\"#999999\"m</font>";
         if(_loc3_ <= 1)
         {
            this.ui.mcPVPQueue.t2.htmlText = "<" + this.ui.mcPVPQueue.t2.htmlText;
         }
      }
      
      public function updatePVPScore(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = {};
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc2_ = param1[_loc4_];
            _loc3_ = this.ui.mcPVPScore.getChildByName("bar" + _loc4_) as MovieClip;
            if(_loc3_ != null)
            {
               _loc3_.ti.text = _loc2_.v + "/1000";
               _loc5_ = int(_loc2_.v / 1000 * _loc3_.bar.width);
               _loc5_ = Math.max(Math.min(_loc5_,_loc3_.bar.width),0);
               _loc3_.bar.x = -_loc3_.bar.width + _loc5_;
            }
            _loc4_++;
         }
      }
      
      public function relayPVPEvent(param1:Object) : void
      {
         if(param1.typ == "kill")
         {
            if(param1.team == this.world.myAvatar.dataLeaf.pvpTeam)
            {
               if(param1.val == "Restorer")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,true));
               }
               if(param1.val == "Brawler")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,true));
               }
               if(param1.val == "Captain")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,true));
               }
               if(param1.val == "General")
               {
                  this.addUpdate("Victory! The enemy general has been defeated!");
               }
               if(param1.val == "Knight")
               {
                  this.addUpdate("A knight of the enemy has fallen! Victory draws closer!");
               }
            }
            else
            {
               if(param1.val == "Restorer")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,false),true);
               }
               if(param1.val == "Brawler")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,false),true);
               }
               if(param1.val == "Captain")
               {
                  this.addUpdate(this.getPVPMessage(param1.val,false),true);
               }
               if(param1.val == "General")
               {
                  this.addUpdate("Oh no!  Our general has been defeated!",true);
               }
               if(param1.val == "Knight")
               {
                  this.addUpdate("A knight has fallen to the enemy!");
               }
            }
         }
      }
      
      private function getPVPMessage(param1:String, param2:Boolean) : String
      {
         switch(param1)
         {
            case "Restorer":
               if(param2)
               {
                  return this.world.strMapName == "dagepvp" ? "An enemy Blade Master has been defeated! Dage\'s healing powers are waning!" : "An enemy Restorer has been defeated! The Captain\'s healing powers are waning!";
               }
               return this.world.strMapName == "dagepvp" ? "A Blade Master has been defeated!\t Dage\'s healing powers are waning!" : "A Restorer has been defeated!\t Our Captain\'s healing powers are waning!";
               break;
            case "Brawler":
               if(param2)
               {
                  return this.world.strMapName == "dagepvp" ? "An enemy Legion Guard has been defeated!  Dage\'s attacks grow weaker!" : "An enemy Brawler has been defeated!  The Captain\'s attacks grow weaker!";
               }
               return this.world.strMapName == "dagepvp" ? "A Legion Guard has been defeated!\tRally to Dage\'s defense!" : "A Brawler has been defeated!\tRally to the Captain\'s defense!";
               break;
            case "Captain":
               if(param2)
               {
                  return this.world.strMapName == "dagepvp" ? "Dage has been defeated!" : "The enemy captain has been defeated!";
               }
               return this.world.strMapName == "dagepvp" ? "Dage has been fallen to the enemy!" : "Our Captain has been fallen to the enemy!";
               break;
            default:
               return "";
         }
      }
      
      public function mcSetColor(param1:MovieClip, param2:String, param3:String) : *
      {
         var _loc4_:MovieClip = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         if(currentLabel == "Select")
         {
            this.mcCharSelect.mcSetColor(param1,param2,param3);
            return;
         }
         if(this._colorCache[param1] != null)
         {
            _loc6_ = this._colorCache[param1];
            if(_loc6_.avatarMC != null && _loc6_.avatarMC.pAV != undefined && param1.parent != null)
            {
               _loc6_.avatarMC.pAV.pMC.setColor(param1,_loc6_.typ,param2,param3);
               return;
            }
            delete this._colorCache[param1];
         }
         _loc4_ = param1;
         _loc5_ = "none";
         while(_loc4_ != null && _loc4_.parent != null && _loc4_.parent != _loc4_.stage)
         {
            if("pAV" in _loc4_)
            {
               if(_loc4_.name.indexOf("previewMC") > -1)
               {
                  _loc5_ = "e";
               }
               else if(_loc4_.name.indexOf("Dummy") > -1)
               {
                  _loc5_ = "d";
               }
               else if(_loc4_.name.indexOf("mcPortraitTarget") > -1)
               {
                  _loc5_ = "c";
               }
               else if(_loc4_.name.indexOf("mcPortrait") > -1)
               {
                  _loc5_ = "b";
               }
               else
               {
                  _loc5_ = "a";
               }
               break;
            }
            _loc4_ = MovieClip(_loc4_.parent);
         }
         if(_loc5_ != "none")
         {
            this._colorCache[param1] = {
               "avatarMC":_loc4_,
               "typ":_loc5_
            };
            if(_loc4_.pAV == undefined)
            {
               this.world.myAvatar.pMC.setColor(param1,_loc5_,param2,param3);
            }
            else
            {
               _loc4_.pAV.pMC.setColor(param1,_loc5_,param2,param3);
            }
         }
      }
      
      public function registerAttackFrame(param1:MovieClip) : *
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1;
         while(_loc2_ != null && _loc2_.parent != null && _loc2_.parent != _loc2_.stage)
         {
            if("pAV" in _loc2_)
            {
               break;
            }
            _loc2_ = MovieClip(_loc2_.parent);
         }
         if("pAV" in _loc2_)
         {
            if(!("attackFrames" in _loc2_.pAV.pMC))
            {
               return;
            }
            if(Boolean(_loc2_.pAV.pMC.attackFrames) && _loc2_.pAV.pMC.attackFrames.indexOf(param1) != -1)
            {
               _loc2_.pAV.pMC.attackFrames.splice(_loc2_.pAV.pMC.attackFrames.indexOf(param1),1);
            }
            _loc2_.pAV.pMC.attackFrames.push(param1);
         }
      }
      
      public function areaListClick(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = MovieClip(param1.currentTarget.parent.parent);
         switch(_loc2_.currentLabel)
         {
            case "init":
               _loc2_.gotoAndPlay("in");
               break;
            case "hold":
               _loc2_.gotoAndPlay("out");
         }
      }
      
      public function updateAreaName() : void
      {
         var _loc1_:* = null;
         if(this.ui == null || this.ui.mcInterface == null || this.ui.mcInterface.areaList == null || this.ui.mcInterface.areaList.title == null || this.world == null)
         {
            return;
         }
         _loc1_ = String(this.world.areaUsers.length) + " player";
         if(this.world.areaUsers.length > 1)
         {
            _loc1_ = _loc1_ + "(s)";
         }
         _loc1_ = _loc1_ + " in <font color =\'#FFFF00\'>";
         if(this.world.strAreaName.indexOf(":") > -1)
         {
            _loc1_ = _loc1_ + (this.world.strAreaName.split(":")[0] + " (party)");
         }
         else
         {
            _loc1_ = _loc1_ + this.world.strAreaName;
         }
         _loc1_ = _loc1_ + "</font>";
         this.ui.mcInterface.areaList.title.t1.htmlText = _loc1_;
      }
      
      public function areaListGet() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         _loc1_ = {};
         _loc2_ = this.sfc.getRoom(this.world.curRoom).getUserList();
         for(var _loc7_ in _loc2_)
         {
            _loc3_ = _loc7_;
            _loc7_;
            _loc4_ = this.world.uoTree[_loc2_[_loc3_].getName()];
            if(_loc4_ != null)
            {
               _loc1_[_loc3_] = {
                  "strUsername":_loc4_.strUsername,
                  "intLevel":_loc4_.intLevel
               };
            }
         }
         this.areaListShow(_loc1_);
      }
      
      public function areaListNameClick(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc2_ = MovieClip(param1.currentTarget);
         _loc3_ = {};
         _loc3_.ID = _loc2_.objData.ID;
         _loc3_.strUsername = _loc2_.objData.strUsername;
         if(_loc2_.objData.strUsername == this.world.myAvatar.objData.strUsername)
         {
            this.ui.cMenu.fOpenWith("self",_loc3_);
         }
         else
         {
            this.ui.cMenu.fOpenWith("user",_loc3_);
         }
      }
      
      public function areaListShow(param1:Object) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         _loc2_ = this.ui.mcInterface.areaList;
         if(_loc2_.currentLabel == "hold")
         {
            while(_loc2_.cnt.numChildren > 0)
            {
               _loc2_.cnt.removeChildAt(0);
            }
         }
         _loc3_ = 0;
         for(var _loc8_ in param1)
         {
            _loc4_ = _loc8_;
            _loc8_;
            _loc5_ = _loc2_.cnt.addChild(new aProto());
            _loc5_.objData = param1[_loc4_];
            _loc5_.txtName.text = param1[_loc4_].strUsername;
            _loc5_.txtLevel.text = param1[_loc4_].intLevel;
            _loc5_.addEventListener(MouseEvent.CLICK,this.areaListNameClick,false,0,true);
            _loc5_.buttonMode = true;
            _loc5_.y = -int(_loc3_ * 14);
            _loc3_++;
         }
         _loc2_.cnt.iproto.visible = _loc2_.currentLabel == "hold";
         _loc2_.visible = true;
      }
      
      public function showFBShare(param1:Object) : void
      {
         var FBShareTabClass:Class;
         var fbTab:FacebookTabMC = null;
         var o:Object = param1;
         var mc:MovieClip = MovieClip(o.parent);
         if(!ApplicationDomain.currentDomain.hasDefinition("FacebookTabMC"))
         {
            trace("[Load] ERR missing linkage FacebookTabMC showFBShare");
            return;
         }
         FBShareTabClass = getDefinitionByName("FacebookTabMC") as Class;
         if(Boolean(this.uoPref.bFBShare) && Boolean(o.isActive))
         {
            try
            {
               fbTab = o.parent.getChildByName("fbTab") as FacebookTabMC;
            }
            catch(error:Error)
            {
               trace("[UI] ERR showFBShare: " + error.message);
            }
            if(fbTab == null)
            {
               fbTab = new FBShareTabClass();
               fbTab.name = "fbTab";
               fbTab.filters = [new GlowFilter(12892822,1,10,10,2,2,false,false)];
               o.parent.addChild(fbTab);
            }
            fbTab.init(o);
            fbTab.visible = true;
            if("position" in o)
            {
               fbTab.positionBy(o);
            }
         }
         else
         {
            try
            {
               o.parent.getChildByName("fbTab").visible = false;
            }
            catch(error:Error)
            {
            }
         }
      }
      
      public function closeFBC() : void
      {
         if(this.fbc != null)
         {
            this.fbc.fClose();
         }
      }
      
      public function getAppName() : String
      {
         return Game.FB_APP_NAME;
      }
      
      public function getAppID() : String
      {
         return Game.FB_APP_ID;
      }
      
      public function getAppSec() : String
      {
         return Game.FB_APP_SEC;
      }
      
      public function getAppURL() : String
      {
         return Game.FB_APP_URL;
      }
      
      public function getUserName() : String
      {
         if(this.world != null && this.world.myAvatar != null && this.world.myAvatar.objData != null && "strUserName" in this.world.myAvatar.objData)
         {
            return this.world.myAvatar.objData.strUserName;
         }
         return "";
      }
      
      public function toggleFaction() : void
      {
         if(this.ui.mcPopup.currentLabel != "Faction")
         {
            this.ui.mcPopup.fOpen("Faction");
         }
         else if("cnt" in MovieClip(this.ui.mcPopup))
         {
            MovieClip(MovieClip(this.ui.mcPopup).cnt).xClick();
         }
      }
      
      public function hideInterface() : void
      {
         this.ui.visible = false;
      }
      
      public function showInterface() : void
      {
         this.ui.visible = true;
      }
      
      public function loadExternalSWF(param1:String) : void
      {
         if(param1.indexOf("https://") == -1 && param1.indexOf("http://") == -1 && param1.indexOf("file://") == -1)
         {
            while(param1.length > 1 && param1.charAt(0) == "/")
            {
               param1 = param1.substr(1,param1.length - 1);
            }
            if(param1.indexOf("maps/") != 0)
            {
               param1 = "maps/" + param1;
            }
         }
         trace("[Load] loadExternalSWF: " + param1 + " base: " + serverFilePath);
         this.ldrMC.loadFile(this.mcExtSWF,param1,"Game Files",true);
         this.hideInterface();
         this.world.visible = false;
      }
      
      public function clearExternamSWF() : void
      {
         var child:DisplayObject = null;
         try
         {
            SoundMixer.stopAll();
         }
         catch(e:Error)
         {
         }
         while(this.mcExtSWF != null && this.mcExtSWF.numChildren > 0)
         {
            child = null;
            try
            {
               child = this.mcExtSWF.removeChildAt(0);
            }
            catch(e2:Error)
            {
               break;
            }
            if(child is MovieClip)
            {
               try
               {
                  this.recursiveStopSafe(MovieClip(child));
               }
               catch(e3:Error)
               {
               }
            }
         }
         if(this.world != null)
         {
            this.world.visible = true;
         }
         this.showInterface();
      }
      
      public function openCharacterCustomize() : void
      {
         this.ui.mcPopup.fOpen("Customize");
      }
      
      public function openArmorCustomize() : void
      {
         this.ui.mcPopup.fOpen("ArmorColor");
      }
      
      public function showFactionInterface() : void
      {
         this.ui.mcPopup.fOpen("Faction");
      }
      
      public function showConfirmtaionBox(param1:String, param2:Function) : void
      {
         var modal:* = undefined;
         var modalO:* = undefined;
         var sMsg:String = param1;
         var fHandler:Function = param2;
         modal = new ModalMC();
         modalO = {};
         modalO.strBody = sMsg;
         modalO.btns = "dual";
         modalO.params = {};
         modalO.callback = function(param1:Object):*
         {
            fHandler(param1.accept);
         };
         this.ui.ModalStack.addChild(modal);
         modal.init(modalO);
      }
      
      public function showMessageBox(param1:String, param2:Function = null) : void
      {
         var modal:* = undefined;
         var modalO:* = undefined;
         var sMsg:String = param1;
         var fHandler:Function = param2;
         modal = new ModalMC();
         modalO = {};
         modalO.strBody = sMsg;
         modalO.btns = "mono";
         modalO.params = {};
         modalO.callback = function(param1:Object):*
         {
            if(fHandler != null)
            {
               fHandler();
            }
         };
         this.ui.ModalStack.addChild(modal);
         modal.init(modalO);
      }
      
      public function getServerTime() : Date
      {
         var _loc1_:Date = null;
         var _loc2_:* = undefined;
         _loc1_ = new Date();
         _loc2_ = this.ts_login_server + (_loc1_.getTime() - this.ts_login_client);
         return new Date(_loc2_);
      }
      
      public function get date_server() : Date
      {
         return this.getServerTime();
      }
      
      public function showTracking(param1:String) : void
      {
         var _loc2_:* = undefined;
         try
         {
            _loc2_ = objLogin.userid != null ? objLogin.userid : 0;
            this.extCall.logQuestProgress(_loc2_,param1);
         }
         catch(e:*)
         {
         }
      }
      
      public function removeApop() : void
      {
         if(this.apop == null)
         {
            return;
         }
         this.apop_ = null;
         this.world.removeMovieFront();
      }
      
      public function createApop() : void
      {
         if(this.apop_ != null)
         {
            this.removeApop();
         }
         this.apop_ = new apopCore(this as MovieClip,this.apopTree[this.curID]);
         this.apop_.x = 270;
         this.apop_.y = 20;
         this.world.FG.addChild(this.apop_);
         this.world.FG.mouseChildren = true;
      }
      
      public function rand(param1:Number = 0, param2:Number = 1) : Number
      {
         return this.rn.rand(param1,param2);
      }
      
      public function get TravelMap() : Object
      {
         return this.travelMapData;
      }
      
      public function get apop() : apopCore
      {
         return this.apop_;
      }
      
      public function get objWorldMap() : *
      {
         return this.WorldMapData;
      }
      
      public function getLogin() : Object
      {
         return objLogin;
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame12() : *
      {
         this.init();
         this.showTracking("2");
      }
      
      internal function frame13() : *
      {
         this.loadTitle();
         if(this.showServers)
         {
            if(FacebookConnect.isLoggedIn && loginInfo.strPassword == null && ISWEB)
            {
               this.extCall.fbLogin();
            }
            else
            {
               this.login(loginInfo.strUsername,loginInfo.strPassword);
            }
            this.showServers = false;
         }
         else if(this.csShowServers)
         {
            this.mcLogin.gotoAndPlay("Servers");
            this.csShowServers = false;
         }
         stop();
      }
      
      internal function frame23() : *
      {
         trace("at game");
         this.initInterface();
         this.initWorld();
         stop();
      }
      
      internal function frame33() : *
      {
         if(this.params.vars != null)
         {
            this.loadAccountCreation("newuser/" + this.params.vars.sCharCreate);
         }
         else
         {
            this.loadAccountCreation("newuser/AQW-Landing-MERGETEST.swf");
         }
         stop();
      }
      
      internal function frame43() : *
      {
         if(this.mcCharSelect != null)
         {
            trace("Cleaning up existing mcCharSelect");
            trace("children count: " + this.numChildren);
            this.mcCharSelect = null;
         }
         this.loader = new mcLoader();
         this.loader.x = 400;
         this.loader.y = 211;
         this.addChild(this.loader);
         this.csLoader = new Loader();
         this.csLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onCSComplete,false,0,true);
         this.csLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onCSProgress,false,0,true);
         this.csLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onCSError,false,0,true);
         this.fileUrl = this.getFilePath() + "interface/CharSelect/charselect.swf";
         if(this.params != null && this.params.vars != null && this.params.vars.sVersion != null)
         {
            this.fileUrl = this.fileUrl + ("?v=" + this.params.vars.sVersion);
         }
         this.csLoader.load(new URLRequest(this.fileUrl));
         this.csbLoaded = 0;
         this.csbTotal = 0;
         stop();
      }
   }
}

