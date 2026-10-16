package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.events.UncaughtErrorEvent;
   import flash.external.*;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.Sound;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.text.TextFormat;
   import flash.utils.*;
   import types.LoaderData;
   import types.LoaderError;
   import types.LoaderSlot;
   import types.MapInfo;
   import types.PlayerDomainCache;
   import types.ResponseData;
   import types.SessionData;
   import types.ZSortItem;
   import utils.ZSortItemPool;
   
   public class World extends MovieClip
   {
      public static var currentInstance:World;
      
      private static const Z_SORT_INTERVAL:int = 2;
      
      public static const PRIORITY_CRITICAL:int = 100;
      
      public static const PRIORITY_HIGH:int = 75;
      
      public static const PRIORITY_NORMAL:int = 50;
      
      public static const PRIORITY_LOW:int = 25;
      
      public static const PRIORITY_BACKGROUND:int = 0;
      
      public var uiLock:Boolean = false;
      
      public var objSession:SessionData;
      
      public var objResponse:ResponseData;
      
      public var objQuestString:*;
      
      public var objInfo:MapInfo;
      
      internal var FEATURE_COLLISION:Boolean = true;
      
      internal var CELL_MODE:String = "normal";
      
      public var SCALE:Number = 1;
      
      public var WALKSPEED:Number = 8;
      
      public var bitWalk:Boolean = false;
      
      internal var lastWalk:Date;
      
      public var strAreaName:String;
      
      public var strMapName:String;
      
      public var strMapFileName:String;
      
      public var intType:int;
      
      public var intKillCount:int;
      
      public var objLock:*;
      
      public var objExtra:*;
      
      public var objHouseData:*;
      
      public var objGuildData:*;
      
      public var returnInfo:Object;
      
      public var strFrame:String = "";
      
      public var strPad:String = "";
      
      public var spawnPoint:Object;
      
      public var FG:MovieClip;
      
      public var CHARS:MovieClip;
      
      public var TRASH:MovieClip;
      
      public var map:MovieClip;
      
      public var mapBoundsMC:MovieClip = null;
      
      public var zSortArr:Vector.<ZSortItem>;
      
      public var ldr_map:Loader;
      
      private var ldr_pNPC:Loader = null;
      
      public var ldrC_map:LoaderContext;
      
      internal var preLMC:*;
      
      internal var zManager:MovieClip;
      
      public var EFAO:Object;
      
      public var arrEvent:Array;
      
      public var arrEventR:Array;
      
      public var arrSolid:Array;
      
      public var arrSolidR:Array;
      
      public var avatars:Dictionary;
      
      public var myAvatar:Avatar;
      
      public var mondef:Array;
      
      public var mondefMap:Object;
      
      public var monswf:Array;
      
      public var monmap:Array;
      
      public var monsters:Vector.<Avatar>;
      
      public var combatAnims:Vector.<String>;
      
      public var staticAnims:Vector.<String>;
      
      private var _originPoint:Point;
      
      private var _collisionRect:Rectangle;
      
      private var _zSortDirty:Boolean = true;
      
      private var _zSortFrameCount:int = 0;
      
      public var bankController:BankController;
      
      public var shopinfo:Object;
      
      public var shopBuyItem:Object;
      
      public var enhShopID:int = -1;
      
      public var enhShopItems:Vector.<Object>;
      
      public var enhItem:Object;
      
      public var hairshopinfo:Object;
      
      public var mapEvents:Object;
      
      public var adData:Object;
      
      public var cellMap:Object;
      
      private var tbmd:BitmapData;
      
      public var scrollData:Object;
      
      public var loaderD:ApplicationDomain;
      
      public var loaderC:LoaderContext;
      
      public var loaderContents:Vector.<Object>;
      
      public var loaderContentsFileNames:Vector.<String>;
      
      public var loaderQueue:Vector.<LoaderData>;
      
      public var playerDomainsCache:PlayerDomainCache;
      
      public var loaderTimeouts:Object;
      
      public var loaderSlots:Vector.<LoaderSlot>;
      
      private var loaderSlotsMap:Object;
      
      private var loadThrottleTimer:Timer;
      
      private var pendingSlots:Vector.<LoaderSlot>;
      
      private var playerDomains:Object;
      
      public var mapLoadInProgress:Boolean = false;
      
      public var mapEntered:Boolean = false;
      
      public var actions:Object;
      
      internal var restTimer:Timer;
      
      internal var AATestTimer:Timer;
      
      internal var connTestTimer:Timer;
      
      internal var autoActionTimer:Timer;
      
      internal var potionAckTimer:Timer;
      
      internal var potionAckActID:int = -1;
      
      internal var mvTimer:Timer;
      
      internal var mvTimerObj:Object;
      
      internal var actionTimer:Timer;
      
      internal var actionMap:Vector.<Object>;
      
      internal var autoAction:Object;
      
      internal var actionReady:Boolean = false;
      
      internal var actionResults:Vector.<Object>;
      
      internal var actionResultsAura:Vector.<Object>;
      
      internal var actionResultsMon:Vector.<Object>;
      
      internal var actionID:Number = 0;
      
      internal var actionIDLimit:Number = 250;
      
      internal var actionDamage:*;
      
      internal var actionRangeSpamTS:Number = 0;
      
      internal var minLatencyOneWay:* = 20;
      
      internal var TcpAckDel:* = 170;
      
      internal var connMsgOut:* = false;
      
      public var mData:mapData;
      
      public var cHandle:cutsceneHandler;
      
      public var sController:soundController;
      
      public var chaosNames:Vector.<String>;
      
      public var hideAllCapes:Boolean = false;
      
      public var hideOtherPets:Boolean = false;
      
      public var showAnimations:Boolean = true;
      
      public var showMonsters:Boolean = true;
      
      public var charMonster:MovieClip;
      
      public var lock:Object;
      
      public var invTree:Dictionary;
      
      public var uoTree:Dictionary;
      
      public var monTree:Object;
      
      public var waveTree:Dictionary;
      
      public var questTree:Object;
      
      public var enhPatternTree:Object;
      
      public var enhp:Array;
      
      public var defaultCT:ColorTransform;
      
      public var whiteCT:ColorTransform;
      
      public var iconCT:ColorTransform;
      
      public var rarityCA:Vector.<uint>;
      
      public var deathCT:ColorTransform;
      
      public var monCT:ColorTransform;
      
      public var avtCT:ColorTransform;
      
      public var avtWCT:ColorTransform;
      
      public var avtMCT:ColorTransform;
      
      public var avtPCT:ColorTransform;
      
      public var statusPoisonCT:ColorTransform;
      
      public var statusStoneCT:ColorTransform;
      
      public var dmgGlowHit:GlowFilter;
      
      public var dmgGlowCrit:GlowFilter;
      
      public var dmgGlowClean:GlowFilter;
      
      public var GCD:int = 1500;
      
      public var GCDO:int = 1500;
      
      public var GCDTS:Number = 0;
      
      public var curRoom:int = 1;
      
      public var modID:int = -1;
      
      public var partyID:int = -1;
      
      public var guildID:int = -1;
      
      public var bPvP:Boolean = false;
      
      public var partyMembers:Vector.<String>;
      
      public var partyOwner:String = "";
      
      public var areaUsers:Vector.<String>;
      
      public var showHPBar:Boolean = false;
      
      public var rootClass:MovieClip;
      
      public var PVPMaps:Array;
      
      public var PVPQueue:Object;
      
      public var PVPResults:Object;
      
      public var PVPFactions:Array;
      
      public var bookData:Object;
      
      public var lockdownPots:Boolean = false;
      
      public var lockdownPotsTS:Number = 0;
      
      public var classMissCache:Object;
      
      private var pendingMapEvents:Array;
      
      private var mapEvtWait:int = 0;
      
      private var intBlankWait:int = -1;
      
      private var bMapWarm:Boolean = false;
      
      private var cellWatchFrame:String = null;
      
      private var cellWatchTicks:int = 0;
      
      private var cellSetupStamp:String = null;
      
      private var propWireTicks:int = -1;
      
      private var cellSettleTicks:int = -1;
      
      private var cellSettleFrame:String = null;
      
      private var speed:Number;
      
      private var clickPts:int = 0;
      
      private var mva:Array;
      
      private var justRan:Boolean;
      
      public var CarolingMonsterKillCount:Number = 0;
      
      public var CarolingPad:String;
      
      public var TrickOrTreatMonsterDead:Boolean = false;
      
      public var TrickOrTreatPad:String;
      
      private var player_npc_pos:Point;
      
      public var hasModified:Boolean = false;
      
      public var frameCopy:Array;
      
      private var houseFrame:String = "";
      
      private var imbalancedHouseCells:Array;
      
      private var houseJson:Object;
      
      private var finishedCells:Array;
      
      private var convertTimer:Timer;
      
      private var activeCell:String;
      
      public var arrHouseItemQueue:*;
      
      public var ldr_House:Loader;
      
      private var monLoadsSettled:int = 0;
      
      private var monLoadsExpected:int = 0;
      
      private var monLoadGen:int = 0;
      
      private var mfLoadTS:int = -1000;
      
      private const TICK_MAX:* = 24;
      
      private var ticksum:Number = 0;
      
      private var ticklist:*;
      
      private var bfps:Boolean = false;
      
      private var fpsTS:Number = 0;
      
      private var fpsQualityCounter:int = 0;
      
      private var fpsArrayQuality:Array;
      
      internal var arrQuality:Array;
      
      private var combatDisplayTime:uint;
      
      public function World(param1:MovieClip)
      {
         this.objSession = new SessionData();
         this.objResponse = new ResponseData();
         this.objInfo = new MapInfo();
         this.lastWalk = new Date();
         this.spawnPoint = new Object();
         this.zSortArr = new Vector.<ZSortItem>();
         this.ldr_map = new Loader();
         this.EFAO = {
            "zc":0,
            "zn":1,
            "xpc":0,
            "xpn":50,
            "xpb":false
         };
         this.avatars = new Dictionary(true);
         this.mondefMap = {};
         this.monsters = new Vector.<Avatar>();
         this.combatAnims = new <String>["Attack1","Attack2","Attack3","Attack4","Hit","Knockout","Getup","Stab","Thrash","Castgood","Cast1","Cast2","Cast3","Sword/ShieldFight","Sword/ShieldAttack1","Sword/ShieldAttack2","ShieldBlock","DuelWield/DaggerFight","DuelWield/DaggerAttack1","DuelWield/DaggerAttack2","FistweaponFight","FistweaponAttack1","FistweaponAttack2","PolearmFight","PolearmAttack1","PolearmAttack2","RangedFight","RangedAttack1","RangedAttack2","RangedAttack3","UnarmedFight","UnarmedAttack1","UnarmedAttack2","UnarmedAttack3","KickAttack","FlipAttack","Dodge","WhipAttack","GunAttack","GunAttack2","GunAttack3","RifleAttack","RifleAttack2","RifleFight","Card"];
         this.staticAnims = new <String>["Fall","Knockout","Die"];
         this._originPoint = new Point(0,0);
         this._collisionRect = new Rectangle();
         this.enhShopItems = new Vector.<Object>();
         this.loaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
         this.loaderC = new LoaderContext(false,this.loaderD);
         this.loaderContents = new Vector.<Object>();
         this.loaderContentsFileNames = new Vector.<String>();
         this.loaderQueue = new Vector.<LoaderData>();
         this.playerDomainsCache = new PlayerDomainCache(20);
         this.loaderTimeouts = {
            "armor":10000,
            "weapon":10000,
            "map":20000,
            "default":7000
         };
         this.loaderSlots = new Vector.<LoaderSlot>();
         this.loaderSlotsMap = {};
         this.loadThrottleTimer = new Timer(1,0);
         this.pendingSlots = new Vector.<LoaderSlot>();
         this.playerDomains = {};
         this.actions = new Object();
         this.restTimer = new Timer(2000,1);
         this.AATestTimer = new Timer(700,1);
         this.connTestTimer = new Timer(5000,1);
         this.autoActionTimer = new Timer(2000,1);
         this.potionAckTimer = new Timer(3000,1);
         this.mvTimer = new Timer(500,1);
         this.actionMap = new Vector.<Object>();
         this.actionResults = new Vector.<Object>();
         this.actionResultsAura = new Vector.<Object>();
         this.actionResultsMon = new Vector.<Object>();
         this.chaosNames = new Vector.<String>();
         this.lock = {
            "loadShop":{
               "cd":3000,
               "ts":0
            },
            "loadEnhShop":{
               "cd":3000,
               "ts":0
            },
            "loadHairShop":{
               "cd":3000,
               "ts":0
            },
            "equipItem":{
               "cd":1500,
               "ts":0
            },
            "unequipItem":{
               "cd":1500,
               "ts":0
            },
            "buyItem":{
               "cd":1000,
               "ts":0
            },
            "sellItem":{
               "cd":1000,
               "ts":0
            },
            "getMapItem":{
               "cd":1000,
               "ts":0
            },
            "tryQuestComplete":{
               "cd":1250,
               "ts":0
            },
            "acceptQuest":{
               "cd":1000,
               "ts":0
            },
            "doIA":{
               "cd":1000,
               "ts":0
            },
            "rest":{
               "cd":1900,
               "ts":0
            },
            "who":{
               "cd":3000,
               "ts":0
            },
            "tfer":{
               "cd":3000,
               "ts":0
            },
            "wearItem":{
               "cd":1500,
               "ts":0
            },
            "unwearItem":{
               "cd":1500,
               "ts":0
            },
            "addLoadout":{
               "cd":1500,
               "ts":0
            },
            "removeLoadout":{
               "cd":1500,
               "ts":0
            },
            "wearLoadout":{
               "cd":3000,
               "ts":0
            },
            "equipLoadout":{
               "cd":3000,
               "ts":0
            },
            "friendshipTalk":{
               "cd":1000,
               "ts":0
            },
            "friendshipChoice":{
               "cd":1000,
               "ts":0
            },
            "friendshipInfo":{
               "cd":1500,
               "ts":0
            },
            "friendshipGift":{
               "cd":1500,
               "ts":0
            },
            "friendshipStats":{
               "cd":3000,
               "ts":0
            },
            "dungeonQueue":{
               "cd":5000,
               "ts":0
            },
            "dungeonRejoin":{
               "cd":5000,
               "ts":0
            },
            "dungeonMTC":{
               "cd":1000,
               "ts":0
            }
         };
         this.invTree = new Dictionary(true);
         this.uoTree = new Dictionary(true);
         this.monTree = {};
         this.waveTree = new Dictionary(true);
         this.questTree = {};
         this.enhp = [{
            "ID":1,
            "sName":"Adventurer",
            "sDesc":"none",
            "iSTR":16,
            "iDEX":16,
            "iEND":18,
            "iINT":16,
            "iWIS":16,
            "iLCK":0
         },{
            "ID":2,
            "sName":"Fighter",
            "sDesc":"M1",
            "iSTR":44,
            "iDEX":13,
            "iEND":43,
            "iINT":0,
            "iWIS":0,
            "iLCK":0
         },{
            "ID":3,
            "sName":"Thief",
            "sDesc":"M2",
            "iSTR":30,
            "iDEX":45,
            "iEND":25,
            "iINT":0,
            "iWIS":0,
            "iLCK":0
         },{
            "ID":4,
            "sName":"Armsman",
            "sDesc":"M4",
            "iSTR":38,
            "iDEX":36,
            "iEND":26,
            "iINT":0,
            "iWIS":0,
            "iLCK":0
         },{
            "ID":5,
            "sName":"Hybrid",
            "sDesc":"M3",
            "iSTR":28,
            "iDEX":20,
            "iEND":25,
            "iINT":27,
            "iWIS":0,
            "iLCK":0
         },{
            "ID":6,
            "sName":"Wizard",
            "sDesc":"C1",
            "iSTR":0,
            "iDEX":0,
            "iEND":10,
            "iINT":50,
            "iWIS":20,
            "iLCK":20
         },{
            "ID":7,
            "sName":"Healer",
            "sDesc":"C2",
            "iSTR":0,
            "iDEX":0,
            "iEND":40,
            "iINT":45,
            "iWIS":15,
            "iLCK":0
         },{
            "ID":8,
            "sName":"Spellbreaker",
            "sDesc":"C3",
            "iSTR":0,
            "iDEX":0,
            "iEND":20,
            "iINT":40,
            "iWIS":30,
            "iLCK":10
         },{
            "ID":9,
            "sName":"Lucky",
            "sDesc":"S1",
            "iSTR":10,
            "iDEX":10,
            "iEND":10,
            "iINT":10,
            "iWIS":10,
            "iLCK":50
         },{
            "ID":23,
            "sName":"Depths",
            "sDesc":"S1",
            "iSTR":0,
            "iDEX":0,
            "iEND":0,
            "iINT":50,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,132,133,131,0)
         },{
            "ID":10,
            "sName":"Forge",
            "sDesc":"Blacksmith",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,255,103,0,0)
         },{
            "ID":11,
            "sName":"Absolution",
            "sDesc":"Smith",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,255,103,0,0),
            "DIS":true
         },{
            "ID":12,
            "sName":"Avarice",
            "sDesc":"Smith",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,255,103,0,0),
            "DIS":true
         },{
            "ID":24,
            "sName":"Vainglory",
            "sDesc":"Smith",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,255,103,0,0),
            "DIS":true
         },{
            "ID":25,
            "sName":"Vim",
            "sDesc":"SmithP2",
            "iSTR":10,
            "iDEX":130,
            "iEND":-90,
            "iINT":0,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,57,255,20,0),
            "DIS":true
         },{
            "ID":26,
            "sName":"Examen",
            "sDesc":"SmithP2",
            "iSTR":0,
            "iDEX":0,
            "iEND":-90,
            "iINT":10,
            "iWIS":130,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,181,145,2,0),
            "DIS":true
         },{
            "ID":27,
            "sName":"Pneuma",
            "sDesc":"SmithP2",
            "iSTR":24,
            "iDEX":24,
            "iEND":-90,
            "iINT":118,
            "iWIS":24,
            "iLCK":0,
            "COLOR":new ColorTransform(1,1,1,1,3,150,161,0),
            "DIS":true
         },{
            "ID":28,
            "sName":"Anima",
            "sDesc":"SmithP2",
            "iSTR":134,
            "iDEX":24,
            "iEND":-90,
            "iINT":16,
            "iWIS":16,
            "iLCK":0,
            "COLOR":new ColorTransform(1,1,1,1,254,34,0,0),
            "DIS":true
         },{
            "ID":29,
            "sName":"Penitence",
            "sDesc":"SmithP2",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,255,103,0,0),
            "DIS":true
         },{
            "ID":30,
            "sName":"Lament",
            "sDesc":"SmithP2",
            "iSTR":25,
            "iDEX":0,
            "iEND":0,
            "iINT":25,
            "iWIS":0,
            "iLCK":50,
            "COLOR":new ColorTransform(1,1,1,1,255,103,0,0),
            "DIS":true
         },{
            "ID":32,
            "sName":"Hearty",
            "sDesc":"Grimskull Troll Enhancement",
            "iSTR":-20,
            "iDEX":-20,
            "iEND":150,
            "iINT":-20,
            "iWIS":-20,
            "iLCK":-20,
            "COLOR":new ColorTransform(1,1,1,1,220,0,220,0),
            "DIS":true
         }];
         this.defaultCT = new ColorTransform(1,1,1,1,0,0,0,0);
         this.whiteCT = new ColorTransform(1,1,1,1,255,255,255,0);
         this.iconCT = new ColorTransform(0.5,0.5,0.5,1,-50,-50,-50,0);
         this.rarityCA = new <uint>[6710886,16777215,6749952,2663679,16711935,16763904,16711680];
         this.deathCT = new ColorTransform(0.7,0.7,1,1,-20,-20,20,0);
         this.monCT = new ColorTransform(1,1,1,1,30,0,0,0);
         this.avtCT = new ColorTransform(1,1,1,1,40,40,70,0);
         this.avtWCT = new ColorTransform(0,0,0,0,255,255,255,0);
         this.avtMCT = new ColorTransform(0,0,0,0,30,0,0,0);
         this.avtPCT = new ColorTransform(0,0,0,0,40,40,70,0);
         this.statusPoisonCT = new ColorTransform(-0.3,-0.3,-0.3,0,0,20,0,0);
         this.statusStoneCT = new ColorTransform(-1.3,-1.3,-1.3,0,100,100,100,0);
         this.dmgGlowHit = new GlowFilter(0,1,5,5,5,1,false,false);
         this.dmgGlowCrit = new GlowFilter(3342336,1,5,5,5,1,false,false);
         this.dmgGlowClean = new GlowFilter(16777215,1,30,30,2,2);
         this.partyMembers = new Vector.<String>();
         this.areaUsers = new Vector.<String>();
         this.PVPMaps = [{
            "nam":"It\'s Us Or Them",
            "desc":"This cozy PvP map is ideal for players new to PvP in AQW.",
            "warzone":"usorthem",
            "label":"usorthem",
            "icon":"tower",
            "hidden":true
         },{
            "nam":"Bludrut Brawl!",
            "desc":"A larger map requiring communication, coordination, and a whole lot of DPS.",
            "warzone":"bludrutbrawl",
            "label":"bludrutbrawl",
            "icon":"swords",
            "hidden":false
         },{
            "nam":"Chaos Brawl!",
            "desc":"A larger map requiring communication, coordination, and a whole lot of DPS.",
            "warzone":"chaosbrawl",
            "label":"chaosbrawl",
            "icon":"swords",
            "hidden":false
         },{
            "nam":"Frost Brawl!",
            "desc":"A larger map requiring communication, coordination, and a whole lot of DPS.",
            "warzone":"frostbrawl",
            "label":"frostbrawl",
            "icon":"swords",
            "hidden":false
         },{
            "nam":"Darkovia Brawl!",
            "desc":"Join in the ancient war between werewolves and vampires!",
            "warzone":"darkoviapvp",
            "label":"darkoviapvp",
            "icon":"swords",
            "hidden":true
         },{
            "nam":"Dage PVP!",
            "desc":"Needs Description!",
            "warzone":"dagepvp",
            "label":"dagepvp",
            "icon":"swords",
            "hidden":true
         },{
            "nam":"Dage 1V1!",
            "desc":"Needs Description!",
            "warzone":"dage1v1",
            "label":"dage1v1",
            "icon":"swords",
            "hidden":true
         },{
            "nam":"Doomwood Arena",
            "desc":"This arena is for one on one duels.",
            "warzone":"doomarena",
            "label":"doomarena",
            "icon":"swords",
            "hidden":true
         }];
         this.PVPQueue = {
            "warzone":"",
            "ts":-1,
            "avgWait":-1
         };
         this.PVPResults = {
            "pvpScore":[],
            "team":0
         };
         this.PVPFactions = [];
         this.classMissCache = {};
         this.pendingMapEvents = [];
         this.mva = [new Date().getTime()];
         this.imbalancedHouseCells = [];
         this.arrHouseItemQueue = [];
         this.ldr_House = new Loader();
         this.ticklist = [];
         this.fpsArrayQuality = [];
         this.arrQuality = new Array("LOW","MEDIUM","HIGH");
         super();
         this.rootClass = param1;
         currentInstance = this;
         this.bankController = new BankController();
         this.map = new MovieClip();
         this.addChild(this.map);
         this.CHARS = new MovieClip();
         var _loc2_:DisplayObject = this.addChild(this.CHARS);
         this.CHARS.mouseEnabled = false;
         _loc2_.x = 0;
         _loc2_.y = 0;
         if(Boolean(this.rootClass.ui) && Boolean(this.rootClass.ui.monsterIcon) && Boolean(this.rootClass.ui.monsterIcon.redX))
         {
            this.rootClass.ui.monsterIcon.redX.visible = false;
         }
         this.TRASH = new MovieClip();
         this.addChild(this.TRASH);
         this.TRASH.mouseEnabled = false;
         this.TRASH.visible = false;
         this.TRASH.y = -1000;
         this.zManager = new MovieClip();
         this.addChild(this.zManager);
         this.FG = new MovieClip();
         this.addChild(this.FG);
         this.zManager.removeEventListener(Event.ENTER_FRAME,this.onZmanagerEnterFrame);
         this.autoActionTimer.removeEventListener("timer",this.autoActionHandler);
         this.restTimer.removeEventListener("timer",this.restRequest);
         this.AATestTimer.removeEventListener("timer",this.AATest);
         this.connTestTimer.removeEventListener("timer",this.connTest);
         this.mvTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.mvTimerHandler);
         this.zManager.addEventListener(Event.ENTER_FRAME,this.onZmanagerEnterFrame,false,0,true);
         this.autoActionTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.autoActionHandler);
         this.restTimer.addEventListener("timer",this.restRequest);
         this.AATestTimer.addEventListener("timer",this.AATest);
         this.connTestTimer.addEventListener("timer",this.connTest);
         this.mvTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.mvTimerHandler);
         this.potionAckTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onPotionAckTimeout);
         this.potionAckTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onPotionAckTimeout);
         this.initLoaders();
         this.initCutscenes();
      }
      
      public static function get GameRoot() : MovieClip
      {
         return currentInstance.rootClass;
      }
      
      public static function get Bank() : BankController
      {
         return currentInstance.bankController;
      }
      
      public function get loaderManager() : Object
      {
         return this.loaderSlotsMap;
      }
      
      public function auraCatOf(param1:Object) : String
      {
         try
         {
            if(param1 != null && param1.cat != null)
            {
               return String(param1.cat).replace(/\s+/g,"").toLowerCase();
            }
         }
         catch(eAC:Error)
         {
         }
         return "";
      }
      
      public function initPatternTree() : void
      {
         var _loc1_:* = undefined;
         this.enhPatternTree = {};
         for each(_loc1_ in this.enhp)
         {
            this.enhPatternTree[_loc1_.ID] = _loc1_;
         }
      }
      
      public function initGuildhallData(param1:Array) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            for(_loc3_ in param1[_loc2_])
            {
            }
            _loc2_++;
         }
      }
      
      public function killTimers() : void
      {
         this.autoActionTimer.reset();
         this.restTimer.reset();
         this.AATestTimer.reset();
         this.connTestTimer.reset();
         this.rootClass.chatF.mute.timer.reset();
         this.autoActionTimer.removeEventListener("timer",this.autoActionHandler);
         this.restTimer.removeEventListener("timer",this.restRequest);
         this.AATestTimer.removeEventListener("timer",this.AATest);
         this.connTestTimer.removeEventListener("timer",this.connTest);
         this.mvTimer.removeEventListener("timer",this.mvTimerHandler);
         this.potionAckTimer.reset();
         this.potionAckTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onPotionAckTimeout);
         this.rootClass.chatF.mute.timer.removeEventListener("timer",this.rootClass.chatF.unmuteMe);
      }
      
      public function killListeners() : void
      {
         this.zManager.removeEventListener(Event.ENTER_FRAME,this.onZmanagerEnterFrame);
         removeChild(this.zManager);
      }
      
      public function initLoaderSlots() : void
      {
         var _loc2_:LoaderSlot = null;
         this.loaderSlots = new Vector.<LoaderSlot>(10,true);
         var _loc1_:int = 0;
         while(_loc1_ < 10)
         {
            _loc2_ = new LoaderSlot("i" + _loc1_);
            this.loaderSlots[_loc1_] = _loc2_;
            this.loaderSlotsMap["i" + _loc1_] = _loc2_;
            _loc2_.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.loaderTimerComplete,false,0,true);
            _loc2_.ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loaderCallback,false,0,true);
            _loc2_.ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loaderErrorHandler,false,0,true);
            _loc2_.ldr.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.loaderSecurityErrorHandler,false,0,true);
            _loc2_.ldr.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.loaderHTTP,false,0,true);
            _loc2_.ldr.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loaderProgressHandler,false,0,true);
            _loc1_++;
         }
      }
      
      private function onLoadThrottle(param1:TimerEvent) : void
      {
         var _loc2_:LoaderSlot = null;
         if(this.pendingSlots.length > 0 && this.loaderQueue.length > 0)
         {
            _loc2_ = this.pendingSlots.shift();
            if(_loc2_.free)
            {
               this.loadNextWith(_loc2_,this.loaderQueue.shift());
            }
         }
         if(this.pendingSlots.length == 0)
         {
            this.loadThrottleTimer.stop();
         }
      }
      
      public function queueLoad(param1:*) : void
      {
         var _loc2_:LoaderData = null;
         var _loc5_:LoaderData = null;
         var _loc6_:LoaderSlot = null;
         var _loc7_:LoaderData = null;
         var _loc8_:LoaderData = null;
         if(param1 is LoaderData)
         {
            _loc2_ = param1 as LoaderData;
         }
         else
         {
            if(!(param1 is Object))
            {
               return;
            }
            _loc2_ = LoaderData.fromObject(param1);
            if(!_loc2_)
            {
               return;
            }
         }
         if(_loc2_.retries <= 0)
         {
            _loc2_.retries = 1;
         }
         if(_loc2_.maxRetries <= 0)
         {
            _loc2_.maxRetries = 1;
         }
         if(_loc2_.priority <= 0)
         {
            _loc2_.priority = this.getDefaultPriority(_loc2_);
         }
         if(_loc2_.strFile != null)
         {
            _loc2_.strFile = this.rootClass.vswf(_loc2_.strFile);
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.loaderQueue.length)
         {
            if(this.loaderQueue[_loc3_].strFile == _loc2_.strFile)
            {
               _loc5_ = this.loaderQueue[_loc3_];
               if(_loc2_.priority > _loc5_.priority)
               {
                  if(_loc5_.waiters != null)
                  {
                     for each(var _loc11_ in _loc5_.waiters)
                     {
                        _loc7_ = _loc11_;
                        _loc11_;
                        _loc2_.addWaiter(_loc7_);
                     }
                     _loc5_.waiters = null;
                  }
                  _loc2_.addWaiter(_loc5_);
                  this.loaderQueue.splice(_loc3_,1);
                  this.insertByPriority(_loc2_);
                  _loc6_ = this.getFreeLoader();
                  if(_loc6_ != null)
                  {
                     this.loadNext(_loc6_);
                  }
               }
               else
               {
                  if(_loc2_.waiters != null)
                  {
                     for each(_loc11_ in _loc2_.waiters)
                     {
                        _loc8_ = _loc11_;
                        _loc11_;
                        _loc5_.addWaiter(_loc8_);
                     }
                     _loc2_.waiters = null;
                  }
                  _loc5_.addWaiter(_loc2_);
               }
               return;
            }
            _loc3_++;
         }
         this.insertByPriority(_loc2_);
         var _loc4_:LoaderSlot = this.getFreeLoader();
         if(_loc4_ != null)
         {
            this.loadNext(_loc4_);
         }
      }
      
      private function insertByPriority(param1:LoaderData) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.loaderQueue.length)
         {
            if(param1.priority > this.loaderQueue[_loc2_].priority)
            {
               this.loaderQueue.splice(_loc2_,0,param1);
               return;
            }
            _loc2_++;
         }
         this.loaderQueue.push(param1);
      }
      
      private function getDefaultPriority(param1:LoaderData) : int
      {
         if(param1.avt != null && param1.avt == this.myAvatar)
         {
            return param1.sES == "Weapon" ? World.PRIORITY_CRITICAL : World.PRIORITY_HIGH;
         }
         if(param1.loadType == "map")
         {
            return World.PRIORITY_HIGH;
         }
         if(param1.loadType == "armor" || param1.loadType == "weapon")
         {
            return World.PRIORITY_NORMAL;
         }
         return World.PRIORITY_NORMAL;
      }
      
      private function bustRetryURL(param1:LoaderData) : void
      {
         if(param1 == null || param1.avt == null || param1.avt != this.myAvatar || param1.strFile == null)
         {
            return;
         }
         var _loc2_:String = param1.strFile;
         var _loc3_:int = int(_loc2_.indexOf("?r="));
         if(_loc3_ < 0)
         {
            _loc3_ = int(_loc2_.indexOf("&r="));
         }
         if(_loc3_ >= 0)
         {
            _loc2_ = _loc2_.substring(0,_loc3_);
         }
         param1.strFile = _loc2_ + (_loc2_.indexOf("?") < 0 ? "?r=" : "&r=") + uint(Math.random() * 16777215);
      }
      
      private function invokeCB(param1:Function, param2:*) : void
      {
         var fn:Function = param1;
         var arg:* = param2;
         if(fn != null)
         {
            try
            {
               fn(arg);
            }
            catch(err:Error)
            {
               rootClass.debugMessage("Loader cb error: " + err.message);
            }
         }
      }
      
      private function fireComplete(param1:LoaderData, param2:Event) : void
      {
         var _loc3_:LoaderData = null;
         if(param1 == null)
         {
            return;
         }
         this.invokeCB(param1.callBackA,param2);
         if(param1.waiters != null)
         {
            for each(var _loc6_ in param1.waiters)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_ != null && !_loc3_.cancelled)
               {
                  this.invokeCB(_loc3_.callBackA,param2);
               }
            }
         }
      }
      
      private function fireError(param1:LoaderData, param2:*) : void
      {
         var _loc3_:LoaderData = null;
         if(param1 == null)
         {
            return;
         }
         this.invokeCB(param1.callBackB,param2);
         if(param1.waiters != null)
         {
            for each(var _loc6_ in param1.waiters)
            {
               _loc3_ = _loc6_;
               _loc6_;
               if(_loc3_ != null && !_loc3_.cancelled)
               {
                  this.invokeCB(_loc3_.callBackB,param2);
               }
            }
         }
      }
      
      private function promoteWaiter(param1:LoaderData, param2:* = null) : LoaderData
      {
         var _loc5_:LoaderData = null;
         if(param1 == null || param1.waiters == null)
         {
            return null;
         }
         var _loc3_:LoaderData = null;
         var _loc4_:Vector.<LoaderData> = new Vector.<LoaderData>();
         for each(var _loc8_ in param1.waiters)
         {
            _loc5_ = _loc8_;
            _loc8_;
            if(!(_loc5_ == null || _loc5_.cancelled || param2 != null && _loc5_.avt == param2))
            {
               if(_loc3_ == null)
               {
                  _loc3_ = _loc5_;
               }
               else
               {
                  _loc4_.push(_loc5_);
               }
            }
         }
         if(_loc3_ != null)
         {
            _loc3_.waiters = _loc4_.length > 0 ? _loc4_ : null;
         }
         param1.waiters = null;
         return _loc3_;
      }
      
      public function loaderCallback(param1:Event) : void
      {
         var _loc2_:Loader = param1.target.loader;
         var _loc3_:LoaderSlot = this.getLoaderHost(_loc2_);
         this.classMissCache = {};
         var _loc4_:LoaderData = _loc3_ != null ? _loc3_.loaderData : null;
         if(_loc3_ != null)
         {
            _loc3_.loaderData = null;
         }
         this.closeLoader(_loc3_,true);
         if(_loc4_ != null)
         {
            this.fireComplete(_loc4_,param1);
            _loc4_.dispose();
         }
      }
      
      public function loaderHTTP(param1:HTTPStatusEvent) : void
      {
         var _loc2_:LoaderSlot = null;
         var _loc3_:String = null;
         if(param1.status != 200 && Boolean(this.rootClass.litePreference.data.bDebugger))
         {
            _loc2_ = this.getLoaderHostByLoaderInfo(param1.currentTarget);
            if(_loc2_)
            {
               trace("[Load] ERR loaderHTTP: " + _loc2_.url + " status " + param1.status);
               _loc3_ = "Queue: " + _loc2_.url + ";" + param1.status;
               this.rootClass.debugMessage(_loc3_);
            }
         }
      }
      
      public function loaderErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc5_:LoaderError = null;
         var _loc2_:String = param1.toString();
         var _loc3_:String = "";
         if(_loc2_.indexOf("URL: ") >= 0)
         {
            _loc3_ = _loc2_.substr(_loc2_.indexOf("URL: ") + 5);
            _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
         }
         var _loc4_:LoaderSlot = null;
         try
         {
            _loc4_ = this.getLoaderHost(param1.target.loader as Loader);
         }
         catch(errHost:Error)
         {
         }
         if(_loc4_ == null)
         {
            _loc4_ = this.getLoaderHostByURL(_loc3_);
         }
         if(_loc4_ != null && Boolean(_loc4_.loaderData))
         {
            _loc5_ = LoaderError.fromIOError(param1,_loc4_.url,_loc4_.loaderData);
            if(_loc5_.shouldRetry() && _loc4_.loaderData.retries > 0)
            {
               _loc4_.loaderData.retries--;
               this.bustRetryURL(_loc4_.loaderData);
               this.loaderQueue.push(_loc4_.loaderData);
               _loc4_.loaderData = null;
               this.closeLoader(_loc4_,false,false,true);
            }
            else
            {
               this.rootClass.debugMessage("Failed to load, Linkage: " + _loc4_.loaderData.sES + ", File: " + _loc4_.loaderData.strFile);
               this.fireError(_loc4_.loaderData,_loc5_);
               this.closeLoader(_loc4_,false,false,true);
            }
         }
         else
         {
            this.closeLoader(_loc4_,false,false,true);
         }
      }
      
      private function loaderProgressHandler(param1:ProgressEvent) : void
      {
         var _loc4_:Object = null;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:LoaderSlot = this.getLoaderHostByLoaderInfo(_loc2_);
         if(_loc3_ != null)
         {
            _loc3_.isOpen = true;
            if(Boolean(_loc3_.loaderData) && _loc3_.loaderData.callBackProgress != null)
            {
               try
               {
                  _loc4_ = {
                     "loaderData":_loc3_.loaderData,
                     "bytesLoaded":param1.bytesLoaded,
                     "bytesTotal":param1.bytesTotal,
                     "progress":(param1.bytesTotal > 0 ? param1.bytesLoaded / param1.bytesTotal : 0),
                     "slot":_loc3_.id
                  };
                  _loc3_.loaderData.callBackProgress(_loc4_);
               }
               catch(err:Error)
               {
               }
            }
         }
      }
      
      private function loaderTimerComplete(param1:TimerEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:LoaderSlot = this.getLoaderHostByTimer(Timer(param1.currentTarget));
         if(_loc2_ != null)
         {
            _loc2_.timer.reset();
            if(!_loc2_.isOpen)
            {
               if(Boolean(_loc2_.loaderData) && _loc2_.loaderData.retries > 0)
               {
                  _loc2_.loaderData.retries--;
                  this.bustRetryURL(_loc2_.loaderData);
                  this.loaderQueue.push(_loc2_.loaderData);
                  _loc2_.loaderData = null;
               }
               else
               {
                  this.fireError(_loc2_.loaderData,null);
               }
               this.closeLoader(_loc2_,false,true);
            }
            else if(!_loc2_.free)
            {
               _loc3_ = -1;
               try
               {
                  _loc3_ = _loc2_.ldr.contentLoaderInfo.bytesLoaded;
               }
               catch(errB:Error)
               {
               }
               if(_loc3_ > _loc2_.lastBytes)
               {
                  _loc2_.lastBytes = _loc3_;
                  _loc2_.timer.start();
               }
               else if(Boolean(_loc2_.loaderData) && _loc2_.loaderData.retries > 0)
               {
                  _loc2_.loaderData.retries--;
                  this.bustRetryURL(_loc2_.loaderData);
                  this.loaderQueue.push(_loc2_.loaderData);
                  _loc2_.loaderData = null;
                  this.closeLoader(_loc2_,false,false);
               }
               else
               {
                  this.fireError(_loc2_.loaderData,null);
                  this.closeLoader(_loc2_,false,false);
               }
            }
         }
      }
      
      public function getLoaderHost(param1:Loader) : LoaderSlot
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.loaderSlots.length)
         {
            if(this.loaderSlots[_loc2_].ldr == param1)
            {
               return this.loaderSlots[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getLoaderHostByLoaderInfo(param1:*) : LoaderSlot
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.loaderSlots.length)
         {
            if(this.loaderSlots[_loc2_].ldr.contentLoaderInfo == param1)
            {
               return this.loaderSlots[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getLoaderHostByTimer(param1:Timer) : LoaderSlot
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.loaderSlots.length)
         {
            if(this.loaderSlots[_loc2_].timer == param1)
            {
               return this.loaderSlots[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getLoaderHostByURL(param1:String) : LoaderSlot
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.loaderSlots.length)
         {
            if(param1 && this.loaderSlots[_loc2_].url && this.loaderSlots[_loc2_].url.length > 0 && param1.indexOf(this.loaderSlots[_loc2_].url) > -1)
            {
               return this.loaderSlots[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getFreeLoader() : LoaderSlot
      {
         var _loc1_:int = 0;
         if(this.loaderQueue.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.loaderSlots.length)
            {
               if(this.loaderSlots[_loc1_].free)
               {
                  return this.loaderSlots[_loc1_];
               }
               _loc1_++;
            }
            return null;
         }
         return null;
      }
      
      public function closeLoader(param1:LoaderSlot, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true) : void
      {
         var _loc5_:MovieClip = null;
         var _loc6_:LoaderSlot = null;
         if(!param1)
         {
            return;
         }
         param1.timer.stop();
         param1.timer.reset();
         try
         {
            if(param1.ldr && param1.ldr.content != null && param1.ldr.content is MovieClip)
            {
               _loc5_ = MovieClip(param1.ldr.content);
               _loc5_.stop();
               this.rootClass.recursiveStop(_loc5_);
            }
         }
         catch(e:Error)
         {
         }
         if(!param2 || !param3)
         {
            try
            {
               param1.ldr.close();
            }
            catch(e:Error)
            {
            }
            try
            {
               param1.ldr.unloadAndStop(true);
            }
            catch(e:Error)
            {
            }
         }
         if(param1.loaderData)
         {
            param1.loaderData.dispose();
         }
         param1.reset();
         if(param4 && this.loaderQueue.length > 0)
         {
            _loc6_ = this.getFreeLoader();
            if(_loc6_ != null)
            {
               this.loadNext(_loc6_);
            }
         }
      }
      
      public function loaderSecurityErrorHandler(param1:SecurityErrorEvent) : void
      {
         var _loc5_:LoaderError = null;
         var _loc2_:String = param1.toString();
         trace("[Load] ERR loaderSecurityErrorHandler: " + _loc2_);
         this.rootClass.debugMessage("Security Error: " + _loc2_);
         var _loc3_:String = "";
         if(_loc2_.indexOf("URL: ") > -1)
         {
            _loc3_ = _loc2_.substr(_loc2_.indexOf("URL: ") + 5);
            _loc3_ = _loc3_.substr(0,_loc3_.length - 1);
         }
         var _loc4_:LoaderSlot = null;
         try
         {
            _loc4_ = this.getLoaderHost(param1.target.loader as Loader);
         }
         catch(errHost:Error)
         {
         }
         if(_loc4_ == null)
         {
            _loc4_ = this.getLoaderHostByURL(_loc3_);
         }
         if(_loc4_ != null)
         {
            _loc5_ = LoaderError.fromSecurityError(_loc3_,_loc4_.loaderData);
            this.fireError(_loc4_.loaderData,_loc5_);
         }
         this.closeLoader(_loc4_,false,false);
      }
      
      public function initLoaders() : void
      {
         if(this.loaderSlots.length == 0)
         {
            this.initLoaderSlots();
         }
      }
      
      public function clearLoaders(param1:Boolean = false) : void
      {
         var _loc3_:LoaderSlot = null;
         var _loc4_:MovieClip = null;
         var _loc5_:LoaderData = null;
         var _loc6_:String = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.loaderSlots.length)
         {
            _loc3_ = this.loaderSlots[_loc2_];
            if(_loc3_.loaderData != null && this.myAvatar != null && _loc3_.loaderData.avt == this.myAvatar && !_loc3_.loaderData.cancelled)
            {
               this.fireError(_loc3_.loaderData,null);
            }
            _loc3_.timer.stop();
            _loc3_.timer.reset();
            try
            {
               _loc3_.ldr.close();
            }
            catch(e:Error)
            {
            }
            try
            {
               if(_loc3_.ldr.content != null && _loc3_.ldr.content is MovieClip)
               {
                  _loc4_ = MovieClip(_loc3_.ldr.content);
                  _loc4_.stop();
                  this.rootClass.recursiveStop(_loc4_);
               }
            }
            catch(e:Error)
            {
            }
            try
            {
               _loc3_.ldr.unloadAndStop(true);
            }
            catch(e:Error)
            {
            }
            if(_loc3_.loaderData)
            {
               _loc3_.loaderData.dispose();
            }
            _loc3_.reset();
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.loaderQueue.length)
         {
            _loc5_ = this.loaderQueue[_loc2_];
            if(_loc5_ != null && this.myAvatar != null && _loc5_.avt == this.myAvatar && !_loc5_.cancelled)
            {
               this.fireError(_loc5_,null);
            }
            if(_loc5_)
            {
               _loc5_.dispose();
            }
            _loc2_++;
         }
         this.loaderQueue = new Vector.<LoaderData>();
         if(param1)
         {
            this.playerDomainsCache.clear();
            for(var _loc9_ in this.playerDomains)
            {
               _loc6_ = _loc9_;
               _loc9_;
               delete this.playerDomains[_loc6_];
            }
            this.playerDomains = {};
         }
         this.loaderD = new ApplicationDomain(ApplicationDomain.currentDomain);
         this.loaderC = new LoaderContext(false,this.loaderD);
         this.classMissCache = {};
         if(System.totalMemory > 200 * 1024 * 1024)
         {
            try
            {
               System.gc();
               System.gc();
            }
            catch(e:Error)
            {
            }
         }
         else
         {
            try
            {
               System.gc();
            }
            catch(e:Error)
            {
            }
         }
      }
      
      public function killLoaders() : void
      {
         var _loc2_:LoaderSlot = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.loaderSlots.length)
         {
            _loc2_ = this.loaderSlots[_loc1_];
            _loc2_.timer.stop();
            _loc2_.timer.reset();
            _loc2_.reset();
            _loc1_++;
         }
         this.loaderQueue = new Vector.<LoaderData>();
      }
      
      public function loadNext(param1:LoaderSlot) : void
      {
         var _loc2_:LoaderData = null;
         if(this.loaderQueue.length > 0)
         {
            _loc2_ = this.loaderQueue.shift();
            this.loadNextWith(param1,_loc2_);
         }
      }
      
      private function loadNextWith(param1:LoaderSlot, param2:LoaderData) : void
      {
         var c:LoaderContext;
         var u:URLRequest = null;
         var slot:LoaderSlot = param1;
         var ld:LoaderData = param2;
         if(!slot || !ld)
         {
            return;
         }
         u = new URLRequest(ld.strFile);
         c = this.loaderC;
         slot.assign(ld);
         slot.url = u.url;
         if(ld.avt != null && ld.avt == this.myAvatar && ld.sES != null)
         {
            c = this.mapPlayerAssetClass(ld.sES);
         }
         try
         {
            slot.ldr.load(u,c);
         }
         catch(e:Error)
         {
            trace("[Load] ERR loadNextWith: " + u.url + " " + e.message);
            fireError(ld,null);
            closeLoader(slot,false,false,true);
            return;
         }
         slot.isOpen = false;
         slot.timer.reset();
         slot.timer.start();
      }
      
      private function mapPlayerAssetClass(param1:String) : LoaderContext
      {
         var _loc2_:LoaderContext = this.playerDomainsCache.getContext(param1);
         if(this.playerDomains[param1] == null)
         {
            this.playerDomains[param1] = {
               "loaderD":null,
               "loaderC":_loc2_
            };
         }
         return _loc2_;
      }
      
      public function cancelLoad(param1:*) : Boolean
      {
         var _loc3_:LoaderData = null;
         var _loc4_:int = 0;
         var _loc5_:LoaderData = null;
         var _loc6_:LoaderData = null;
         var _loc7_:String = null;
         var _loc2_:Boolean = false;
         if(param1 is LoaderData)
         {
            _loc3_ = param1 as LoaderData;
            _loc4_ = 0;
            while(_loc4_ < this.loaderSlots.length)
            {
               if(this.loaderSlots[_loc4_].loaderData == _loc3_)
               {
                  _loc3_.cancelled = true;
                  _loc5_ = this.promoteWaiter(_loc3_);
                  this.closeLoader(this.loaderSlots[_loc4_],false,false,true);
                  if(_loc5_ != null)
                  {
                     this.queueLoad(_loc5_);
                  }
                  _loc2_ = true;
                  break;
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < this.loaderQueue.length)
            {
               if(this.loaderQueue[_loc4_] == _loc3_)
               {
                  _loc3_.cancelled = true;
                  _loc6_ = this.promoteWaiter(_loc3_);
                  _loc3_.dispose();
                  this.loaderQueue.splice(_loc4_,1);
                  if(_loc6_ != null)
                  {
                     this.queueLoad(_loc6_);
                  }
                  _loc2_ = true;
                  break;
               }
               _loc4_++;
            }
         }
         else if(param1 is String)
         {
            _loc7_ = param1 as String;
            _loc4_ = 0;
            while(_loc4_ < this.loaderSlots.length)
            {
               if(Boolean(this.loaderSlots[_loc4_].url) && this.loaderSlots[_loc4_].url.indexOf(_loc7_) >= 0)
               {
                  if(this.loaderSlots[_loc4_].loaderData)
                  {
                     this.loaderSlots[_loc4_].loaderData.cancelled = true;
                  }
                  this.closeLoader(this.loaderSlots[_loc4_],false,false,true);
                  _loc2_ = true;
               }
               _loc4_++;
            }
            _loc4_ = 0;
            while(_loc4_ < this.loaderQueue.length)
            {
               if(Boolean(this.loaderQueue[_loc4_].strFile) && this.loaderQueue[_loc4_].strFile.indexOf(_loc7_) >= 0)
               {
                  this.loaderQueue[_loc4_].cancelled = true;
                  this.loaderQueue[_loc4_].dispose();
                  this.loaderQueue.splice(_loc4_,1);
                  _loc2_ = true;
                  _loc4_--;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function cancelAvatarLoads(param1:*) : int
      {
         var _loc5_:LoaderData = null;
         var _loc6_:LoaderData = null;
         var _loc7_:LoaderData = null;
         var _loc2_:int = 0;
         var _loc3_:Vector.<LoaderData> = new Vector.<LoaderData>();
         var _loc4_:int = 0;
         while(_loc4_ < this.loaderSlots.length)
         {
            if(Boolean(this.loaderSlots[_loc4_].loaderData) && this.loaderSlots[_loc4_].loaderData.avt == param1)
            {
               this.loaderSlots[_loc4_].loaderData.cancelled = true;
               _loc6_ = this.promoteWaiter(this.loaderSlots[_loc4_].loaderData,param1);
               if(_loc6_ != null)
               {
                  _loc3_.push(_loc6_);
               }
               this.closeLoader(this.loaderSlots[_loc4_],false,false,true);
               _loc2_++;
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < this.loaderQueue.length)
         {
            if(this.loaderQueue[_loc4_].avt == param1)
            {
               this.loaderQueue[_loc4_].cancelled = true;
               _loc7_ = this.promoteWaiter(this.loaderQueue[_loc4_],param1);
               if(_loc7_ != null)
               {
                  _loc3_.push(_loc7_);
               }
               this.loaderQueue[_loc4_].dispose();
               this.loaderQueue.splice(_loc4_,1);
               _loc2_++;
            }
            else
            {
               _loc4_++;
            }
         }
         for each(var _loc10_ in _loc3_)
         {
            _loc5_ = _loc10_;
            _loc10_;
            this.queueLoad(_loc5_);
         }
         return _loc2_;
      }
      
      public function cancelAllLoads() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this.loaderSlots.length)
         {
            if(!this.loaderSlots[_loc2_].free)
            {
               if(this.loaderSlots[_loc2_].loaderData)
               {
                  this.loaderSlots[_loc2_].loaderData.cancelled = true;
                  _loc1_++;
               }
               this.closeLoader(this.loaderSlots[_loc2_],false,false,false);
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.loaderQueue.length)
         {
            this.loaderQueue[_loc2_].cancelled = true;
            this.loaderQueue[_loc2_].dispose();
            _loc1_++;
            _loc2_++;
         }
         this.loaderQueue = new Vector.<LoaderData>();
         return _loc1_;
      }
      
      public function getClass(param1:String) : Class
      {
         var _loc2_:Class = null;
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:LoaderContext = null;
         if(this.classMissCache[param1])
         {
            return null;
         }
         try
         {
            _loc2_ = getDefinitionByName(param1) as Class;
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.rootClass.assetsDomain.getDefinition(param1) as Class;
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            _loc2_ = this.loaderD.getDefinition(param1) as Class;
            if(_loc2_ != null)
            {
               return _loc2_;
            }
         }
         catch(e:Error)
         {
         }
         var _loc3_:Object = this.playerDomainsCache.getStats();
         if(Boolean(_loc3_) && Boolean(_loc3_.entries))
         {
            for each(var _loc9_ in _loc3_.entries)
            {
               _loc5_ = _loc9_;
               _loc9_;
               try
               {
                  _loc6_ = this.playerDomainsCache.getContext(_loc5_);
                  if((Boolean(_loc6_)) && _loc6_.applicationDomain.hasDefinition(param1))
                  {
                     return _loc6_.applicationDomain.getDefinition(param1) as Class;
                  }
               }
               catch(e:Error)
               {
               }
            }
         }
         for(_loc9_ in this.playerDomains)
         {
            _loc4_ = _loc9_;
            _loc9_;
            try
            {
               if(Boolean(this.playerDomains[_loc4_].loaderD) && Boolean(this.playerDomains[_loc4_].loaderD.hasDefinition(param1)))
               {
                  return this.playerDomains[_loc4_].loaderD.getDefinition(param1) as Class;
               }
            }
            catch(e:Error)
            {
            }
         }
         this.classMissCache[param1] = true;
         trace("[Load] ERR getClass: could not find " + param1);
         if(!this.rootClass.litePreference.data.dOptions["debugLinkage"])
         {
            this.rootClass.debugMessage("Failed to find Linkage: " + param1);
         }
         return null;
      }
      
      public function loadMap(param1:String) : *
      {
         if(param1.indexOf("cdn.aq.com") == -1)
         {
            param1 = this.rootClass.getFilePath() + "maps/" + param1;
         }
         trace("[Map] loadMap: " + param1);
         this.rootClass.mcConnDetail.showConn("Loading Map Files...");
         this.mapEntered = false;
         this.bMapWarm = false;
         this.monLoadGen++;
         if(this.cHandle != null)
         {
            this.cHandle.cancel();
         }
         this.pendingMapEvents.length = 0;
         removeEventListener(Event.ENTER_FRAME,this.flushMapEvents);
         if(this.map != null)
         {
            try
            {
               this.map.gotoAndStop("Wait");
            }
            catch(e:Error)
            {
            }
            this.removeChild(this.map);
            this.map = null;
         }
         this.ldr_map.contentLoaderInfo.removeEventListener(Event.INIT,this.onMapLoadInit);
         this.ldr_map.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onMapLoadComplete);
         this.ldr_map.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onMapLoadError);
         this.ldr_map.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onMapHTTPError);
         this.ldr_map.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onMapLoadProgress);
         this.ldr_map.uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onMapUncaughtError);
         this.ldr_map = new Loader();
         this.ldrC_map = new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain));
         this.ldr_map.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onMapUncaughtError,false,0,true);
         this.ldr_map.contentLoaderInfo.addEventListener(Event.INIT,this.onMapLoadInit,false,0,true);
         this.ldr_map.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onMapLoadComplete,false,0,true);
         this.ldr_map.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onMapLoadError,false,0,true);
         this.ldr_map.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,this.onMapHTTPError,false,0,true);
         this.ldr_map.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onMapLoadProgress,false,0,true);
         this.ldr_map.load(new URLRequest(this.rootClass.vswf(param1)),this.ldrC_map);
         this.rootClass.clearPopups();
      }
      
      public function removeMapListeners() : void
      {
         this.ldr_map.contentLoaderInfo.removeEventListener(Event.INIT,this.onMapLoadInit);
         this.ldr_map.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onMapLoadComplete);
         this.ldr_map.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onMapLoadError);
         this.ldr_map.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,this.onMapHTTPError);
         this.ldr_map.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onMapLoadProgress);
      }
      
      private function onMapHTTPError(param1:HTTPStatusEvent) : void
      {
         var _loc2_:String = null;
         if(param1.status != 200 && Boolean(this.rootClass.litePreference.data.bDebugger))
         {
            this.mapLoadInProgress = false;
            trace("[Map] ERR onMapHTTPError: status " + param1.status);
            _loc2_ = "Map File: " + this.ldr_map.contentLoaderInfo.url + ";" + param1.status;
            this.rootClass.debugMessage(_loc2_);
            this.removeMapListeners();
            this.rootClass.mcConnDetail.showError(_loc2_);
         }
      }
      
      private function onMapLoadProgress(param1:ProgressEvent) : void
      {
         var _loc2_:int = Math.floor(param1.bytesLoaded / param1.bytesTotal * 100);
         this.rootClass.mcConnDetail.showConn("Loading Map... " + _loc2_ + "%");
      }
      
      private function onMapLoadError(param1:IOErrorEvent) : *
      {
         trace("[Map] ERR onMapLoadError: " + param1.text);
         this.mapLoadInProgress = false;
         this.removeMapListeners();
         if(this.rootClass.litePreference.data.bDebugger)
         {
            this.rootClass.debugMessage("Failed to load Map: " + param1);
         }
         else
         {
            this.rootClass.mcConnDetail.showError("Loading Map Files... Failed!");
         }
      }
      
      private function onMapUncaughtError(param1:UncaughtErrorEvent) : void
      {
         var _loc2_:Error = null;
         param1.preventDefault();
         param1.stopImmediatePropagation();
         try
         {
            _loc2_ = param1.error as Error;
            this.rootClass.debugMessage("suppressed map error: " + (_loc2_ != null ? _loc2_.message : String(param1.error)));
         }
         catch(e2:Error)
         {
         }
      }
      
      private function onMapLoadInit(param1:Event) : void
      {
         this.map = MovieClip(this.ldr_map.content);
         if(this.map != null && this.map.parent != this)
         {
            addChildAt(this.map,0).x = 0;
         }
      }
      
      private function onMapLoadComplete(param1:Event) : *
      {
         trace("[Map] onMapLoadComplete: " + param1.target.url);
         this.rootClass.ui.visible = true;
         this.mapLoadInProgress = false;
         this.map = MovieClip(this.ldr_map.content);
         if(this.map != null && this.map.parent != this)
         {
            addChildAt(this.map,0).x = 0;
         }
         this.CHARS.x = 0;
         this.resetSpawnPoint();
         if(this.mondef != null && Boolean(this.mondef.length))
         {
            this.initMonsters(this.mondef,this.monmap);
         }
         else
         {
            this.enterMap();
         }
         if(this.isMyHouse() && this.rootClass.ui.mcPopup.currentLabel != "House")
         {
            this.rootClass.ui.mcPopup.fOpen("House");
         }
         if(Boolean(this.rootClass.cMenuUI) && Boolean(this.rootClass.cMenuUI.isMenuOpen()))
         {
            this.rootClass.cMenuUI.reDraw();
         }
      }
      
      public function reloadCurrentMap() : void
      {
         this.cleanupMap();
         this.clearMonstersAndProps();
         this.loadMap(this.strMapFileName + "?" + Math.random());
      }
      
      public function enterMap() : void
      {
         var _loc1_:* = this.uoTreeLeaf(this.rootClass.sfc.myUserName);
         if(this.cHandle != null && this.cHandle.isPending())
         {
            trace("[Map] enterMap: cutscene pending, deferring spawn move");
         }
         else if(this.intType == 0 || this.returnInfo == null)
         {
            trace("[Map] enterMap: cell " + _loc1_.strFrame + " pad " + _loc1_.strPad);
            this.moveToCell(_loc1_.strFrame,_loc1_.strPad);
         }
         else
         {
            this.moveToCell(this.returnInfo.strCell,this.returnInfo.strPad);
            this.returnInfo = null;
         }
         this.initMapEvents();
         this.rootClass.mcConnDetail.hideConn();
         if(!this.rootClass.litePreference.data.bHideUI)
         {
            this.rootClass.ui.mcInterface.areaList.visible = true;
         }
         if(this.myAvatar != null)
         {
            this.rootClass.showPortrait(this.myAvatar);
         }
         if(this.isMyHouse())
         {
            this.initMassConvert();
         }
         this.mapEntered = true;
      }
      
      public function setReturnInfo(param1:String, param2:String, param3:String) : void
      {
         this.returnInfo = new Object();
         this.returnInfo.strMap = param1;
         this.returnInfo.strCell = param2;
         this.returnInfo.strPad = param3;
      }
      
      private function breakCircularRefs() : void
      {
         var _loc1_:Avatar = null;
         var _loc2_:Avatar = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         for each(var _loc7_ in this.avatars)
         {
            _loc1_ = _loc7_;
            _loc7_;
            if(_loc1_ != null && _loc1_.dataLeaf != null && _loc1_.dataLeaf.auras != null)
            {
               for each(var _loc9_ in _loc1_.dataLeaf.auras)
               {
                  _loc3_ = _loc9_;
                  _loc9_;
                  _loc3_.casterType = null;
                  _loc3_.casterId = null;
               }
            }
         }
         for each(_loc7_ in this.monsters)
         {
            _loc2_ = _loc7_;
            _loc7_;
            if(_loc2_ != null && _loc2_.dataLeaf != null && _loc2_.dataLeaf.auras != null)
            {
               for each(_loc9_ in _loc2_.dataLeaf.auras)
               {
                  _loc4_ = _loc9_;
                  _loc9_;
                  _loc4_.casterType = null;
                  _loc4_.casterId = null;
               }
            }
         }
      }
      
      public function hideCharsForBlank() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.CHARS.numChildren)
         {
            this.CHARS.getChildAt(_loc1_).visible = false;
            _loc1_++;
         }
         this.hideAvatarsForCellChange();
      }
      
      public function exitCell(param1:Boolean = false) : void
      {
         if(!param1)
         {
            this.hideCharsForBlank();
         }
         this.mvTimerKill();
         this.exitCombat();
         this.breakCircularRefs();
         this.arrSolid = [];
         this.arrEvent = [];
         this.arrSolidR = [];
         this.arrEventR = [];
         this.cellSetupStamp = null;
         this.rootClass.clearPopups(["House"]);
         if(this.myAvatar != null)
         {
            this.myAvatar.targets = {};
            if(this.myAvatar.pMC != null)
            {
               this.myAvatar.pMC.stopWalking();
            }
            if(this.myAvatar.petMC != null)
            {
               this.myAvatar.petMC.stopWalking();
            }
            if(this.myAvatar.target != null)
            {
               this.setTarget(null);
            }
         }
         this.rootClass.sfcSocial = false;
         this.rootClass.ui.mcInterface.areaList.gotoAndStop("init");
      }
      
      public function cleanupMap() : void
      {
         if(this.ldr_map != null)
         {
            try
            {
               this.ldr_map.close();
            }
            catch(e:Error)
            {
            }
            try
            {
               this.ldr_map.unloadAndStop(true);
            }
            catch(e:Error)
            {
            }
         }
         if(this.sController != null && this.sController.mChannel != null)
         {
            try
            {
               this.sController.mChannel.stop();
            }
            catch(e:Error)
            {
            }
         }
         try
         {
            this.killWalkObjects();
         }
         catch(eKW:Error)
         {
            trace("[Map] ERR cleanupMap killWalkObjects: " + eKW.message);
         }
         this.arrSolid = [];
         this.arrEvent = [];
         this.arrSolidR = [];
         this.arrEventR = [];
         this.mapBoundsMC = null;
         this.cellSetupStamp = null;
         try
         {
            System.gc();
         }
         catch(e:Error)
         {
         }
      }
      
      public function mapEventTrigger(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.pendingMapEvents.push(param1);
         if(this.pendingMapEvents.length > 20)
         {
            this.pendingMapEvents.shift();
         }
         this.mapEvtWait = 450;
         if(this.pendingMapEvents.length == 1)
         {
            addEventListener(Event.ENTER_FRAME,this.flushMapEvents,false,0,true);
         }
      }
      
      private function flushMapEvents(param1:Event) : void
      {
         var ext:MovieClip;
         var i:int = 0;
         var c:* = undefined;
         var o:Object = null;
         var j:int = 0;
         var e:Event = param1;
         var targets:Array = [];
         if(this.map != null && "eventTrigger" in this.map)
         {
            targets.push(this.map);
         }
         ext = this.rootClass.mcExtSWF as MovieClip;
         if(ext != null)
         {
            i = 0;
            while(i < ext.numChildren)
            {
               c = ext.getChildAt(i);
               if(c != null && "eventTrigger" in c)
               {
                  targets.push(c);
               }
               i++;
            }
         }
         if(targets.length > 0)
         {
            while(this.pendingMapEvents.length > 0)
            {
               o = this.pendingMapEvents.shift();
               j = 0;
               while(j < targets.length)
               {
                  trace("[Map] flushMapEvents: " + o.cmd + " -> " + targets[j].name);
                  try
                  {
                     targets[j].eventTrigger(o);
                  }
                  catch(err:Error)
                  {
                     rootClass.debugMessage("eventTrigger error: " + err.message);
                  }
                  j++;
               }
            }
         }
         if(this.pendingMapEvents.length == 0 || --this.mapEvtWait <= 0)
         {
            if(this.pendingMapEvents.length > 0)
            {
               trace("[Map] ERR flushMapEvents: dropped " + this.pendingMapEvents.length + " events");
            }
            this.pendingMapEvents.length = 0;
            removeEventListener(Event.ENTER_FRAME,this.flushMapEvents);
         }
      }
      
      private function blankGotoNow() : void
      {
         this.bMapWarm = true;
         this.hideCharsForBlank();
         try
         {
            this.map.gotoAndPlay("Blank");
         }
         catch(err:Error)
         {
            rootClass.debugMessage("map frame script error: " + err.message);
            if(map.currentLabel != strFrame)
            {
               try
               {
                  map.gotoAndStop(strFrame);
               }
               catch(err2:Error)
               {
                  rootClass.debugMessage("blank fallback goto failed: " + err2.message);
               }
            }
         }
      }
      
      private function mapGotoBlank() : void
      {
         if(this.cHandle != null && this.cHandle.isPending())
         {
            trace("[Map] mapGotoBlank: skipped, cutscene pending");
            this.hideCharsForBlank();
            return;
         }
         if(this.intBlankWait < 0)
         {
            addEventListener(Event.ENTER_FRAME,this.doBlankGoto,false,0,true);
         }
         this.intBlankWait = this.bMapWarm && this.map != null && this.map.stage != null ? 1 : 2;
      }
      
      private function doBlankGoto(param1:Event) : void
      {
         if(this.map == null)
         {
            this.intBlankWait = -1;
            removeEventListener(Event.ENTER_FRAME,this.doBlankGoto);
            return;
         }
         if(this.cHandle != null && this.cHandle.isPending())
         {
            this.intBlankWait = -1;
            removeEventListener(Event.ENTER_FRAME,this.doBlankGoto);
            trace("[Map] doBlankGoto: skipped, cutscene pending");
            this.hideCharsForBlank();
            return;
         }
         if(this.map.stage == null)
         {
            return;
         }
         this.intBlankWait--;
         if(this.intBlankWait > 0)
         {
            return;
         }
         this.intBlankWait = -1;
         removeEventListener(Event.ENTER_FRAME,this.doBlankGoto);
         this.blankGotoNow();
      }
      
      public function clearCellSetupStamp() : void
      {
         this.cellSetupStamp = null;
      }
      
      private function startCellArrivalWatch(param1:String) : void
      {
         this.cellWatchFrame = param1;
         this.cellWatchTicks = 45;
         removeEventListener(Event.ENTER_FRAME,this.cellArrivalWatch);
         addEventListener(Event.ENTER_FRAME,this.cellArrivalWatch,false,0,true);
      }
      
      private function cellArrivalWatch(param1:Event) : void
      {
         var strB:String;
         var strA:String = null;
         var e:Event = param1;
         if(stage == null || this.map == null || this.cellWatchFrame == null || this.strFrame != this.cellWatchFrame || this.cHandle != null && this.cHandle.isPending())
         {
            removeEventListener(Event.ENTER_FRAME,this.cellArrivalWatch);
            this.cellWatchFrame = null;
            return;
         }
         if(this.map.currentLabel == this.cellWatchFrame && !this.map.isPlaying)
         {
            removeEventListener(Event.ENTER_FRAME,this.cellArrivalWatch);
            strA = this.cellWatchFrame;
            this.cellWatchFrame = null;
            this.verifyCellSetup(strA);
            return;
         }
         if(--this.cellWatchTicks > 0)
         {
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.cellArrivalWatch);
         if(this.map.currentLabel != this.cellWatchFrame || this.map.isPlaying)
         {
            trace("[Map] ERR cellArrivalWatch: map at " + this.map.currentLabel + (this.map.isPlaying ? " playing" : "") + ", forcing " + this.cellWatchFrame);
            try
            {
               this.map.gotoAndStop(this.cellWatchFrame);
            }
            catch(err:Error)
            {
               rootClass.debugMessage("cell arrival force failed: " + err.message);
               try
               {
                  map.gotoAndStop("Enter");
               }
               catch(err2:Error)
               {
               }
            }
         }
         strB = this.cellWatchFrame;
         this.cellWatchFrame = null;
         this.verifyCellSetup(strB);
      }
      
      private function verifyCellSetup(param1:String) : void
      {
         var strF:String = param1;
         if(this.map == null || strF == null || this.strFrame != strF)
         {
            return;
         }
         if(this.cellSetupStamp != strF)
         {
            trace("[Map] ERR verifyCellSetup: cellSetup never ran for " + strF + ", forcing");
            try
            {
               this.cellSetup(this.SCALE,this.WALKSPEED,this.CELL_MODE);
            }
            catch(eFS:Error)
            {
               rootClass.debugMessage("forced cellSetup failed: " + eFS.message);
            }
         }
         if(!this.bitWalk && this.houseFrame == "" && this.myAvatar != null && this.rootClass.sfc != null && this.rootClass.sfc.myUserName != null && (this.cHandle == null || !this.cHandle.isPending()) && this.uoTreeLeaf(this.rootClass.sfc.myUserName).freeze == null)
         {
            trace("[Map] ERR verifyCellSetup: bitWalk stuck, re-running playerInit");
            try
            {
               this.playerInit();
            }
            catch(ePW:Error)
            {
               rootClass.debugMessage("forced playerInit failed: " + ePW.message);
            }
         }
      }
      
      private function schedulePropWireSweep() : void
      {
         if(this.propWireTicks < 0)
         {
            addEventListener(Event.ENTER_FRAME,this.propWireTick,false,0,true);
         }
         this.propWireTicks = 2;
      }
      
      private function propWireTick(param1:Event) : void
      {
         if(this.map == null || this.map.stage == null)
         {
            this.propWireTicks = -1;
            removeEventListener(Event.ENTER_FRAME,this.propWireTick);
            return;
         }
         if(--this.propWireTicks > 0)
         {
            return;
         }
         this.propWireTicks = -1;
         removeEventListener(Event.ENTER_FRAME,this.propWireTick);
         this.propWireSweep(this.map,0);
         this.propWireSweep(this.CHARS,0);
      }
      
      private function propWireSweep(param1:DisplayObjectContainer, param2:int) : void
      {
         var c:DisplayObject = null;
         var m:MovieClip = null;
         var cont:DisplayObjectContainer = param1;
         var depth:int = param2;
         var i:int = 0;
         while(i < cont.numChildren)
         {
            c = cont.getChildAt(i);
            m = c as MovieClip;
            if(m != null && ("iaType" in m && "strLinkage" in m || "isHouseItem" in m && m.isHouseItem == true) && m.stage != null && m.hasEventListener(Event.ADDED_TO_STAGE))
            {
               try
               {
                  m.dispatchEvent(new Event(Event.ADDED_TO_STAGE));
               }
               catch(err:Error)
               {
                  rootClass.debugMessage("propWireSweep: " + err.message);
               }
            }
            if(depth < 1 && c is DisplayObjectContainer)
            {
               this.propWireSweep(DisplayObjectContainer(c),depth + 1);
            }
            i++;
         }
      }
      
      private function scheduleCellSettle() : void
      {
         this.cellSettleFrame = this.strFrame;
         if(this.cellSettleTicks < 0)
         {
            addEventListener(Event.ENTER_FRAME,this.cellSettleTick,false,0,true);
         }
         this.cellSettleTicks = 2;
      }
      
      private function cellSettleTick(param1:Event) : void
      {
         if(this.map == null || this.map.stage == null || this.cellSettleFrame == null || this.cellSettleFrame != this.strFrame || this.cellSetupStamp != this.cellSettleFrame || this.cHandle != null && this.cHandle.isPending())
         {
            this.cellSettleTicks = -1;
            this.cellSettleFrame = null;
            removeEventListener(Event.ENTER_FRAME,this.cellSettleTick);
            return;
         }
         if(--this.cellSettleTicks > 0)
         {
            return;
         }
         this.cellSettleTicks = -1;
         this.cellSettleFrame = null;
         removeEventListener(Event.ENTER_FRAME,this.cellSettleTick);
         this.cellSettleSweep();
      }
      
      private function hasButtonChild(param1:MovieClip) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc2_) is SimpleButton)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function cellSettleSweep() : void
      {
         var child:DisplayObject = null;
         var m:MovieClip = null;
         var j:uint = 0;
         var cm:MovieClip = null;
         var oref:* = undefined;
         var late:int = 0;
         var i:int = 0;
         for(; i < this.map.numChildren; i++)
         {
            child = this.map.getChildAt(i);
            m = child as MovieClip;
            if(m != null)
            {
               try
               {
                  if(m.hasPads)
                  {
                     j = 0;
                     while(j < m.numChildren)
                     {
                        cm = m.getChildAt(j) as MovieClip;
                        if(cm != null)
                        {
                           if(cm.isEvent && !cm.isProp && this.arrEvent.indexOf(cm) == -1)
                           {
                              this.arrEvent.push(cm);
                              late++;
                           }
                           if(Boolean(cm.isSolid) && this.arrSolid.indexOf(m) == -1)
                           {
                              this.arrSolid.push(m);
                              late++;
                           }
                        }
                        j++;
                     }
                  }
                  if(Boolean(m.isSolid) && this.arrSolid.indexOf(m) == -1)
                  {
                     this.arrSolid.push(m);
                     late++;
                  }
                  if(m.isEvent && !m.isProp && this.arrEvent.indexOf(m) == -1)
                  {
                     this.arrEvent.push(m);
                     late++;
                  }
                  if("walk" in m && m.btnWalkingArea != null)
                  {
                     m.btnWalkingArea.useHandCursor = false;
                  }
                  if(Boolean(m.isProp) && !m.isMonster)
                  {
                     oref = this.CHARS.addChild(m);
                     MovieClip(oref).propCell = this.strMapName + ":" + this.map.currentLabel;
                     if(MovieClip(oref).isEvent)
                     {
                        if(this.arrEvent.indexOf(MovieClip(oref)) == -1)
                        {
                           this.arrEvent.push(MovieClip(oref));
                        }
                        MovieClip(oref).isEvent = false;
                        MovieClip(oref).wasPropEvent = true;
                     }
                     i--;
                     late++;
                  }
                  if(m.width > 700 && !("isSolid" in m) && !("walk" in m) && !("btnSkip" in m) && !m.hasEventListener(MouseEvent.CLICK) && !this.hasButtonChild(m))
                  {
                     m.mouseEnabled = false;
                     m.mouseChildren = false;
                  }
               }
               catch(eLS:Error)
               {
                  trace("[Map] ERR cellSettleSweep child " + (child != null ? child.name : "null") + ": " + eLS.message);
                  continue;
               }
            }
         }
         if(late > 0)
         {
            trace("[Map] cellSettleSweep: wired " + late + " late children for " + this.strFrame);
            try
            {
               this.buildBoundingRects();
            }
            catch(eBR:Error)
            {
               trace("[Map] ERR cellSettleSweep buildBoundingRects: " + eBR.message);
            }
            this.schedulePropWireSweep();
         }
         try
         {
            this.placeMissingCellMonsters(this.monLoadsSettled >= this.monLoadsExpected);
         }
         catch(ePM:Error)
         {
         }
      }
      
      public function moveToCell(param1:String, param2:String, param3:Boolean = false, param4:Boolean = false) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this.strMapName == "trickortreat" && param1 != "Enter")
         {
            if(!this.TrickOrTreatMonsterDead)
            {
               return;
            }
         }
         if(this.strMapName == "caroling" && param1 != "Enter")
         {
            if(this.CarolingMonsterKillCount < 5)
            {
               return;
            }
         }
         this.afkPostpone();
         if(this.objLock == null || this.objLock[param1] == null || this.objLock[param1] <= this.intKillCount)
         {
            if(this.uoTree[this.rootClass.sfc.myUserName].freeze == null)
            {
               _loc5_ = [];
               this.actionReady = false;
               this.bitWalk = false;
               _loc6_ = {};
               _loc6_.strFrame = param1;
               _loc6_.strPad = param2;
               if(param2.toLowerCase() != "none")
               {
                  _loc6_.tx = 0;
                  _loc6_.ty = 0;
               }
               this.uoTreeLeafSet(this.rootClass.sfc.myUserName,_loc6_);
               this.strFrame = param1;
               this.strPad = param2;
               if(this.strAreaName.indexOf("battleon") < 0 || this.strAreaName.indexOf("battleontown") > -1)
               {
                  this.rootClass.menuClose();
               }
               if(!param3)
               {
                  this.rootClass.sfc.sendXtMessage("zm","moveToCell",[param1,param2],"str",this.curRoom);
               }
               this.exitCell(true);
               if(param4 && this.bMapWarm && this.map != null && this.map.stage != null && this.intBlankWait < 0 && (this.cHandle == null || !this.cHandle.isPending()))
               {
                  this.blankGotoNow();
               }
               else
               {
                  this.mapGotoBlank();
               }
               this.startCellArrivalWatch(param1);
               if(Boolean(this.rootClass.cMenuUI) && Boolean(this.rootClass.cMenuUI.isMenuOpen()))
               {
                  this.rootClass.cMenuUI.reDraw();
               }
               if(this.strMapName == "house" && this.isMyHouse() && this.rootClass.ui.mcPopup.currentLabel != "House")
               {
                  this.rootClass.ui.mcPopup.fOpen("House");
               }
            }
         }
      }
      
      public function moveToCellByIDa(param1:int) : void
      {
         if(this.bPvP && !this.isMoveOK(this.myAvatar.dataLeaf))
         {
            return;
         }
         this.rootClass.sfc.sendXtMessage("zm","mtcid",[param1],"str",this.curRoom);
      }
      
      public function moveToCellByIDb(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.arrEvent.length)
         {
            _loc2_ = this.arrEvent[_loc3_] as MovieClip;
            if("tID" in _loc2_ && _loc2_.tID == param1 || _loc2_.name.indexOf("ia") == 0 && int(_loc2_.name.substr(2)) == param1)
            {
               this.moveToCell(_loc2_.tCell,_loc2_.tPad,true,true);
               return;
            }
            _loc3_++;
         }
      }
      
      public function hideAllAvatars() : void
      {
         var _loc1_:* = undefined;
         for(var _loc4_ in this.avatars)
         {
            _loc1_ = _loc4_;
            _loc4_;
            if(this.avatars[_loc1_] != null && this.avatars[_loc1_].pMC != null)
            {
               if(!this.avatars[_loc1_].isMyAvatar)
               {
                  if(this.avatars[_loc1_] != this.myAvatar)
                  {
                     this.avatars[_loc1_].hideMC();
                  }
               }
            }
         }
      }
      
      public function hideAvatarsForCellChange() : void
      {
         var _loc1_:* = undefined;
         for(var _loc4_ in this.avatars)
         {
            _loc1_ = _loc4_;
            _loc4_;
            if(this.avatars[_loc1_] != null && this.avatars[_loc1_].pMC != null)
            {
               if(!this.avatars[_loc1_].isMyAvatar)
               {
                  if(this.avatars[_loc1_] != this.myAvatar)
                  {
                     this.avatars[_loc1_].pMC.visible = false;
                     if(this.avatars[_loc1_].petMC != null)
                     {
                        this.avatars[_loc1_].petMC.visible = false;
                     }
                  }
               }
            }
         }
      }
      
      public function clearAllAvatars() : void
      {
         var _loc1_:String = null;
         for(var _loc4_ in this.avatars)
         {
            _loc1_ = _loc4_;
            _loc4_;
            this.destroyAvatar(Number(_loc1_));
         }
         this.avatars = new Dictionary(true);
      }
      
      public function destroyAllAvatars() : void
      {
         this.clearAllAvatars();
         if(this.myAvatar != null)
         {
            try
            {
               this.myAvatar.unloadPet();
            }
            catch(eMP:Error)
            {
            }
            if(this.myAvatar.pMC != null)
            {
               try
               {
                  this.myAvatar.pMC.fClose();
               }
               catch(eMC:Error)
               {
               }
            }
            try
            {
               this.myAvatar.cleanup();
            }
            catch(eML:Error)
            {
            }
            this.myAvatar = null;
         }
      }
      
      public function clearOtherAvatars() : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:* = undefined;
         if(this.myAvatar == null)
         {
            return;
         }
         var _loc1_:Array = [];
         for(var _loc8_ in this.avatars)
         {
            _loc2_ = _loc8_;
            _loc8_;
            _loc4_ = Number(_loc2_);
            _loc5_ = this.avatars[_loc4_];
            if(_loc5_ != null)
            {
               if(_loc5_ != this.myAvatar)
               {
                  if(!_loc5_.isMyAvatar)
                  {
                     if(_loc5_.uid != this.myAvatar.uid)
                     {
                        _loc1_.push(_loc4_);
                     }
                  }
               }
            }
         }
         _loc3_ = 0;
         while(_loc3_ < _loc1_.length)
         {
            this.destroyAvatar(_loc1_[_loc3_]);
            _loc3_++;
         }
      }
      
      public function clearAvatarsExcept(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:* = undefined;
         if(this.myAvatar == null)
         {
            return;
         }
         var _loc2_:Array = [];
         for(var _loc9_ in this.avatars)
         {
            _loc3_ = _loc9_;
            _loc9_;
            _loc5_ = Number(_loc3_);
            _loc6_ = this.avatars[_loc5_];
            if(_loc6_ != null)
            {
               if(_loc6_ != this.myAvatar)
               {
                  if(!_loc6_.isMyAvatar)
                  {
                     if(_loc6_.uid != this.myAvatar.uid)
                     {
                        if(param1[_loc5_] != true)
                        {
                           _loc2_.push(_loc5_);
                        }
                     }
                  }
               }
            }
         }
         trace("[Map] clearAvatarsExcept: clearing " + _loc2_.length + " avatars");
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            this.destroyAvatar(_loc2_[_loc4_]);
            _loc4_++;
         }
      }
      
      public function clearMonstersAndProps(param1:Boolean = false) : void
      {
         var i:int;
         var child:DisplayObject = null;
         var pad:* = undefined;
         var bKeepCellProps:Boolean = param1;
         if(this.CHARS == null || this.TRASH == null)
         {
            return;
         }
         i = 0;
         i = this.CHARS.numChildren - 1;
         for(; i >= 0; i--)
         {
            if(i < this.CHARS.numChildren)
            {
               child = this.CHARS.getChildAt(i);
               try
               {
                  if(Boolean(child.hasOwnProperty("isProp")) && Boolean(MovieClip(child).isProp))
                  {
                     if(bKeepCellProps && this.map != null && "propCell" in child && MovieClip(child).propCell == this.strMapName + ":" + this.map.currentLabel && !this.mapHasPropTwin(child))
                     {
                        child.visible = true;
                        if("wasPropEvent" in child && this.arrEvent.indexOf(MovieClip(child)) == -1)
                        {
                           this.arrEvent.push(MovieClip(child));
                        }
                        if("isSolid" in child && MovieClip(child).isSolid && this.arrSolid.indexOf(MovieClip(child)) == -1)
                        {
                           this.arrSolid.push(MovieClip(child));
                        }
                     }
                     else
                     {
                        this.CHARS.removeChild(child);
                     }
                  }
                  else if(Boolean(child.hasOwnProperty("isHouseItem")) && Boolean(MovieClip(child).isHouseItem))
                  {
                     child.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHouseItemClick);
                     child.removeEventListener(Event.ENTER_FRAME,this.onHouseItemEnterFrame);
                     this.CHARS.removeChild(child);
                  }
                  else if(Boolean(child.hasOwnProperty("isMonster")) && Boolean(MovieClip(child).isMonster))
                  {
                     MovieClip(child).fClose();
                     if(child.parent == this.CHARS)
                     {
                        this.CHARS.removeChild(child);
                     }
                  }
                  else if(Boolean(child.hasOwnProperty("isSpell")) && Boolean(MovieClip(child).isSpell))
                  {
                     MovieClip(child).killSpell();
                     if(child.parent == this.CHARS)
                     {
                        this.CHARS.removeChild(child);
                     }
                  }
               }
               catch(eCh:Error)
               {
                  trace("[Map] ERR clearMonstersAndProps: " + eCh.message);
                  try
                  {
                     if(child.parent == CHARS)
                     {
                        CHARS.removeChild(child);
                     }
                  }
                  catch(eRm:Error)
                  {
                  }
                  continue;
               }
            }
         }
         i = this.TRASH.numChildren - 1;
         for(; i >= 0; i--)
         {
            if(i < this.TRASH.numChildren)
            {
               child = this.TRASH.getChildAt(i);
               if(Boolean(child.hasOwnProperty("isMonster")) && Boolean(MovieClip(child).isMonster))
               {
                  try
                  {
                     MovieClip(child).fClose();
                  }
                  catch(eTr:Error)
                  {
                  }
                  try
                  {
                     if(child.parent == this.TRASH)
                     {
                        this.TRASH.removeChild(child);
                     }
                  }
                  catch(eTr2:Error)
                  {
                     continue;
                  }
               }
            }
         }
         i = 0;
         while(i < this.monsters.length)
         {
            if(this.monsters[i] != null)
            {
               this.monsters[i].pMC = null;
            }
            i++;
         }
         try
         {
            while(this.rootClass.ui.mcPadNames.numChildren)
            {
               pad = this.rootClass.ui.mcPadNames.getChildAt(0);
               MovieClip(pad).stop();
               this.rootClass.ui.mcPadNames.removeChild(pad);
            }
         }
         catch(ePd:Error)
         {
         }
      }
      
      private function mapHasPropTwin(param1:DisplayObject) : Boolean
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.map.numChildren)
         {
            _loc3_ = this.map.getChildAt(_loc2_);
            if(_loc3_.name == param1.name)
            {
               return true;
            }
            if(Math.abs(_loc3_.x - param1.x) < 2 && Math.abs(_loc3_.y - param1.y) < 2)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function setMapEvents(param1:Object) : void
      {
         this.mapEvents = param1;
      }
      
      public function initMapEvents() : void
      {
         if("eventUpdate" in this.map && this.mapEvents != null)
         {
            try
            {
               this.map.eventUpdate({
                  "cmd":"event",
                  "args":this.mapEvents
               });
            }
            catch(e:Error)
            {
               rootClass.debugMessage("initMapEvents: " + e.message);
            }
         }
         this.mapEvents = null;
      }
      
      public function setCellMap(param1:Object) : void
      {
         this.cellMap = param1;
      }
      
      public function updateCellMap(param1:Object) : void
      {
         var s:String = null;
         var mc:MovieClip = null;
         var p:String = null;
         var o:Object = param1;
         var cell:Object = {};
         for(var _loc5_ in this.cellMap)
         {
            s = _loc5_;
            _loc5_;
            cell = this.cellMap[s];
            if(cell.ias != null && cell.ias[o.ID] != null)
            {
               for(var _loc7_ in o)
               {
                  p = _loc7_;
                  _loc7_;
                  cell.ias[o.ID][p] = o[p];
               }
            }
         }
         try
         {
            mc = MovieClip(this.CHARS.getChildByName("ia" + o.ID));
            mc.update();
            return;
         }
         catch(e:Error)
         {
         }
         try
         {
            mc = MovieClip(this.map.getChildByName("ia" + o.ID));
            mc.update();
         }
         catch(e:Error)
         {
            trace("[Map] ERR updateCellMap: ia" + o.ID + " not found: " + e.message);
         }
      }
      
      public function onWalkClick() : void
      {
         var sCat:String = null;
         var aura:Object = null;
         var p:Point = null;
         var now:* = undefined;
         var mvPT:* = undefined;
         var fellDown:Array = null;
         var cLeaf:Object = this.myAvatar.dataLeaf;
         for each(var _loc4_ in cLeaf.auras)
         {
            aura = _loc4_;
            _loc4_;
            try
            {
               sCat = this.auraCatOf(aura);
               if(sCat == "stun" || sCat == "stone" || sCat == "paralyze" || sCat == "disable" || sCat == "disabled")
               {
                  return;
               }
            }
            catch(e:Error)
            {
               trace("[Map] ERR onWalkClick: " + e.message);
            }
         }
         p = new Point(mouseX,mouseY);
         if(this.bitWalk)
         {
            this.afkPostpone();
            if(mouseX >= 0 && mouseX <= 960 && mouseY >= 0 && mouseY <= 500)
            {
               p = this.CHARS.globalToLocal(p);
               p.x = Math.round(p.x);
               p.y = Math.round(p.y);
               this.speed = this.WALKSPEED;
               now = new Date().getTime();
               if(Boolean(this.rootClass.pDash) && !this.justRan)
               {
                  this.speed = this.speed * 3;
                  this.justRan = true;
                  this.rootClass.pDash = false;
               }
               mvPT = this.myAvatar.pMC.simulateTo(p.x,p.y,this.speed);
               if(mvPT != null)
               {
                  if(!this.bPvP)
                  {
                     if(this.clickPts >= 5)
                     {
                        fellDown = ["Feign","Dazed"];
                        this.myAvatar.pMC.gotoAndPlay(fellDown[Math.floor(Math.random() * 2)]);
                        return;
                     }
                     this.myAvatar.pMC.walkTo(mvPT.x,mvPT.y,this.speed);
                  }
                  if(this.bPvP)
                  {
                     if(now - this.mva[0] <= 300 * this.mva.length)
                     {
                        this.myAvatar.pMC.walkTo(this.myAvatar.pMC.tp.x,this.myAvatar.pMC.tp.y,this.speed);
                        return;
                     }
                     this.mva.push(now);
                     if(this.mva.length > 5)
                     {
                        this.mva.shift();
                     }
                     this.myAvatar.pMC.walkTo(mvPT.x,mvPT.y,this.speed);
                     this.pushMove(this.myAvatar.pMC,mvPT.x,mvPT.y,this.speed);
                  }
                  else if(this.clickOnEventTest(mvPT.x,mvPT.y))
                  {
                     this.pushMove(this.myAvatar.pMC,mvPT.x,mvPT.y,this.speed);
                  }
                  else
                  {
                     this.clickPts++;
                     this.moveRequest({
                        "mc":this.myAvatar.pMC,
                        "tx":mvPT.x,
                        "ty":mvPT.y,
                        "sp":this.speed
                     });
                  }
               }
            }
         }
      }
      
      public function clickOnEventTest(param1:int, param2:int) : Boolean
      {
         var _loc3_:Rectangle = this.myAvatar.pMC.shadow.getBounds(this);
         var _loc4_:Rectangle = new Rectangle();
         _loc3_.x = param1 - _loc3_.width / 2;
         _loc3_.y = param2 - _loc3_.height / 2;
         var _loc5_:int = 0;
         while(_loc5_ < this.arrEvent.length)
         {
            if(!(this.arrEvent[_loc5_] == null || this.arrEvent[_loc5_].shadow == null || this.arrEvent[_loc5_].stage == null))
            {
               _loc4_ = this.arrEvent[_loc5_].shadow.getBounds(this);
               if(_loc3_.intersects(_loc4_))
               {
                  return true;
               }
            }
            _loc5_++;
         }
         return false;
      }
      
      public function moveRequest(param1:Object) : void
      {
         if(!this.mvTimer.running)
         {
            this.pushMove(param1.mc,param1.tx,param1.ty,param1.sp);
            this.mvTimer.reset();
            this.mvTimer.start();
         }
         else
         {
            this.mvTimerObj = param1;
         }
      }
      
      public function mvTimerHandler(param1:TimerEvent) : void
      {
         var _loc2_:Object = {};
         if(this.mvTimerObj != null)
         {
            this.pushMove(this.mvTimerObj.mc,this.mvTimerObj.tx,this.mvTimerObj.ty,this.mvTimerObj.sp);
            this.mvTimerObj = null;
         }
      }
      
      public function mvTimerKill() : void
      {
         this.mvTimer.reset();
         this.mvTimerObj = null;
      }
      
      public function pushMove(param1:MovieClip, param2:int, param3:int, param4:int) : *
      {
         var _loc6_:* = undefined;
         this.clickPts = 0;
         var _loc5_:* = {};
         _loc5_.tx = int(param2);
         _loc5_.ty = int(param3);
         _loc5_.sp = int(param4);
         this.uoTreeLeafSet(this.rootClass.sfc.myUserName,_loc5_);
         if(this.justRan)
         {
            if(this.myAvatar.dataLeaf.intSP < this.uoTree[this.myAvatar.pnm].sta.$dsh)
            {
               this.speed = this.WALKSPEED;
               this.justRan = false;
            }
         }
         else
         {
            this.speed = this.WALKSPEED;
         }
         if(this.bitWalk)
         {
            this.rootClass.sfc.sendXtMessage("zm","mv",[param2,param3,this.speed],"str",this.curRoom);
         }
         if(this.justRan)
         {
            _loc6_ = Math.max(0,this.myAvatar.dataLeaf.intSP - this.uoTree[this.myAvatar.pnm].sta.$dsh);
            this.myAvatar.dataLeaf.intSP = _loc6_;
            this.myAvatar.objData["intSP"] = _loc6_;
            this.updatePortrait(this.myAvatar);
            this.updateActBar();
            this.justRan = false;
         }
      }
      
      public function monstersToPads() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         for(var _loc5_ in this.monsters)
         {
            _loc1_ = _loc5_;
            _loc5_;
            _loc2_ = this.monsters[_loc1_];
            if(_loc2_.objData != null && _loc2_.objData.strFrame == this.strFrame && _loc2_.pMC != null)
            {
               _loc2_.pMC.walkTo(_loc2_.pMC.ox,_loc2_.pMC.oy,this.WALKSPEED * 1.4);
            }
         }
      }
      
      public function updatePadNames() : *
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < this.rootClass.ui.mcPadNames.numChildren)
         {
            _loc2_ = MovieClip(this.rootClass.ui.mcPadNames.getChildAt(_loc1_));
            if(this.objLock == null || this.objLock[_loc2_.tCell] == null || this.objLock[_loc2_.tCell] <= this.intKillCount)
            {
               _loc2_.cnt.lock.visible = false;
            }
            else
            {
               _loc2_.cnt.lock.visible = true;
            }
            _loc1_++;
         }
      }
      
      public function cellSetup(param1:Number, param2:Number, param3:String) : void
      {
         var monName:Boolean = false;
         var i:int = 0;
         var bReapply:Boolean = false;
         var child:DisplayObject = null;
         var j:uint = 0;
         var c:DisplayObject = null;
         var monArr:* = undefined;
         var Mons:Array = null;
         var Mon:Avatar = null;
         var oref:* = undefined;
         var k:int = 0;
         var mc:MovieClip = null;
         var intScale:Number = param1;
         var intSpeed:Number = param2;
         var strMode:String = param3;
         if(this.cellSetupStamp == this.strFrame)
         {
            bReapply = this.SCALE != intScale || this.CELL_MODE != strMode;
            this.CELL_MODE = strMode;
            this.SCALE = intScale;
            this.WALKSPEED = intSpeed;
            trace("[Map] cellSetup: already ran for " + this.strFrame + ", skipping" + (bReapply ? " (reapplying scale/mode)" : ""));
            if(bReapply)
            {
               this.rescaleCellEntities();
            }
            return;
         }
         trace("[Map] cellSetup: " + this.strFrame);
         this.cellSetupStamp = this.strFrame;
         this.CELL_MODE = strMode;
         this.SCALE = intScale;
         this.WALKSPEED = intSpeed;
         this.arrSolid = [];
         this.arrEvent = [];
         try
         {
            this.clearMonstersAndProps(true);
         }
         catch(eCS:Error)
         {
            trace("[Map] ERR cellSetup clearMonstersAndProps: " + eCS.message);
         }
         monName = Number(this.objExtra["bMonName"]) == 1;
         i = 0;
         while(i < this.map.numChildren)
         {
            child = this.map.getChildAt(i);
            try
            {
               if(child is MovieClip)
               {
                  if(MovieClip(child).hasPads)
                  {
                     j = 0;
                     while(j < MovieClip(child).numChildren)
                     {
                        c = MovieClip(child).getChildAt(j);
                        if(c is MovieClip && MovieClip(c).isEvent && !MovieClip(c).isProp)
                        {
                           this.arrEvent.push(MovieClip(c));
                        }
                        if(c is MovieClip && Boolean(MovieClip(c).isSolid))
                        {
                           this.arrSolid.push(MovieClip(child));
                        }
                        j++;
                     }
                  }
               }
               if(child is MovieClip && Boolean(MovieClip(child).isSolid))
               {
                  this.arrSolid.push(MovieClip(child));
               }
               if(child is MovieClip && "walk" in child && MovieClip(child).btnWalkingArea != null)
               {
                  MovieClip(child).btnWalkingArea.useHandCursor = false;
               }
               if(child is MovieClip && MovieClip(child).isEvent && !MovieClip(child).isProp)
               {
                  this.arrEvent.push(MovieClip(child));
               }
               if(this.strMapName != "trickortreat" && this.strMapName != "caroling")
               {
                  if(child is MovieClip && Boolean(MovieClip(child).isMonster))
                  {
                     monArr = [];
                     Mons = this.getMonsters(MovieClip(child).MonMapID);
                     for each(var _loc7_ in Mons)
                     {
                        Mon = _loc7_;
                        _loc7_;
                        if(Mon == null)
                        {
                           trace("[Map] ERR cellSetup: no monster definition for pad " + MovieClip(child).MonMapID);
                        }
                        else
                        {
                           try
                           {
                              Mon.pMC = this.createMonsterMC(MovieClip(child),Mon.objData.MonID,monName,this.monLoadsSettled >= this.monLoadsExpected);
                              if(Mon.pMC == null)
                              {
                                 continue;
                              }
                              Mon.pMC.scale(this.SCALE);
                              Mon.pMC.pAV = Mon;
                              Mon.pMC.setData();
                              if(Mon.dataLeaf == null)
                              {
                                 this.TRASH.addChild(Mon.pMC);
                              }
                              else if(this.rootClass.litePreference.data.bMonsType)
                              {
                                 Mon.pMC.pname.typ.text = "< " + Mon.pMC.pAV.objData.sRace + " >";
                                 Mon.pMC.pname.typ.visible = Mon.pMC.pAV.objData.sRace != "None";
                              }
                              else
                              {
                                 Mon.pMC.pname.typ.visible = false;
                              }
                           }
                           catch(eMn:Error)
                           {
                              trace("[Map] ERR cellSetup monster: " + eMn.message);
                              continue;
                           }
                        }
                     }
                  }
               }
               if(child is MovieClip && Boolean(MovieClip(child).isProp))
               {
                  oref = this.CHARS.addChild(child);
                  MovieClip(oref).propCell = this.strMapName + ":" + this.map.currentLabel;
                  if(MovieClip(oref).isEvent)
                  {
                     this.arrEvent.push(MovieClip(oref));
                     MovieClip(oref).isEvent = false;
                     MovieClip(oref).wasPropEvent = true;
                  }
                  i--;
               }
               if(child is MovieClip && child.width > 700 && !("isSolid" in child) && !("walk" in child) && !("btnSkip" in child) && !child.hasEventListener(MouseEvent.CLICK) && !this.hasButtonChild(MovieClip(child)))
               {
                  MovieClip(child).mouseEnabled = false;
                  MovieClip(child).mouseChildren = false;
               }
               if(child is MovieClip && child.width >= 960 && !("isSolid" in child) && !("walk" in child) && !("btnSkip" in child))
               {
               }
            }
            catch(eCh:Error)
            {
               trace("[Map] ERR cellSetup child " + (child != null ? child.name : "null") + ": " + eCh.message);
            }
            i++;
         }
         if(this.strFrame == "Enter" && this.strMapName == "trickortreat")
         {
            try
            {
               if(this.TrickOrTreatMonsterDead && !this.CHARS.getChildByName("mcPlayerNPCTrickOrTreat"))
               {
                  this.loadPlayerNPC();
               }
               else
               {
                  this.TrickOrTreatPad = "Spawn";
                  k = 0;
                  while(k < this.map.numChildren)
                  {
                     mc = this.map.getChildAt(k) as MovieClip;
                     if(mc != null && mc.toString().indexOf("Pad") != -1)
                     {
                        if(mc.name != "Spawn")
                        {
                           this.TrickOrTreatPad = mc.name;
                           break;
                        }
                     }
                     k++;
                  }
                  monArr = [];
                  Mons = this.getMonsters(1);
                  for each(_loc7_ in Mons)
                  {
                     Mon = _loc7_;
                     _loc7_;
                     Mon.pMC = this.createMonsterMC(this.map[this.TrickOrTreatPad],Mon.objData.MonID,monName,true);
                     if(Mon.pMC != null)
                     {
                        Mon.pMC.scale(this.SCALE);
                        Mon.pMC.pAV = Mon;
                        Mon.pMC.setData();
                        if(Mon.dataLeaf == null)
                        {
                           this.TRASH.addChild(Mon.pMC);
                        }
                        else if(this.rootClass.litePreference.data.bMonsType)
                        {
                           Mon.pMC.pname.typ.text = "< " + Mon.pMC.pAV.objData.sRace + " >";
                           Mon.pMC.pname.typ.visible = Mon.pMC.pAV.objData.sRace != "None";
                        }
                        else
                        {
                           Mon.pMC.pname.typ.visible = false;
                        }
                     }
                  }
                  this.player_npc_pos = new Point(this.map[this.TrickOrTreatPad].x,this.map[this.TrickOrTreatPad].y);
               }
            }
            catch(eTot:Error)
            {
               trace("[Map] ERR cellSetup trickortreat: " + eTot.message);
            }
         }
         if(this.strFrame == "Enter" && this.strMapName == "caroling")
         {
            try
            {
               if(this.CarolingMonsterKillCount >= 5 && !this.CHARS.getChildByName("mcPlayerNPCCaroling"))
               {
                  this.loadPlayerNPC();
               }
               else
               {
                  this.CarolingPad = "Spawn";
                  k = 0;
                  while(k < this.map.numChildren)
                  {
                     mc = this.map.getChildAt(k) as MovieClip;
                     if(mc != null && mc.toString().indexOf("Pad") != -1)
                     {
                        if(mc.name != "Spawn")
                        {
                           this.CarolingPad = mc.name;
                           break;
                        }
                     }
                     k++;
                  }
                  monArr = [];
                  Mons = this.getMonsters(1);
                  for each(_loc7_ in Mons)
                  {
                     Mon = _loc7_;
                     _loc7_;
                     Mon.pMC = this.createMonsterMC(this.map[this.CarolingPad],Mon.objData.MonID,monName,true);
                     if(Mon.pMC != null)
                     {
                        Mon.pMC.scale(this.SCALE);
                        Mon.pMC.pAV = Mon;
                        Mon.pMC.setData();
                        if(Mon.dataLeaf == null)
                        {
                           this.TRASH.addChild(Mon.pMC);
                        }
                        else if(this.rootClass.litePreference.data.bMonsType)
                        {
                           Mon.pMC.pname.typ.text = "< " + Mon.pMC.pAV.objData.sRace + " >";
                           Mon.pMC.pname.typ.visible = Mon.pMC.pAV.objData.sRace != "None";
                        }
                        else
                        {
                           Mon.pMC.pname.typ.visible = false;
                        }
                        break;
                     }
                  }
                  this.player_npc_pos = new Point(this.map[this.CarolingPad].x,this.map[this.CarolingPad].y);
               }
            }
            catch(eCar:Error)
            {
               trace("[Map] ERR cellSetup caroling: " + eCar.message);
            }
         }
         try
         {
            this.buildBoundingRects();
         }
         catch(eBR:Error)
         {
            trace("[Map] ERR cellSetup buildBoundingRects: " + eBR.message);
         }
         try
         {
            if(this.map.bounds != null)
            {
               this.mapBoundsMC = this.map.getChildByName("bounds") as MovieClip;
            }
         }
         catch(eBd:Error)
         {
         }
         try
         {
            this.playerInit();
         }
         catch(ePI:Error)
         {
            trace("[Map] ERR cellSetup playerInit: " + ePI.message);
         }
         try
         {
            this.updateMonsters();
         }
         catch(eUMs:Error)
         {
            trace("[Map] ERR cellSetup updateMonsters: " + eUMs.message);
         }
         try
         {
            this.updatePadNames();
         }
         catch(ePN:Error)
         {
            trace("[Map] ERR cellSetup updatePadNames: " + ePN.message);
         }
         try
         {
            if(this.objHouseData != null)
            {
               this.updateHouseItems();
            }
         }
         catch(eHI:Error)
         {
            trace("[Map] ERR cellSetup updateHouseItems: " + eHI.message);
         }
         this.schedulePropWireSweep();
         this.scheduleCellSettle();
      }
      
      public function rescaleCellEntities() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Avatar = null;
         var _loc4_:Avatar = null;
         for(var _loc7_ in this.avatars)
         {
            _loc1_ = _loc7_;
            _loc7_;
            _loc3_ = this.avatars[_loc1_];
            if(!(_loc3_ == null || _loc3_.pMC == null))
            {
               if(!(!_loc3_.isMyAvatar && (_loc3_.dataLeaf == null || String(_loc3_.dataLeaf.strFrame) != this.strFrame)))
               {
                  try
                  {
                     _loc3_.pMC.scale(this.SCALE);
                     if(_loc3_.petMC != null && _loc3_.petMC.stage != null)
                     {
                        _loc3_.petMC.scale(this.SCALE);
                     }
                     if(_loc3_.isMyAvatar || this.CELL_MODE == "normal")
                     {
                        _loc3_.showMC();
                     }
                     else
                     {
                        _loc3_.hideMC();
                     }
                  }
                  catch(eRA:Error)
                  {
                     continue;
                  }
               }
            }
         }
         for(_loc7_ in this.monsters)
         {
            _loc2_ = _loc7_;
            _loc7_;
            _loc4_ = this.monsters[_loc2_];
            if(!(_loc4_ == null || _loc4_.pMC == null || _loc4_.objData == null))
            {
               if(_loc4_.objData.strFrame == this.strFrame)
               {
                  try
                  {
                     _loc4_.pMC.scale(this.SCALE);
                  }
                  catch(eRM:Error)
                  {
                  }
                  continue;
               }
            }
         }
      }
      
      public function loadPlayerNPC() : void
      {
         if(this.strMapName == "caroling")
         {
            if(this.loaderD.hasDefinition("PlayerNPCCaroling"))
            {
               this.onPlayerNPCComplete();
               return;
            }
         }
         else if(this.loaderD.hasDefinition("PlayerNPCTrickOrTreat"))
         {
            this.onPlayerNPCComplete();
            return;
         }
         if(this.ldr_pNPC != null)
         {
            try
            {
               this.ldr_pNPC.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onPlayerNPCComplete);
               this.ldr_pNPC.close();
               this.ldr_pNPC.unloadAndStop(true);
            }
            catch(e:Error)
            {
            }
         }
         this.ldr_pNPC = new Loader();
         this.ldr_pNPC.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onPlayerNPCComplete,false,0,true);
         if(this.strMapName == "caroling")
         {
            this.ldr_pNPC.load(new URLRequest(this.rootClass.vswf(this.rootClass.getFilePath() + "items/house/PlayerNPC_Caroling.swf")),this.loaderC);
         }
         else
         {
            this.ldr_pNPC.load(new URLRequest(this.rootClass.vswf(this.rootClass.getFilePath() + "items/house/PlayerNPC_TrickOrTreat.swf")),this.loaderC);
         }
      }
      
      private function onPlayerNPCComplete(param1:Event = null) : void
      {
         var _loc2_:Class = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:MovieClip = null;
         _loc3_ = this.strMapName == "caroling" ? "PlayerNPCCaroling" : "PlayerNPCTrickOrTreat";
         if(!this.loaderD.hasDefinition(_loc3_))
         {
            trace("[Load] ERR missing linkage " + _loc3_ + " onPlayerNPCComplete");
            return;
         }
         _loc2_ = this.loaderD.getDefinition(_loc3_) as Class;
         _loc4_ = new _loc2_();
         _loc4_.x = this.player_npc_pos.x;
         _loc4_.y = this.player_npc_pos.y;
         if(_loc4_.x > this.myAvatar.pMC.x)
         {
            _loc4_.scaleX = _loc4_.scaleX * -1;
         }
         _loc5_ = this.CHARS.addChild(_loc4_) as MovieClip;
         _loc5_.name = "mc" + getQualifiedClassName(_loc5_);
         _loc5_.isProp = true;
         if(param1 != null && this.ldr_pNPC != null)
         {
            try
            {
               this.ldr_pNPC.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onPlayerNPCComplete);
               this.ldr_pNPC.close();
               this.ldr_pNPC.unloadAndStop(true);
            }
            catch(err:Error)
            {
            }
            this.ldr_pNPC = null;
         }
      }
      
      private function buildBoundingRects() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Rectangle = null;
         var _loc3_:MovieClip = null;
         _loc1_ = 0;
         this.arrEventR = [];
         this.arrSolidR = [];
         _loc1_ = 0;
         while(_loc1_ < this.arrEvent.length)
         {
            _loc3_ = this.arrEvent[_loc1_];
            _loc2_ = _loc3_.getBounds(this.rootClass.stage);
            this.arrEventR.push(_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.arrSolid.length)
         {
            _loc3_ = this.arrSolid[_loc1_];
            _loc2_ = _loc3_.getBounds(this.rootClass.stage);
            this.arrSolidR.push(_loc2_);
            _loc1_++;
         }
      }
      
      public function killWalkObjects() : void
      {
         var _loc1_:int = 0;
         var _loc2_:DisplayObject = null;
         if(this.map == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.map.numChildren)
         {
            _loc2_ = this.map.getChildAt(_loc1_);
            if(_loc2_ is MovieClip && MovieClip(_loc2_).isEvent && MovieClip(_loc2_).onEnter is Function)
            {
               MovieClip(_loc2_).removeEventListener("enter",MovieClip(_loc2_).onEnter);
            }
            _loc1_++;
         }
      }
      
      public function exitQuest() : void
      {
         if(this.returnInfo != null)
         {
            this.rootClass.sfc.sendXtMessage("zm","cmd",["tfer",this.rootClass.sfc.myUserName,this.returnInfo.strMap,this.returnInfo.strCell,this.returnInfo.strPad],"str",this.curRoom);
         }
      }
      
      public function gotoTown(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:* = undefined;
         _loc4_ = this.uoTree[this.rootClass.sfc.myUserName];
         if(_loc4_.intState == 0)
         {
            this.rootClass.chatF.pushMsg("warning","You are dead!","SERVER","",0);
         }
         else if(!this.rootClass.world.myAvatar.invLoaded || !this.rootClass.world.myAvatar.pMC.artLoaded())
         {
            this.rootClass.MsgBox.notify("Character still being loaded.");
         }
         else if(this.coolDown("tfer"))
         {
            this.rootClass.MsgBox.notify("Joining " + param1);
            this.setReturnInfo(param1,param2,param3);
            this.rootClass.sfc.sendXtMessage("zm","cmd",["tfer",this.rootClass.sfc.myUserName,param1,param2,param3],"str",this.curRoom);
            if(this.strAreaName.indexOf("battleon") < 0 || this.strAreaName.indexOf("battleontown") > -1)
            {
               this.rootClass.menuClose();
            }
         }
         else
         {
            this.rootClass.MsgBox.notify("You must wait 5 seconds before joining another map.");
         }
      }
      
      public function gotoQuest(param1:String, param2:String, param3:String) : void
      {
         this.gotoTown(param1,param2,param3);
      }
      
      public function openApop(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         if(this.isMovieFront("Apop") || (!("frame" in param1) || "frame" in param1 && "cnt" in param1))
         {
            this.rootClass.menuClose();
            _loc2_ = this.attachMovieFront("Apop");
            _loc2_.update(param1);
         }
      }
      
      public function setSpawnPoint(param1:*, param2:*) : void
      {
         this.spawnPoint.strFrame = param1;
         this.spawnPoint.strPad = param2;
      }
      
      public function resetSpawnPoint() : void
      {
         this.spawnPoint.strFrame = "Enter";
         this.spawnPoint.strPad = "Spawn";
      }
      
      public function initObjExtra(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         this.objExtra = new Object();
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_].split("=");
               this.objExtra[_loc4_[0]] = _loc4_[1];
               _loc3_++;
            }
         }
      }
      
      public function initObjInfo(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         this.objInfo = new MapInfo();
         if(param1 != null && param1 != "")
         {
            _loc2_ = param1.split(",");
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_].split("=");
               this.objInfo[_loc4_[0]] = _loc4_[1];
               _loc3_++;
            }
         }
      }
      
      public function initMap() : mapData
      {
         this.mData = new mapData(this.rootClass);
         return this.mData;
      }
      
      public function initCutscenes() : cutsceneHandler
      {
         if(this.cHandle != null)
         {
            this.cHandle.cancel();
         }
         this.cHandle = new cutsceneHandler(this.rootClass);
         return this.cHandle;
      }
      
      public function initSound(param1:Sound) : soundController
      {
         if(this.sController != null && this.sController.mChannel != null)
         {
            try
            {
               this.sController.mChannel.stop();
            }
            catch(e:Error)
            {
            }
         }
         this.sController = new soundController(param1,this.rootClass);
         return this.sController;
      }
      
      public function gotoHouse(param1:String) : void
      {
         param1 = param1.toLowerCase();
         if(this.objHouseData != null && this.objHouseData.unm == param1 && this.strMapName == "house")
         {
            return;
         }
         this.rootClass.sfc.sendXtMessage("zm","house",[param1],"str",1);
      }
      
      public function isHouseEquipped() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.myAvatar.houseitems.length)
         {
            if(this.myAvatar.houseitems[_loc1_].bEquip)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function isMyHouse() : *
      {
         return this.objHouseData != null && this.objHouseData.unm == this.myAvatar.objData.strUsername.toLowerCase() && this.strMapName == "house";
      }
      
      public function showHouseOptions(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = this.rootClass.ui.mcPopup.mcHouseOptions;
         switch(param1)
         {
            case "default":
            case "save":
            default:
               _loc2_.visible = true;
               _loc2_.bg.x = 0;
               _loc2_.cnt.x = 0;
               _loc2_.tTitle.x = 5;
               _loc2_.bExpand.x = 190;
               _loc2_.bg.visible = true;
               _loc2_.cnt.visible = true;
               _loc2_.tTitle.visible = true;
               _loc2_.bExpand.visible = false;
               break;
            case "hide":
               _loc2_.visible = true;
               _loc2_.bg.x = 181;
               _loc2_.cnt.x = 181;
               _loc2_.tTitle.x = 186;
               _loc2_.bExpand.x = 120;
               _loc2_.bg.visible = false;
               _loc2_.cnt.visible = false;
               _loc2_.tTitle.visible = false;
               _loc2_.bExpand.visible = true;
         }
      }
      
      public function hideHouseOptions() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         _loc1_ = this.rootClass.ui.mcPopup.mcHouseOptions;
         if(_loc1_.visible)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.numChildren)
            {
               _loc1_.getChildAt(_loc2_).x = 190;
               _loc2_++;
            }
         }
         _loc1_.visible = false;
      }
      
      public function onHouseOptionsDesignClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         this.toggleHouseEdit();
      }
      
      public function onHouseOptionsSaveClick(param1:MouseEvent) : void
      {
         if(this.hasModified)
         {
            this.rootClass.mixer.playSound("Click");
            this.saveHouseSetup();
         }
      }
      
      public function onHouseOptionsHideClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         this.showHouseOptions("hide");
      }
      
      public function onHouseOptionsExpandClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         this.showHouseOptions("default");
      }
      
      public function onHouseOptionsFloorClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         this.showHouseInventory(70);
      }
      
      public function onHouseOptionsWallClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         this.showHouseInventory(72);
      }
      
      public function onHouseOptionsMiscClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         this.showHouseInventory(73);
      }
      
      public function onHouseOptionsHouseReset(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.rootClass.mixer.playSound("Click");
         _loc2_ = new ModalMC();
         _loc3_ = {};
         _loc3_.params = {};
         _loc3_.strBody = "Are you sure you want to reset the entire house?";
         _loc3_.callback = this.confirmClear;
         _loc3_.btns = "dual";
         this.rootClass.ui.ModalStack.addChild(_loc2_);
         _loc2_.init(_loc3_);
      }
      
      public function confirmClear(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         if(param1.accept)
         {
            _loc2_ = 0;
            while(_loc2_ < this.CHARS.numChildren)
            {
               _loc3_ = this.CHARS.getChildAt(_loc2_);
               if(Boolean(_loc3_.hasOwnProperty("isHouseItem")) && Boolean(MovieClip(_loc3_).isHouseItem))
               {
                  this.CHARS.removeChild(_loc3_);
                  _loc2_--;
               }
               _loc2_++;
            }
            this.objHouseData.sHouseInfo = "";
            this.objHouseData.arrPlacement = [];
            this.initEquippedItems(this.objHouseData.arrPlacement);
            this.sendSaveHouseSetup(this.objHouseData.sHouseInfo);
            this.rootClass.requestAPI("HouseSaveRoom",{"frame":"*"},this.callbackC,this.callbackB,true);
         }
      }
      
      public function callbackC(param1:Event) : void
      {
         if(param1.target.data == "cleared")
         {
            this.rootClass.addUpdate("House cleared successfully.");
            this.rootClass.chatF.pushMsg("server","House cleared successfully.","SERVER","",0);
            this.cleanEverything();
         }
         else
         {
            this.rootClass.chatF.pushMsg("warning","Error clearing your house. (CODE: " + param1.target.data + ")","SERVER","",0);
         }
      }
      
      public function cleanEverything() : void
      {
         var _loc1_:int = 0;
         var _loc2_:DisplayObject = null;
         _loc1_ = 0;
         while(_loc1_ < this.CHARS.numChildren)
         {
            _loc2_ = this.CHARS.getChildAt(_loc1_);
            if(Boolean(_loc2_.hasOwnProperty("isHouseItem")) && Boolean(MovieClip(_loc2_).isHouseItem))
            {
               this.CHARS.removeChild(_loc2_);
               _loc1_--;
            }
            _loc1_++;
         }
         this.objHouseData.sHouseInfo = "";
         this.objHouseData.sData = new Object();
         this.objHouseData.arrPlacement = [];
         this.initEquippedItems(this.objHouseData.arrPlacement);
      }
      
      public function onHouseOptionsHouseClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         this.gotoTown("buyhouse","Enter","Spawn");
      }
      
      public function showHouseInventory(param1:int) : *
      {
         if(this.myAvatar.houseitems != null)
         {
            this.sendLoadShopRequest(param1);
         }
      }
      
      public function discardHouseChanges(param1:Object) : *
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         if(param1.accept)
         {
            this.saveHouseSetup();
         }
         else
         {
            this.hasModified = false;
            if(this.rootClass.ui.mcPopup.mcHouseItemHandle.visible)
            {
               this.rootClass.ui.mcPopup.mcHouseItemHandle.tgt = null;
               this.rootClass.ui.mcPopup.mcHouseItemHandle.x = 1000;
               this.rootClass.ui.mcPopup.mcHouseItemHandle.visible = false;
            }
            _loc3_ = 0;
            while(_loc3_ < this.CHARS.numChildren)
            {
               _loc2_ = this.CHARS.getChildAt(_loc3_);
               if(Boolean(_loc2_.hasOwnProperty("isHouseItem")) && Boolean(MovieClip(_loc2_).isHouseItem))
               {
                  this.CHARS.removeChild(_loc2_);
                  _loc3_--;
               }
               _loc3_++;
            }
            if(this.isLegacy())
            {
               _loc3_ = 0;
               while(_loc3_ < this.objHouseData.arrPlacement.length)
               {
                  if(this.strFrame == this.objHouseData.arrPlacement[_loc3_].c)
                  {
                     this.objHouseData.arrPlacement.splice(_loc3_,1);
                     _loc3_--;
                  }
                  _loc3_++;
               }
               for each(var _loc8_ in this.frameCopy)
               {
                  _loc4_ = _loc8_;
                  _loc8_;
                  this.objHouseData.arrPlacement.push(_loc4_);
               }
            }
            else
            {
               this.objHouseData.arrPlacement[this.strFrame] = new Object();
               this.objHouseData.arrPlacement[this.strFrame]["xi"] = [];
               _loc5_ = 0;
               for each(_loc8_ in this.frameCopy)
               {
                  _loc4_ = _loc8_;
                  _loc8_;
                  this.objHouseData.arrPlacement[this.strFrame]["xi"].push(_loc4_);
                  _loc5_++;
               }
               if(_loc5_ == 0)
               {
                  this.objHouseData.arrPlacement[this.strFrame] = null;
               }
            }
            this.updateHouseItems();
         }
         if(!this.hasModified && Boolean(this.rootClass.ui.mcPopup.mcHouseMenu.visible))
         {
            this.toggleHouseEdit();
         }
      }
      
      public function toggleHouseEdit() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:* = undefined;
         if(this.isMyHouse() && this.myAvatar.houseitems != null)
         {
            if(this.rootClass.ui.mcPopup.mcHouseMenu.visible)
            {
               if(this.hasModified)
               {
                  _loc1_ = new ModalMC();
                  _loc2_ = {};
                  _loc2_.params = {};
                  _loc2_.strBody = "Do you want to Save (Yes) or Undo (No) the room?";
                  _loc2_.callback = this.discardHouseChanges;
                  _loc2_.btns = "dual";
                  this.rootClass.ui.ModalStack.addChild(_loc1_);
                  _loc1_.init(_loc2_);
                  return;
               }
               this.rootClass.ui.mcPopup.mcHouseMenu.hideEditMenu();
               this.setEditMode(false);
            }
            else
            {
               if(this.arrHouseItemQueue.length > 0)
               {
                  this.rootClass.showMessageBox("Please wait for your house items to finish loading on your screen before being able to edit them.");
                  return;
               }
               if(this.isLegacy())
               {
                  this.frameCopy = [];
                  _loc3_ = 0;
                  while(_loc3_ < this.CHARS.numChildren)
                  {
                     _loc4_ = this.CHARS.getChildAt(_loc3_);
                     if(Boolean(_loc4_.hasOwnProperty("isHouseItem")) && Boolean(MovieClip(_loc4_).isHouseItem))
                     {
                        if(MovieClip(_loc4_).isStable)
                        {
                           this.frameCopy.push({
                              "c":this.strFrame,
                              "ID":MovieClip(_loc4_).ItemID,
                              "x":_loc4_.x,
                              "y":_loc4_.y
                           });
                        }
                     }
                     _loc3_++;
                  }
               }
               else
               {
                  this.frameCopy = [];
                  if(this.objHouseData.arrPlacement[this.strFrame])
                  {
                     for each(var _loc8_ in this.objHouseData.arrPlacement[this.strFrame]["xi"])
                     {
                        _loc5_ = _loc8_;
                        _loc8_;
                        this.frameCopy.push(_loc5_);
                     }
                  }
               }
               this.rootClass.ui.mcPopup.mcHouseMenu.showEditMenu();
               this.setEditMode(true);
            }
         }
         else if(this.strMapName == "buyhouse")
         {
            if(!this.rootClass.ui.mcPopup.mcHouseMenu.visible)
            {
               this.rootClass.ui.mcPopup.mcHouseMenu.showEditMenu();
            }
            else
            {
               this.rootClass.ui.mcPopup.mcHouseMenu.hideEditMenu();
            }
         }
      }
      
      private function houseBounds(param1:Event) : void
      {
         if(!this.isMyHouse() || this.strFrame != this.houseFrame || this.bitWalk || this.strMapName != "house")
         {
            this.houseFrame = "";
            this.removeEventListener(Event.ENTER_FRAME,this.houseBounds);
            this.toggleHouseEdit();
            this.setEditMode(false);
         }
      }
      
      public function setEditMode(param1:Boolean) : *
      {
         var _loc2_:* = undefined;
         if(param1)
         {
            this.houseFrame = this.strFrame;
            for each(var _loc5_ in this.avatars)
            {
               _loc2_ = _loc5_;
               _loc5_;
               if(_loc2_.pMC)
               {
                  _loc2_.pMC.visible = false;
                  _loc2_.unloadPet();
               }
            }
            this.myAvatar.isWorldCamera = true;
            this.bitWalk = false;
            this.addEventListener(Event.ENTER_FRAME,this.houseBounds,false,0,true);
         }
         else
         {
            for each(_loc5_ in this.avatars)
            {
               _loc2_ = _loc5_;
               _loc5_;
               if(Boolean(_loc2_.pMC) && (_loc2_.isMyAvatar || _loc2_.dataLeaf != null && String(_loc2_.dataLeaf.strFrame) == this.strFrame))
               {
                  _loc2_.pMC.visible = true;
                  _loc2_.loadPet();
               }
            }
            this.myAvatar.isWorldCamera = false;
            this.bitWalk = true;
         }
      }
      
      public function loadHouseInventory() : *
      {
         this.rootClass.sfc.sendXtMessage("zm","loadHouseInventory",[],"str",this.curRoom);
      }
      
      public function updateHouseItems() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         if(this.objHouseData != null)
         {
            if(this.isMyHouse())
            {
               this.initEquippedItems(this.objHouseData.arrPlacement);
            }
            this.arrHouseItemQueue = [];
            try
            {
               this.ldr_House.close();
            }
            catch(e:Error)
            {
            }
            if(this.isLegacy())
            {
               _loc1_ = 0;
               while(_loc1_ < this.objHouseData.arrPlacement.length)
               {
                  if(this.strFrame == this.objHouseData.arrPlacement[_loc1_].c)
                  {
                     _loc2_ = this.getHouseItem(this.objHouseData.arrPlacement[_loc1_].ID);
                     if(_loc2_ != null)
                     {
                        this.loadHouseItem(_loc2_,this.objHouseData.arrPlacement[_loc1_].x,this.objHouseData.arrPlacement[_loc1_].y);
                     }
                  }
                  _loc1_++;
               }
            }
            else
            {
               for(var _loc6_ in this.objHouseData.arrPlacement)
               {
                  _loc3_ = _loc6_;
                  _loc6_;
                  if(this.strFrame == _loc3_)
                  {
                     if(!(!this.objHouseData.arrPlacement[_loc3_] || !this.objHouseData.arrPlacement[_loc3_]["xi"]))
                     {
                        _loc1_ = 0;
                        while(_loc1_ < this.objHouseData.arrPlacement[_loc3_]["xi"].length)
                        {
                           _loc2_ = this.getHouseItem(this.objHouseData.arrPlacement[_loc3_]["xi"][_loc1_]["ID"]);
                           if(_loc2_ != null)
                           {
                              this.loadHouseItem(_loc2_,this.objHouseData.arrPlacement[_loc3_]["xi"][_loc1_]["x"],this.objHouseData.arrPlacement[_loc3_]["xi"][_loc1_]["y"],this.objHouseData.arrPlacement[_loc3_]["xi"][_loc1_]["f"]);
                           }
                           _loc1_++;
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function attachHouseItem(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:MovieClip = null;
         if(this.objHouseData == null)
         {
            return;
         }
         if(param1.item.sLink == null || !this.loaderD.hasDefinition(param1.item.sLink))
         {
            if(param1.item.sLink != null)
            {
               trace("[Load] ERR missing linkage " + param1.item.sLink + " " + param1.item.sFile);
            }
            return;
         }
         var _loc2_:Class = this.loaderD.getDefinition(param1.item.sLink) as Class;
         _loc3_ = new _loc2_();
         _loc3_.f = param1.f;
         _loc3_.x = param1.x;
         _loc3_.y = param1.y;
         _loc3_.ItemID = param1.item.ItemID;
         _loc3_.item = param1.item;
         _loc3_.isHouseItem = true;
         _loc3_.isStable = false;
         _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.onHouseItemClick,false,0,true);
         if(_loc3_.f)
         {
            _loc3_.scaleX = _loc3_.scaleX * -1;
         }
         _loc4_ = this.CHARS.addChild(_loc3_) as MovieClip;
         _loc4_.name = "mc" + getQualifiedClassName(_loc4_);
         this.houseItemValidate(_loc3_);
      }
      
      public function onHouseItemClick(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(this.isMyHouse() && Boolean(this.rootClass.ui.mcPopup.mcHouseMenu.visible))
         {
            this.rootClass.ui.mcPopup.mcHouseMenu.drawItemHandle(MovieClip(param1.currentTarget));
            this.rootClass.ui.mcPopup.mcHouseMenu.onHandleMoveClick(param1.clone());
         }
         else if(_loc2_.btnButton == null || !_loc2_.btnButton.hasEventListener(MouseEvent.CLICK))
         {
            this.onWalkClick();
         }
      }
      
      public function houseItemValidate(param1:MovieClip) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         _loc2_ = this.getHouseItem(param1.ItemID);
         if(_loc2_ == null)
         {
            MovieClip(param1.parent).removeChild(param1);
            return;
         }
         if(_loc2_.sType == "Floor Item")
         {
            param1.isStable = false;
            param1.addEventListener(Event.ENTER_FRAME,this.onHouseItemEnterFrame,false,0,true);
         }
         else if(_loc2_.sType == "Wall Item")
         {
            param1.isStable = true;
            _loc3_ = 0;
            while(_loc3_ < this.map.numChildren)
            {
               _loc4_ = this.map.getChildAt(_loc3_);
               if(_loc4_ is MovieClip && MovieClip(_loc4_).isFloor && MovieClip(_loc4_).hitTestObject(param1))
               {
                  param1.isStable = false;
                  break;
               }
               _loc3_++;
            }
            if(!param1.isStable)
            {
               param1.transform.colorTransform = new ColorTransform(1,1,1,1,150,0,0,0);
            }
            else
            {
               param1.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
            }
         }
      }
      
      public function onHouseItemEnterFrame(param1:Event) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.parent == null || this.map == null)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.onHouseItemEnterFrame);
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < this.map.numChildren)
         {
            _loc4_ = this.map.getChildAt(_loc3_);
            if(_loc4_ is MovieClip && MovieClip(_loc4_).isFloor && MovieClip(_loc4_).hitTestPoint(_loc2_.x,_loc2_.y))
            {
               _loc2_.removeEventListener(Event.ENTER_FRAME,this.onHouseItemEnterFrame);
               _loc2_.isStable = true;
               break;
            }
            _loc3_++;
         }
         if(!_loc2_.isStable)
         {
            _loc5_ = _loc2_.getBounds(this.rootClass.stage);
            if(_loc5_.y + _loc5_.height / 2 > 495)
            {
               _loc2_.isStable = true;
               _loc2_.y = Math.ceil(_loc5_.y - (_loc5_.y - _loc2_.y));
               _loc2_.removeEventListener(Event.ENTER_FRAME,this.onHouseItemEnterFrame);
            }
            else
            {
               _loc2_.y = _loc2_.y + 10;
            }
            if(Boolean(this.rootClass.ui.mcPopup.mcHouseMenu) && Boolean(this.rootClass.ui.mcPopup.mcHouseMenu.visible))
            {
               this.rootClass.ui.mcPopup.mcHouseMenu.drawItemHandle(_loc2_);
            }
         }
      }
      
      public function isLegacy() : Boolean
      {
         if(this.objHouseData != null && (this.objHouseData.sData == "" && this.objHouseData.sHouseInfo == ""))
         {
            return false;
         }
         return !(this.objHouseData != null && this.objHouseData.sData != "");
      }
      
      public function initHouseData(param1:Object) : void
      {
         this.arrHouseItemQueue = [];
         try
         {
            this.ldr_House.close();
         }
         catch(eHL:Error)
         {
         }
         this.objHouseData = param1;
         if(this.objHouseData != null)
         {
            if(!this.isLegacy())
            {
               if(this.isMyHouse())
               {
                  this.searchForInequalities();
               }
               this.objHouseData.arrPlacement = this.objHouseData.sData;
               if(this.objHouseData.sData == "")
               {
                  this.objHouseData.arrPlacement = {};
               }
               if(this.isMyHouse())
               {
                  this.rootClass.chatF.pushMsg("server","Your house data has been upgraded.","SERVER","",0);
               }
            }
            else
            {
               this.objHouseData.arrPlacement = this.createItemPlacementArray(this.objHouseData.sHouseInfo);
               if(this.isMyHouse())
               {
                  this.rootClass.chatF.pushMsg("server","Your house data needs to be upgraded. Upgrading will start shortly.","SERVER","",0);
               }
            }
            this.verifyItemQty();
         }
         if(this.isMyHouse() && this.imbalancedHouseCells.length > 0)
         {
            this.massAutoSave();
         }
      }
      
      public function massAutoSave() : void
      {
         this.convertTimer = new Timer(500,1);
         this.convertTimer.addEventListener(TimerEvent.TIMER,this.onAutoSave,false,0,true);
         this.convertTimer.start();
      }
      
      public function onAutoSave(param1:TimerEvent) : void
      {
         var _loc2_:String = null;
         _loc2_ = this.imbalancedHouseCells.shift();
         this.rootClass.mcConnDetail.showConn("Upgrading room " + _loc2_ + "...",false,true);
         this.rootClass.chatF.pushMsg("server","Saving room " + _loc2_ + "...","SERVER","",0);
         this.rootClass.requestAPI("HouseSaveRoom",{
            "frame":_loc2_,
            "layout":this.objHouseData.sData[_loc2_]
         },this.callbackA,this.callbackB,true);
         if(this.imbalancedHouseCells.length < 1)
         {
            this.rootClass.mcConnDetail.hideConn();
            this.convertTimer.removeEventListener(TimerEvent.TIMER,this.onSendConvert);
            this.convertTimer.reset();
            this.convertTimer = null;
         }
      }
      
      public function searchForInequalities() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         _loc1_ = {};
         for(var _loc12_ in this.objHouseData.sData)
         {
            _loc2_ = _loc12_;
            _loc12_;
            if(!(!this.objHouseData.sData[_loc2_] || !this.objHouseData.sData[_loc2_]["xi"]))
            {
               _loc4_ = 0;
               while(_loc4_ < this.objHouseData.sData[_loc2_]["xi"].length)
               {
                  _loc7_ = this.objHouseData.sData[_loc2_]["xi"][_loc4_]["ID"];
                  if(_loc1_[_loc7_] == null)
                  {
                     _loc1_[_loc7_] = 1;
                  }
                  else
                  {
                     _loc1_[_loc7_]++;
                  }
                  _loc4_++;
               }
            }
         }
         _loc3_ = [];
         _loc4_ = 0;
         while(_loc4_ < this.myAvatar.houseitems.length)
         {
            _loc8_ = this.myAvatar.houseitems[_loc4_];
            if(Number(_loc1_[_loc8_.ItemID]) > Number(_loc8_.iQty))
            {
               _loc3_.push(_loc8_.ItemID);
            }
            _loc4_++;
         }
         if(_loc3_.length == 0)
         {
            return;
         }
         this.imbalancedHouseCells = [];
         _loc5_ = false;
         for(_loc12_ in this.objHouseData.sData)
         {
            _loc6_ = _loc12_;
            _loc12_;
            _loc5_ = false;
            if(!(!this.objHouseData.sData[_loc6_] || !this.objHouseData.sData[_loc6_]["xi"]))
            {
               _loc9_ = 0;
               while(_loc9_ < this.objHouseData.sData[_loc6_]["xi"].length)
               {
                  if(_loc3_.indexOf(this.objHouseData.sData[_loc6_]["xi"][_loc9_]["ID"]) > -1)
                  {
                     this.objHouseData.sData[_loc6_]["xi"].splice(_loc9_,1);
                     _loc9_--;
                     _loc5_ = true;
                  }
                  _loc9_++;
               }
               if(_loc5_)
               {
                  this.imbalancedHouseCells.push(_loc6_);
               }
            }
         }
      }
      
      public function initMassConvert() : void
      {
         if(this.objHouseData != null)
         {
            if(this.objHouseData.sHouseInfo != "")
            {
               if(this.isLegacy())
               {
                  this.massConvert();
               }
            }
         }
      }
      
      public function verifyItemQty() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         _loc1_ = {};
         if(this.isLegacy())
         {
            _loc2_ = 0;
            while(_loc2_ < this.objHouseData.arrPlacement.length)
            {
               _loc3_ = this.objHouseData.arrPlacement[_loc2_].ID;
               if(_loc1_[_loc3_] == null)
               {
                  _loc1_[_loc3_] = 1;
               }
               else
               {
                  _loc1_[_loc3_]++;
               }
               _loc2_++;
            }
         }
         else
         {
            for(var _loc7_ in this.objHouseData.arrPlacement)
            {
               _loc4_ = _loc7_;
               _loc7_;
               if(_loc4_ == this.strFrame)
               {
                  if(!(!this.objHouseData.arrPlacement[_loc4_] || !this.objHouseData.arrPlacement[_loc4_]["xi"]))
                  {
                     _loc2_ = 0;
                     while(_loc2_ < this.objHouseData.arrPlacement[_loc4_]["xi"].length)
                     {
                        _loc3_ = this.objHouseData.arrPlacement[_loc4_]["xi"][_loc2_]["ID"];
                        if(_loc1_[_loc3_] == null)
                        {
                           _loc1_[_loc3_] = 1;
                        }
                        else
                        {
                           _loc1_[_loc3_]++;
                        }
                        _loc2_++;
                     }
                  }
               }
            }
         }
      }
      
      public function getHouseItem(param1:int) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.isMyHouse())
         {
            _loc2_ = 0;
            while(_loc2_ < this.myAvatar.houseitems.length)
            {
               if(this.myAvatar.houseitems[_loc2_].ItemID == param1)
               {
                  return this.myAvatar.houseitems[_loc2_];
               }
               _loc2_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this.objHouseData.items.length)
            {
               if(this.objHouseData.items[_loc3_].ItemID == param1)
               {
                  return this.objHouseData.items[_loc3_];
               }
               _loc3_++;
            }
         }
         return null;
      }
      
      public function removeSelectedItem() : void
      {
         var _loc1_:MovieClip = null;
         if(this.objHouseData.selectedMC == null)
         {
            this.rootClass.MsgBox.notify("Please selected an item to be removed.");
         }
         else
         {
            _loc1_ = this.objHouseData.selectedMC;
            _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHouseItemClick);
            this.unequipHouseItem(_loc1_.ItemID);
            this.CHARS.removeChild(_loc1_);
            delete this.objHouseData.selectedMC;
         }
      }
      
      public function equipHouse(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc2_ = new ModalMC();
         _loc3_ = {};
         _loc3_.strBody = "Are you sure you want to equip \'" + param1.sName + "\'?";
         _loc3_.params = {"item":param1};
         _loc3_.callback = this.equipHouseRequest;
         this.rootClass.ui.ModalStack.addChild(_loc2_);
         _loc2_.init(_loc3_);
      }
      
      public function equipHouseRequest(param1:*) : void
      {
         if(param1.accept)
         {
            this.rootClass.world.sendEquipItemRequest(param1.item);
            this.rootClass.world.equipHouseByID(param1.item.ItemID);
         }
      }
      
      public function equipHouseByID(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.myAvatar.houseitems.length)
         {
            this.myAvatar.houseitems[_loc2_].bEquip = this.myAvatar.houseitems[_loc2_].ItemID == param1 ? 1 : 0;
            _loc2_++;
         }
         if(this.rootClass.ui.mcPopup.currentLabel == "HouseInventory")
         {
            MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcInventory")).update({"eventType":"refreshItems"});
         }
      }
      
      public function massConvert() : void
      {
         var _loc1_:* = undefined;
         this.houseJson = new Object();
         for each(var _loc4_ in this.createItemPlacementArray(this.objHouseData.sHouseInfo))
         {
            _loc1_ = _loc4_;
            _loc4_;
            if(_loc1_.c)
            {
               if(!this.frameExists(_loc1_.c))
               {
                  trace("[Map] massConvert: skipping missing frame " + _loc1_.c);
               }
               else
               {
                  if(!this.houseJson.hasOwnProperty(_loc1_.c))
                  {
                     this.houseJson[_loc1_.c] = new Object();
                     this.houseJson[_loc1_.c]["xi"] = [];
                  }
                  this.houseJson[_loc1_.c]["xi"].push({
                     "ID":parseInt(_loc1_.ID),
                     "x":parseInt(_loc1_.x),
                     "y":parseInt(_loc1_.y)
                  });
               }
            }
         }
         this.finishedCells = [];
         this.retrieveUnsentCell();
         this.convertTimer = new Timer(500,1);
         this.convertTimer.addEventListener(TimerEvent.TIMER,this.onSendConvert,false,0,true);
         this.convertTimer.start();
      }
      
      public function retrieveUnsentCell() : void
      {
         var _loc1_:* = undefined;
         for(var _loc4_ in this.houseJson)
         {
            _loc1_ = _loc4_;
            _loc4_;
            if(this.finishedCells.indexOf(_loc1_) == -1)
            {
               this.activeCell = _loc1_;
               this.finishedCells.push(_loc1_);
               return;
            }
         }
         this.rootClass.mcConnDetail.hideConn();
         if(this.convertTimer)
         {
            this.convertTimer.removeEventListener(TimerEvent.TIMER,this.onSendConvert);
            this.convertTimer.reset();
            this.convertTimer = null;
         }
      }
      
      public function onSendConvert(param1:TimerEvent) : void
      {
         var _loc2_:* = undefined;
         this.rootClass.mcConnDetail.showConn("Converting frame " + this.activeCell + " from legacy house data...",false,true);
         this.rootClass.chatF.pushMsg("server","Saving room " + this.activeCell + "...","SERVER","",0);
         this.rootClass.requestAPI("HouseSaveRoom",{
            "frame":this.activeCell,
            "layout":this.houseJson[this.activeCell]
         },this.callbackA,this.callbackB,true);
         for each(var _loc5_ in this.houseJson[this.activeCell]["xi"])
         {
            _loc2_ = _loc5_;
            _loc5_;
         }
         this.retrieveUnsentCell();
      }
      
      public function saveHouseSetup() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < this.CHARS.numChildren)
         {
            _loc3_ = this.CHARS.getChildAt(_loc1_);
            if(Boolean(_loc3_.hasOwnProperty("isHouseItem")) && Boolean(MovieClip(_loc3_).isHouseItem))
            {
               if(!MovieClip(_loc3_).isStable)
               {
                  this.rootClass.showMessageBox(MovieClip(_loc3_).item.sName + " is not properly placed!");
                  return;
               }
            }
            _loc1_++;
         }
         _loc2_ = new Object();
         _loc2_["xi"] = [];
         _loc1_ = 0;
         while(_loc1_ < this.CHARS.numChildren)
         {
            _loc3_ = this.CHARS.getChildAt(_loc1_);
            if(Boolean(_loc3_.hasOwnProperty("isHouseItem")) && Boolean(MovieClip(_loc3_).isHouseItem))
            {
               if(MovieClip(_loc3_).isStable)
               {
                  _loc4_ = {
                     "ID":int(MovieClip(_loc3_).ItemID),
                     "x":int(_loc3_.x),
                     "y":int(_loc3_.y)
                  };
                  if(MovieClip(_loc3_).scaleX < 0)
                  {
                     _loc4_["f"] = 1;
                  }
                  _loc2_["xi"].push(_loc4_);
               }
               else
               {
                  this.rootClass.chatF.pushMsg("warning",MovieClip(_loc3_).item.sName + " was removed for being in an invalid position.","SERVER","",0);
                  this.unequipHouseItem(MovieClip(_loc3_).ItemID);
                  _loc3_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHouseItemClick);
                  this.CHARS.removeChild(_loc3_);
               }
            }
            _loc1_++;
         }
         this.objHouseData.arrPlacement[this.strFrame] = _loc2_;
         this.rootClass.requestAPI("HouseSaveRoom",{
            "frame":this.strFrame,
            "layout":_loc2_
         },this.callbackA,this.callbackB,true);
         this.hasModified = false;
      }
      
      public function callbackA(param1:Event) : void
      {
         if(param1.target.data == "success")
         {
            this.rootClass.addUpdate("House saved successfully.");
            this.rootClass.chatF.pushMsg("server","House saved successfully.","SERVER","",0);
            if(this.convertTimer)
            {
               this.convertTimer.start();
            }
         }
         else
         {
            this.rootClass.chatF.pushMsg("warning","Error saving your house. (CODE: " + param1.target.data + ")","SERVER","",0);
            this.convertTimer.removeEventListener(TimerEvent.TIMER,this.onSendConvert);
            this.convertTimer.reset();
            this.convertTimer = null;
            this.rootClass.mcConnDetail.hideConn();
         }
      }
      
      public function callbackB(param1:IOErrorEvent) : void
      {
         this.rootClass.chatF.pushMsg("warning","IOError occurred.","SERVER","",0);
      }
      
      public function createItemPlacementString(param1:Array) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         _loc2_ = "";
         if(param1.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               for(var _loc7_ in param1[_loc3_])
               {
                  _loc4_ = _loc7_;
                  _loc7_;
                  _loc2_ = _loc2_ + _loc4_ + ":" + param1[_loc3_][_loc4_] + ",";
               }
               _loc2_ = _loc2_.substring(0,_loc2_.length - 1);
               _loc2_ = _loc2_ + "|";
               _loc3_++;
            }
            _loc2_ = _loc2_.substring(0,_loc2_.length - 1);
         }
         return _loc2_;
      }
      
      public function createItemPlacementArray(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         _loc2_ = [];
         if(param1.length > 0)
         {
            _loc3_ = param1.split("|");
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = {};
               _loc6_ = _loc3_[_loc4_].split(",");
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  _loc5_[_loc6_[_loc7_].split(":")[0]] = _loc6_[_loc7_].split(":")[1];
                  _loc7_++;
               }
               if(this.getHouseItem(parseInt(_loc5_["ID"])) != null)
               {
                  _loc2_.push(_loc5_);
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function sendSaveHouseSetup(param1:*) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","housesave",[param1],"str",1);
      }
      
      public function frameExists(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         if(!param1)
         {
            return false;
         }
         for each(var _loc5_ in this.rootClass.world.map.currentScene.labels)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_.name == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function initEquippedItems(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         if(!this.objHouseData)
         {
            return;
         }
         if(this.isLegacy())
         {
            _loc2_ = 0;
            while(_loc2_ < this.myAvatar.houseitems.length)
            {
               if(this.myAvatar.houseitems[_loc2_].sType != "House")
               {
                  this.myAvatar.houseitems[_loc2_].bEquip = 0;
                  _loc3_ = 0;
                  while(_loc3_ < param1.length)
                  {
                     if(this.myAvatar.houseitems[_loc2_].ItemID == param1[_loc3_].ID && this.frameExists(param1[_loc3_].c))
                     {
                        this.myAvatar.houseitems[_loc2_].bEquip = this.myAvatar.houseitems[_loc2_].bEquip + 1;
                     }
                     _loc3_++;
                  }
               }
               _loc2_++;
            }
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.myAvatar.houseitems.length)
            {
               if(this.myAvatar.houseitems[_loc2_].sType != "House")
               {
                  this.myAvatar.houseitems[_loc2_].bEquip = 0;
                  for(var _loc7_ in param1)
                  {
                     _loc4_ = _loc7_;
                     _loc7_;
                     if(this.frameExists(_loc4_))
                     {
                        if(param1[_loc4_])
                        {
                           _loc3_ = 0;
                           while(_loc3_ < param1[_loc4_]["xi"].length)
                           {
                              if(this.myAvatar.houseitems[_loc2_].ItemID == param1[_loc4_]["xi"][_loc3_].ID)
                              {
                                 this.myAvatar.houseitems[_loc2_].bEquip = this.myAvatar.houseitems[_loc2_].bEquip + 1;
                              }
                              _loc3_++;
                           }
                        }
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      public function initHouseInventory(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         this.myAvatar.houseitems = param1.items == null ? [] : param1.items;
         this.initEquippedItems(this.createItemPlacementArray(param1.sHouseInfo));
         _loc2_ = this.myAvatar.houseitems;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc2_[_loc3_].iQty = int(_loc2_[_loc3_].iQty);
            this.rootClass.world.invTree[_loc2_[_loc3_].ItemID] = _loc2_[_loc3_];
            _loc3_++;
         }
      }
      
      public function unequipHouseItem(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.myAvatar.houseitems.length)
         {
            if(this.myAvatar.houseitems[_loc2_].ItemID == param1)
            {
               this.myAvatar.houseitems[_loc2_].bEquip = this.myAvatar.houseitems[_loc2_].bEquip - 1;
            }
            _loc2_++;
         }
      }
      
      public function loadHouseItem(param1:Object, param2:int, param3:int, param4:int = 0) : void
      {
         var item:Object = param1;
         var x:int = param2;
         var y:int = param3;
         var f:int = param4;
         if(item.sLink == null || !this.loaderD.hasDefinition(item.sLink))
         {
            this.arrHouseItemQueue.push({
               "item":item,
               "typ":"A",
               "x":x,
               "y":y,
               "f":f
            });
            if(this.arrHouseItemQueue.length > 0)
            {
               this.loadNextHouseItem();
            }
            return;
         }
         try
         {
            this.attachHouseItem({
               "item":item,
               "x":x,
               "y":y,
               "f":f
            });
         }
         catch(err:Error)
         {
            arrHouseItemQueue.push({
               "item":item,
               "typ":"A",
               "x":x,
               "y":y,
               "f":f
            });
            if(arrHouseItemQueue.length > 0)
            {
               loadNextHouseItem();
            }
         }
      }
      
      public function loadNextHouseItem() : void
      {
         this.ldr_House.load(new URLRequest(this.rootClass.vswf(this.rootClass.getFilePath() + this.arrHouseItemQueue[0].item.sFile)),this.loaderC);
         if(!this.ldr_House.hasEventListener(Event.COMPLETE))
         {
            this.ldr_House.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onHouseItemComplete);
            this.ldr_House.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onHouseItemError);
         }
      }
      
      public function onHouseItemError(param1:IOErrorEvent) : void
      {
         var _loc2_:* = undefined;
         this.rootClass.debugMessage(param1.text);
         _loc2_ = this.arrHouseItemQueue[0];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.typ == "A")
         {
            this.arrHouseItemQueue.splice(0,1);
            if(this.arrHouseItemQueue.length > 0)
            {
               this.loadNextHouseItem();
            }
         }
         else
         {
            this.arrHouseItemQueue.splice(0,1);
            if(this.arrHouseItemQueue.length > 0)
            {
               this.loadNextHouseItemB();
            }
         }
      }
      
      public function onHouseItemComplete(param1:Event) : void
      {
         var loaderEntry:* = undefined;
         var e:Event = param1;
         loaderEntry = this.arrHouseItemQueue[0];
         if(loaderEntry == null)
         {
            return;
         }
         if(loaderEntry.typ == "A")
         {
            try
            {
               this.attachHouseItem(loaderEntry);
            }
            catch(eAt:Error)
            {
               trace("[Load] ERR attachHouseItem: " + eAt.message);
            }
            this.arrHouseItemQueue.splice(0,1);
            if(this.arrHouseItemQueue.length > 0)
            {
               this.loadNextHouseItem();
            }
         }
         else
         {
            this.rootClass.ui.mcPopup.mcHouseMenu.previewHouseItem(loaderEntry);
            this.arrHouseItemQueue.splice(0,1);
            if(this.arrHouseItemQueue.length > 0)
            {
               this.loadNextHouseItemB();
            }
         }
      }
      
      public function loadHouseItemB(param1:Object) : void
      {
         var sPrevB:String = null;
         var item:Object = param1;
         sPrevB = item.sLink;
         if(item.sType == "House" && item.sFile != null)
         {
            sPrevB = item.sFile.substr(0,-4).substr(item.sFile.lastIndexOf("/") + 1).split("-").join("_") + "_preview";
         }
         if(sPrevB == null || !this.loaderD.hasDefinition(sPrevB))
         {
            this.rootClass.ui.mcPopup.mcHouseMenu.preview.t2.visible = true;
            this.rootClass.ui.mcPopup.mcHouseMenu.preview.cnt.visible = false;
            this.rootClass.ui.mcPopup.mcHouseMenu.preview.bAdd.visible = false;
            this.arrHouseItemQueue.push({
               "item":item,
               "typ":"B"
            });
            if(this.arrHouseItemQueue.length > 0)
            {
               this.loadNextHouseItemB();
            }
            return;
         }
         try
         {
            this.rootClass.ui.mcPopup.mcHouseMenu.previewHouseItem({"item":item});
         }
         catch(err:Error)
         {
            rootClass.ui.mcPopup.mcHouseMenu.preview.t2.visible = true;
            rootClass.ui.mcPopup.mcHouseMenu.preview.cnt.visible = false;
            rootClass.ui.mcPopup.mcHouseMenu.preview.bAdd.visible = false;
            arrHouseItemQueue.push({
               "item":item,
               "typ":"B"
            });
            if(arrHouseItemQueue.length > 0)
            {
               loadNextHouseItemB();
            }
         }
      }
      
      public function loadNextHouseItemB() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         _loc1_ = this.arrHouseItemQueue[0].item;
         _loc2_ = _loc1_.sFile;
         if(_loc1_.sType == "House")
         {
            _loc2_ = "maps/" + _loc1_.sFile.substr(0,-4) + "_preview.swf";
         }
         this.ldr_House.load(new URLRequest(this.rootClass.vswf(this.rootClass.getFilePath() + _loc2_)),this.loaderC);
         if(!this.ldr_House.hasEventListener(Event.COMPLETE))
         {
            this.ldr_House.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onHouseItemComplete);
            this.ldr_House.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onHouseItemError);
         }
      }
      
      public function playerInit() : *
      {
         var uid:int;
         var roomList:* = undefined;
         var s:* = undefined;
         var userList:* = undefined;
         var i:* = undefined;
         var a:Array = null;
         trace("[Avatar] playerInit: " + this.rootClass.sfc.myUserName);
         roomList = this.rootClass.sfc.getAllRooms();
         for(var _loc4_ in roomList)
         {
            s = _loc4_;
            _loc4_;
         }
         userList = this.rootClass.sfc.getRoom(this.curRoom).getUserList();
         a = [];
         uid = 0;
         for(_loc4_ in userList)
         {
            i = _loc4_;
            _loc4_;
            a.push(userList[i].getId());
         }
         if(a.length > 0)
         {
            this.objectByIDArray(a);
         }
         this.myAvatar = this.avatars[this.rootClass.sfc.myUserId];
         if(this.myAvatar != null)
         {
            this.myAvatar.isMyAvatar = true;
            if(this.myAvatar.pMC != null)
            {
               this.myAvatar.pMC.disablePNameMouse();
            }
         }
         try
         {
            if(this.rootClass.flushPendingSelfInitData != null)
            {
               this.rootClass.flushPendingSelfInitData();
            }
         }
         catch(e:Error)
         {
            trace("[Avatar] ERR flushPendingSelfInitData: " + e.message);
         }
         this.rootClass.sfcSocial = true;
      }
      
      public function objectByIDArray(param1:Array) : *
      {
         var i:int = 0;
         var uid:int = 0;
         var uo:* = undefined;
         var unm:String = null;
         var uoLeaf:Object = null;
         var strF:String = null;
         var b:Array = null;
         var selfIdx:int = 0;
         var a:Array = param1;
         trace("[Avatar] objectByIDArray: " + a.length + " uids");
         b = [];
         i = 0;
         while(i < a.length)
         {
            uid = int(a[i]);
            try
            {
               uoLeaf = this.getUoLeafById(uid);
               if(uoLeaf != null)
               {
                  unm = uoLeaf.uoName;
                  strF = String(uoLeaf.strFrame);
                  if(uid == this.rootClass.sfc.myUserId)
                  {
                     strF = this.strFrame;
                  }
                  if(this.avatars[uid] == null)
                  {
                     this.avatars[uid] = new Avatar(this.rootClass);
                     this.avatars[uid].uid = uid;
                     this.avatars[uid].pnm = unm;
                  }
                  this.avatars[uid].dataLeaf = uoLeaf;
                  if(this.avatars[uid].pMC == null && strF == this.strFrame)
                  {
                     this.avatars[uid].pMC = this.createAvatarMC(uid);
                     this.avatars[uid].showMC();
                     b.push(uid);
                  }
                  else if(this.avatars[uid].pMC != null && strF == this.strFrame)
                  {
                     this.avatars[uid].pMC.visible = true;
                     if(this.avatars[uid].petMC != null)
                     {
                        this.avatars[uid].petMC.visible = true;
                     }
                     if(this.avatars[uid].pMC.isLoaded)
                     {
                        this.avatars[uid].pMC.gotoAndPlay("in2");
                     }
                     if(!this.rootClass.world.CHARS.contains(this.avatars[uid].pMC))
                     {
                        this.avatars[uid].showMC();
                     }
                     if(uid != this.rootClass.sfc.myUserId)
                     {
                        b.push(uid);
                     }
                     else if(this.avatars[uid].items == null || this.avatars[uid].items.length < 1)
                     {
                        b.push(uid);
                     }
                  }
                  else if(this.avatars[uid].pMC != null && strF != this.strFrame)
                  {
                     if(uid != this.rootClass.sfc.myUserId)
                     {
                        this.avatars[uid].pMC.visible = false;
                        if(this.avatars[uid].petMC != null)
                        {
                           this.avatars[uid].petMC.visible = false;
                        }
                     }
                  }
                  this.updateUserDisplay(uid);
               }
               else
               {
                  trace("[Avatar] ERR objectByIDArray: no uoLeaf for uid " + uid);
               }
            }
            catch(e:Error)
            {
               trace("[Avatar] ERR objectByIDArray: uid " + uid + " " + e.message);
               if(uid == rootClass.sfc.myUserId && avatars[uid] != null && avatars[uid].pMC != null && b.indexOf(uid) < 0)
               {
                  b.push(uid);
               }
            }
            i++;
         }
         if(b.length > 0)
         {
            selfIdx = int(b.indexOf(this.rootClass.sfc.myUserId));
            if(selfIdx > -1)
            {
               b.splice(selfIdx,1);
               this.getUserDataById(this.rootClass.sfc.myUserId);
            }
            if(b.length > 0)
            {
               this.getUserDataByIds(b);
            }
         }
      }
      
      public function objectByID(param1:Number) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         trace("[Avatar] objectByID: uid " + param1);
         _loc2_ = this.getUoLeafById(param1);
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.uoName;
            _loc4_ = String(_loc2_.strFrame);
            if(param1 == this.rootClass.sfc.myUserId)
            {
               _loc4_ = this.strFrame;
            }
            if(this.avatars[param1] == null)
            {
               this.avatars[param1] = new Avatar(this.rootClass);
               this.avatars[param1].uid = param1;
               this.avatars[param1].pnm = _loc3_;
            }
            this.avatars[param1].dataLeaf = _loc2_;
            if(this.avatars[param1].pMC == null && _loc4_ == this.strFrame)
            {
               this.avatars[param1].pMC = this.createAvatarMC(param1);
               this.getUserDataById(param1);
            }
            this.updateUserDisplay(param1);
         }
      }
      
      public function createAvatarMC(param1:Number) : AvatarMC
      {
         var _loc2_:AvatarMC = null;
         _loc2_ = new AvatarMC();
         _loc2_.name = "a" + param1;
         _loc2_.x = -600;
         _loc2_.y = 0;
         _loc2_.pAV = this.avatars[param1];
         _loc2_.world = this;
         return _loc2_;
      }
      
      public function destroyAvatar(param1:Number) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.avatars[param1] != null)
         {
            if(!this.avatars[param1].isMyAvatar)
            {
               _loc2_ = this.avatars[param1];
               try
               {
                  _loc2_.unloadPet();
               }
               catch(eDP:Error)
               {
               }
               _loc3_ = _loc2_.pMC;
               if(_loc3_ != null)
               {
                  try
                  {
                     _loc3_.fClose();
                  }
                  catch(eDC:Error)
                  {
                  }
                  try
                  {
                     if(_loc3_.parent != null)
                     {
                        _loc3_.parent.removeChild(_loc3_);
                     }
                  }
                  catch(eDR:Error)
                  {
                  }
               }
               try
               {
                  _loc2_.cleanup();
               }
               catch(eDL:Error)
               {
               }
               delete this.avatars[param1];
            }
         }
      }
      
      public function updateUserDisplay(param1:Number) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         _loc2_ = this.getMCByUserID(param1);
         _loc3_ = this.getUoLeafById(param1);
         if(_loc2_ == null || _loc3_ == null)
         {
            return;
         }
         _loc4_ = String(_loc3_.strFrame);
         if(param1 == this.rootClass.sfc.myUserId)
         {
            _loc4_ = this.strFrame;
         }
         if(_loc4_ == this.strFrame)
         {
            _loc2_.mvts = Number(_loc3_.mvts);
            _loc2_.mvtd = Number(_loc3_.mvtd);
            _loc2_.px = int(_loc3_.px);
            _loc2_.py = int(_loc3_.py);
            _loc2_.tx = int(_loc3_.tx);
            _loc2_.ty = int(_loc3_.ty);
            _loc2_.sp = int(_loc3_.sp);
            _loc5_ = int(_loc3_.intState);
            _loc6_ = null;
            if("strPad" in _loc3_ && _loc3_.strPad.toLowerCase() != "none" && _loc3_.strPad in this.map)
            {
               _loc6_ = this.map[_loc3_.strPad];
            }
            if(_loc2_.tx != 0 || _loc2_.ty != 0)
            {
               if(this.bPvP)
               {
                  _loc2_.mcChar.onMove = true;
               }
               else if(!this.testTxTy(new Point(_loc2_.tx,_loc2_.ty),_loc2_))
               {
                  _loc7_ = this.solveTxTy(new Point(_loc2_.tx,_loc2_.ty),_loc2_);
                  if(_loc7_ != null)
                  {
                     _loc2_.x = _loc7_.x;
                     _loc2_.y = _loc7_.y;
                  }
                  else
                  {
                     _loc2_.x = int(960 / 2);
                     _loc2_.y = int(550 / 2);
                  }
               }
               else
               {
                  _loc2_.x = _loc2_.tx;
                  _loc2_.y = _loc2_.ty;
               }
            }
            else
            {
               if(this.bPvP)
               {
                  _loc2_.destroyWalkFrame();
                  _loc2_.resetSyncVars();
               }
               if(_loc6_ != null)
               {
                  _loc2_.x = int(_loc6_.x + int(Math.random() * 10) - 5);
                  _loc2_.y = int(_loc6_.y + int(Math.random() * 10) - 5);
               }
               else
               {
                  _loc2_.x = int(960 / 2);
                  _loc2_.y = int(550 / 2);
               }
            }
            _loc2_.scale(this.SCALE);
            if(_loc5_)
            {
               _loc2_.mcChar.gotoAndStop("Idle");
            }
            else
            {
               _loc2_.mcChar.gotoAndStop("Dead");
            }
            if(this.showHPBar)
            {
               _loc2_.showHPBar();
            }
            else
            {
               _loc2_.hideHPBar();
            }
            if(param1 == this.rootClass.sfc.myUserId)
            {
               this.bitWalk = true;
               if(this.myAvatar != null && this.myAvatar.petMC != null)
               {
                  this.myAvatar.petPos();
               }
            }
            if(this.CELL_MODE == "normal" || param1 == this.rootClass.sfc.myUserId)
            {
               _loc2_.pAV.showMC();
            }
            else
            {
               _loc2_.pAV.hideMC();
            }
            if(this.bPvP && _loc3_.pvpTeam != null && _loc3_.pvpTeam > -1)
            {
               _loc2_.mcChar.pvpFlag.visible = true;
               _loc2_.mcChar.pvpFlag.gotoAndStop(new Array("a","b","c")[_loc3_.pvpTeam]);
            }
            else
            {
               _loc2_.mcChar.pvpFlag.visible = false;
            }
            if(!_loc2_.isLoaded)
            {
               if(_loc2_.currentLabel != "hold" && _loc2_.currentLabel != "in1")
               {
                  _loc2_.gotoAndPlay("hold");
               }
            }
            else if(_loc2_.currentLabel != "in2")
            {
               _loc2_.gotoAndPlay("in2");
            }
            if(_loc2_.isLoaded)
            {
               _loc2_.pAV.isMyAvatar = param1 == this.rootClass.sfc.myUserId;
               _loc2_.handleAfterAvatarLoad();
            }
         }
      }
      
      public function repairAvatars() : void
      {
         var _loc1_:Avatar = null;
         var _loc2_:Boolean = false;
         this.rootClass.chatF.pushMsg("server","Attempting to repair incomplete Avatars...","SERVER","",0);
         _loc2_ = false;
         for each(var _loc5_ in this.avatars)
         {
            _loc1_ = _loc5_;
            _loc5_;
            if(!_loc1_.pMC.isLoaded)
            {
               _loc2_ = true;
               if(_loc1_.objData != null)
               {
                  this.rootClass.chatF.pushMsg("server"," > repairing " + _loc1_.objData.strUsername,"SERVER","",0);
                  _loc1_.initAvatar(_loc1_.objData);
               }
               else if(_loc1_.pnm != null)
               {
                  this.rootClass.chatF.pushMsg("warning"," *> Data load incomplete for " + _loc1_.pnm + ", repair cannot continue.","SERVER","",0);
               }
               else
               {
                  this.rootClass.chatF.pushMsg("warning"," *> Avatar instantiated but no data exists at all!","SERVER","",0);
               }
            }
         }
         if(!_loc2_)
         {
            this.rootClass.chatF.pushMsg("server"," > No incomplete Avatars found!","SERVER","",0);
         }
      }
      
      private function solveTxTy(param1:Point, param2:MovieClip) : Point
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         _loc3_ = 20;
         _loc4_ = 960 / _loc3_;
         _loc5_ = 550 / _loc3_;
         _loc8_ = [];
         _loc9_ = 0;
         while(_loc9_ <= _loc4_)
         {
            _loc10_ = 0;
            while(_loc10_ <= _loc5_)
            {
               _loc6_ = new Point(_loc9_ * _loc3_,_loc10_ * _loc3_);
               if(this.testTxTy(_loc6_,param2))
               {
                  _loc8_.push({
                     "x":_loc6_.x,
                     "y":_loc6_.y,
                     "d":Math.abs(Point.distance(param1,_loc6_))
                  });
               }
               _loc10_++;
            }
            _loc9_++;
         }
         if(_loc8_.length)
         {
            _loc8_.sortOn(["d"],[Array.NUMERIC]);
            _loc7_ = new Point(_loc8_[0].x + int(Math.random() * 10) - 5,_loc8_[0].y + int(Math.random() * 10) - 5);
            _loc11_ = 0;
            while(!this.testTxTy(_loc7_,param2) && _loc11_ < 100)
            {
               _loc7_ = new Point(_loc8_[0].x + int(Math.random() * 10) - 5,_loc8_[0].y + int(Math.random() * 10) - 5);
               _loc11_++;
            }
            return _loc7_;
         }
         return null;
      }
      
      private function testTxTy(param1:Point, param2:MovieClip) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:MovieClip = null;
         var _loc9_:Boolean = false;
         var _loc10_:int = 0;
         _loc3_ = int(param2.shadow.width);
         _loc4_ = int(param2.shadow.height);
         _loc5_ = param1.x - _loc3_ / 2;
         _loc6_ = param1.y - _loc4_ / 2;
         _loc7_ = new Rectangle(_loc5_,_loc6_,_loc3_,_loc4_);
         _loc8_ = null;
         _loc9_ = false;
         _loc10_ = 0;
         while(_loc10_ < this.arrSolid.length)
         {
            if(!(this.arrSolid[_loc10_] == null || this.arrSolid[_loc10_].shadow == null || this.arrSolid[_loc10_].stage == null))
            {
               _loc8_ = MovieClip(this.arrSolid[_loc10_].shadow);
               this._collisionRect.x = _loc8_.x;
               this._collisionRect.y = _loc8_.y;
               this._collisionRect.width = _loc8_.width;
               this._collisionRect.height = _loc8_.height;
               if(this._collisionRect.intersects(_loc7_))
               {
                  return false;
               }
               _loc9_ = true;
            }
            _loc10_++;
         }
         return _loc9_;
      }
      
      public function updatePortrait(param1:Avatar) : *
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         _loc4_ = 0;
         _loc5_ = 0;
         if(param1 != this.myAvatar)
         {
            _loc2_ = [this.rootClass.ui.mcPortraitTarget];
         }
         else if(param1 == this.myAvatar.target)
         {
            _loc2_ = [this.rootClass.ui.mcPortraitTarget,this.rootClass.ui.mcPortrait];
         }
         else
         {
            _loc2_ = [this.rootClass.ui.mcPortrait];
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc7_ = {};
            _loc3_ = _loc2_[_loc4_];
            _loc3_.strName.mouseEnabled = false;
            _loc3_.strClass.mouseEnabled = false;
            if(param1.npcType == "monster")
            {
               _loc7_ = this.monTree[param1.objData.MonMapID];
               _loc3_.strName.text = param1.objData.strMonName.toUpperCase();
               _loc3_.strClass.text = param1.objData.sRace != "None" ? param1.objData.sRace : "Monster";
               if("stars" in _loc3_)
               {
                  _loc6_ = Math.round(Math.pow(param1.objData.intLevel * 1.3,0.5) / 2);
                  _loc5_ = 1;
                  while(_loc5_ < 6)
                  {
                     if(_loc5_ <= _loc6_)
                     {
                        _loc3_.stars.getChildByName("s" + _loc5_).visible = true;
                     }
                     else
                     {
                        _loc3_.stars.getChildByName("s" + _loc5_).visible = false;
                     }
                     _loc5_++;
                  }
               }
            }
            if(param1.npcType == "player")
            {
               _loc7_ = this.uoTree[param1.pnm];
               _loc3_.strName.text = param1.objData.strUsername.toUpperCase();
               _loc3_.strClass.text = param1.objData.strClassName + ", Rank " + param1.objData.iRank;
               if("stars" in _loc3_)
               {
                  _loc5_ = 1;
                  while(_loc5_ < 6)
                  {
                     _loc3_.stars.getChildByName("s" + _loc5_).visible = false;
                     _loc5_++;
                  }
               }
            }
            if(param1.npcType == "monster" || param1.npcType == "player")
            {
               _loc3_.strLevel.text = param1.objData.intLevel;
               _loc8_ = 0;
               _loc9_ = 0;
               _loc10_ = null;
               _loc8_ = _loc7_.intHP;
               _loc9_ = _loc7_.intHPMax;
               _loc10_ = _loc3_.HP;
               if(_loc7_.intHP >= 0)
               {
                  _loc10_.strIntHP.text = String(_loc7_.intHP);
               }
               else
               {
                  _loc10_.strIntHP.text = "X";
               }
               if(_loc7_.intSG > 0)
               {
                  _loc10_.strIntHP.text = String(_loc7_.intHP) + " +" + String(_loc7_.intSG);
               }
               if(_loc8_ < 0)
               {
                  _loc8_ = 0;
               }
               if(_loc8_ > _loc9_)
               {
                  _loc8_ = _loc9_;
               }
               _loc10_.intHPbar.x = Math.min(-(_loc10_.intHPbar.width * (1 - _loc8_ / _loc9_)),0);
               _loc8_ = _loc7_.intMP;
               _loc9_ = _loc7_.intMPMax;
               _loc10_ = _loc3_.MP;
               if(_loc7_.intMP >= 0)
               {
                  _loc10_.strIntMP.text = String(_loc7_.intMP);
               }
               else
               {
                  _loc10_.strIntMP.text = "X";
               }
               if(_loc8_ < 0)
               {
                  _loc8_ = 0;
               }
               if(_loc8_ > _loc9_)
               {
                  _loc8_ = _loc9_;
               }
               _loc10_.intMPbar.x = Math.min(-(_loc10_.intMPbar.width * (1 - _loc8_ / _loc9_)),0);
               if(param1.isMyAvatar && Boolean(_loc3_.SP))
               {
                  _loc8_ = _loc7_.intSP;
                  _loc9_ = 100;
                  _loc10_ = _loc3_.SP;
                  if(_loc7_.intSP >= 0)
                  {
                     _loc10_.strIntSP.text = String(_loc7_.intSP);
                  }
                  else
                  {
                     _loc10_.strIntSP.text = "100";
                  }
                  if(_loc8_ < 0)
                  {
                     _loc8_ = 0;
                  }
                  if(_loc8_ > _loc9_)
                  {
                     _loc8_ = _loc9_;
                  }
                  _loc10_.intSPbar.x = Math.min(-(_loc10_.intSPbar.width * (1 - _loc8_ / _loc9_)),0);
               }
            }
            _loc4_++;
         }
      }
      
      public function getAvatarByUserID(param1:int) : Avatar
      {
         var _loc2_:String = null;
         _loc2_ = String(param1);
         if(_loc2_ in this.avatars)
         {
            return this.avatars[_loc2_];
         }
         return null;
      }
      
      public function getAvatarByUserName(param1:String) : Avatar
      {
         var _loc2_:String = null;
         for(var _loc5_ in this.avatars)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(this.avatars[_loc2_] != null && this.avatars[_loc2_].pnm != null && this.avatars[_loc2_].pnm.toLowerCase() == param1.toLowerCase())
            {
               return this.avatars[_loc2_];
            }
         }
         return null;
      }
      
      public function getMCByUserName(param1:*) : AvatarMC
      {
         var _loc2_:String = null;
         for(var _loc5_ in this.avatars)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(this.avatars[_loc2_] != null && this.avatars[_loc2_].pnm != null && this.avatars[_loc2_].pnm.toLowerCase() == param1.toLowerCase())
            {
               if(this.avatars[_loc2_].pMC != null)
               {
                  return this.avatars[_loc2_].pMC;
               }
            }
         }
         return null;
      }
      
      public function getMCByUserID(param1:*) : AvatarMC
      {
         if(this.avatars[param1] != undefined && this.avatars[param1].pMC != null)
         {
            return this.avatars[param1].pMC;
         }
         return null;
      }
      
      public function getUserByName(param1:*) : *
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         _loc2_ = this.rootClass.sfc.getAllRooms();
         for(var _loc9_ in _loc2_)
         {
            _loc3_ = _loc9_;
            _loc9_;
            _loc4_ = _loc2_[_loc3_];
            for(var _loc11_ in _loc4_.getUserList())
            {
               _loc5_ = _loc11_;
               _loc11_;
               _loc6_ = _loc4_.getUserList()[_loc5_];
               if(String(_loc6_.getName()) == param1)
               {
                  return _loc6_;
               }
            }
         }
         return null;
      }
      
      public function getUserById(param1:Number) : *
      {
         return this.rootClass.sfc.getRoom(this.curRoom).getUser(Number(param1));
      }
      
      public function getUoLeafById(param1:*) : Object
      {
         var _loc2_:Object = null;
         for each(var _loc5_ in this.uoTree)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_.entID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getUoLeafByName(param1:String) : Object
      {
         var _loc2_:Object = null;
         param1 = param1.toLowerCase();
         for each(var _loc5_ in this.uoTree)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_.uoName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getUserDataById(param1:*) : *
      {
         trace("[Avatar] getUserDataById: uid " + param1);
         this.rootClass.sfc.sendXtMessage("zm","retrieveUserData",[param1],"str",this.curRoom);
      }
      
      public function getUserDataByIds(param1:Array) : *
      {
         trace("[Avatar] getUserDataByIds: " + param1.length + " uids");
         this.rootClass.sfc.sendXtMessage("zm","retrieveUserDatas",param1,"str",this.curRoom);
      }
      
      public function getUsersByCell(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         _loc2_ = [];
         for(var _loc6_ in this.avatars)
         {
            _loc3_ = _loc6_;
            _loc6_;
            if(this.avatars[_loc3_].dataLeaf.strFrame == param1)
            {
               _loc2_.push(this.avatars[_loc3_]);
            }
         }
         return _loc2_;
      }
      
      public function getAllAvatarsInCell() : Array
      {
         var _loc1_:Array = null;
         _loc1_ = [];
         _loc1_ = this.getMonstersByCell(this.myAvatar.dataLeaf.strFrame);
         return _loc1_.concat(this.getUsersByCell(this.myAvatar.dataLeaf.strFrame));
      }
      
      private function lookAtValue(param1:String, param2:int) : Number
      {
         return parseInt(param1.charAt(param2),36);
      }
      
      private function updateValue(param1:*, param2:int, param3:Number) : String
      {
         var _loc4_:String = null;
         if(param3 >= 0 && param3 < 10)
         {
            _loc4_ = String(param3);
         }
         else if(param3 >= 10 && param3 < 36)
         {
            _loc4_ = String.fromCharCode(param3 + 55);
         }
         else
         {
            _loc4_ = "0";
         }
         return this.rootClass.strSetCharAt(param1,param2,_loc4_);
      }
      
      public function getQuestValue(param1:Number) : Number
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(this.myAvatar != null && this.myAvatar.objData != null)
         {
            _loc2_ = param1 / 100;
            _loc3_ = _loc2_ > 0 ? "strQuests" + (_loc2_ + 1) : "strQuests";
            if(this.myAvatar.objData[_loc3_] == null)
            {
               return -1;
            }
            return this.lookAtValue(this.myAvatar.objData[_loc3_],param1 - _loc2_ * 100);
         }
         return -1;
      }
      
      public function setQuestValue(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = param1 / 100;
         _loc4_ = _loc3_ > 0 ? "strQuests" + (_loc3_ + 1) : "strQuests";
         if(_loc4_ in this.myAvatar.objData)
         {
            this.myAvatar.objData[_loc4_] = this.updateValue(this.myAvatar.objData[_loc4_],param1 - _loc3_ * 100,param2);
         }
      }
      
      public function sendUpdateQuestRequest(param1:Number, param2:Number) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","updateQuest",[param1,param2],"str",this.curRoom);
      }
      
      public function setHomeTownCurrent() : void
      {
         this.rootClass.sfc.sendXtMessage("zm","setHomeTown",[],"str",this.curRoom);
         this.myAvatar.objData.strHomeTown = this.myAvatar.objData.strMapName;
      }
      
      public function setHomeTown(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","setHomeTown",[param1],"str",this.curRoom);
         this.myAvatar.objData.strHomeTown = param1;
      }
      
      private function isHouseOrRegularFull() : Boolean
      {
         return this.rootClass.ui.mcPopup.currentLabel == "Bank" && this.myAvatar.items.length >= this.myAvatar.objData.iBagSlots || this.rootClass.ui.mcPopup.currentLabel == "HouseBank" && this.myAvatar.houseitems.length >= this.myAvatar.objData.iHouseSlots;
      }
      
      public function sendBankFromInvRequest(param1:Object) : *
      {
         var _loc2_:ModalMC = null;
         var _loc3_:Object = null;
         if(param1.bEquip)
         {
            _loc2_ = new ModalMC();
            _loc3_ = {};
            _loc3_.strBody = "You must unequip the item before storing it in the bank!";
            _loc3_.params = {};
            _loc3_.glow = "red,medium";
            _loc3_.btns = "mono";
            this.rootClass.ui.ModalStack.addChild(_loc2_);
            _loc2_.init(_loc3_);
         }
         else if(param1.bCoins == 0 && this.myAvatar.iBankCount >= this.myAvatar.objData.iBankSlots)
         {
            _loc2_ = new ModalMC();
            _loc3_ = {};
            _loc3_.strBody = "You have exceeded your maximum bank storage for non-AC items!";
            _loc3_.params = {};
            _loc3_.glow = "red,medium";
            _loc3_.btns = "mono";
            this.rootClass.ui.ModalStack.addChild(_loc2_);
            _loc2_.init(_loc3_);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","bankFromInv",[param1.ItemID,param1.CharItemID],"str",this.curRoom);
         }
      }
      
      public function sendBankToInvRequest(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.isHouseOrRegularFull())
         {
            _loc2_ = new ModalMC();
            _loc3_ = {};
            _loc3_.strBody = "You have exceeded your maximum inventory storage!";
            _loc3_.params = {};
            _loc3_.glow = "red,medium";
            _loc3_.btns = "mono";
            this.rootClass.ui.ModalStack.addChild(_loc2_);
            _loc2_.init(_loc3_);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","bankToInv",[param1.ItemID,param1.CharItemID],"str",this.curRoom);
         }
      }
      
      public function sendBankSwapInvRequest(param1:Object, param2:Object) : *
      {
         var _loc3_:ModalMC = null;
         var _loc4_:Object = null;
         if(param2.bEquip)
         {
            _loc3_ = new ModalMC();
            _loc4_ = {};
            _loc4_.strBody = "You must unequip the item before storing it in the bank!";
            _loc4_.params = {};
            _loc4_.glow = "red,medium";
            _loc4_.btns = "mono";
            this.rootClass.ui.ModalStack.addChild(_loc3_);
            _loc3_.init(_loc4_);
         }
         else if(param2.bCoins == 0 && param1.bCoins == 1 && this.myAvatar.iBankCount >= this.myAvatar.objData.iBankSlots)
         {
            _loc3_ = new ModalMC();
            _loc4_ = {};
            _loc4_.strBody = "You have exceeded your maximum bank storage for non-AC items!";
            _loc4_.params = {};
            _loc4_.glow = "red,medium";
            _loc4_.btns = "mono";
            this.rootClass.ui.ModalStack.addChild(_loc3_);
            _loc3_.init(_loc4_);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","bankSwapInv",[param2.ItemID,param2.CharItemID,param1.ItemID,param1.CharItemID],"str",this.curRoom);
         }
      }
      
      public function getInventory(param1:*) : *
      {
         this.rootClass.sfc.sendXtMessage("zm","retrieveInventory",[param1],"str",this.curRoom);
      }
      
      public function sendChangeColorRequest(param1:int, param2:int, param3:int, param4:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","changeColor",[param1,param2,param3,param4,this.hairshopinfo.HairShopID],"str",this.curRoom);
      }
      
      public function sendChangeArmorColorRequest(param1:int, param2:int, param3:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","changeArmorColor",[param1,param2,param3],"str",this.curRoom);
      }
      
      public function sendLoadBankRequest(param1:Array = null) : void
      {
         if(param1[0] == "*")
         {
            param1 = ["All"];
         }
         this.bankinfo.addRequestedTypes(param1);
         this.rootClass.sfc.sendXtMessage("zm","loadBank",param1,"str",this.curRoom);
      }
      
      public function sendReloadShopRequest(param1:int) : void
      {
         if(this.shopinfo != null && this.shopinfo.ShopID == param1 && this.shopinfo.bLimited != null)
         {
            this.rootClass.sfc.sendXtMessage("zm","reloadShop",[param1],"str",this.curRoom);
         }
      }
      
      public function sendLoadShopRequest(param1:int) : void
      {
         if(this.shopinfo == null || (this.shopinfo.ShopID != param1 || this.shopinfo.bLimited))
         {
            if(this.coolDown("loadShop"))
            {
               this.rootClass.menuClose();
               this.rootClass.sfc.sendXtMessage("zm","loadShop",[param1],"str",this.curRoom);
            }
         }
         else
         {
            this.rootClass.menuClose();
            if(this.shopinfo.bHouse == 1)
            {
               this.rootClass.ui.mcPopup.fOpen("HouseShop");
            }
            else if(this.rootClass.isMergeShop(this.shopinfo))
            {
               this.rootClass.ui.mcPopup.fOpen("MergeShop");
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("Shop");
            }
         }
      }
      
      public function sendLoadHairShopRequest(param1:int) : void
      {
         if(this.hairshopinfo == null || this.hairshopinfo.HairShopID != param1)
         {
            this.rootClass.sfc.sendXtMessage("zm","loadHairShop",[param1],"str",this.curRoom);
         }
         else
         {
            this.rootClass.openCharacterCustomize();
         }
      }
      
      public function sendLoadEnhShopRequest(param1:int) : void
      {
         var _loc2_:ModalMC = null;
         var _loc3_:Object = null;
         _loc2_ = new ModalMC();
         _loc3_ = {};
         _loc3_.strBody = "Old enhancement shops are disabled on the PTR.  Please visit Battleon for the new shops.";
         _loc3_.params = {};
         _loc3_.btns = "mono";
         this.rootClass.ui.ModalStack.addChild(_loc2_);
         _loc2_.init(_loc3_);
      }
      
      public function sendEnhItemRequest(param1:Object) : void
      {
         this.enhItem = param1;
         this.rootClass.sfc.sendXtMessage("zm","enhanceItem",[param1.ItemID,param1.EnhID,this.enhShopID],"str",this.curRoom);
      }
      
      public function sendEnhItemRequestShop(param1:Array, param2:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.coolDown("buyItem"))
         {
            this.enhItem = param1;
            if(this.myAvatar.objData.intGold < param2.iCost * param1.length)
            {
               this.rootClass.MsgBox.notify("Insufficient Funds!");
               return;
            }
            _loc3_ = new ModalMC();
            _loc4_ = {};
            _loc4_.params = {
               "item":param1,
               "enh":param2
            };
            _loc4_.strBody = "Are you sure you want to enhance " + param1.length + " item(s) for " + this.rootClass.strNumWithCommas(param2.iCost * param1.length) + " gold?";
            _loc4_.callback = this.confirmSendEnhItemRequestShop;
            _loc4_.glow = "white,medium";
            _loc4_.greedy = true;
            this.rootClass.ui.ModalStack.addChild(_loc3_);
            _loc3_.init(_loc4_);
         }
      }
      
      public function confirmSendEnhItemRequestShop(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","enhanceItemShop",[param1.item,param1.enh.ItemID,this.shopinfo.ShopID],"str",this.curRoom);
         }
      }
      
      public function sendEnhItemRequestLocal(param1:Array, param2:Object) : void
      {
         if(this.coolDown("buyItem"))
         {
            this.enhItem = param1;
            this.rootClass.sfc.sendXtMessage("zm","enhanceItemLocal",[param1[0],param2.ItemID],"str",this.curRoom);
         }
      }
      
      public function sendBuyItemRequest(param1:Object) : void
      {
         if(this.coolDown("buyItem"))
         {
            if(param1.bStaff == 1 && this.myAvatar.objData.intAccessLevel < 40)
            {
               this.rootClass.MsgBox.notify("Test Item: Cannot be purchased yet!");
            }
            else if(this.shopinfo.sField != "" && this.getAchievement(this.shopinfo.sField,this.shopinfo.iIndex) != 1)
            {
               this.rootClass.MsgBox.notify("Item Locked: Special requirement not met.");
            }
            else if(param1.bUpg == 1 && !this.myAvatar.isUpgraded())
            {
               this.rootClass.showUpgradeWindow();
            }
            else if(param1.FactionID > 1 && this.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
            {
               this.rootClass.MsgBox.notify("Item Locked: Reputation Requirement not met.");
            }
            else if(!this.rootClass.validateArmor(param1))
            {
               this.rootClass.MsgBox.notify("Item Locked: Class Requirement not met.");
            }
            else if(param1.iQSindex >= 0 && this.getQuestValue(param1.iQSindex) < int(param1.iQSvalue))
            {
               this.rootClass.MsgBox.notify("Item Locked: Quest Requirement not met.");
            }
            else if((this.myAvatar.isItemInInventory(param1.ItemID) || this.myAvatar.isItemInBank(param1.ItemID)) && this.myAvatar.isItemStackMaxed(param1.ItemID))
            {
               this.rootClass.MsgBox.notify("You cannot have more than " + param1.iStk + " of that item!");
            }
            else if(param1.bCoins == 0 && param1.iCost > this.myAvatar.objData.intGold)
            {
               this.rootClass.MsgBox.notify("Insufficient Funds!");
            }
            else if(param1.bCoins == 1 && param1.iCost > this.myAvatar.objData.intCoins)
            {
               this.rootClass.MsgBox.notify("Insufficient Funds!");
            }
            else if(!this.rootClass.isHouseItem(param1) && this.myAvatar.items.length >= this.myAvatar.objData.iBagSlots || this.rootClass.isHouseItem(param1) && this.myAvatar.houseitems.length >= this.myAvatar.objData.iHouseSlots)
            {
               this.rootClass.MsgBox.notify("Inventory Full!");
            }
            else
            {
               if(this.shopBuyItem == null || this.shopBuyItem.ShopItemID != param1.ShopItemID)
               {
                  this.shopBuyItem = param1;
               }
               this.rootClass.sfc.sendXtMessage("zm","buyItem",[this.shopBuyItem.ItemID,this.shopinfo.ShopID,this.shopBuyItem.ShopItemID],"str",this.curRoom);
            }
         }
      }
      
      public function sendBuyItemRequestWithQuantity(param1:Object) : *
      {
         if(param1.accept)
         {
            this.shopBuyItem = param1.iSel;
            this.rootClass.sfc.sendXtMessage("zm","buyItem",[param1.iSel.ItemID,this.shopinfo.ShopID,param1.iSel.ShopItemID,param1.iQty],"str",this.curRoom);
         }
      }
      
      public function maximumShopBuys(param1:Object) : int
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(param1 == null)
         {
            return 0;
         }
         _loc2_ = this.myAvatar.getItemByID(param1.ItemID);
         if(param1.sES == "ar")
         {
            return 1;
         }
         _loc3_ = _loc2_ != null ? param1.iStk - _loc2_.iQty : Number(param1.iStk);
         if(_loc3_ < 1)
         {
            return 0;
         }
         if(param1.iCost > 0)
         {
            _loc4_ = param1.bCoins == 1 ? Math.floor(this.myAvatar.objData.intCoins / param1.iCost) : Math.floor(this.myAvatar.objData.intGold / param1.iCost);
            _loc3_ = Math.min(_loc4_,_loc3_);
         }
         if(param1.turnin != null)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.turnin.length)
            {
               _loc6_ = param1.turnin[_loc5_];
               _loc7_ = this.myAvatar.getItemByID(_loc6_.ItemID);
               if(_loc7_ == null)
               {
                  return 0;
               }
               _loc8_ = Math.floor(_loc7_.iQty / _loc6_.iQty);
               if(_loc8_ == 0)
               {
                  return 0;
               }
               _loc3_ = Math.min(_loc3_,_loc8_);
               _loc5_++;
            }
            _loc3_ = _loc3_ * param1.iQty;
         }
         _loc3_ = Math.min(_loc3_,100000);
         return Math.min(_loc3_,_loc2_ != null ? param1.iStk - _loc2_.iQty : Number(param1.iStk));
      }
      
      public function sendSellItemRequest(param1:Object) : void
      {
         if(this.coolDown("sellItem"))
         {
            this.rootClass.sfc.sendXtMessage("zm","sellItem",[param1.ItemID,param1.iQty,param1.CharItemID],"str",this.curRoom);
         }
      }
      
      public function sendSellItemRequestWithQuantity(param1:Object) : *
      {
         if(param1.accept)
         {
            if(this.coolDown("sellItem"))
            {
               this.rootClass.sfc.sendXtMessage("zm","sellItem",[param1.iSel.ItemID,param1.iQty,param1.iSel.CharItemID],"str",this.curRoom);
            }
         }
      }
      
      public function maximumShopSells(param1:Object) : int
      {
         var _loc2_:* = undefined;
         if(param1.sES == "ar")
         {
            return 1;
         }
         _loc2_ = this.myAvatar.getItemByID(param1.ItemID);
         return _loc2_ == null ? 0 : int(_loc2_.iQty);
      }
      
      public function sendRemoveItemRequest(param1:Object, param2:int = 1) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param2 == 1)
         {
            this.rootClass.sfc.sendXtMessage("zm","removeItem",[param1.ItemID,param1.CharItemID],"str",this.curRoom);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","removeItem",[param1.ItemID,param1.CharItemID,param2],"str",this.curRoom);
         }
      }
      
      public function sendRemoveTempItemRequest(param1:int, param2:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","removeTempItem",[param1,param2],"str",this.curRoom);
         this.myAvatar.removeTempItem(param1,param2);
      }
      
      public function sendEquipItemRequest(param1:Object) : Boolean
      {
         var _loc2_:Boolean = false;
         _loc2_ = true;
         if(param1 != null && !this.myAvatar.isItemEquipped(param1.ItemID))
         {
            if(this.coolDown("equipItem"))
            {
               this.rootClass.sfc.sendXtMessage("zm","equipItem",[param1.ItemID],"str",this.curRoom);
            }
            else
            {
               _loc2_ = false;
            }
         }
         else
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
      
      public function sendForceEquipRequest(param1:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","forceEquipItem",[param1],"str",this.curRoom);
      }
      
      public function sendUnequipItemRequest(param1:Object) : void
      {
         if(param1 != null && this.myAvatar.isItemEquipped(param1.ItemID))
         {
            if(this.coolDown("unequipItem"))
            {
               this.rootClass.sfc.sendXtMessage("zm","unequipItem",[param1.ItemID],"str",this.curRoom);
            }
         }
      }
      
      public function sendChangeClassRequest(param1:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","changeClass",[param1],"str",this.curRoom);
      }
      
      public function selfMute(param1:int = 1) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","cmd",["mute",param1,this.myAvatar.objData.strUsername.toLowerCase()],"str",this.rootClass.world.curRoom);
      }
      
      public function equipUseableItem(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this.actions.active.length)
         {
            if(Boolean(this.actions.active[_loc3_]) && this.actions.active[_loc3_].ref == "i1")
            {
               _loc2_ = this.actions.active[_loc3_];
            }
            _loc3_++;
         }
         _loc2_.sArg1 = String(param1.ItemID);
         _loc2_.sArg2 = String(param1.sDesc);
         this.rootClass.updateIcons(this.getActIcons(_loc2_),[param1.sFile],param1);
         this.rootClass.updateActionObjIcon(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < this.myAvatar.items.length)
         {
            _loc4_ = this.myAvatar.items[_loc3_];
            if(_loc4_.sType.toLowerCase() == "item" && _loc4_.sLink.toLowerCase() != "none")
            {
               if(_loc4_.ItemID == param1.ItemID)
               {
                  _loc4_.bEquip = 1;
                  this.lockdownPots = true;
                  this.lockdownPotsTS = new Date().getTime();
                  this.rootClass.sfc.sendXtMessage("zm","geia",[_loc4_.sLink,_loc4_.sMeta,param1.ItemID],"str",this.rootClass.world.curRoom);
               }
               else
               {
                  _loc4_.bEquip = 0;
               }
            }
            _loc3_++;
         }
         if(this.rootClass.ui.mcPopup.mcInventory != null)
         {
            this.rootClass.ui.mcPopup.mcInventory.mcItemList.refreshList();
            this.rootClass.ui.mcPopup.mcInventory.refreshDetail();
         }
      }
      
      public function unequipUseableItem(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         _loc4_ = 0;
         _loc4_ = 0;
         while(_loc4_ < this.actions.active.length)
         {
            if(Boolean(this.actions.active[_loc4_]) && this.actions.active[_loc4_].ref == "i1")
            {
               _loc2_ = this.actions.active[_loc4_];
            }
            _loc4_++;
         }
         _loc2_.sArg1 = "";
         _loc2_.sArg2 = "";
         this.rootClass.updateIcons(this.getActIcons(_loc2_),["icu1"],null);
         if(param1 == null)
         {
            _loc4_ = 0;
            while(_loc4_ < this.myAvatar.items.length)
            {
               _loc3_ = this.myAvatar.items[_loc4_];
               if(String(_loc3_.ItemID) == _loc2_.sArg1)
               {
                  param1 = _loc3_;
               }
               _loc4_++;
            }
         }
         param1.bEquip = 0;
         if(this.rootClass.ui.mcPopup.mcInventory != null)
         {
            this.rootClass.ui.mcPopup.mcInventory.mcItemList.refreshList();
            this.rootClass.ui.mcPopup.mcInventory.refreshDetail();
         }
      }
      
      public function tryUseItem(param1:Object) : void
      {
         if(param1.sType.toLowerCase() == "clientuse")
         {
            var _loc2_:* = param1.sLink;
            switch(0)
            {
            }
         }
         else if(param1.sType.toLowerCase() == "serveruse")
         {
            this.sendUseItemRequest(param1);
         }
      }
      
      public function sendUseItemRequest(param1:Object) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","serverUseItem",["+",param1.ItemID],"str",-1);
      }
      
      public function sendUseItemArrayRequest(param1:Array) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","serverUseItem",param1,"str",-1);
      }
      
      public function bankHasRequested(param1:Array) : Boolean
      {
         return this.bankinfo.hasRequested(param1);
      }
      
      public function addItemsToBank(param1:Array) : void
      {
         this.bankinfo.addItemsToBank(param1);
      }
      
      public function toggleBank() : void
      {
         if(this.myAvatar.bank == null)
         {
            this.rootClass.getBank();
         }
         if(!this.uiLock)
         {
            if(this.rootClass.ui.mcPopup.currentLabel == "Bank")
            {
               MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcBank")).fClose();
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("Bank");
            }
         }
      }
      
      public function toggleHouseBank() : void
      {
         if(this.myAvatar.bank == null)
         {
            this.rootClass.getBank();
         }
         if(!this.uiLock)
         {
            if(this.rootClass.ui.mcPopup.currentLabel == "HouseBank")
            {
               MovieClip(this.rootClass.ui.mcPopup.getChildByName("mcBank")).fClose();
            }
            else
            {
               this.rootClass.ui.mcPopup.fOpen("HouseBank");
            }
         }
      }
      
      public function sendReport(param1:Array) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","cmd",param1,"str",this.rootClass.world.curRoom);
      }
      
      public function sendWhoRequest() : void
      {
         if(this.coolDown("who"))
         {
            this.rootClass.sfc.sendXtMessage("zm","cmd",["who"],"str",this.curRoom);
         }
      }
      
      public function sendRewardReferralRequest(param1:*) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","rewardReferral",[],"str",this.curRoom);
      }
      
      public function sendGetAdDataRequest() : void
      {
         if(this.rootClass.world.myAvatar.objData.iDailyAds < this.rootClass.world.myAvatar.objData.iDailyAdCap)
         {
            this.rootClass.sfc.sendXtMessage("zm","getAdData",[],"str",this.curRoom);
         }
      }
      
      public function sendGetAdRewardRequest() : void
      {
         if(this.rootClass.world.myAvatar.objData.iDailyAds < this.rootClass.world.myAvatar.objData.iDailyAdCap)
         {
            this.rootClass.sfc.sendXtMessage("zm","getAdReward",[],"str",this.curRoom);
         }
      }
      
      public function sendWarVarsRequest() : void
      {
         this.rootClass.sfc.sendXtMessage("zm","loadWarVars",[],"str",this.curRoom);
      }
      
      public function loadQuestStringData() : void
      {
         this.rootClass.sfc.sendXtMessage("zm","loadQuestStringData",[],"str",this.curRoom);
      }
      
      public function buyBagSlots(param1:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","buyBagSlots",[param1],"str",this.curRoom);
      }
      
      public function buyBankSlots(param1:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","buyBankSlots",[param1],"str",this.curRoom);
      }
      
      public function buyHouseSlots(param1:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","buyHouseSlots",[param1],"str",this.curRoom);
      }
      
      public function sendLoadFriendsListRequest() : *
      {
         this.rootClass.sfc.sendXtMessage("zm","loadFriendsList",[],"str",this.curRoom);
      }
      
      public function sendLoadFactionRequest() : *
      {
         this.rootClass.sfc.sendXtMessage("zm","loadFactions",[],"str",this.curRoom);
      }
      
      public function initAchievements() : void
      {
         with(this.myAvatar.objData)
         {
            ip0 = uint(ip0);
            ia0 = uint(ia0);
            ia1 = uint(ia1);
            id0 = uint(id0);
            id1 = uint(id1);
            id2 = uint(id2);
            im0 = uint(im0);
            iq0 = uint(iq0);
         }
      }
      
      public function getAchievement(param1:String, param2:int) : int
      {
         var _loc3_:* = undefined;
         if(param2 < 0 || param2 > 31)
         {
            return -1;
         }
         _loc3_ = this.myAvatar.objData[param1];
         if(_loc3_ == null)
         {
            return -1;
         }
         return (_loc3_ & Math.pow(2,param2)) == 0 ? 0 : 1;
      }
      
      public function setAchievement(param1:String, param2:int, param3:int = 1) : void
      {
         var _loc4_:* = undefined;
         _loc4_ = ["ia0","iq0"];
         if(_loc4_.indexOf(param1) >= 0 && param2 >= 0 && param2 < 32 && this.getAchievement(param1,param2) != param3)
         {
            this.rootClass.sfc.sendXtMessage("zm","setAchievement",[param1,param2,param3],"str",this.curRoom);
         }
      }
      
      public function updateAchievement(param1:String, param2:int, param3:int) : void
      {
         if(param3 == 0)
         {
            this.myAvatar.objData[param1] = this.myAvatar.objData[param1] & ~Math.pow(2,param2);
         }
         else if(param3 == 1)
         {
            this.myAvatar.objData[param1] = this.myAvatar.objData[param1] | Math.pow(2,param2);
         }
         this.rootClass.readIA1Preferences();
      }
      
      public function showFriendsList() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.myAvatar.friends != null && this.myAvatar.friendsLoaded && (new Date().getTime() - this.myAvatar.friendsLoaded) / 1000 < 30)
         {
            _loc1_ = {};
            _loc1_.typ = "userListFriends";
            for each(var _loc5_ in this.myAvatar.friends)
            {
               _loc2_ = _loc5_;
               _loc5_;
               _loc2_.bOffline = _loc2_.sServer == this.rootClass.objServerInfo.sName ? 0 : (_loc2_.sServer == "Offline" ? 2 : 1);
            }
            this.myAvatar.friends.sortOn("sName",Array.CASEINSENSITIVE);
            this.myAvatar.friends.sortOn(["bOffline","sServer","sName"],[Array.NUMERIC,Array.CASEINSENSITIVE,Array.CASEINSENSITIVE]);
            _loc1_.ul = this.myAvatar.friends;
            this.rootClass.ui.mcOFrame.fOpenWith(_loc1_);
         }
         else
         {
            this.myAvatar.friendsLoaded = new Date().getTime();
            this.rootClass.sfc.sendXtMessage("zm","getfriendlist",[],"str",-1);
         }
      }
      
      public function showGuildList() : void
      {
         if(this.myAvatar.objData.guild != null)
         {
            this.rootClass.ui.mcPopup.fOpen("GuildPanelNew");
         }
         else
         {
            this.rootClass.MsgBox.notify("You need to create or join a guild first.");
         }
      }
      
      public function showIgnoreList() : void
      {
         var _loc1_:Object = null;
         if(this.rootClass.chatF.ignoreList.data.users != null && this.rootClass.chatF.ignoreList.data.users.length > 0)
         {
            _loc1_ = {};
            _loc1_.typ = "userListIgnore";
            this.rootClass.ui.mcOFrame.fOpenWith(_loc1_);
         }
         else
         {
            this.rootClass.chatF.pushMsg("warning","Your ignore list is empty.","SERVER","",0);
         }
      }
      
      public function isModerator(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","isModerator",[param1],"str",-1);
      }
      
      public function toggleName(param1:*, param2:String) : *
      {
         if(param2 == "on")
         {
            this.getMCByUserID(param1).pname.visible = true;
         }
         if(param2 == "off")
         {
            this.getMCByUserID(param1).pname.visible = false;
         }
      }
      
      public function toggleHPBar() : void
      {
         var _loc1_:String = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Avatar = null;
         this.showHPBar = !this.showHPBar;
         for(var _loc6_ in this.avatars)
         {
            _loc1_ = _loc6_;
            _loc6_;
            _loc3_ = this.avatars[_loc1_];
            if(_loc3_.pMC != null)
            {
               _loc2_ = _loc3_.pMC;
               if(this.showHPBar)
               {
                  _loc2_.showHPBar();
               }
               else
               {
                  _loc2_.hideHPBar();
               }
            }
         }
      }
      
      public function resPlayer() : *
      {
         this.afkPostpone();
         this.rootClass.sfc.sendXtMessage("zm","resPlayerTimed",[this.rootClass.sfc.myUserId],"str",this.curRoom);
      }
      
      public function showResCounter() : *
      {
         var _loc1_:* = undefined;
         _loc1_ = MovieClip(this.rootClass.ui.mcRes);
         if(_loc1_.currentLabel == "in")
         {
            return;
         }
         _loc1_.gotoAndPlay("in");
         _loc1_.resC = 10;
         if(_loc1_.resTimer == null)
         {
            _loc1_.resTimer = new Timer(1000);
            _loc1_.resTimer.addEventListener("timer",this.resTimer);
         }
         else
         {
            _loc1_.resTimer.reset();
         }
         _loc1_.resTimer.start();
      }
      
      public function resTimer(param1:TimerEvent) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = MovieClip(this.rootClass.ui.mcRes);
         _loc2_.resC--;
         if(_loc2_.resC > 0)
         {
            _loc2_.mcTomb.ti.text = "0" + _loc2_.resC;
         }
         else
         {
            _loc2_.mcTomb.ti.text = "00";
            param1.target.reset();
            _loc2_.visible = false;
            _loc2_.gotoAndStop(1);
            this.resPlayer();
         }
      }
      
      public function danceRequest(param1:*) : *
      {
         var _loc2_:* = undefined;
         if(param1.accept)
         {
            this.rootClass.chatF.submitMsg(param1.emote1,"emote",this.rootClass.sfc.myUserName);
         }
         else
         {
            _loc2_ = {};
            _loc2_.typ = "danceDenied";
            _loc2_.cell = this.strFrame;
            this.rootClass.sfc.sendObjectToGroup(_loc2_,[param1.sender.getId()],this.curRoom);
         }
      }
      
      public function rest() : void
      {
         if(this.myAvatar.dataLeaf.intState != 1)
         {
            return;
         }
         if(!this.restTimer.running)
         {
            this.rootClass.sfc.sendXtMessage("zm","restRequest",[""],"str",1);
            this.myAvatar.pMC.mcChar.gotoAndPlay("Rest");
            this.rootClass.sfc.sendXtMessage("zm","emotea",["rest"],"str",1);
            this.restStart();
         }
      }
      
      public function restStart() : *
      {
         this.afkPostpone();
         this.restTimer.reset();
         this.restTimer.start();
      }
      
      public function restRequest(param1:TimerEvent) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = this.getUoLeafById(this.myAvatar.uid);
         if((_loc2_.intHP != _loc2_.intHPMax || _loc2_.intMP != _loc2_.intMPMax || _loc2_.intSP != 100) && this.myAvatar.pMC.mcChar.currentLabel == "Rest" && _loc2_.intState == 1)
         {
            if(this.coolDown("rest"))
            {
               this.restTimer.reset();
            }
            else
            {
               this.restStart();
            }
         }
         else
         {
            this.restTimer.reset();
         }
      }
      
      public function afkToggle() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.uoTree[this.rootClass.sfc.myUserName];
         if(_loc1_ != null)
         {
            this.rootClass.sfc.sendXtMessage("zm","afk",[!_loc1_.afk],"str",1);
         }
      }
      
      public function afkTimerHandler(param1:Event) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = this.uoTree[this.rootClass.sfc.myUserName];
         if(_loc2_ != null)
         {
            this.rootClass.sfc.sendXtMessage("zm","afk",[true],"str",1);
         }
      }
      
      public function afkPostpone() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = new Date().getTime();
         _loc2_ = this.uoTree[this.rootClass.sfc.myUserName];
         if(_loc2_ != null && _loc2_.afk && (_loc2_.afkts == null || _loc1_ > _loc2_.afkts + 500))
         {
            this.rootClass.sfc.sendXtMessage("zm","afk",[false],"str",1);
            _loc2_.afkts = _loc1_;
         }
      }
      
      public function hideAllPets(param1:Boolean = true) : void
      {
         var _loc2_:* = undefined;
         for(var _loc5_ in this.avatars)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(!(!param1 && this.avatars[_loc2_] == this.myAvatar))
            {
               if(this.avatars[_loc2_] != null)
               {
                  this.avatars[_loc2_].unloadPet();
               }
            }
         }
      }
      
      public function showAllPets(param1:Boolean = true) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         for(var _loc7_ in this.avatars)
         {
            _loc2_ = _loc7_;
            _loc7_;
            if(!(!param1 && this.avatars[_loc2_] == this.myAvatar))
            {
               _loc3_ = this.getUoLeafById(_loc2_);
               _loc4_ = String(_loc3_.strFrame);
               if(_loc4_ == this.strFrame)
               {
                  this.avatars[_loc2_].loadPet();
               }
            }
         }
      }
      
      public function updateMonsters() : *
      {
         var i:int = 0;
         if(this.monmap != null)
         {
            i = 0;
            while(i < this.monmap.length)
            {
               if(this.monmap[i].strFrame == this.strFrame)
               {
                  try
                  {
                     this.updateMonster(this.monmap[i]);
                  }
                  catch(eUM:Error)
                  {
                     trace("[Combat] ERR updateMonsters: " + eUM.message);
                  }
               }
               i++;
            }
         }
      }
      
      public function updateMonster(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = this.getMonsterDefinition(param1.MonID);
         _loc3_ = this.getMonster(param1.MonMapID);
         if(_loc3_ == null || _loc3_.pMC == null)
         {
            trace("[Combat] ERR updateMonster: monster pad missing MonMapID " + param1.MonMapID);
            return;
         }
         _loc3_.objData.intMPMax = int(_loc3_.objData.intMPMax);
         _loc3_.objData.intHPMax = int(_loc3_.objData.intHPMax);
         _loc4_ = this.monTree[param1.MonMapID];
         if(_loc4_ == null)
         {
            trace("[Combat] ERR updateMonster: no monTree leaf for MonMapID " + param1.MonMapID);
            return;
         }
         if(_loc4_.MonID != _loc3_.objData.MonID || _loc4_.intState == 0)
         {
            _loc3_.pMC.visible = false;
         }
         if(this.myAvatar != null && this.myAvatar.pMC != null && _loc3_.pMC.x < this.myAvatar.pMC.x && _loc4_.intState == 1)
         {
            _loc3_.pMC.turn("right");
         }
         else if(_loc4_.intState == 1)
         {
            _loc3_.pMC.turn("left");
         }
         _loc3_.pMC.updateNamePlate();
      }
      
      public function createMonsterMC(param1:MovieClip, param2:int, param3:Boolean = false, param4:Boolean = false) : MonsterMC
      {
         var mondef:* = undefined;
         var isCharMon:Boolean = false;
         var monMC:MonsterMC = null;
         var rand:int = 0;
         var AssetClass:Class = null;
         var monPad:MovieClip = param1;
         var MonID:int = param2;
         var randomName:Boolean = param3;
         var force:Boolean = param4;
         mondef = this.getMonsterDefinition(MonID);
         if(mondef == null)
         {
            return null;
         }
         isCharMon = Number(this.objExtra["bChar"]) == 1 && this.myAvatar != null && this.myAvatar.objData != null;
         if(!force && !isCharMon && this.getClass(mondef.strLinkage) == null)
         {
            return null;
         }
         if(randomName && this.chaosNames.length > 0 && this.myAvatar != null && this.myAvatar.objData != null)
         {
            rand = Math.round(Math.random() * (this.chaosNames.length - 1));
            if(this.chaosNames[rand] != this.rootClass.world.myAvatar.objData.strUsername)
            {
               monMC = new MonsterMC(this.chaosNames[rand]);
            }
            else
            {
               rand = rand == 0 ? (this.chaosNames.length > 1 ? 1 : 0) : rand - 1;
               monMC = new MonsterMC(this.chaosNames[rand]);
            }
         }
         else if(Number(this.objExtra["bChar"]) == 1 && this.myAvatar != null && this.myAvatar.objData != null)
         {
            monMC = new MonsterMC(this.myAvatar.objData.strUsername);
         }
         else
         {
            monMC = new MonsterMC(mondef.strMonName);
         }
         this.CHARS.addChild(monMC);
         monMC.x = monPad.x;
         monMC.y = monPad.y;
         monMC.ox = monMC.x;
         monMC.oy = monMC.y;
         try
         {
            if(Number(this.objExtra["bChar"]) == 1 && this.myAvatar != null && this.myAvatar.objData != null)
            {
               monMC.removeChildAt(1);
               monMC.addChildAt(new dummyMC() as MovieClip,1);
               this.copyAvatarMC(monMC.getChildAt(1) as MovieClip);
            }
            else
            {
               AssetClass = this.getClass(mondef.strLinkage);
               if(AssetClass != null)
               {
                  monMC.removeChildAt(1);
                  monMC.addChildAt(new AssetClass(),1);
               }
            }
            monMC.mouseEnabled = false;
            monMC.bubble.mouseEnabled = monMC.bubble.mouseChildren = false;
            monMC.init();
            if("strDir" in monPad)
            {
               if(monPad.strDir.toLowerCase() == "static")
               {
                  monMC.isStatic = true;
               }
            }
            if("noMove" in monPad)
            {
               monMC.noMove = monPad.noMove;
            }
            if(this.rootClass.litePreference.data.bFreezeMons)
            {
               monMC.noMove = true;
            }
            if(this.rootClass.litePreference.data.bMonsType)
            {
               monMC.pname.typ.text = "< " + mondef.sRace + " >";
               monMC.pname.typ.visible = mondef.sRace != "None";
            }
            else
            {
               monMC.pname.typ.visible = false;
            }
            if(this.rootClass.litePreference.data.bComicSans)
            {
               this.rootClass.applyComicSansPname(monMC.pname,true);
            }
         }
         catch(eMk:Error)
         {
            trace("[Load] ERR createMonsterMC " + mondef.strLinkage + ": " + eMk.message);
            try
            {
               monMC.fClose();
            }
            catch(eMk2:Error)
            {
            }
            try
            {
               if(monMC.parent != null)
               {
                  monMC.parent.removeChild(monMC);
               }
            }
            catch(eMk3:Error)
            {
            }
            return null;
         }
         return monMC;
      }
      
      public function retrieveMonData() : *
      {
         this.rootClass.sfc.sendXtMessage("zm","retrieveMonData",[],"str",1);
      }
      
      private function getMonID(param1:int) : int
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         for(var _loc6_ in this.monTree)
         {
            _loc2_ = _loc6_;
            _loc6_;
            _loc3_ = this.monTree[_loc2_];
            if(_loc3_.MonMapID == param1)
            {
               return _loc3_.MonID;
            }
         }
         return -1;
      }
      
      private function getMonsterDefinition(param1:int) : Object
      {
         if(this.mondefMap[param1] != null)
         {
            return this.mondefMap[param1];
         }
         return null;
      }
      
      public function getMonster(param1:int) : Avatar
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.monsters.length)
         {
            if(this.monsters[_loc2_].objData.MonMapID == param1 && this.monTree[param1] != null && this.monsters[_loc2_].objData.MonID == this.monTree[param1].MonID)
            {
               return this.monsters[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getMonsters(param1:int) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         _loc2_ = [];
         _loc3_ = 0;
         while(_loc3_ < this.monsters.length)
         {
            if(this.monsters[_loc3_].objData.MonMapID == param1)
            {
               _loc2_.push(this.monsters[_loc3_]);
            }
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            return _loc2_;
         }
         return null;
      }
      
      public function getMonsterCluster(param1:int) : Array
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         _loc2_ = [];
         _loc3_ = 0;
         while(_loc3_ < this.monsters.length)
         {
            if(this.monsters[_loc3_].objData.MonMapID == param1)
            {
               _loc2_.push(this.monsters[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getMonstersByCell(param1:String) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         _loc2_ = [];
         _loc3_ = 0;
         while(_loc3_ < this.monsters.length)
         {
            if(this.monsters[_loc3_].dataLeaf != null && this.monsters[_loc3_].dataLeaf.strFrame == param1)
            {
               _loc2_.push(this.monsters[_loc3_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function initMonsters(param1:Array, param2:Array) : *
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         _loc3_ = 0;
         this.monLoadGen++;
         this.monLoadsSettled = 0;
         this.monLoadsExpected = 0;
         if(param1 != null && param2 != null)
         {
            this.monswf = [];
            this.monsters = new Vector.<Avatar>();
            _loc4_ = null;
            _loc3_ = 0;
            while(_loc3_ < param2.length)
            {
               _loc5_ = 0;
               while(_loc5_ < param1.length)
               {
                  if(param2[_loc3_].MonID == param1[_loc5_].MonID)
                  {
                     _loc4_ = param1[_loc5_];
                  }
                  _loc5_++;
               }
               this.monsters.push(new Avatar(this.rootClass));
               _loc6_ = this.monsters[this.monsters.length - 1];
               _loc6_.npcType = "monster";
               if(_loc6_.objData == null)
               {
                  _loc6_.objData = {};
               }
               for(var _loc11_ in _loc4_)
               {
                  _loc7_ = _loc11_;
                  _loc11_;
                  _loc6_.objData[_loc7_] = _loc4_[_loc7_];
               }
               for(_loc11_ in param2[_loc3_])
               {
                  _loc7_ = _loc11_;
                  _loc11_;
                  _loc6_.objData[_loc7_] = param2[_loc3_][_loc7_];
               }
               _loc8_ = this.monTree[String(_loc6_.objData.MonMapID)];
               _loc8_.strFrame = String(_loc6_.objData.strFrame);
               if(_loc8_.MonID == _loc6_.objData.MonID)
               {
                  _loc6_.dataLeaf = this.monTree[_loc6_.objData.MonMapID];
               }
               else
               {
                  _loc6_.dataLeaf = null;
               }
               _loc3_++;
            }
            this.monLoadsExpected = param1.length;
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               trace("[Load] initMonsters: queue " + param1[_loc3_].strMonFileName);
               this.queueLoad({
                  "strFile":this.rootClass.getFilePath() + "mon/" + param1[_loc3_].strMonFileName,
                  "callBackA":this.monLoadCB(this.monLoadGen,this.onMonLoadComplete),
                  "callBackB":this.monLoadCB(this.monLoadGen,this.onMonLoadError)
               });
               _loc3_++;
            }
         }
         if(this.monLoadsExpected == 0 || this.canStreamMonsters())
         {
            this.enterMap();
         }
      }
      
      private function canStreamMonsters() : Boolean
      {
         return this.strMapName != "trickortreat" && this.strMapName != "caroling";
      }
      
      private function monLoadCB(param1:int, param2:Function) : Function
      {
         var gen:int = param1;
         var fn:Function = param2;
         return function(param1:*):void
         {
            if(gen != monLoadGen)
            {
               return;
            }
            fn(param1);
         };
      }
      
      private function onMonLoadComplete(param1:Event) : *
      {
         var event:Event = param1;
         try
         {
            this.monswf.push(MovieClip(Loader(event.target.loader).content));
         }
         catch(e:Error)
         {
            rootClass.debugMessage("monster swf content invalid");
         }
         this.monLoadSettled();
      }
      
      private function onMonLoadError(param1:*) : void
      {
         this.rootClass.debugMessage("monster swf failed to load");
         this.monLoadSettled();
      }
      
      private function monLoadSettled() : void
      {
         this.monLoadsSettled++;
         if(!this.mapEntered)
         {
            if(this.monLoadsSettled >= this.monLoadsExpected)
            {
               this.enterMap();
            }
            return;
         }
         this.placeMissingCellMonsters(this.monLoadsSettled >= this.monLoadsExpected);
      }
      
      private function placeMissingCellMonsters(param1:Boolean = false) : void
      {
         var monName:Boolean = false;
         var placed:Boolean = false;
         var i:int = 0;
         var child:MovieClip = null;
         var Mons:Array = null;
         var Mon:Avatar = null;
         var force:Boolean = param1;
         if(this.map == null || !this.mapEntered)
         {
            return;
         }
         if(!this.canStreamMonsters())
         {
            return;
         }
         if(this.intBlankWait >= 0 || this.cHandle != null && this.cHandle.isPending())
         {
            return;
         }
         monName = Number(this.objExtra["bMonName"]) == 1;
         placed = false;
         i = 0;
         while(i < this.map.numChildren)
         {
            child = this.map.getChildAt(i) as MovieClip;
            if(!(child == null || !child.isMonster))
            {
               Mons = this.getMonsters(child.MonMapID);
               for each(var _loc5_ in Mons)
               {
                  Mon = _loc5_;
                  _loc5_;
                  if(!(Mon == null || Mon.pMC != null))
                  {
                     try
                     {
                        Mon.pMC = this.createMonsterMC(child,Mon.objData.MonID,monName,force);
                        if(Mon.pMC == null)
                        {
                           continue;
                        }
                        placed = true;
                        Mon.pMC.scale(this.SCALE);
                        Mon.pMC.pAV = Mon;
                        Mon.pMC.setData();
                        if(Mon.dataLeaf == null)
                        {
                           this.TRASH.addChild(Mon.pMC);
                        }
                        else if(this.rootClass.litePreference.data.bMonsType)
                        {
                           Mon.pMC.pname.typ.text = "< " + Mon.pMC.pAV.objData.sRace + " >";
                           Mon.pMC.pname.typ.visible = Mon.pMC.pAV.objData.sRace != "None";
                        }
                        else
                        {
                           Mon.pMC.pname.typ.visible = false;
                        }
                     }
                     catch(ePM:Error)
                     {
                        trace("[Load] ERR placeMissingCellMonsters: " + ePM.message);
                        continue;
                     }
                  }
               }
            }
            i++;
         }
         if(placed)
         {
            this.updateMonsters();
         }
      }
      
      public function toggleMonsters() : *
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         this.rootClass.ui.monsterIcon.redX.visible = this.showMonsters;
         this.showMonsters = !this.showMonsters;
         _loc2_ = 0;
         while(_loc2_ < this.CHARS.numChildren)
         {
            _loc1_ = this.CHARS.getChildAt(_loc2_);
            if(Boolean(_loc1_.hasOwnProperty("isMonster")) && Boolean(MovieClip(_loc1_).isMonster))
            {
               MovieClip(_loc1_).setVisible();
            }
            _loc2_++;
         }
      }
      
      public function setTarget(param1:*) : *
      {
         if(this.strMapName == "caroling" && this.CarolingMonsterKillCount >= 5)
         {
            if(param1 != null && param1.npcType != "player")
            {
               return;
            }
         }
         if(this.myAvatar != null && param1 != null && param1.npcType == "player" && Boolean(param1.isMyAvatar))
         {
            if(this.rootClass.litePreference.data.bUntargetSelf)
            {
               return;
            }
         }
         if(this.myAvatar != null && this.myAvatar.target != param1)
         {
            if(this.myAvatar.target != null)
            {
               if(this.myAvatar.target.npcType == "monster")
               {
                  if(this.bPvP && this.myAvatar.target.dataLeaf.react != null && this.myAvatar.target.dataLeaf.react[this.myAvatar.dataLeaf.pvpTeam] == 1)
                  {
                     this.myAvatar.target.pMC.modulateColor(this.avtPCT,"-");
                  }
                  else
                  {
                     this.myAvatar.target.pMC.modulateColor(this.avtMCT,"-");
                  }
               }
               if(this.myAvatar.target.npcType == "player")
               {
                  if(this.bPvP && this.myAvatar.target.dataLeaf.pvpTeam != this.myAvatar.dataLeaf.pvpTeam)
                  {
                     this.myAvatar.target.pMC.modulateColor(this.avtMCT,"-");
                  }
                  else
                  {
                     this.myAvatar.target.pMC.modulateColor(this.avtPCT,"-");
                  }
               }
            }
            if(param1 != null)
            {
               if(!this.bPvP && param1.npcType == "player")
               {
                  if(this.autoActionTimer != null)
                  {
                     this.cancelAutoAttack();
                  }
               }
               this.myAvatar.target = param1;
               if(this.myAvatar.target.npcType == "monster")
               {
                  if(this.bPvP && this.myAvatar.target.dataLeaf.react != null && this.myAvatar.target.dataLeaf.react[this.myAvatar.dataLeaf.pvpTeam] == 1)
                  {
                     this.myAvatar.target.pMC.modulateColor(this.avtPCT,"+");
                  }
                  else
                  {
                     this.myAvatar.target.pMC.modulateColor(this.avtMCT,"+");
                  }
               }
               if(this.myAvatar.target.npcType == "player")
               {
                  if(this.bPvP && this.myAvatar.target.dataLeaf.pvpTeam != this.myAvatar.dataLeaf.pvpTeam)
                  {
                     this.myAvatar.target.pMC.modulateColor(this.avtMCT,"+");
                  }
                  else
                  {
                     this.myAvatar.target.pMC.modulateColor(this.avtPCT,"+");
                  }
               }
               this.rootClass.showPortraitTarget(param1);
            }
            else
            {
               this.rootClass.hidePortraitTarget();
               if(this.myAvatar.dataLeaf.intState > 0)
               {
                  this.exitCombat();
               }
               this.myAvatar.target = null;
            }
         }
      }
      
      public function cancelTarget() : void
      {
         if(this.autoActionTimer != null && this.autoActionTimer.running)
         {
            this.cancelAutoAttack();
            if(this.myAvatar != null && this.myAvatar.pMC != null && this.myAvatar.pMC.mcChar != null)
            {
               this.myAvatar.pMC.mcChar.gotoAndStop("Idle");
            }
            return;
         }
         if(this.myAvatar != null && this.myAvatar.target != null)
         {
            this.setTarget(null);
            return;
         }
      }
      
      public function approachTarget() : *
      {
         var _loc1_:Boolean = false;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:Array = null;
         var _loc23_:Array = null;
         _loc1_ = true;
         _loc2_ = this.uoTree[this.rootClass.sfc.myUserName];
         _loc4_ = this.getAutoAttack();
         if(this.myAvatar.target != null)
         {
            if(this.myAvatar.target.npcType == "monster")
            {
               _loc3_ = this.monTree[this.myAvatar.target.objData.MonMapID];
            }
            else if(this.myAvatar.target.npcType == "player")
            {
               _loc3_ = this.myAvatar.target.dataLeaf;
            }
            if(_loc3_ == null || _loc2_.intState == 0 || _loc3_.intState == 0)
            {
               _loc1_ = false;
            }
            if(this.bPvP && (_loc3_.react != null && _loc3_.react[_loc2_.pvpTeam] == 1 || _loc2_.pvpTeam == _loc3_.pvpTeam) || !this.bPvP && this.myAvatar.target.npcType == "player")
            {
               _loc1_ = false;
            }
            if(_loc1_)
            {
               if(_loc4_ != null)
               {
                  if(this.actionRangeCheck(_loc4_))
                  {
                     this.testAction(_loc4_);
                  }
                  else
                  {
                     this.actionReady = true;
                     _loc5_ = false;
                     this._originPoint.x = 0;
                     this._originPoint.y = 0;
                     _loc6_ = this.myAvatar.pMC.mcChar.localToGlobal(this._originPoint);
                     this._originPoint.x = 0;
                     this._originPoint.y = 0;
                     _loc7_ = this.myAvatar.target.pMC.mcChar.localToGlobal(this._originPoint);
                     if(_loc4_.range > 301)
                     {
                        _loc8_ = Point.distance(_loc6_,_loc7_);
                        _loc9_ = _loc4_.range * this.SCALE;
                        _loc9_ = _loc9_ * 0.9;
                        if(_loc9_ < _loc8_)
                        {
                           _loc7_ = Point.interpolate(_loc6_,_loc7_,_loc9_ / _loc8_);
                        }
                        _loc5_ = !this.padHit(_loc7_.x,_loc7_.y,this.myAvatar.pMC.shadow.getBounds(this.rootClass.stage));
                     }
                     else
                     {
                        _loc10_ = 0;
                        while(_loc10_ < 100 && !_loc5_)
                        {
                           _loc11_ = int(50 + Math.random() * 110);
                           if(_loc10_ > 50)
                           {
                              _loc11_ = _loc11_ * -1;
                           }
                           _loc12_ = _loc7_.x - _loc6_.x >= 0 ? int(-_loc11_) : _loc11_;
                           _loc13_ = Math.random() * 40 - 20;
                           _loc12_ = Math.ceil(_loc12_ * this.SCALE);
                           _loc13_ = Math.floor(_loc13_ * this.SCALE);
                           _loc14_ = _loc7_.x + _loc12_;
                           _loc15_ = _loc7_.y + _loc13_;
                           _loc5_ = !this.padHit(_loc14_,_loc15_,this.myAvatar.pMC.shadow.getBounds(this.rootClass.stage));
                           _loc10_++;
                        }
                        _loc7_.x = _loc7_.x + _loc12_;
                        _loc7_.y = _loc7_.y + _loc13_;
                     }
                     if(_loc5_)
                     {
                        _loc16_ = this.myAvatar.objData.strClassName.toLowerCase();
                        if(_loc16_.indexOf("archmage") == 0 || _loc16_.indexOf("deathknight") == 0)
                        {
                           this.rootClass.mixer.playSound("ClickBig");
                        }
                        if(this.bPvP)
                        {
                           this.myAvatar.pMC.walkTo(_loc7_.x,_loc7_.y,this.WALKSPEED);
                           this.pushMove(this.myAvatar.pMC,_loc7_.x,_loc7_.y,this.WALKSPEED);
                        }
                        else
                        {
                           this.myAvatar.pMC.walkTo(_loc7_.x,_loc7_.y,this.WALKSPEED * 2);
                           this.pushMove(this.myAvatar.pMC,_loc7_.x,_loc7_.y,this.WALKSPEED * 2);
                        }
                     }
                     else
                     {
                        this.rootClass.chatF.pushMsg("server","No path found!","SERVER","",0);
                     }
                  }
               }
            }
         }
         else
         {
            _loc17_ = this.myAvatar;
            _loc18_ = null;
            _loc19_ = null;
            _loc20_ = "tgtMin" in _loc4_ ? int(_loc4_.tgtMin) : 1;
            _loc21_ = this.getRealTgtMax(_loc4_);
            _loc22_ = [];
            _loc23_ = this.getAllAvatarsInCell();
            for each(var _loc26_ in _loc23_)
            {
               _loc18_ = _loc26_;
               _loc26_;
               _loc3_ = _loc18_.dataLeaf;
               if(_loc3_ != null && (!this.bPvP && _loc18_.npcType == "monster" || this.bPvP && _loc18_.npcType == "player" && _loc2_.pvpTeam != _loc3_.pvpTeam || this.bPvP && _loc18_.npcType == "monster" && _loc3_.react != null && _loc3_.react[_loc2_.pvpTeam] == 0) && this.actionRangeCheck(_loc4_,_loc18_))
               {
                  this.setTarget(_loc18_);
                  this.testAction(_loc4_);
                  return;
               }
            }
            this.rootClass.chatF.pushMsg("warning","No target selected!","SERVER","",0);
         }
      }
      
      private function getRealTgtMax(param1:*) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         _loc2_ = "tgtMax" in param1 ? Number(param1.tgtMax) : 1;
         if("toggleAoe" in param1 && "toggleAoeLimit" in param1)
         {
            _loc3_ = this.uoTreeLeaf(this.rootClass.sfc.myUserName);
            for each(var _loc7_ in _loc3_.auras)
            {
               _loc4_ = _loc7_;
               _loc7_;
               if(_loc4_.nam == param1.toggleAoe)
               {
                  _loc2_ = Number(param1.toggleAoeLimit);
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function padHit(param1:int, param2:int, param3:Rectangle) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:Rectangle = null;
         var _loc6_:MovieClip = null;
         _loc4_ = 0;
         if(param1 < 0 || param1 > 960 || param2 < 10 || param2 > 530)
         {
            return false;
         }
         param3.x = int(param1 - param3.width / 2);
         param3.y = int(param2 - param3.height / 2);
         _loc4_ = 0;
         while(_loc4_ < this.arrEvent.length)
         {
            _loc6_ = this.arrEvent[_loc4_];
            if("strSpawnCell" in _loc6_ || "tCell" in _loc6_)
            {
               _loc5_ = this.arrEventR[_loc4_];
               if(param3.intersects(_loc5_))
               {
                  return true;
               }
            }
            _loc4_++;
         }
         return false;
      }
      
      public function drawRects(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Sprite = null;
         var _loc4_:Graphics = null;
         var _loc5_:Rectangle = null;
         var _loc6_:int = 0;
         _loc2_ = [16711680,65280,255];
         _loc3_ = new Sprite();
         _loc4_ = _loc3_.graphics;
         _loc6_ = 0;
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc5_ = param1[_loc6_];
            _loc4_.moveTo(_loc5_.x,_loc5_.y);
            _loc4_.beginFill(_loc2_[_loc6_],0.3);
            _loc4_.lineTo(_loc5_.x + _loc5_.width,_loc5_.y);
            _loc4_.lineTo(_loc5_.x + _loc5_.width,_loc5_.y + _loc5_.height);
            _loc4_.lineTo(_loc5_.x,_loc5_.y + _loc5_.height);
            _loc4_.lineTo(_loc5_.x,_loc5_.y);
            _loc4_.endFill();
            _loc6_++;
         }
      }
      
      public function testAction(param1:Object, param2:Boolean = false, param3:int = 0) : *
      {
         var a:int = 0;
         var b:int = 0;
         var c:int = 0;
         var cLeaf:Object = null;
         var tLeaf:Object = null;
         var cAvt:* = undefined;
         var tAvt:* = undefined;
         var pAvt:* = undefined;
         var tgtMin:int = 0;
         var tgtMax:int = 0;
         var targets:Array = null;
         var scan:Array = null;
         var errMsg:String = null;
         var forceAAloop:Boolean = false;
         var sCatT:String = null;
         var aura:Object = null;
         var pet:* = undefined;
         var petItem:* = undefined;
         var tgtOK:Boolean = false;
         var sAvt:Avatar = null;
         var to:Object = null;
         var now:Number = NaN;
         var actionObj:Object = param1;
         var forceAARangeError:Boolean = param2;
         var _depth:int = param3;
         if(_depth > 3)
         {
            return;
         }
         if(this.strMapName == "caroling" && this.CarolingMonsterKillCount >= 5)
         {
            return;
         }
         a = 0;
         b = 0;
         c = 0;
         cLeaf = this.uoTreeLeaf(this.rootClass.sfc.myUserName);
         cAvt = this.myAvatar;
         tAvt = null;
         pAvt = null;
         tgtMin = "tgtMin" in actionObj ? int(actionObj.tgtMin) : 1;
         tgtMax = this.getRealTgtMax(actionObj);
         targets = [];
         scan = this.getAllAvatarsInCell();
         a = 0;
         while(a < scan.length)
         {
            tAvt = scan[a];
            if(tAvt.dataLeaf == null || tAvt.dataLeaf.intState == 0 || (tAvt.pMC == null || tAvt.pMC.x == null))
            {
               scan.splice(a,1);
               a--;
               if(tAvt == this.myAvatar.target)
               {
                  this.setTarget(null);
               }
            }
            a++;
         }
         a = 0;
         tAvt = null;
         if(this.myAvatar.target != null && scan.indexOf(this.myAvatar.target) > -1)
         {
            scan.unshift(scan.splice(scan.indexOf(this.myAvatar.target),1)[0]);
         }
         this.afkPostpone();
         errMsg = "none";
         forceAAloop = false;
         if(actionObj.ref == "i1" && this.lockdownPots)
         {
            if(new Date().getTime() - this.lockdownPotsTS > 5000)
            {
               this.lockdownPots = false;
            }
            else
            {
               errMsg = "The potion is not quite ready yet.";
            }
         }
         if(!this.actionTimeCheck(actionObj))
         {
            errMsg = "Ability \'" + actionObj.nam + "\' is not ready yet.";
         }
         if(errMsg == "none" && actionObj.mp != null && Math.round(actionObj.mp * cLeaf.sta["$cmc"]) > cLeaf.intMP)
         {
            errMsg = "Not enough mana!";
         }
         if(errMsg == "none" && actionObj.sp != null)
         {
            if(!this.checkSP(actionObj.sp,cLeaf))
            {
               errMsg = "Not Enough Spirit Power!";
            }
         }
         if(errMsg == "none" && actionObj.ref == "i1" && actionObj.sArg1 == "")
         {
            errMsg = "No item assigned to that slot!";
         }
         if(errMsg == "none" && this.myAvatar.target != null && "filter" in actionObj && "sRace" in this.myAvatar.target.objData && this.myAvatar.target.objData.sRace.toLowerCase() != actionObj.filter.toLowerCase())
         {
            errMsg = "Target is not a " + actionObj.filter + "!";
         }
         if(errMsg == "none")
         {
            for each(var _loc7_ in cLeaf.auras)
            {
               aura = _loc7_;
               _loc7_;
               try
               {
                  sCatT = this.auraCatOf(aura);
                  if(sCatT == "stun")
                  {
                     errMsg = "Cannot act while stunned!";
                  }
                  if(sCatT == "stone")
                  {
                     errMsg = "Cannot act while petrified!";
                  }
                  if(sCatT == "paralyze")
                  {
                     errMsg = "Cannot act while paralyzed!";
                  }
                  if(sCatT == "disable" || sCatT == "disabled")
                  {
                     errMsg = "Cannot act while disabled!";
                  }
                  if(errMsg != "none")
                  {
                     forceAAloop = true;
                  }
               }
               catch(e:Error)
               {
                  trace("[Combat] ERR testAction: aura scan " + e.message);
               }
            }
         }
         if(errMsg == "none")
         {
            if(actionObj.pet != null)
            {
               pet = cAvt.getItemByEquipSlot("pe");
               if(cAvt.getItemByEquipSlot("pe") == null)
               {
                  if(cAvt.checkTempItem(actionObj.pet,1))
                  {
                     this.summonPet(actionObj.pet,true);
                  }
                  else
                  {
                     this.summonPet(actionObj.pet,false);
                  }
               }
            }
            else if(actionObj.checkPet != null)
            {
               petItem = cAvt.getItemByEquipSlot("pe");
               if(petItem == null || petItem.sMeta.indexOf(actionObj.checkPet) == -1)
               {
                  errMsg = "No battle pet equipped.";
               }
            }
         }
         if(errMsg == "none" || forceAAloop)
         {
            if(this.myAvatar.target != null)
            {
               tAvt = this.myAvatar.target;
               if(this.myAvatar.target.npcType == "monster")
               {
                  tLeaf = this.monTree[tAvt.objData.MonMapID];
               }
               else if(tAvt.npcType == "player")
               {
                  tLeaf = tAvt.dataLeaf;
               }
            }
            switch(actionObj.tgt)
            {
               case "h":
                  if(tAvt == null)
                  {
                     if(tgtMin > 0)
                     {
                        for each(_loc7_ in scan)
                        {
                           tAvt = _loc7_;
                           _loc7_;
                           tLeaf = tAvt.dataLeaf;
                           if(tLeaf != null && (!this.bPvP && tAvt.npcType == "monster" || this.bPvP && tAvt.npcType == "player" && cLeaf.pvpTeam != tLeaf.pvpTeam || this.bPvP && tAvt.npcType == "monster" && tLeaf.react != null && tLeaf.react[cLeaf.pvpTeam] == 0) && this.actionRangeCheck(actionObj,tAvt))
                           {
                              this.setTarget(tAvt);
                              this.testAction(actionObj,false,_depth + 1);
                              return;
                           }
                        }
                        errMsg = "No target selected!";
                        if(actionObj.typ == "aa")
                        {
                           this.cancelAutoAttack();
                        }
                     }
                  }
                  else
                  {
                     if(!this.bPvP && tAvt.npcType == "player" || this.bPvP && tAvt.npcType == "player" && cLeaf.pvpTeam == tLeaf.pvpTeam || this.bPvP && tAvt.npcType == "monster" && tLeaf.react != null && tLeaf.react[cLeaf.pvpTeam] == 1)
                     {
                        errMsg = "Can\'t attack that target!";
                        if(actionObj.typ == "aa")
                        {
                           this.cancelAutoAttack();
                        }
                     }
                     if(tgtMin > 0 && tAvt.dataLeaf.intState == 0)
                     {
                        errMsg = "Your target is dead!";
                     }
                  }
                  break;
               case "f":
                  if(tAvt == null)
                  {
                     this.setTarget(this.myAvatar);
                     tAvt = this.myAvatar;
                     tLeaf = tAvt.dataLeaf;
                  }
                  if(!this.bPvP && tAvt.npcType == "monster" || this.bPvP && cLeaf.pvpTeam != tLeaf.pvpTeam || this.bPvP && tAvt.npcType == "monster" && tLeaf.react != null && tLeaf.react[cLeaf.pvpTeam] == 1)
                  {
                     tAvt = this.myAvatar;
                  }
                  tLeaf = tAvt.dataLeaf;
                  break;
               case "s":
                  if(tAvt == null)
                  {
                     this.setTarget(this.myAvatar);
                     tAvt = this.myAvatar;
                  }
                  if(tAvt != null && tAvt != this.myAvatar)
                  {
                     tAvt = this.myAvatar;
                  }
                  tLeaf = tAvt.dataLeaf;
            }
            pAvt = tAvt;
            if(errMsg == "none" && !this.actionRangeCheck(actionObj,pAvt) || forceAAloop)
            {
               if(!forceAAloop)
               {
                  errMsg = "You are out of range!  Move closer to your target!";
               }
               if(actionObj.typ == "aa")
               {
                  this.autoActionTimer.delay = 500;
                  this.autoActionTimer.reset();
                  this.autoActionTimer.start();
               }
            }
            tgtOK = true;
            if(errMsg == "none")
            {
               while(scan.length > 0)
               {
                  tAvt = scan[0];
                  tLeaf = tAvt.dataLeaf;
                  tgtOK = true;
                  if(tLeaf.intState == 0)
                  {
                     tgtOK = false;
                  }
                  if(tAvt != null && "filter" in actionObj && "sRace" in tAvt.objData)
                  {
                     if(tAvt.objData.sRace.toLowerCase() != actionObj.filter.toLowerCase())
                     {
                        tgtOK = false;
                     }
                  }
                  switch(actionObj.tgt)
                  {
                     case "h":
                        if(!this.bPvP && tAvt.npcType == "player" || this.bPvP && tAvt.npcType == "player" && cLeaf.pvpTeam == tLeaf.pvpTeam || this.bPvP && tAvt.npcType == "monster" && tLeaf.react != null && tLeaf.react[cLeaf.pvpTeam] == 1)
                        {
                           tgtOK = false;
                        }
                        break;
                     case "f":
                        if(!this.bPvP && tAvt.npcType == "monster" || this.bPvP && cLeaf.pvpTeam != tLeaf.pvpTeam || this.bPvP && tAvt.npcType == "monster" && tLeaf.react != null && tLeaf.react[cLeaf.pvpTeam] == 1)
                        {
                           tgtOK = false;
                        }
                        break;
                     case "s":
                        if(tAvt != null && tAvt != this.myAvatar)
                        {
                           tgtOK = false;
                        }
                  }
                  if(tgtOK)
                  {
                     sAvt = this.myAvatar;
                     if(actionObj.fx == "c" && targets.length > 0)
                     {
                        sAvt = targets[targets.length - 1].avt;
                     }
                     a = Math.abs(tAvt.pMC.x - sAvt.pMC.x);
                     b = Math.abs(tAvt.pMC.y - sAvt.pMC.y);
                     c = Math.pow(a * a + b * b,0.5);
                     if(this.actionRangeCheck(actionObj,tAvt))
                     {
                        targets.push({
                           "avt":tAvt,
                           "d":c,
                           "hp":tLeaf.intHP
                        });
                     }
                  }
                  scan.shift();
               }
            }
            targets.sortOn("hp",Array.NUMERIC);
            if(pAvt != null)
            {
               a = 0;
               while(a < targets.length)
               {
                  to = targets[a];
                  if(to.avt == pAvt)
                  {
                     targets.unshift(targets.splice(a,1)[0]);
                  }
                  a++;
               }
            }
            if(targets.length > tgtMax)
            {
               targets = targets.splice(0,tgtMax);
            }
            if(targets.length > 0)
            {
               if(pAvt != null)
               {
                  if(targets[0].avt != null && targets[0].avt.dataLeaf != null)
                  {
                     tAvt = targets[0].avt;
                     tLeaf = tAvt.dataLeaf;
                  }
                  else
                  {
                     tAvt = null;
                     tLeaf = null;
                  }
               }
               else
               {
                  tAvt = null;
                  tLeaf = null;
               }
            }
         }
         if(errMsg == "none")
         {
            if(cLeaf.intState != 0)
            {
               if(!actionObj.lock && (tLeaf == null || tLeaf.intState != 0) && targets.length >= tgtMin)
               {
                  this.doAction(actionObj,targets);
               }
               if(this.myAvatar.target == null || (tLeaf == null || tLeaf.intState == 0))
               {
                  this.exitCombat();
               }
            }
         }
         else
         {
            now = Number(new Date().getTime());
            if(errMsg == "You are out of range!  Move closer to your target!" && (actionObj.typ != "aa" || forceAARangeError))
            {
               if(now - this.actionRangeSpamTS > 3000)
               {
                  this.actionRangeSpamTS = now;
                  this.rootClass.chatF.pushMsg("warning",errMsg,"SERVER","",0);
               }
            }
            else if(actionObj.typ != "aa")
            {
               this.rootClass.chatF.pushMsg("warning",errMsg,"SERVER","",0);
            }
         }
      }
      
      public function summonPet(param1:int, param2:Boolean) : *
      {
         if(param2)
         {
            this.rootClass.sfc.sendXtMessage("zm","equipItem",[param1],"str",this.curRoom);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","summonPet",[param1],"str",this.curRoom);
         }
      }
      
      public function autoActionHandler(param1:TimerEvent) : *
      {
         if(this.rootClass.litePreference.data.bUntargetDead && this.myAvatar.target != null && !this.myAvatar.target.isMyAvatar && this.myAvatar.target.dataLeaf.intState == 0)
         {
            this.cancelTarget();
            return;
         }
         if(this.myAvatar.dataLeaf != null && this.myAvatar.dataLeaf.intState != 0 && this.myAvatar.target != null && this.myAvatar.target.dataLeaf != null && this.myAvatar.target.dataLeaf.intState != 0)
         {
            this.testAction(this.getAutoAttack(),true);
         }
         else
         {
            this.exitCombat();
         }
      }
      
      public function getAutoAttack() : Object
      {
         var _loc1_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < this.actions.active.length)
         {
            if(this.actions.active[_loc1_] != null && this.actions.active[_loc1_].auto != null && this.actions.active[_loc1_].auto == true)
            {
               return this.actions.active[_loc1_];
            }
            _loc1_++;
         }
         return this.actions.active[0];
      }
      
      public function exitCombat() : *
      {
         var _loc1_:int = 0;
         this.actionReady = false;
         if(this.actions != null && this.actions.active != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.actions.active.length)
            {
               if(this.actions.active[_loc1_])
               {
                  this.actions.active[_loc1_].lock = false;
               }
               _loc1_++;
            }
         }
         if(this.myAvatar != null)
         {
            if(this.myAvatar.pMC != null && this.myAvatar.pMC.mcChar != null && !this.myAvatar.pMC.mcChar.onMove && this.myAvatar.pMC.mcChar.currentLabel != "Rest")
            {
               this.myAvatar.pMC.mcChar.gotoAndStop("Idle");
            }
            if(this.myAvatar.dataLeaf != null)
            {
               this.myAvatar.dataLeaf.targets = {};
            }
            this.cancelAutoAttack();
            if(this.myAvatar.pMC != null)
            {
               this.myAvatar.pMC.clearQueue();
            }
         }
      }
      
      public function cancelAutoAttack() : *
      {
         var icon:MovieClip = null;
         var i:* = undefined;
         if(this.autoActionTimer != null)
         {
            this.autoActionTimer.reset();
         }
         if(this.AATestTimer != null)
         {
            this.AATestTimer.reset();
         }
         i = 0;
         while(i < this.actionMap.length)
         {
            try
            {
               if(this.actionMap[i] == "aa")
               {
                  icon = MovieClip(this.rootClass.ui.mcInterface.actBar.getChildByName("i" + (i + 1)));
                  icon.bg.gotoAndStop(1);
               }
            }
            catch(e:Error)
            {
               trace("[Combat] ERR cancelAutoAttack: " + e.message);
            }
            i++;
         }
      }
      
      public function doAction(param1:*, param2:*) : *
      {
         var _loc3_:Avatar = null;
         var _loc4_:int = 0;
         this.afkPostpone();
         if(param2.length > 0)
         {
            _loc3_ = param2[0].avt;
            if(_loc3_ != this.myAvatar)
            {
               if(_loc3_.pMC.x - this.myAvatar.pMC.x >= 0)
               {
                  this.myAvatar.pMC.turn("right");
               }
               else
               {
                  this.myAvatar.pMC.turn("left");
               }
            }
         }
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_ = param2[_loc4_].avt;
            switch(_loc3_.npcType)
            {
               case "monster":
                  if(this.myAvatar.dataLeaf.targets[_loc3_.objData.MonMapID] == null)
                  {
                     this.myAvatar.dataLeaf.targets[_loc3_.objData.MonMapID] = "m";
                  }
                  break;
               case "player":
                  if(this.myAvatar.dataLeaf.targets[_loc3_.objData.uid] == null)
                  {
                     this.myAvatar.dataLeaf.targets[_loc3_.objData.uid] = "p";
                  }
                  break;
            }
            _loc4_++;
         }
         this.getActionResult(param1,param2);
      }
      
      public function aggroMap(param1:String, param2:String, param3:*) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         _loc4_ = param1.split(":");
         _loc5_ = param2.split(":");
         _loc6_ = _loc4_[0];
         _loc7_ = _loc4_[1];
         _loc8_ = _loc5_[0];
         _loc9_ = _loc5_[1];
         var _loc10_:String = "";
         var _loc11_:String = "";
         _loc12_ = {};
         _loc13_ = {};
         if(_loc6_ == "p")
         {
            _loc12_ = this.getUoLeafById(_loc7_);
         }
         else
         {
            _loc12_ = this.monTree[_loc7_];
         }
         if(_loc8_ == "p")
         {
            _loc13_ = this.getUoLeafById(_loc9_);
         }
         else
         {
            _loc13_ = this.monTree[_loc9_];
         }
         if(!("targets" in _loc12_))
         {
            _loc12_.targets = {};
         }
         if(!("targets" in _loc13_))
         {
            _loc13_.targets = {};
         }
         if(_loc8_ == "m")
         {
            if(!(_loc9_ in _loc12_.targets))
            {
               _loc12_.targets[_loc9_] = _loc8_;
            }
            if(!(_loc7_ in _loc13_.targets))
            {
               _loc13_.targets[_loc7_] = _loc6_;
            }
         }
         if(_loc6_ == "p" && _loc8_ == "p" && param3)
         {
            for(var _loc18_ in this.monTree)
            {
               _loc14_ = _loc18_;
               _loc18_;
               _loc15_ = this.monTree[_loc14_];
               if(_loc15_.targets[_loc9_] != null && !(_loc7_ in _loc15_.targets))
               {
                  _loc15_.targets[_loc7_] = _loc6_;
               }
            }
         }
      }
      
      public function actionTimeCheck(param1:*, param2:Boolean = false) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         _loc3_ = Number(new Date().getTime());
         _loc4_ = 1 - Math.min(Math.max(this.myAvatar.dataLeaf.sta.$tha,-1),0.5);
         if(param1.auto)
         {
            if(this.autoActionTimer.running)
            {
               return false;
            }
            return true;
         }
         if(!param2)
         {
            if(_loc3_ - this.GCDTS < this.GCD)
            {
               return false;
            }
         }
         if(param1.OldCD != null)
         {
            _loc5_ = Math.round(param1.OldCD * _loc4_);
         }
         else
         {
            _loc5_ = Math.round(param1.cd * _loc4_);
         }
         if(_loc3_ - param1.ts >= _loc5_)
         {
            delete param1.OldCD;
            return true;
         }
         return false;
      }
      
      private function actionRangeCheck(param1:*, param2:Avatar = null) : Boolean
      {
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(param2 == null && this.myAvatar.target != null)
         {
            param2 = this.myAvatar.target;
         }
         if(param2 == this.myAvatar)
         {
            return true;
         }
         if("tgtMin" in param1 && param1.tgtMin == 0)
         {
            return true;
         }
         if(param2 == null)
         {
            return false;
         }
         this._originPoint.x = 0;
         this._originPoint.y = 0;
         _loc3_ = this.myAvatar.pMC.mcChar.localToGlobal(this._originPoint);
         this._originPoint.x = 0;
         this._originPoint.y = 0;
         _loc4_ = param2.pMC.mcChar.localToGlobal(this._originPoint);
         _loc5_ = Math.abs(_loc4_.x - _loc3_.x);
         _loc6_ = Math.abs(_loc4_.y - _loc3_.y);
         _loc7_ = Math.pow(_loc5_ * _loc5_ + _loc6_ * _loc6_,0.5);
         _loc8_ = param1.range * this.SCALE;
         if(param1.range <= 301)
         {
            if(this.bPvP && _loc5_ <= _loc8_ * 1.15 && _loc6_ <= 30 * 1.15 * this.SCALE || !this.bPvP && _loc5_ <= _loc8_ && _loc6_ <= 30 * this.SCALE)
            {
               return true;
            }
            return false;
         }
         if(_loc7_ <= _loc8_)
         {
            return true;
         }
         return false;
      }
      
      public function aggroAllMon() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = [];
         for(var _loc5_ in this.monTree)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(this.monTree[_loc2_].strFrame == this.strFrame)
            {
               _loc1_.push(_loc2_);
            }
         }
         this.aggroMons(_loc1_);
      }
      
      public function aggroMon(param1:*) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = [];
         _loc2_.push(param1);
         this.aggroMons(_loc2_);
      }
      
      public function aggroMons(param1:*) : *
      {
         if(param1.length)
         {
            this.rootClass.sfc.sendXtMessage("zm","aggroMon",param1,"str",this.curRoom);
         }
      }
      
      public function castSpellFX(param1:*, param2:*, param3:*, param4:int = 0) : *
      {
         var tAvt:Avatar = null;
         var AssetClass:Class = null;
         var spellFX:* = undefined;
         var targetMCs:Array = null;
         var i:int = 0;
         var cAvt:* = param1;
         var spFX:* = param2;
         var spell:* = param3;
         var dur:int = param4;
         try
         {
            if(cAvt && Boolean(cAvt.isCameraTool))
            {
               cAvt.pMC.clearSpFXQueue();
               return;
            }
            if(!this.showAnimations || cAvt && !cAvt.isMyAvatar && !cAvt.pMC.mcChar.visible)
            {
               cAvt.pMC.clearSpFXQueue();
               return;
            }
            if(this.rootClass.litePreference.data.bDisSkillAnim)
            {
               if(!this.rootClass.litePreference.data.dOptions["animSelf"] || this.rootClass.litePreference.data.dOptions["animSelf"] && cAvt && !cAvt.isMyAvatar)
               {
                  cAvt.pMC.clearSpFXQueue();
                  return;
               }
            }
            if(spFX.strl != null && spFX.strl != "" && spFX.avts != null)
            {
               targetMCs = [];
               i = 0;
               if(spFX.fx == "c")
               {
                  if(spFX.strl == "lit1")
                  {
                     targetMCs.push(cAvt.pMC.mcChar);
                     i = 0;
                     while(i < spFX.avts.length)
                     {
                        tAvt = spFX.avts[i];
                        if(tAvt != null && tAvt.pMC != null && tAvt.pMC.mcChar != null)
                        {
                           targetMCs.push(tAvt.pMC.mcChar);
                        }
                        i++;
                     }
                     if(targetMCs.length > 1)
                     {
                        AssetClass = this.getClass("sp_C1") as Class;
                        if(AssetClass != null)
                        {
                           spellFX = new AssetClass();
                           spellFX.mouseEnabled = false;
                           spellFX.mouseChildren = false;
                           spellFX.visible = true;
                           spellFX.world = MovieClip(this);
                           spellFX.strl = spFX.strl;
                           spellFX.isSpell = true;
                           try
                           {
                              spellFX.fxDeadline = getTimer() + 20000 + dur;
                           }
                           catch(eDl:Error)
                           {
                           }
                           this.rootClass.drawChainsLinear(targetMCs,33,MovieClip(this.CHARS.addChild(spellFX)));
                        }
                     }
                  }
               }
               else if(spFX.fx == "f")
               {
                  targetMCs.push(cAvt.pMC.mcChar);
                  tAvt = spFX.avts[0];
                  if(tAvt != null && tAvt.pMC != null && tAvt.pMC.mcChar != null)
                  {
                     targetMCs.push(tAvt.pMC.mcChar);
                  }
                  if(targetMCs.length > 1)
                  {
                     spellFX = new MovieClip();
                     spellFX.mouseEnabled = false;
                     spellFX.mouseChildren = false;
                     spellFX.visible = true;
                     spellFX.world = MovieClip(this);
                     spellFX.strl = spFX.strl;
                     spellFX.fxDeadline = getTimer() + 20000 + dur;
                     this.rootClass.drawFunnel(targetMCs,MovieClip(this.CHARS.addChild(spellFX)));
                  }
               }
               else
               {
                  i = 0;
                  while(i < spFX.avts.length)
                  {
                     tAvt = spFX.avts[i];
                     if(tAvt != null)
                     {
                        if(tAvt.pMC != null)
                        {
                           AssetClass = this.getClass(spFX.strl) as Class;
                           if(AssetClass != null)
                           {
                              spellFX = new AssetClass();
                              spellFX.spellDur = dur;
                              try
                              {
                                 spellFX.fxDeadline = getTimer() + 20000 + dur;
                              }
                              catch(eDl2:Error)
                              {
                              }
                              if(spell != null)
                              {
                                 spellFX.transform = spell.transform;
                              }
                              this.CHARS.addChild(spellFX);
                              spellFX.mouseEnabled = false;
                              spellFX.mouseChildren = false;
                              spellFX.visible = true;
                              spellFX.world = MovieClip(this);
                              spellFX.strl = spFX.strl;
                              spellFX.tMC = tAvt.pMC;
                              switch(spFX.fx)
                              {
                                 case "p":
                                    spellFX.x = cAvt.pMC.x;
                                    spellFX.y = cAvt.pMC.y - cAvt.pMC.mcChar.height * 0.5;
                                    spellFX.dir = tAvt.pMC.x - cAvt.pMC.x >= 0 ? 1 : -1;
                                    break;
                                 case "w":
                                    spellFX.x = spellFX.tMC.x;
                                    spellFX.y = spellFX.tMC.y + 3;
                                    if(cAvt != null)
                                    {
                                       if(spellFX.tMC.x < cAvt.pMC.x)
                                       {
                                          spellFX.scaleX = spellFX.scaleX * -1;
                                       }
                                    }
                              }
                           }
                           else
                           {
                              trace("[Combat] ERR castSpellFX: could not load class " + spFX.strl);
                           }
                        }
                     }
                     i++;
                  }
               }
            }
            if(cAvt)
            {
               cAvt.pMC.spFX.strl = "";
               cAvt.pMC.canCastSpFX();
            }
         }
         catch(e:*)
         {
            if(cAvt && Boolean(cAvt.pMC))
            {
               cAvt.pMC.clearSpFXQueue();
            }
         }
      }
      
      public function showSpellFXHit(param1:*) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = {};
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
         _loc2_.avts = [param1.tMC.pAV];
         this.castSpellFX(null,_loc2_,null);
      }
      
      public function doCastIA(param1:Object) : void
      {
      }
      
      public function getActionByActID(param1:int) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(param1 < 0)
         {
            return null;
         }
         _loc2_ = null;
         _loc3_ = 0;
         while(_loc3_ < this.actions.active.length)
         {
            if(Boolean(this.actions.active[_loc3_]) && this.actions.active[_loc3_].actID == param1)
            {
               _loc2_ = this.actions.active[_loc3_];
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getActionByRef(param1:String) : Object
      {
         var _loc2_:* = undefined;
         for each(var _loc5_ in this.actions.active)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_ && _loc2_.ref == param1)
            {
               return _loc2_;
            }
         }
         for each(_loc5_ in this.actions.passive)
         {
            _loc2_ = _loc5_;
            _loc5_;
            if(_loc2_.ref == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function handleSAR(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         _loc2_ = {};
         _loc3_ = "";
         _loc4_ = -1;
         var _loc5_:String = "";
         var _loc6_:int = -1;
         if(param1.iRes == 1)
         {
            if(this.rootClass.bAnalyzer)
            {
               if(this.rootClass.bAnalyzer.isRunning)
               {
                  _loc7_ = param1.actionResult.cInf.split(":");
                  _loc8_ = param1.actionResult.tInf.split(":");
                  if(_loc7_[0] == "p")
                  {
                     if(_loc7_[1] == this.rootClass.sfc.myUserId)
                     {
                        if(param1.actionResult.hp >= 0)
                        {
                           this.rootClass.bAnalyzer.addDamage(param1.actionResult.hp);
                        }
                        else
                        {
                           this.rootClass.bAnalyzer.addHeal(param1.actionResult.hp * -1);
                        }
                     }
                  }
                  else if(_loc8_[0] == "p")
                  {
                     if(_loc8_[1] == this.rootClass.sfc.myUserId)
                     {
                        if(param1.actionResult.hp >= 0)
                        {
                           this.rootClass.bAnalyzer.addReceived(param1.actionResult.hp);
                        }
                        else
                        {
                           this.rootClass.bAnalyzer.addHeal(param1.actionResult.hp * -1);
                        }
                     }
                  }
               }
            }
            if(param1.actionResult.typ == "d")
            {
               this.actionResultsAura.push(param1.actionResult);
               _loc2_ = this.rootClass.copyObj(param1.actionResult);
               _loc2_.a = [this.rootClass.copyObj(param1.actionResult)];
            }
            else
            {
               this.aggroMap(param1.actionResult.cInf,param1.actionResult.tInf,param1.actionResult.hp >= 0);
               _loc9_ = param1.actionResult.cInf.split(":");
               _loc10_ = param1.actionResult.tInf.split(":");
               _loc3_ = _loc9_[0];
               _loc4_ = int(_loc9_[1]);
               _loc5_ = _loc10_[0];
               _loc6_ = int(_loc10_[1]);
               _loc2_ = this.rootClass.copyObj(param1.actionResult);
               _loc2_.a = [this.rootClass.copyObj(param1.actionResult)];
               if(_loc3_ == "p" && _loc4_ == this.rootClass.sfc.myUserId)
               {
                  this.showActionResult(_loc2_,_loc2_.actID);
               }
               else
               {
                  this.showIncomingAttackResult(_loc2_);
               }
            }
         }
         if(param1.iRes == 0)
         {
            switch(param1.actionResult.cInf.split(":")[0])
            {
               case "p":
                  this.showActionResult(null,param1.actID);
            }
         }
      }
      
      public function handleSARS(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc2_:Object = {};
         _loc3_ = "";
         _loc4_ = -1;
         var _loc5_:String = "";
         var _loc6_:int = -1;
         _loc7_ = param1.cInf;
         _loc7_ = param1.cInf;
         _loc8_ = _loc7_.split(":");
         _loc3_ = _loc8_[0];
         _loc4_ = int(_loc8_[1]);
         _loc9_ = {};
         if(param1.iRes == 1)
         {
            _loc10_ = [];
            _loc11_ = 0;
            while(_loc11_ < param1.a.length)
            {
               if(this.rootClass.bAnalyzer)
               {
                  if(this.rootClass.bAnalyzer.isRunning)
                  {
                     if(_loc3_ == "p")
                     {
                        if(_loc4_ == this.rootClass.sfc.myUserId)
                        {
                           if(param1.a[_loc11_].hp >= 0)
                           {
                              this.rootClass.bAnalyzer.addDamage(param1.a[_loc11_].hp);
                           }
                           else
                           {
                              this.rootClass.bAnalyzer.addHeal(param1.a[_loc11_].hp * -1);
                           }
                        }
                     }
                     else if(param1.a[_loc11_].tInf.split(":")[0] == "p")
                     {
                        if(param1.a[_loc11_].tInf.split(":")[1] == this.rootClass.sfc.myUserId)
                        {
                           if(param1.a[_loc11_].hp >= 0)
                           {
                              this.rootClass.bAnalyzer.addReceived(param1.a[_loc11_].hp);
                           }
                           else
                           {
                              this.rootClass.bAnalyzer.addHeal(param1.a[_loc11_].hp * -1);
                           }
                        }
                     }
                  }
               }
               _loc9_ = param1.a[_loc11_];
               this.aggroMap(_loc7_,_loc9_.tInf,_loc9_.hp >= 0);
               _loc11_++;
            }
            if(_loc3_ == "p" && _loc4_ == this.rootClass.sfc.myUserId)
            {
               this.showActionResult(this.rootClass.copyObj(param1),param1.actID);
            }
            else
            {
               this.showIncomingAttackResult(this.rootClass.copyObj(param1));
            }
         }
         if(param1.iRes == 0)
         {
            switch(_loc7_.split(":")[0])
            {
               case "p":
                  this.showActionResult(null,param1.actID);
            }
         }
      }
      
      public function isNotAuto(param1:*) : Boolean
      {
         return param1.auto == null || param1.auto != null && param1.auto == false;
      }
      
      public function getActionResult(param1:*, param2:*) : *
      {
         var xtArr:* = undefined;
         var cmd:* = undefined;
         var tgtStr:String = null;
         var tAvt:Avatar = null;
         var i:int = 0;
         var now:Number = NaN;
         var icon:* = undefined;
         var actionObj:* = param1;
         var targets:* = param2;
         xtArr = [];
         cmd = "gar";
         tgtStr = "";
         i = 0;
         xtArr.push(this.actionID);
         if(targets.length > 0)
         {
            i = 0;
            while(i < targets.length)
            {
               tAvt = targets[i].avt;
               if(i > 0)
               {
                  tgtStr = tgtStr + ",";
               }
               tgtStr = tgtStr + (actionObj.ref + ">");
               if(tAvt.npcType == "monster")
               {
                  tgtStr = tgtStr + ("m:" + tAvt.objData.MonMapID);
               }
               if(tAvt.npcType == "player")
               {
                  tgtStr = tgtStr + ("p:" + tAvt.uid);
               }
               i++;
            }
         }
         else
         {
            tgtStr = tgtStr + (actionObj.ref + ">");
         }
         xtArr.push(tgtStr);
         if(actionObj.ref == "i1")
         {
            xtArr.push(actionObj.sArg1);
         }
         xtArr.push("wvz");
         this.rootClass.sfc.sendXtMessage("zm",cmd,xtArr,"str",1);
         if(this.map.getAction != null && this.map.getAction == true)
         {
            try
            {
               this.map.sendAction(actionObj.ref);
            }
            catch(e:Error)
            {
               trace("[Combat] ERR getActionResult sendAction: " + e.message);
            }
         }
         now = Number(new Date().getTime());
         actionObj.lock = true;
         actionObj.actID = this.actionID;
         this.actionID++;
         if(this.actionID > this.actionIDLimit)
         {
            this.actionID = 0;
         }
         actionObj.lastTS = actionObj.ts;
         actionObj.ts = now;
         if(this.isNotAuto(actionObj))
         {
            if(actionObj.ref == "i1")
            {
               this.globalCoolDownExcept(actionObj);
               this.potionAckActID = actionObj.actID;
               this.potionAckTimer.reset();
               this.potionAckTimer.start();
               this.pulseActionIcon(actionObj);
            }
            else
            {
               this.coolDownAct(actionObj);
               this.globalCoolDownExcept(actionObj);
            }
            if(!this.autoActionTimer.running && actionObj.tgt == "h")
            {
               this.testAction(this.getAutoAttack());
            }
         }
         else
         {
            if(this.rootClass.litePreference.data.bSkillCD)
            {
               this.coolDownAct(actionObj);
            }
            else
            {
               i = 0;
               while(i < this.actionMap.length)
               {
                  if(this.actionMap[i] == actionObj.ref)
                  {
                     icon = MovieClip(this.rootClass.ui.mcInterface.actBar.getChildByName("i" + (i + 1)));
                     if(icon.bg.currentLabel != "pulse")
                     {
                        icon.bg.gotoAndPlay("pulse");
                     }
                  }
                  i++;
               }
            }
            this.actionReady = false;
         }
      }
      
      public function showActionResult(param1:*, param2:*) : *
      {
         var dat:* = undefined;
         var actObj:* = undefined;
         var potionAcked:Boolean = false;
         var originTS:* = undefined;
         var returnTS:* = undefined;
         var latency:* = undefined;
         var cd:* = undefined;
         var aacd:* = undefined;
         var actionResult:* = param1;
         var actID:* = param2;
         dat = new Date();
         actObj = this.getActionByActID(actID);
         potionAcked = false;
         if(actObj != null)
         {
            actObj.lock = false;
            actObj.actID = -1;
            if(actObj.ref == "i1" && actID == this.potionAckActID)
            {
               this.potionAckTimer.reset();
               this.potionAckActID = -1;
               potionAcked = true;
               this.stopPulseActionIcon(actObj);
            }
            originTS = actObj.ts;
            returnTS = dat.getTime();
            latency = int((returnTS - originTS) / 2);
            if(actObj.typ == "aa")
            {
               cd = Math.round(actObj.cd * (1 - Math.min(Math.max(this.myAvatar.dataLeaf.sta.$tha,-1),0.5)));
               aacd = cd - int(returnTS - originTS);
               if(aacd > cd)
               {
                  aacd = cd;
               }
               if(aacd < cd - 100)
               {
                  aacd = cd - 100;
               }
               this.autoActionTimer.delay = aacd;
               this.autoActionTimer.reset();
               this.autoActionTimer.start();
            }
            if(actionResult == null)
            {
               actObj.ts = actObj.lastTS;
               if(potionAcked)
               {
                  this.rootClass.chatF.pushMsg("warning","Your potion could not be used. Please try again.","SERVER","",0);
               }
            }
            else
            {
               actObj.ts = Math.max(int(returnTS - latency),originTS + this.minLatencyOneWay);
               this.unlockActionsExcept(actObj);
               this.rootClass.updateActionObjIcon(actObj);
               if(actObj.ref == "i1")
               {
                  this.coolDownAct(actObj);
               }
            }
         }
         if(actionResult != null)
         {
            this.playActionSound(actionResult);
            if(actionResult.type != "none")
            {
               try
               {
                  if(this.actionResults.length > 30)
                  {
                     this.actionResults.shift();
                  }
               }
               catch(e:Error)
               {
                  trace("[Combat] ERR showActionResult: " + e.message);
               }
               this.actionResults.push(actionResult);
            }
         }
      }
      
      public function onPotionAckTimeout(param1:TimerEvent) : void
      {
         var _loc2_:Object = null;
         if(this.potionAckActID < 0)
         {
            return;
         }
         _loc2_ = this.getActionByRef("i1");
         if(_loc2_ != null)
         {
            if(Boolean(_loc2_.lock) && _loc2_.actID == this.potionAckActID)
            {
               _loc2_.lock = false;
               _loc2_.ts = _loc2_.lastTS;
               _loc2_.actID = -1;
               this.rootClass.updateActionObjIcon(_loc2_);
               this.rootClass.chatF.pushMsg("warning","Your potion could not be used. Please try again.","SERVER","",0);
            }
            this.stopPulseActionIcon(_loc2_);
         }
         this.potionAckActID = -1;
      }
      
      public function showIncomingAttackResult(param1:Object) : void
      {
         this.playActionSound(param1);
         this.actionResultsMon.push(param1);
      }
      
      public function playActionSound(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1.a.length > 0 && param1.a[0].type != null)
         {
            _loc2_ = param1.a[0];
            switch(_loc2_.type)
            {
               case "hit":
                  if(_loc2_.hp >= 0)
                  {
                     if(Math.random() < 0.5)
                     {
                        this.rootClass.mixer.playSound("Hit1");
                     }
                     else
                     {
                        this.rootClass.mixer.playSound("Hit2");
                     }
                  }
                  else
                  {
                     this.rootClass.mixer.playSound("Heal");
                  }
                  break;
               case "crit":
                  if(_loc2_.hp >= 0)
                  {
                     this.rootClass.mixer.playSound("Hit3");
                  }
                  else
                  {
                     this.rootClass.mixer.playSound("Heal");
                  }
                  break;
               case "miss":
                  this.rootClass.mixer.playSound("Miss");
                  break;
               case "none":
                  this.rootClass.mixer.playSound("Good");
            }
         }
      }
      
      public function showActionImpact(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc8_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:TextFormat = null;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:Object = null;
         var _loc15_:Array = null;
         var _loc16_:Avatar = null;
         if(this.rootClass.litePreference.data.bDisDmgDisplay)
         {
            return;
         }
         _loc3_ = null;
         _loc4_ = null;
         _loc5_ = "";
         _loc6_ = 0;
         var _loc7_:Array = ["GOOD","GREAT!","MASSIVE!!"];
         _loc8_ = [16777215,16777215,16777215];
         var _loc9_:Array = [2381688,0,0];
         _loc10_ = 0;
         _loc11_ = new TextFormat();
         _loc12_ = 0;
         _loc13_ = param1.a;
         _loc14_ = {};
         _loc12_ = 0;
         while(_loc12_ < _loc13_.length)
         {
            _loc14_ = _loc13_[_loc12_];
            _loc15_ = _loc14_.tInf.split(":");
            _loc5_ = _loc15_[0];
            _loc6_ = int(_loc15_[1]);
            switch(_loc5_)
            {
               case "p":
                  if(this.avatars[_loc6_] != null)
                  {
                     _loc2_ = this.avatars[_loc6_].pMC;
                  }
                  break;
               case "m":
                  _loc16_ = this.getMonster(_loc6_);
                  if(_loc16_ != null)
                  {
                     _loc2_ = _loc16_.pMC;
                  }
            }
            if(_loc2_ != null && _loc2_.pAV != null && _loc2_.pAV.dataLeaf != null)
            {
               switch(_loc14_.type)
               {
                  case "hit":
                     _loc4_ = new hitDisplay();
                     _loc4_.t.ti.autoSize = "center";
                     if(_loc14_.hp >= 0)
                     {
                        _loc10_ = 0;
                        _loc4_.t.ti.text = _loc14_.hp;
                        _loc4_.t.ti.textColor = _loc8_[_loc10_];
                        _loc4_.t.ti.filters = [this.dmgGlowHit];
                        _loc4_.t.ti.setTextFormat(_loc11_);
                     }
                     else
                     {
                        _loc4_.t.ti.text = "+" + -_loc14_.hp + "+";
                        _loc4_.t.ti.textColor = 65450;
                     }
                     this.wound(_loc2_,"damage");
                     break;
                  case "crit":
                     _loc4_ = new critDisplay();
                     _loc4_.t.ti.autoSize = "center";
                     if(_loc14_.hp > 0)
                     {
                        _loc4_.t.ti.text = _loc14_.hp;
                        _loc4_.t.ti.textColor = 16750916;
                        _loc4_.t.ti.filters = [this.dmgGlowCrit];
                     }
                     else
                     {
                        _loc4_.t.ti.text = -_loc14_.hp;
                        _loc4_.t.ti.textColor = 65450;
                     }
                     this.wound(_loc2_,"damage");
                     break;
                  case "miss":
                     _loc4_ = new avoidDisplay();
                     _loc4_.t.ti.text = "Miss!";
                     break;
                  case "dodge":
                     _loc4_ = new avoidDisplay();
                     _loc4_.t.ti.text = "Dodge!";
                     if(this.isMoveOK(_loc2_.pAV.dataLeaf))
                     {
                        _loc2_.queueAnim("Dodge");
                     }
                     break;
                  case "parry":
                     _loc4_ = new avoidDisplay();
                     _loc4_.t.ti.text = "Parry!";
                     if(this.isMoveOK(_loc2_.pAV.dataLeaf))
                     {
                        _loc2_.queueAnim("Dodge");
                     }
                     break;
                  case "block":
                     _loc4_ = new avoidDisplay();
                     _loc4_.t.ti.text = "Block!";
                     if(this.isMoveOK(_loc2_.pAV.dataLeaf))
                     {
                        _loc2_.queueAnim("Block");
                     }
                     break;
                  case "none":
               }
               if(_loc4_ != null)
               {
                  _loc2_.addChild(_loc4_);
                  _loc4_.x = _loc2_.mcChar.x;
                  _loc4_.y = _loc2_.pname.y + 10;
               }
               if(_loc3_ != null)
               {
                  _loc2_.addChild(_loc3_);
                  _loc3_.x = _loc2_.mcChar.x;
                  _loc3_.y = _loc2_.pname.y + _loc2_.mcChar.height / 2;
               }
            }
            _loc12_++;
         }
      }
      
      public function showAuraImpact(param1:*) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this.rootClass.litePreference.data.bDisDmgDisplay)
         {
            return;
         }
         _loc3_ = param1.tInf.split(":");
         _loc4_ = _loc3_[0];
         _loc5_ = int(_loc3_[1]);
         _loc6_ = null;
         switch(_loc4_)
         {
            case "p":
               if(this.avatars[_loc5_] != null && "pMC" in this.avatars[_loc5_] && this.avatars[_loc5_].pMC != null)
               {
                  _loc2_ = this.avatars[_loc5_].pMC;
               }
               break;
            case "m":
               if(this.getMonster(_loc5_) != null && "pMC" in this.getMonster(_loc5_) && this.getMonster(_loc5_).pMC != null)
               {
                  _loc2_ = this.getMonster(_loc5_).pMC;
               }
         }
         if(_loc2_ != null)
         {
            _loc6_ = new dotDisplay();
            _loc6_.hpDisplay = param1.hp;
            _loc6_.init();
            _loc2_.addChild(_loc6_);
            _loc6_.x = _loc2_.mcChar.x;
            _loc6_.y = _loc2_.pname.y + 10;
         }
      }
      
      public function showAuraChange(param1:Object, param2:Avatar, param3:Object) : *
      {
         var tMC:MovieClip = null;
         var actionDamage:* = undefined;
         var cLeaf:Object = null;
         var i:int = 0;
         var nc:int = 0;
         var gap:int = 0;
         var child:DisplayObject = null;
         var cTyp:String = null;
         var cID:int = 0;
         var tTyp:String = null;
         var tID:int = 0;
         var aura:Object = null;
         var existingAura:Object = null;
         var dateObj:Date = null;
         var isOK:Boolean = false;
         var tFilters:Array = null;
         var tFilter:* = undefined;
         var cInfParts2:Array = null;
         var auras:* = undefined;
         var sCatA:String = null;
         var ai:* = undefined;
         var actObj:* = undefined;
         var icon1:* = undefined;
         var sCatR:String = null;
         var filterIndex:int = 0;
         var resObj:Object = param1;
         var tAvt:Avatar = param2;
         var tLeaf:Object = param3;
         tMC = tAvt.pMC;
         actionDamage = null;
         var cAvt:Avatar = null;
         cLeaf = null;
         if(tMC != null)
         {
            i = 0;
            nc = tMC.numChildren;
            gap = 1;
            if(resObj.cInf != null)
            {
               cInfParts2 = resObj.cInf.split(":");
               cTyp = String(cInfParts2[0]);
               cID = int(cInfParts2[1]);
               switch(cTyp)
               {
                  case "p":
                     cAvt = this.getAvatarByUserID(cID);
                     cLeaf = this.getUoLeafById(cID);
                     break;
                  case "m":
                     cAvt = this.getMonster(cID);
                     cLeaf = this.monTree[cID];
               }
            }
            if(resObj.auras != null)
            {
               gap = int(resObj.auras.length);
            }
            i = 0;
            while(i < nc)
            {
               child = tMC.getChildAt(i);
               if(child != null && child.toString() != null && child.toString().indexOf("auraDisplay") > -1)
               {
                  child.y = child.y - int(child.height + 3) * gap;
               }
               i++;
            }
            aura = {};
            existingAura = {};
            dateObj = new Date();
            isOK = true;
            if(tLeaf.auras == null)
            {
               tLeaf.auras = [];
            }
            if(tLeaf.passives == null)
            {
               tLeaf.passives = [];
            }
            switch(resObj.cmd)
            {
               case "aura+":
               case "aura++":
               case "aura+p":
                  i = 0;
                  while(i < resObj.auras.length)
                  {
                     aura = resObj.auras[i];
                     if(cLeaf != null)
                     {
                        aura.casterType = cLeaf.MonID != null ? "m" : "p";
                        aura.casterId = cLeaf.MonID != null ? cLeaf.MonMapID : cLeaf.entID;
                     }
                     else
                     {
                        aura.casterType = null;
                        aura.casterId = null;
                     }
                     if(resObj.cmd == "aura+p")
                     {
                        aura.passive = true;
                     }
                     else
                     {
                        aura.passive = false;
                     }
                     if(!aura.passive)
                     {
                        if(aura.t != null)
                        {
                           aura.ts = dateObj.getTime();
                        }
                        if(tAvt == this.myAvatar || tAvt == this.myAvatar.target || tLeaf.targets != null && tLeaf.targets[this.rootClass.sfc.myUserId] != null || resObj.cmd == "aura++")
                        {
                           if(aura.potionType != null)
                           {
                              if(aura.potionType.toLowerCase() == "tonic")
                              {
                                 tAvt.objData.Tonic = true;
                              }
                              if(aura.potionType.toLowerCase() == "elixir")
                              {
                                 tAvt.objData.Elixir = true;
                              }
                           }
                           if(aura.nam == "Safeguard")
                           {
                              if(tAvt == this.myAvatar)
                              {
                                 this.rootClass.ui.mcPortrait.HP.strIntHP.text = String(tAvt.dataLeaf.intHP) + " +" + String(aura.val);
                              }
                              if(tAvt == this.myAvatar.target)
                              {
                                 this.rootClass.ui.mcPortraitTarget.HP.strIntHP.text = String(tAvt.dataLeaf.intHP) + " +" + String(aura.val);
                              }
                              tAvt.dataLeaf.intSG = aura.val;
                           }
                           if(aura.nam == "Skill Locked")
                           {
                              ai = 0;
                              while(ai < this.actions.active.length)
                              {
                                 actObj = this.actions.active[ai];
                                 if(actObj)
                                 {
                                    if(actObj.nam == aura.val)
                                    {
                                       icon1 = this.rootClass.ui.mcInterface.actBar.getChildByName("i" + (ai + 1));
                                       icon1.actObj.skillLock = true;
                                    }
                                 }
                                 ai++;
                              }
                           }
                           if(!(Boolean(this.rootClass.litePreference.data.bAuras) && Boolean(this.rootClass.litePreference.data.dOptions["disAuraText"])))
                           {
                              actionDamage = new auraDisplay();
                              actionDamage.t.ti.text = aura.nam + "!";
                              if(aura.nam == "Spirit Power")
                              {
                                 actionDamage.t.ti.text = aura.nam + " " + aura.val;
                              }
                              tMC.addChild(actionDamage);
                              actionDamage.x = tMC.mcChar.scaleX < 0 ? 35 : -actionDamage.t.ti.textWidth - 35;
                              actionDamage.y = tMC.pname.y + 25 + (actionDamage.height + 3) * i;
                           }
                           if(aura.fx != null)
                           {
                              if(!this.rootClass.litePreference.data.bDisAuraAnim || this.rootClass.litePreference.data.bDisAuraAnim && tAvt == this.myAvatar && Boolean(this.rootClass.litePreference.data.dOptions["auraAnimSelf"]))
                              {
                                 this.addAuraFX(tMC,aura.fx);
                              }
                           }
                        }
                        if(aura.s != null)
                        {
                           switch(aura.s)
                           {
                              case "s":
                                 if(tMC.mcChar.currentLabel != "Fall")
                                 {
                                    tMC.clearQueue();
                                    tMC.mcChar.gotoAndPlay("Fall");
                                 }
                           }
                        }
                        sCatA = this.auraCatOf(aura);
                        if(sCatA != "")
                        {
                           isOK = true;
                           for each(var _loc7_ in tLeaf.auras)
                           {
                              existingAura = _loc7_;
                              _loc7_;
                              try
                              {
                                 if(existingAura != aura && this.auraCatOf(existingAura) == sCatA)
                                 {
                                    if(sCatA == "stone" || sCatA == "paralyze")
                                    {
                                       if(existingAura.catTinted == true)
                                       {
                                          isOK = false;
                                       }
                                    }
                                    else
                                    {
                                       isOK = false;
                                    }
                                 }
                              }
                              catch(e:Error)
                              {
                                 trace("[Combat] ERR applyAuras: " + e);
                              }
                           }
                           if(isOK)
                           {
                              switch(sCatA)
                              {
                                 case "paralyze":
                                 case "stone":
                                    try
                                    {
                                       if("stopWalking" in tMC && tMC.stopWalking is Function)
                                       {
                                          tMC.stopWalking();
                                       }
                                    }
                                    catch(eSW:Error)
                                    {
                                    }
                                    tMC.modulateColor(this.statusStoneCT,"+");
                                    tMC.mcChar.stop();
                                    aura.catTinted = true;
                                    break;
                                 case "clean":
                                    tFilters = tMC.mcChar.filters;
                                    tFilters.push(this.dmgGlowClean);
                                    tMC.mcChar.filters = tFilters;
                              }
                           }
                        }
                        if(aura.animOn != null && (cLeaf == null || cLeaf.intState == 2))
                        {
                           if(aura.animOn.indexOf("fadeFX:") > -1)
                           {
                              this.removeAuraFX(tMC,aura.animOn.split(":")[1],"fade");
                           }
                           else if(aura.animOn.indexOf("useFX:") > -1)
                           {
                              this.removeAuraFX(tMC,aura.animOn.split(":")[1],"use");
                           }
                           else if(aura.animOn.indexOf("removeFX:") > -1)
                           {
                              this.removeAuraFX(tMC,aura.animOn.split(":")[1]);
                           }
                           else
                           {
                              tMC.mcChar.gotoAndPlay(aura.animOn);
                           }
                        }
                        if(aura.msgOn != null)
                        {
                           if(aura.msgOn.charAt(0) == "@")
                           {
                              if(tAvt == this.myAvatar)
                              {
                                 this.rootClass.addUpdate(aura.msgOn.substr(1));
                              }
                           }
                           else
                           {
                              this.rootClass.addUpdate(aura.msgOn);
                           }
                        }
                        if(aura.isNew)
                        {
                           tLeaf.auras.push(aura);
                        }
                        else
                        {
                           this.updateAuraData(cLeaf,aura,tLeaf);
                        }
                     }
                     else
                     {
                        tLeaf.passives.push(aura);
                     }
                     i++;
                  }
                  break;
               case "aura-":
               case "aura--":
                  auras = [];
                  if(resObj.auras != null)
                  {
                     auras = resObj.auras;
                  }
                  else if(resObj.aura != null)
                  {
                     auras = [resObj.aura];
                  }
                  i = 0;
                  while(i < auras.length)
                  {
                     aura = auras[i];
                     if(this.removeAura(aura,tLeaf,tMC))
                     {
                        if(tAvt == this.myAvatar || tAvt == this.myAvatar.target || tLeaf.targets != null && tLeaf.targets[this.rootClass.sfc.myUserId] != null || resObj.cmd == "aura--")
                        {
                           if(!(Boolean(this.rootClass.litePreference.data.bAuras) && Boolean(this.rootClass.litePreference.data.dOptions["disAuraText"])))
                           {
                              actionDamage = new auraDisplay();
                              actionDamage.t.ti.text = "*" + aura.nam + " fades*";
                              actionDamage.t.ti.textColor = 10066329;
                              tMC.addChild(actionDamage);
                              actionDamage.x = tMC.mcChar.scaleX < 0 ? 35 : -actionDamage.t.ti.textWidth - 35;
                              actionDamage.y = tMC.pname.y + 25;
                           }
                        }
                        if(aura.potionType != null)
                        {
                           if(aura.potionType.toLowerCase() == "tonic")
                           {
                              tAvt.objData.Tonic = false;
                           }
                           if(aura.potionType.toLowerCase() == "elixir")
                           {
                              tAvt.objData.Elixir = false;
                           }
                        }
                        if(aura.nam == "Safeguard")
                        {
                           if(tAvt == this.myAvatar)
                           {
                              this.rootClass.ui.mcPortrait.HP.strIntHP.text = String(tAvt.dataLeaf.intHP);
                           }
                           if(tAvt == this.myAvatar.target)
                           {
                              this.rootClass.ui.mcPortraitTarget.HP.strIntHP.text = String(tAvt.dataLeaf.intHP);
                           }
                           tAvt.dataLeaf.intSG = 0;
                        }
                        if(aura.s != null)
                        {
                           switch(aura.s)
                           {
                              case "s":
                                 if(tMC.mcChar.currentLabel == "Fall")
                                 {
                                    if(this.isStatusGone("s",tLeaf))
                                    {
                                       tMC.mcChar.gotoAndPlay("Getup");
                                    }
                                 }
                           }
                        }
                        sCatR = this.auraCatOf(aura);
                        if(sCatR != "")
                        {
                           isOK = true;
                           for each(_loc7_ in tLeaf.auras)
                           {
                              existingAura = _loc7_;
                              _loc7_;
                              try
                              {
                                 if(this.auraCatOf(existingAura) == sCatR)
                                 {
                                    isOK = false;
                                    if(aura.catTinted == true && existingAura.catTinted != true)
                                    {
                                       existingAura.catTinted = true;
                                       aura.catTinted = false;
                                    }
                                 }
                              }
                              catch(e:Error)
                              {
                                 trace("[Combat] ERR applyAuras: " + e.message);
                              }
                           }
                           if(isOK)
                           {
                              switch(sCatR)
                              {
                                 case "paralyze":
                                 case "stone":
                                    if(aura.catTinted == true)
                                    {
                                       tMC.modulateColor(this.statusStoneCT,"-");
                                       tMC.mcChar.play();
                                    }
                                    break;
                                 case "clean":
                                    tFilters = tMC.mcChar.filters;
                                    filterIndex = 0;
                                    while(filterIndex < tFilters.length)
                                    {
                                       tFilter = tFilters[filterIndex];
                                       if(tFilter is GlowFilter && GlowFilter(tFilter).color == 16777215)
                                       {
                                          tFilters.splice(filterIndex,1);
                                          filterIndex--;
                                       }
                                       filterIndex++;
                                    }
                                    tMC.mcChar.filters = tFilters;
                              }
                           }
                        }
                        if(aura.nam == "Skill Locked")
                        {
                           ai = 0;
                           while(ai < this.actions.active.length)
                           {
                              actObj = this.actions.active[ai];
                              if(actObj)
                              {
                                 if(actObj.nam == aura.val)
                                 {
                                    icon1 = this.rootClass.ui.mcInterface.actBar.getChildByName("i" + (ai + 1));
                                    icon1.actObj.skillLock = false;
                                    icon1.cnt.alpha = 1;
                                 }
                              }
                              ai++;
                           }
                        }
                        if(aura.animOff != null)
                        {
                           tMC.mcChar.gotoAndPlay(aura.animOff);
                        }
                        if(aura.msgOff != null)
                        {
                           if(aura.msgOff.charAt(0) == "@")
                           {
                              if(tAvt == this.myAvatar)
                              {
                                 this.rootClass.addUpdate(aura.msgOff.substr(1));
                              }
                           }
                           else
                           {
                              this.rootClass.addUpdate(aura.msgOff);
                           }
                        }
                     }
                     i++;
                  }
                  break;
               case "aura*":
                  actionDamage = new auraDisplay();
                  actionDamage.t.ti.text = "* IMMUNE *";
                  tMC.addChild(actionDamage);
                  actionDamage.x = tMC.mcChar.scaleX < 0 ? 35 : -actionDamage.t.ti.textWidth - 35;
                  actionDamage.y = tMC.pname.y + 25 + (actionDamage.height + 3) * i;
            }
         }
      }
      
      private function auraDataOnly(param1:Object, param2:Object, param3:Object = null) : void
      {
         var i:int = 0;
         var j:int = 0;
         var aura:Object = null;
         var dateObj:Date = null;
         var rem:Array = null;
         var resObj:Object = param1;
         var tLeaf:Object = param2;
         var cLeaf:Object = param3;
         if(tLeaf == null || resObj == null)
         {
            return;
         }
         try
         {
            if(tLeaf.auras == null)
            {
               tLeaf.auras = [];
            }
            if(tLeaf.passives == null)
            {
               tLeaf.passives = [];
            }
            dateObj = new Date();
            switch(resObj.cmd)
            {
               case "aura+":
               case "aura++":
                  if(resObj.auras == null)
                  {
                     return;
                  }
                  i = 0;
                  while(i < resObj.auras.length)
                  {
                     aura = resObj.auras[i];
                     aura.passive = false;
                     if(cLeaf != null)
                     {
                        aura.casterType = cLeaf.MonID != null ? "m" : "p";
                        aura.casterId = cLeaf.MonID != null ? cLeaf.MonMapID : cLeaf.entID;
                     }
                     else
                     {
                        aura.casterType = null;
                        aura.casterId = null;
                     }
                     if(aura.t != null)
                     {
                        aura.ts = dateObj.getTime();
                     }
                     if(aura.isNew)
                     {
                        tLeaf.auras.push(aura);
                     }
                     else
                     {
                        this.updateAuraData(cLeaf,aura,tLeaf);
                     }
                     i++;
                  }
                  break;
               case "aura+p":
                  if(resObj.auras == null)
                  {
                     return;
                  }
                  i = 0;
                  while(i < resObj.auras.length)
                  {
                     aura = resObj.auras[i];
                     aura.passive = true;
                     if(cLeaf != null)
                     {
                        aura.casterType = cLeaf.MonID != null ? "m" : "p";
                        aura.casterId = cLeaf.MonID != null ? cLeaf.MonMapID : cLeaf.entID;
                     }
                     else
                     {
                        aura.casterType = null;
                        aura.casterId = null;
                     }
                     tLeaf.passives.push(aura);
                     i++;
                  }
                  break;
               case "aura-":
               case "aura--":
                  rem = resObj.auras != null ? resObj.auras : (resObj.aura != null ? [resObj.aura] : []);
                  i = 0;
                  while(i < rem.length)
                  {
                     j = 0;
                     while(j < tLeaf.auras.length)
                     {
                        if(tLeaf.auras[j] != null && tLeaf.auras[j].nam == rem[i].nam)
                        {
                           tLeaf.auras.splice(j,1);
                           break;
                        }
                        j++;
                     }
                     j = 0;
                     while(j < tLeaf.passives.length)
                     {
                        if(tLeaf.passives[j] != null && tLeaf.passives[j].nam == rem[i].nam)
                        {
                           tLeaf.passives.splice(j,1);
                           break;
                        }
                        j++;
                     }
                     i++;
                  }
            }
         }
         catch(eDO:Error)
         {
            trace("[Combat] ERR auraDataOnly: " + eDO.message);
         }
      }
      
      public function updateAuraData(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:Object = null;
         _loc4_ = param1 != null && param1.MonID != null ? "m" : "p";
         _loc5_ = param1 != null ? (param1.MonID != null ? param1.MonMapID : param1.entID) : null;
         for each(var _loc9_ in param3.auras)
         {
            _loc6_ = _loc9_;
            _loc9_;
            if(_loc6_.nam == param2.nam && _loc6_.casterType == _loc4_ && _loc6_.casterId == _loc5_)
            {
               _loc6_.dur = param2.dur;
               _loc6_.val = param2.val;
            }
         }
      }
      
      public function handleAuraEvent(param1:String, param2:Object) : void
      {
         var ntp:Array = null;
         var ncl:Object = null;
         var ncp:Array = null;
         var cLeaf:Object = null;
         var tLeaf:Object = null;
         var cAvt:Avatar = null;
         var tAvt:Avatar = null;
         var cTyp:String = null;
         var cID:int = 0;
         var tTyp:String = null;
         var tID:int = 0;
         var forceAura:Boolean = false;
         var cInfParts3:Array = null;
         var tInfParts2:Array = null;
         var cmd:String = param1;
         var resObj:Object = param2;
         if(!this.rootClass.sfcSocial)
         {
            try
            {
               if(resObj.tInf != null)
               {
                  ntp = resObj.tInf.split(":");
                  ncl = null;
                  if(resObj.cInf != null)
                  {
                     ncp = resObj.cInf.split(":");
                     ncl = String(ncp[0]) == "m" ? this.monTree[int(ncp[1])] : this.getUoLeafById(int(ncp[1]));
                  }
                  this.auraDataOnly(resObj,String(ntp[0]) == "m" ? this.monTree[int(ntp[1])] : this.getUoLeafById(int(ntp[1])),ncl);
               }
            }
            catch(eNS:Error)
            {
            }
            return;
         }
         if(this.rootClass.sfcSocial)
         {
            forceAura = false;
            if(cmd.indexOf("++") > -1 || cmd.indexOf("--") > -1)
            {
               forceAura = true;
            }
            cAvt = null;
            tAvt = null;
            if(resObj.cInf != null)
            {
               cInfParts3 = resObj.cInf.split(":");
               cTyp = String(cInfParts3[0]);
               cID = int(cInfParts3[1]);
               switch(cTyp)
               {
                  case "p":
                     cAvt = this.getAvatarByUserID(cID);
                     cLeaf = this.getUoLeafById(cID);
                     break;
                  case "m":
                     cAvt = this.getMonster(cID);
                     cLeaf = this.monTree[cID];
               }
            }
            if(resObj.tInf != null)
            {
               tInfParts2 = resObj.tInf.split(":");
               tTyp = String(tInfParts2[0]);
               tID = int(tInfParts2[1]);
               switch(tTyp)
               {
                  case "p":
                     try
                     {
                        tAvt = this.getAvatarByUserID(tID);
                        tLeaf = this.getUoLeafById(tID);
                        if(forceAura || tLeaf.strFrame == this.strFrame)
                        {
                           if(this.rootClass.sfcSocial && tAvt != null && tAvt.pMC != null)
                           {
                              this.showAuraChange(resObj,tAvt,tLeaf);
                           }
                           else
                           {
                              this.auraDataOnly(resObj,tLeaf,cLeaf);
                           }
                        }
                     }
                     catch(e:Error)
                     {
                        trace("[Combat] ERR handleAuraEvent player: " + e.message);
                     }
                     break;
                  case "m":
                     try
                     {
                        tAvt = this.getMonster(tID);
                        tLeaf = this.monTree[tID];
                        if(forceAura || (cLeaf == null || cLeaf.targets[tID] != null && tLeaf.strFrame == this.strFrame))
                        {
                           if(this.rootClass.sfcSocial && tAvt != null && tAvt.pMC != null)
                           {
                              this.showAuraChange(resObj,tAvt,tLeaf);
                           }
                           else
                           {
                              this.auraDataOnly(resObj,tLeaf,cLeaf);
                           }
                        }
                     }
                     catch(e:Error)
                     {
                        trace("[Combat] ERR handleAuraEvent monster: " + e.message);
                     }
               }
            }
         }
      }
      
      public function removeAura(param1:Object, param2:Object, param3:MovieClip) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         if(this.rootClass.sfcSocial)
         {
            _loc4_ = false;
            _loc5_ = 0;
            _loc5_ = 0;
            while(_loc5_ < param2.auras.length)
            {
               if(param2.auras[_loc5_].nam == param1.nam)
               {
                  if(param3 != null && param2.auras[_loc5_].fx != null)
                  {
                     this.removeAuraFX(param3,param2.auras[_loc5_].fx,"fade");
                  }
                  if(param2.auras[_loc5_].catTinted == true)
                  {
                     param1.catTinted = true;
                  }
                  param2.auras.splice(_loc5_,1);
                  _loc5_ = int(param2.auras.length);
                  _loc4_ = true;
               }
               _loc5_++;
            }
            _loc5_ = 0;
            while(_loc5_ < param2.passives.length)
            {
               if(param2.passives[_loc5_].nam == param1.nam)
               {
                  param2.passives.splice(_loc5_,1);
                  _loc5_ = int(param2.passives.length);
                  _loc4_ = false;
               }
               _loc5_++;
            }
            return _loc4_;
         }
         return false;
      }
      
      public function addAuraFX(param1:MovieClip, param2:String) : void
      {
         var c:Class = null;
         var fx:MovieClip = null;
         var tMC:MovieClip = param1;
         var fxName:String = param2;
         try
         {
            if(tMC.fx.getChildByName(fxName) == null)
            {
               c = this.getClass(fxName);
               fx = MovieClip(tMC.fx.addChild(new c()));
               fx.name = fxName;
               fx.y = -30;
            }
         }
         catch(e:Error)
         {
            trace("[Combat] ERR addAuraFX: " + fxName + " " + e.message);
         }
      }
      
      public function removeAuraFX(param1:MovieClip, param2:String, param3:String = null) : void
      {
         var i:int = 0;
         var fx:MovieClip = null;
         var tMC:MovieClip = param1;
         var fxName:String = param2;
         var fxLabel:String = param3;
         i = 0;
         i = 0;
         while(i < tMC.fx.numChildren)
         {
            fx = MovieClip(tMC.fx.getChildAt(i));
            if(fxName == "all" || fx.name == fxName)
            {
               if(fxLabel != null)
               {
                  try
                  {
                     MovieClip(fx.getChildByName("inner")).gotoAndPlay(fxLabel);
                  }
                  catch(fxe:Error)
                  {
                     trace("[Combat] ERR removeAuraFX: " + fxName + " " + fxe.message);
                  }
               }
               else
               {
                  MovieClip(tMC.fx.removeChildAt(i)).stop();
                  i--;
               }
            }
            i++;
         }
      }
      
      public function isStatusGone(param1:String, param2:Object) : Boolean
      {
         var _loc3_:* = undefined;
         _loc3_ = 0;
         while(_loc3_ < param2.auras.length)
         {
            if(param2.auras[_loc3_].s != null && param2.auras[_loc3_].s == param1)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function isMoveOK(param1:Object) : Boolean
      {
         var isOK:Boolean = false;
         var aura:Object = null;
         var sCatM:String = null;
         var tLeaf:Object = param1;
         isOK = true;
         aura = {};
         if(tLeaf.auras != null)
         {
            for each(var _loc5_ in tLeaf.auras)
            {
               aura = _loc5_;
               _loc5_;
               try
               {
                  sCatM = this.auraCatOf(aura);
                  if(sCatM == "stun" || sCatM == "stone" || sCatM == "paralyze" || sCatM == "disable" || sCatM == "disabled")
                  {
                     isOK = false;
                  }
               }
               catch(e:Error)
               {
                  trace("[Combat] ERR isMoveOK: " + e.message);
               }
            }
            return isOK;
         }
         return false;
      }
      
      public function wound(param1:*, param2:*) : *
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         if(this.rootClass.litePreference.data.bDisDmgStrobe)
         {
            return;
         }
         if(param2 == "damage")
         {
            _loc3_ = param1.getChildByName("flickermc") as MovieClip;
            if(_loc3_ != null)
            {
               _loc3_.removeEventListener(Event.ENTER_FRAME,this.flickerFrame);
               if(_loc3_.whiteApplied)
               {
                  param1.modulateColor(this.avtWCT,"-");
               }
               param1.removeChild(_loc3_);
            }
            _loc4_ = new MovieClip();
            _loc4_.name = "flickermc";
            _loc4_.maxF = 3;
            _loc4_.curF = 0;
            _loc4_.whiteApplied = false;
            _loc4_.addEventListener(Event.ENTER_FRAME,this.flickerFrame,false,0,true);
            param1.addChild(_loc4_);
         }
      }
      
      public function flickerFrame(param1:Event) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = MovieClip(param1.currentTarget);
         if(_loc2_.parent != null && _loc2_.parent.stage != null)
         {
            if(_loc2_.curF == 0)
            {
               _loc2_.parent.modulateColor(this.avtWCT,"+");
               _loc2_.whiteApplied = true;
            }
            if(_loc2_.curF == 1)
            {
               _loc2_.parent.modulateColor(this.avtWCT,"-");
               _loc2_.whiteApplied = false;
            }
            if(_loc2_.curF == 2)
            {
               _loc2_.parent.modulateColor(this.avtWCT,"+");
               _loc2_.whiteApplied = true;
            }
            if(_loc2_.curF >= _loc2_.maxF)
            {
               _loc2_.parent.modulateColor(this.avtWCT,"-");
               _loc2_.whiteApplied = false;
               _loc2_.removeEventListener(Event.ENTER_FRAME,this.flickerFrame);
               _loc2_.parent.removeChild(_loc2_);
            }
            _loc2_.curF++;
         }
         else
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.flickerFrame);
         }
      }
      
      public function unlockActionsExcept(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         _loc2_ = [];
         _loc3_ = 0;
         _loc3_ = 0;
         while(_loc3_ < this.actions.active.length)
         {
            _loc5_ = this.actions.active[_loc3_];
            if(_loc5_)
            {
               if(_loc5_.ref != param1.ref && _loc5_.lock == true && _loc5_.ts < param1.ts)
               {
                  _loc6_ = 0;
                  while(_loc6_ < this.actionMap.length)
                  {
                     if(this.actionMap[_loc6_] == _loc5_.ref)
                     {
                        _loc2_.push("i" + (_loc6_ + 1));
                     }
                     _loc6_++;
                  }
               }
            }
            _loc3_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc7_ = this.rootClass.ui.mcInterface.actBar.getChildByName(_loc2_[_loc4_]);
            if(_loc7_.actObj != null)
            {
               _loc7_.actObj.lock = false;
            }
            _loc4_++;
         }
      }
      
      public function unlockActions() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         _loc1_ = 0;
         while(_loc1_ < this.actions.active.length)
         {
            _loc2_ = this.actions.active[_loc1_];
            if(_loc2_)
            {
               _loc2_.lock = false;
            }
            _loc1_++;
         }
      }
      
      public function updateActBar() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.myAvatar != null && this.myAvatar.dataLeaf != null && this.myAvatar.dataLeaf.sta != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.rootClass.ui.mcInterface.actBar.numChildren)
            {
               _loc2_ = this.rootClass.ui.mcInterface.actBar.getChildAt(_loc1_);
               if("actObj" in _loc2_ && _loc2_.actObj != null)
               {
                  _loc3_ = _loc2_.actObj.skillLock;
                  _loc3_ = _loc3_ == null ? false : _loc3_;
                  if(this.myAvatar.dataLeaf.intMP >= Math.round(_loc2_.actObj.mp * this.myAvatar.dataLeaf.sta["$cmc"]) && !_loc3_)
                  {
                     if(_loc2_.cnt.alpha < 1)
                     {
                        _loc2_.cnt.alpha = 1;
                     }
                  }
                  else if(_loc2_.cnt.alpha == 1)
                  {
                     _loc2_.cnt.alpha = 0.4;
                  }
               }
               _loc1_++;
            }
         }
      }
      
      public function getActIcons(param1:Object) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:* = undefined;
         _loc2_ = [];
         _loc4_ = 0;
         while(_loc4_ < this.actionMap.length)
         {
            if(this.actionMap[_loc4_] == param1.ref)
            {
               _loc3_ = this.rootClass.ui.mcInterface.actBar.getChildByName("i" + (_loc4_ + 1)) as MovieClip;
               if(_loc3_ != null)
               {
                  _loc2_.push(_loc3_);
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function pulseActionIcon(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         _loc2_ = this.getActIcons(param1);
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_ != null && "bg" in _loc4_ && _loc4_.bg != null && _loc4_.bg.currentLabel != "pulse")
            {
               _loc4_.bg.gotoAndPlay("pulse");
            }
            _loc3_++;
         }
      }
      
      public function stopPulseActionIcon(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         _loc2_ = this.getActIcons(param1);
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_ != null && "bg" in _loc4_ && _loc4_.bg != null)
            {
               _loc4_.bg.gotoAndStop(1);
            }
            _loc3_++;
         }
      }
      
      public function globalCoolDownExcept(param1:Object) : void
      {
         var now:Number = NaN;
         var actIcon:MovieClip = null;
         var actionObj:Object = null;
         var cd:* = undefined;
         var exemptAction:Object = param1;
         now = Number(new Date().getTime());
         for each(var _loc5_ in this.actions.active)
         {
            actionObj = _loc5_;
            _loc5_;
            if(actionObj)
            {
               actIcon = this.getActIcons(actionObj)[0];
               if(actIcon != null)
               {
                  try
                  {
                     cd = Math.round(actionObj.cd * (1 - Math.min(Math.max(this.myAvatar.dataLeaf.sta.$tha,-1),0.5)));
                     if(actionObj != exemptAction && this.isNotAuto(actionObj) && (!("icon2" in actIcon) || actIcon.icon2 == null || actionObj.ts + cd > now && actionObj.ts + cd - now < this.GCD))
                     {
                        this.coolDownAct(actionObj,this.GCD + 300,now);
                     }
                  }
                  catch(e:Error)
                  {
                     trace("[Combat] ERR globalCoolDownExcept: " + e.message);
                     continue;
                  }
               }
            }
         }
         this.GCDTS = now;
      }
      
      public function checkCooldown(param1:Object) : *
      {
         var _loc2_:Array = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         _loc2_ = this.getActIcons(param1);
         _loc4_ = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = _loc2_[_loc4_];
            if(_loc3_.icon2 != null)
            {
               _loc3_.icon2.bitmapData.dispose();
               this.rootClass.ui.mcInterface.actBar.removeChild(_loc3_.icon2);
               _loc5_ = new BitmapData(50,50,true,0);
               _loc5_.draw(_loc3_,null,this.iconCT);
               _loc6_ = new Bitmap(_loc5_);
               _loc7_ = this.rootClass.ui.mcInterface.actBar.addChild(_loc6_);
               _loc3_.icon2 = _loc7_;
            }
            _loc4_++;
         }
      }
      
      public function coolDownAct(param1:Object, param2:int = -1, param3:Number = -1) : *
      {
         var _loc4_:Array = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:MovieClip = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         var _loc12_:DisplayObject = null;
         _loc4_ = this.getActIcons(param1);
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_];
            _loc7_ = null;
            _loc8_ = null;
            if(_loc5_.icon2 == null)
            {
               _loc9_ = new BitmapData(50,50,true,0);
               _loc9_.draw(_loc5_,null,this.iconCT);
               _loc10_ = new Bitmap(_loc9_);
               _loc7_ = this.rootClass.ui.mcInterface.actBar.addChild(_loc10_);
               _loc5_.icon2 = _loc7_;
               if(param2 == -1)
               {
                  _loc12_ = this.rootClass.ui.mcInterface.actBar.addChild(new iconFlare());
                  _loc7_.transform = _loc12_.transform = _loc5_.transform;
                  _loc5_.ts = param1.ts;
                  _loc5_.tsg = getTimer();
                  _loc5_.cd = param1.cd;
               }
               else
               {
                  _loc7_.transform = _loc5_.transform;
                  _loc5_.ts = param3;
                  _loc5_.tsg = getTimer();
                  _loc5_.cd = param2;
               }
               _loc8_ = this.rootClass.ui.mcInterface.actBar.addChild(new ActMask()) as MovieClip;
               _loc8_.scaleX = 0.33;
               _loc8_.scaleY = 0.33;
               _loc8_.x = int(_loc7_.x + _loc7_.width / 2 - _loc8_.width / 2);
               _loc8_.y = int(_loc7_.y + _loc7_.height / 2 - _loc8_.height / 2);
               _loc11_ = 0;
               while(_loc11_ < 4)
               {
                  _loc8_["e" + _loc11_ + "oy"] = _loc8_["e" + _loc11_].y;
                  _loc11_++;
               }
               _loc7_.mask = _loc8_;
            }
            else
            {
               _loc7_ = _loc5_.icon2;
               _loc8_ = _loc7_.mask;
               if(param2 == -1)
               {
                  _loc5_.ts = param1.ts;
                  _loc5_.tsg = getTimer();
                  _loc5_.cd = param1.cd;
               }
               else
               {
                  _loc5_.ts = param3;
                  _loc5_.tsg = getTimer();
                  _loc5_.cd = param2;
               }
            }
            if(param2 == -1 && Boolean(this.rootClass.litePreference.data.bSkillCD))
            {
               switch(param1.ref)
               {
                  case "aa":
                     _loc5_.ref = "txtCD0";
                     break;
                  case "i1":
                     _loc5_.ref = "txtCD5";
                     break;
                  default:
                     _loc5_.ref = "txtCD" + param1.ref.slice(1);
               }
               this.rootClass.ui.mcInterface.actBar.setChildIndex(this.rootClass.ui.mcInterface.actBar.getChildByName(_loc5_.ref),this.rootClass.ui.mcInterface.actBar.numChildren - 1);
               this.rootClass.ui.mcInterface.actBar.getChildByName(_loc5_.ref).text = String(Number(_loc5_.cd / 1000).toFixed(1));
               this.rootClass.ui.mcInterface.actBar.getChildByName(_loc5_.ref).visible = true;
            }
            _loc8_.e0.stop();
            _loc8_.e1.stop();
            _loc8_.e2.stop();
            _loc8_.e3.stop();
            _loc5_.removeEventListener(Event.ENTER_FRAME,this.countDownAct);
            _loc5_.addEventListener(Event.ENTER_FRAME,this.countDownAct,false,0,true);
            _loc6_++;
         }
      }
      
      public function countDownAct(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         _loc2_ = MovieClip(param1.target);
         _loc3_ = _loc2_.icon2;
         if(_loc3_ == null || _loc3_.mask == null)
         {
            _loc2_.removeEventListener(Event.ENTER_FRAME,this.countDownAct);
            return;
         }
         _loc4_ = getTimer();
         if(this.myAvatar != null && this.myAvatar.dataLeaf != null && this.myAvatar.dataLeaf.sta != null)
         {
            _loc5_ = Math.round(_loc2_.cd * (1 - Math.min(Math.max(this.myAvatar.dataLeaf.sta.$tha,-1),0.5)));
         }
         else
         {
            _loc5_ = Number(_loc2_.cd);
         }
         _loc6_ = (_loc4_ - _loc2_.tsg) / _loc5_;
         _loc7_ = Math.floor(_loc6_ * 4);
         _loc8_ = int(_loc6_ * 360 % 90) + 1;
         if(!_loc2_.actObj.lock)
         {
            if(_loc6_ < 0.99)
            {
               if(_loc2_.ref)
               {
                  this.rootClass.ui.mcInterface.actBar.getChildByName(_loc2_.ref).text = String(Number(Number(1 - _loc6_) * (_loc5_ / 1000)).toFixed(1));
               }
               _loc9_ = 0;
               while(_loc9_ < 4)
               {
                  if(_loc9_ < _loc7_)
                  {
                     _loc3_.mask["e" + _loc9_].y = -300;
                  }
                  else
                  {
                     _loc3_.mask["e" + _loc9_].y = _loc3_.mask["e" + _loc9_ + "oy"];
                     if(_loc9_ > _loc7_)
                     {
                        _loc3_.mask["e" + _loc9_].gotoAndStop(0);
                     }
                  }
                  _loc9_++;
               }
               MovieClip(_loc3_.mask["e" + _loc7_]).gotoAndStop(_loc8_);
            }
            else
            {
               if(_loc2_.ref)
               {
                  this.rootClass.ui.mcInterface.actBar.getChildByName(_loc2_.ref).visible = false;
               }
               _loc10_ = _loc3_.mask;
               _loc3_.mask = null;
               _loc3_.parent.removeChild(_loc10_);
               _loc2_.removeEventListener(Event.ENTER_FRAME,this.countDownAct);
               _loc3_.parent.removeChild(_loc3_);
               _loc3_.bitmapData.dispose();
               _loc2_.icon2 = null;
            }
         }
      }
      
      public function healByIcon(param1:Avatar) : void
      {
         var _loc2_:Object = null;
         _loc2_ = this.getFirstHeal();
         if(_loc2_ != null)
         {
            this.setTarget(param1);
            this.testAction(_loc2_);
         }
      }
      
      public function getFirstHeal() : Object
      {
         var i:* = undefined;
         try
         {
            i = 0;
            while(i < this.actions.active.length)
            {
               if(this.actions.active[i] != null && this.actions.active[i].damage != null && this.actions.active[i].damage < 0 && Boolean(this.actions.active[i].isOK))
               {
                  return this.actions.active[i];
               }
               i++;
            }
         }
         catch(e:Error)
         {
            trace("[Combat] ERR getFirstHeal: " + e.message);
         }
         return null;
      }
      
      public function AATest(param1:Event) : *
      {
      }
      
      public function connTest(param1:Event) : *
      {
      }
      
      internal function checkSP(param1:int, param2:Object) : Boolean
      {
         var _loc3_:* = undefined;
         _loc3_ = 0;
         while(_loc3_ < param2.auras.length)
         {
            if(param2.auras[_loc3_].nam == "Spirit Power")
            {
               if(param1 <= param2.auras[_loc3_].val)
               {
                  return true;
               }
               return false;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function acceptQuest(param1:int) : void
      {
         if(this.questTree[param1] == null)
         {
            this.getQuests([param1]);
         }
         if(this.questTree[param1].status == null)
         {
            this.questTree[param1].status = "p";
            this.rootClass.ui.mcQTracker.updateQuest();
         }
         if(!this.rootClass.ui.mcQTracker.visible)
         {
            this.rootClass.ui.mcQTracker.toggle();
         }
         this.rootClass.sfc.sendXtMessage("zm","acceptQuest",[param1],"str",this.curRoom);
      }
      
      public function tryQuestComplete(param1:int, param2:int = -1, param3:Boolean = false, param4:int = 1) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","tryQuestComplete",[param1,param2,param3,param4,"wvz"],"str",this.curRoom);
      }
      
      public function getMapItem(param1:int) : void
      {
         if(this.coolDown("getMapItem"))
         {
            this.rootClass.sfc.sendXtMessage("zm","getMapItem",[param1],"str",this.curRoom);
         }
      }
      
      public function isQuestInProgress(param1:int) : Boolean
      {
         return this.questTree[param1] != null && this.questTree[param1].status != null;
      }
      
      public function getQuests(param1:Array) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","getQuests",param1,"str",this.curRoom);
      }
      
      public function getQuest(param1:int) : void
      {
      }
      
      public function showQuestList(param1:String, param2:String, param3:String) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:String = null;
         if(!this.rootClass.isGreedyModalInStack())
         {
            this.rootClass.clearPopupsQ();
            _loc4_ = this.rootClass.attachOnModalStack("QFrameMC");
            _loc5_ = param2.split(",");
            _loc6_ = param3.split(",");
            _loc4_.sIDs = _loc5_;
            _loc4_.tIDs = _loc6_;
            _loc4_.world = this;
            _loc4_.rootClass = this.rootClass;
            _loc4_.qMode = param1;
            _loc7_ = [];
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               _loc9_ = _loc5_[_loc8_];
               if(this.questTree[_loc9_] == null)
               {
                  _loc7_.push(_loc9_);
               }
               else if(this.questTree[_loc9_].strDynamic != null)
               {
                  this.questTree[_loc9_] = null;
                  delete this.questTree[_loc9_];
                  _loc7_.push(_loc9_);
               }
               _loc8_++;
            }
            if(_loc7_.length > 0 && param2 != "")
            {
               this.getQuests(_loc7_);
            }
            else
            {
               _loc4_.open();
            }
         }
      }
      
      public function getApop(param1:String) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = undefined;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         if(int(param1) < 1)
         {
            return;
         }
         if(this.rootClass.curID != param1)
         {
            this.rootClass.curID = param1;
            this.rootClass.sfc.sendXtMessage("zm","getApop",[param1],"str",this.curRoom);
            return;
         }
         _loc2_ = this.rootClass.apopTree[param1];
         _loc3_ = [];
         _loc5_ = 0;
         while(_loc5_ < _loc2_.arrScenes.length)
         {
            _loc4_ = _loc2_.arrScenes[_loc5_];
            if(_loc4_.qID == null)
            {
               if(_loc4_.arrQuests != null)
               {
                  _loc6_ = String(_loc4_.arrQuests).split(",");
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.length)
                  {
                     if(this.questTree[_loc6_[_loc7_]] == null)
                     {
                        _loc3_.push(_loc6_[_loc7_]);
                        this.rootClass.quests = true;
                     }
                     else if(this.questTree[_loc6_[_loc7_]].strDynamic != null)
                     {
                        this.questTree[_loc6_[_loc7_]] = null;
                        delete this.questTree[_loc6_[_loc7_]];
                        _loc3_.push(_loc6_[_loc7_]);
                        this.rootClass.quests = true;
                     }
                     _loc7_++;
                  }
               }
            }
            else if(this.questTree[_loc4_.qID] == null)
            {
               _loc3_.push(_loc4_.qID);
               this.rootClass.quests = true;
            }
            else if(this.questTree[_loc4_.qID].strDynamic != null)
            {
               this.questTree[_loc4_.qID] = null;
               delete this.questTree[_loc4_.qID];
               _loc3_.push(_loc4_.qID);
               this.rootClass.quests = true;
            }
            _loc5_++;
         }
         if(_loc3_.length > 0)
         {
            this.rootClass.quests = true;
            this.rootClass.sfc.sendXtMessage("zm","getQuests2",_loc3_,"str",this.curRoom);
         }
         else
         {
            this.rootClass.quests = false;
            this.rootClass.createApop();
         }
      }
      
      public function showQuests(param1:String, param2:String) : void
      {
         this.showQuestList(param2,param1,param1);
      }
      
      public function showQuestLink(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         _loc2_ = "$({";
         _loc3_ = "})$";
         _loc4_ = "";
         if(param1.unm.toLowerCase() != this.rootClass.sfc.myUserName)
         {
            _loc4_ = _loc4_ + (param1.unm + " issues a Call to Arms for " + _loc2_);
            _loc4_ = _loc4_ + ["quest",param1.quest.sName,param1.quest.QuestID,param1.quest.iLvl,param1.unm].toString();
            _loc4_ = _loc4_ + (_loc3_ + "!");
         }
         else
         {
            _loc4_ = _loc4_ + ("You issue a Call to Arms for " + param1.quest.sName + "!");
         }
         this.rootClass.chatF.pushMsg("event",_loc4_,"SERVER","",0);
      }
      
      public function getActiveQuests() : String
      {
         var _loc1_:String = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _loc1_ = "";
         for(var _loc6_ in this.questTree)
         {
            _loc2_ = _loc6_;
            _loc6_;
            _loc3_ = this.questTree[_loc2_];
            if(_loc3_.status != null)
            {
               _loc1_ = _loc1_ + _loc2_;
               _loc1_ = _loc1_ + ("," + _loc2_);
               !!_loc1_.length ? (_loc1_) : (_loc1_);
            }
         }
         return _loc1_;
      }
      
      public function checkAllQuestStatus(param1:* = null) : *
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         _loc2_ = [];
         if(param1 != null)
         {
            _loc2_ = [String(param1)];
         }
         else
         {
            for(var _loc13_ in this.questTree)
            {
               _loc3_ = _loc13_;
               _loc13_;
               _loc2_.push(_loc3_);
            }
         }
         for each(_loc13_ in _loc2_)
         {
            _loc3_ = _loc13_;
            _loc13_;
            _loc4_ = this.questTree[_loc3_];
            _loc5_ = {};
            if(_loc4_.status != null)
            {
               if(_loc4_.turnin != null && _loc4_.turnin.length > 0)
               {
                  _loc5_.sItems = true;
                  _loc7_ = 0;
                  while(_loc7_ < _loc4_.turnin.length)
                  {
                     _loc8_ = _loc4_.turnin[_loc7_].ItemID;
                     _loc9_ = _loc4_.turnin[_loc7_].iQty;
                     if(this.invTree[_loc8_] == null || this.invTree[_loc8_].iQty < _loc9_)
                     {
                        _loc5_.sItems = false;
                        break;
                     }
                     _loc7_++;
                  }
               }
               if(_loc4_.iTime != null)
               {
                  _loc5_.iTime = false;
                  if(_loc4_.ts != null)
                  {
                     _loc10_ = new Date();
                     if(_loc10_.getTime() - _loc4_.ts <= _loc4_.iTime)
                     {
                        _loc5_.iTime = true;
                     }
                  }
               }
               _loc4_.status = "c";
               for(var _loc15_ in _loc5_)
               {
                  _loc6_ = _loc15_;
                  _loc15_;
                  if(_loc5_[_loc6_] == false)
                  {
                     _loc4_.status = "p";
                  }
               }
            }
         }
         this.rootClass.ui.mcQTracker.updateQuest();
      }
      
      public function updateQuestProgress(param1:String, param2:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         for(var _loc12_ in this.questTree)
         {
            _loc3_ = _loc12_;
            _loc12_;
            _loc4_ = this.questTree[_loc3_];
            _loc5_ = {};
            if(_loc4_.status != null)
            {
               if(this.rootClass.litePreference.data.bQuestNotif)
               {
                  if(param1 == "item" && _loc4_.turnin != null && _loc4_.turnin.length > 0)
                  {
                     _loc5_.sItems = true;
                     _loc6_ = 0;
                     while(_loc6_ < _loc4_.turnin.length)
                     {
                        _loc7_ = _loc4_.turnin[_loc6_].ItemID;
                        _loc8_ = _loc4_.turnin[_loc6_].iQty;
                        if(param2.ItemID == _loc7_ && this.invTree[_loc7_] != null && this.invTree[_loc7_].iQty > _loc8_)
                        {
                           _loc9_ = this.invTree[_loc7_];
                           this.rootClass.ui.mcQTracker.updateQuest();
                           this.rootClass.addUpdate(_loc4_.sName + ": " + _loc9_.sName + " " + this.invTree[_loc7_].iQty + "/" + _loc8_);
                        }
                        _loc6_++;
                     }
                  }
               }
            }
            if(_loc4_.status != null && _loc4_.status == "p")
            {
               if(param1 == "item" && _loc4_.turnin != null && _loc4_.turnin.length > 0)
               {
                  _loc5_.sItems = true;
                  _loc6_ = 0;
                  while(_loc6_ < _loc4_.turnin.length)
                  {
                     _loc7_ = _loc4_.turnin[_loc6_].ItemID;
                     _loc8_ = _loc4_.turnin[_loc6_].iQty;
                     if(param2.ItemID == _loc7_ && this.invTree[_loc7_] != null && this.invTree[_loc7_].iQty <= _loc8_)
                     {
                        _loc9_ = this.invTree[_loc7_];
                        this.rootClass.addUpdate(_loc4_.sName + ": " + _loc9_.sName + " " + this.invTree[_loc7_].iQty + "/" + _loc8_);
                     }
                     _loc6_++;
                  }
               }
               this.checkAllQuestStatus(_loc3_);
               if(_loc4_.status == "c")
               {
                  this.rootClass.addUpdate(_loc4_.sName + " complete!");
                  this.rootClass.mixer.playSound("Good");
               }
            }
         }
      }
      
      public function canTurnInQuest(param1:int) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         _loc2_ = this.questTree[param1];
         if(_loc2_.turnin != null && _loc2_.turnin.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.turnin.length)
            {
               _loc4_ = _loc2_.turnin[_loc3_].ItemID;
               _loc5_ = _loc2_.turnin[_loc3_].iQty;
               if(this.invTree[_loc4_] == null || this.invTree[_loc4_].iQty < _loc5_)
               {
                  return false;
               }
               if(this.myAvatar.isItemEquipped(_loc4_))
               {
                  this.rootClass.MsgBox.notify("Cannot turn in equipped item(s)!");
                  return false;
               }
               _loc3_++;
            }
         }
         return true;
      }
      
      public function maximumQuestTurnIns(param1:int) : int
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         _loc2_ = -1;
         _loc3_ = this.questTree[param1];
         if(_loc3_.turnin != null && _loc3_.turnin.length > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.turnin.length)
            {
               _loc5_ = _loc3_.turnin[_loc4_].ItemID;
               _loc6_ = _loc3_.turnin[_loc4_].iQty;
               if(this.invTree[_loc5_] == null || this.invTree[_loc5_].iQty < _loc6_)
               {
                  return 0;
               }
               if(this.myAvatar.isItemEquipped(_loc5_))
               {
                  this.rootClass.MsgBox.notify("Cannot turn in equipped item(s)!");
                  return 0;
               }
               _loc7_ = Math.floor(this.invTree[_loc5_].iQty / _loc6_);
               if(_loc2_ == -1 || _loc2_ > _loc7_)
               {
                  _loc2_ = _loc7_;
               }
               _loc4_++;
            }
         }
         return Math.min(_loc2_,250);
      }
      
      public function abandonQuest(param1:int) : void
      {
         this.questTree[param1].status = null;
         this.rootClass.ui.mcQTracker.updateQuest();
      }
      
      public function completeQuest(param1:int) : void
      {
         if(this.questTree[param1] != null)
         {
            this.questTree[param1].status = null;
            this.rootClass.ui.mcQTracker.updateQuest();
         }
      }
      
      public function toggleQuestLog() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.rootClass.getInstanceFromModalStack("QFrameMC");
         if(_loc1_ == null)
         {
            if(this.rootClass.litePreference.data.bQuestLog)
            {
               this.showQuests(this.getActiveQuests(),"q");
            }
            else
            {
               this.showQuests("","l");
            }
         }
         else
         {
            _loc1_.open();
         }
      }
      
      public function isPartyMember(param1:String) : Boolean
      {
         var _loc2_:int = 0;
         param1 = param1.toLowerCase();
         if(param1 != this.rootClass.sfc.myUserName)
         {
            _loc2_ = 0;
            while(_loc2_ < this.partyMembers.length)
            {
               if(this.partyMembers[_loc2_].toLowerCase() == param1)
               {
                  return true;
               }
               _loc2_++;
            }
         }
         return false;
      }
      
      public function doPartyAccept(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","gp",["pa",param1.pid],"str",1);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","gp",["pd",param1.pid],"str",1);
         }
      }
      
      public function doCTAAccept(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","gp",["ctaa",param1.unm],"str",1);
            this.showQuests(param1.QuestID,"q");
         }
      }
      
      public function doCTAClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:ModalMC = null;
         var _loc4_:Object = null;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = new ModalMC();
         _loc4_ = {};
         _loc4_.strBody = "Would you like to join the next avabilable party for " + _loc2_.sName + "?";
         _loc4_.callback = this.doCTAAccept;
         _loc4_.params = {
            "QuestID":_loc2_.QuestID,
            "unm":_loc2_.unm
         };
         _loc4_.btns = "dual";
         this.rootClass.ui.ModalStack.addChild(_loc3_);
         _loc3_.init(_loc4_);
      }
      
      public function addPartyMember(param1:String) : *
      {
         this.partyMembers.push(param1.toLowerCase());
         this.updatePartyFrame();
      }
      
      public function removePartyMember(param1:String) : *
      {
         var _loc2_:* = undefined;
         if(param1.toLowerCase() != this.rootClass.sfc.myUserName.toLowerCase())
         {
            _loc2_ = this.partyMembers.indexOf(param1.toLowerCase());
            if(_loc2_ > -1)
            {
               this.partyMembers.splice(_loc2_,1);
            }
         }
         else
         {
            this.partyID = -1;
            this.partyOwner = "";
            this.partyMembers = new Vector.<String>();
         }
         this.updatePartyFrame();
      }
      
      public function updatePartyFrame(param1:Object = null) : *
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         _loc2_ = null;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = null;
         _loc6_ = 0;
         _loc7_ = null;
         _loc8_ = [];
         _loc9_ = true;
         _loc10_ = false;
         if(param1 != null && param1.range != null && param1.range == false)
         {
            _loc9_ = false;
         }
         if(param1 != null)
         {
            _loc8_ = [param1.unm.toLowerCase()];
         }
         else
         {
            _loc10_ = true;
            _loc11_ = 0;
            while(_loc11_ < this.partyMembers.length)
            {
               _loc8_.push(this.partyMembers[_loc11_]);
               _loc11_++;
            }
         }
         if(_loc8_.length > 0)
         {
            _loc12_ = "";
            if(param1 == null)
            {
               _loc13_ = [];
               _loc6_ = 0;
               _loc6_ = 0;
               while(_loc6_ < this.rootClass.ui.mcPartyFrame.numChildren)
               {
                  _loc13_.push(MovieClip(this.rootClass.ui.mcPartyFrame.getChildAt(_loc6_)));
                  _loc6_++;
               }
               _loc6_ = 0;
               _loc6_ = 0;
               while(_loc6_ < _loc13_.length)
               {
                  _loc2_ = _loc13_[_loc6_];
                  _loc14_ = _loc2_.strName.text;
                  if(this.partyMembers.indexOf(_loc14_) == -1)
                  {
                     _loc2_.removeEventListener(MouseEvent.CLICK,this.onPartyPanelClick);
                     this.rootClass.ui.mcPartyFrame.removeChild(_loc2_);
                  }
                  _loc6_++;
               }
            }
            _loc6_ = 0;
            while(_loc6_ < _loc8_.length)
            {
               _loc12_ = _loc8_[_loc6_];
               _loc2_ = this.getPartyPanelByName(_loc12_);
               _loc7_ = this.uoTree[_loc12_.toLowerCase()];
               if(_loc7_ == null)
               {
                  _loc2_.HP.visible = false;
                  _loc2_.MP.visible = false;
                  _loc2_.txtRange.visible = true;
               }
               else if(_loc9_)
               {
                  _loc3_ = int(_loc7_.intHP);
                  _loc4_ = int(_loc7_.intHPMax);
                  _loc5_ = _loc2_.HP;
                  if(_loc3_ >= 0)
                  {
                     _loc5_.strIntHP.text = String(_loc7_.intHP);
                  }
                  else
                  {
                     _loc5_.strIntHP.text = "X";
                  }
                  if(_loc3_ < 0)
                  {
                     _loc3_ = 0;
                  }
                  _loc5_.intHPbar.x = -(_loc5_.intHPbar.width * (1 - (_loc4_ > 0 ? _loc3_ / _loc4_ : 0)));
                  _loc3_ = int(_loc7_.intMP);
                  _loc4_ = int(_loc7_.intMPMax);
                  _loc5_ = _loc2_.MP;
                  if(_loc3_ >= 0)
                  {
                     _loc5_.strIntMP.text = String(_loc7_.intMP);
                  }
                  else
                  {
                     _loc5_.strIntMP.text = "X";
                  }
                  if(_loc3_ < 0)
                  {
                     _loc3_ = 0;
                  }
                  _loc5_.intMPbar.x = -(_loc5_.intMPbar.width * (1 - (_loc4_ > 0 ? _loc3_ / _loc4_ : 0)));
                  _loc2_.HP.visible = true;
                  _loc2_.MP.visible = true;
                  _loc2_.txtRange.visible = false;
               }
               else
               {
                  _loc2_.HP.visible = false;
                  _loc2_.MP.visible = false;
                  _loc2_.txtRange.visible = true;
               }
               if(_loc10_)
               {
                  _loc2_.y = int((_loc2_.height + 2) * _loc6_);
               }
               _loc2_.partyLead.visible = _loc12_.toLowerCase() == this.partyOwner.toLowerCase();
               _loc6_++;
            }
         }
         else
         {
            _loc6_ = 0;
            while(this.rootClass.ui.mcPartyFrame.numChildren > 0 && _loc6_ < 10)
            {
               _loc2_ = MovieClip(this.rootClass.ui.mcPartyFrame.getChildAt(0));
               _loc2_.removeEventListener(MouseEvent.CLICK,this.onPartyPanelClick);
               this.rootClass.ui.mcPartyFrame.removeChildAt(0);
               _loc6_++;
            }
         }
         this.rootClass.ui.mcPortrait.partyLead.visible = this.partyOwner.toLowerCase() == this.rootClass.sfc.myUserName;
      }
      
      public function createPartyPanel(param1:Object) : MovieClip
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this.rootClass.ui.mcPartyFrame.numChildren + 1;
         _loc3_ = MovieClip(this.rootClass.ui.mcPartyFrame.addChild(new PartyPanel()));
         _loc3_.strName.text = param1.unm;
         _loc3_.HP.visible = false;
         _loc3_.MP.visible = false;
         _loc3_.txtRange.visible = false;
         _loc3_.addEventListener(MouseEvent.CLICK,this.onPartyPanelClick,false,0,true);
         _loc3_.buttonMode = true;
         return _loc3_;
      }
      
      public function getPartyPanelByName(param1:String) : MovieClip
      {
         var _loc2_:* = undefined;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         _loc2_ = this.rootClass.ui.mcPartyFrame.numChildren;
         _loc3_ = null;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = MovieClip(this.rootClass.ui.mcPartyFrame.getChildAt(_loc4_));
            if(_loc3_.strName.text == param1.toLowerCase())
            {
               return _loc3_;
            }
            _loc4_++;
         }
         return this.createPartyPanel({"unm":param1.toLowerCase()});
      }
      
      public function onPartyPanelClick(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:Avatar = null;
         _loc2_ = MovieClip(param1.currentTarget);
         _loc3_ = {};
         _loc3_.strUsername = _loc2_.strName.text;
         if(param1.shiftKey)
         {
            _loc4_ = this.getAvatarByUserName(_loc3_.strUsername.toLowerCase());
            if(_loc4_ != null && _loc4_.pMC != null && _loc4_.dataLeaf != null && _loc4_.dataLeaf.strFrame == this.myAvatar.dataLeaf.strFrame)
            {
               this.setTarget(_loc4_);
            }
         }
         else
         {
            this.rootClass.ui.cMenu.fOpenWith("party",_loc3_);
         }
      }
      
      public function partyInvite(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","gp",["pi",param1],"str",1);
      }
      
      public function partyKick(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","gp",["pk",param1],"str",1);
      }
      
      public function partyLeave() : void
      {
         this.rootClass.sfc.sendXtMessage("zm","gp",["pl"],"str",1);
      }
      
      public function partySummon(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","gp",["ps",param1],"str",1);
      }
      
      public function acceptPartySummon(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","gp",["psa"],"str",1);
            if(param1.strF == null)
            {
               this.rootClass.sfc.sendXtMessage("zm","cmd",["goto",param1.unm],"str",1);
            }
            else
            {
               this.moveToCell(param1.strF,param1.strP);
            }
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","gp",["psd",param1.unm],"str",1);
         }
      }
      
      public function partyUpdate(param1:String, param2:String) : void
      {
      }
      
      public function partyPromote(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","gp",["pp",param1],"str",1);
      }
      
      public function partyDisband() : void
      {
         this.rootClass.sfc.sendXtMessage("zm","gp",["pc"],"str",1);
      }
      
      public function isPartyFull() : Boolean
      {
         return this.partyMembers.length >= 4;
      }
      
      public function goto(param1:*) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         param1 = param1.toLowerCase();
         _loc2_ = this.uoTree[this.rootClass.sfc.myUserName];
         _loc3_ = this.uoTree[String(param1).toLowerCase()];
         if(_loc2_.intState == 1 && (_loc2_.pvpTeam == null || _loc2_.pvpTeam == -1))
         {
            if(_loc3_ != null && _loc2_.uoName != _loc3_.uoName)
            {
               if("nogoto" in this.map && Boolean(this.map.nogoto))
               {
                  this.rootClass.chatF.pushMsg("warning","/goto can\'t target players within this map.","SERVER","",0);
                  return;
               }
               if(_loc2_.strFrame != _loc3_.strFrame)
               {
                  this.moveToCell(_loc3_.strFrame,_loc3_.strPad);
               }
            }
            else
            {
               this.rootClass.sfc.sendXtMessage("zm","cmd",["goto",param1],"str",1);
            }
         }
      }
      
      public function pull(param1:*) : *
      {
         param1 = param1.toLowerCase();
         this.rootClass.sfc.sendXtMessage("zm","cmd",["pull",param1],"str",1);
      }
      
      public function requestFriend(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","requestFriend",[param1],"str",1);
      }
      
      public function addFriend(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","addFriend",[param1.unm],"str",1);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","declineFriend",[param1.unm],"str",1);
         }
      }
      
      public function deleteFriend(param1:int, param2:*) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","deleteFriend",[param1,param2],"str",1);
      }
      
      public function guildInvite(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","guild",["gi",param1],"str",1);
      }
      
      public function guildRemove(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","guild",["gr",param1.userName],"str",1);
         }
      }
      
      public function guildPromote(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","guild",["gp",param1],"str",1);
      }
      
      public function guildDemote(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","guild",["gd",param1],"str",1);
      }
      
      public function doGuildAccept(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","guild",["ga",param1.guildID,param1.owner],"str",1);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","guild",["gdi",param1.guildID,param1.owner],"str",1);
         }
      }
      
      public function setGuildMOTD(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","guild",["motd",param1],"str",1);
      }
      
      public function createGuild(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","guild",["gc",param1.guildName],"str",1);
         }
      }
      
      public function addMemSlots(param1:int) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","guild",["slots",param1],"str",1);
      }
      
      public function renameGuild(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","guild",["rename",param1.guildName],"str",1);
         }
      }
      
      public function requestPVPQueue(param1:String, param2:int = -1) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","PVPQr",[param1,param2],"str",this.rootClass.world.curRoom);
      }
      
      public function handlePVPQueue(param1:Object) : void
      {
         var _loc2_:MovieClip = null;
         if(param1.bitSuccess == 1)
         {
            this.PVPQueue.warzone = param1.warzone;
            this.PVPQueue.ts = new Date().getTime();
            this.PVPQueue.avgWait = param1.avgWait;
            this.rootClass.showMCPVPQueue();
         }
         else
         {
            this.PVPQueue.warzone = "";
            this.PVPQueue.ts = -1;
            this.PVPQueue.avgWait = -1;
            this.rootClass.hideMCPVPQueue();
         }
         _loc2_ = this.rootClass.ui.mcPopup;
         if(_loc2_.currentLabel == "PVPPanel" && _loc2_.mcPVPPanel != null)
         {
            _loc2_.mcPVPPanel.updateBody();
         }
         this.rootClass.closeModalByStrBody("A new Warzone battle has started!");
      }
      
      public function updatePVPAvgWait(param1:int) : void
      {
         this.PVPQueue.avgWait = param1;
      }
      
      public function duelExpire() : *
      {
         this.rootClass.closeModalByStrBody("has challenged you to a duel.");
      }
      
      public function receivePVPInvite(param1:Object) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         _loc2_ = new ModalMC();
         _loc3_ = {};
         _loc4_ = this.getWarzoneByWarzoneName(param1.warzone);
         _loc3_.strBody = "A new Warzone battle has started!  Will you join " + _loc4_.nam + "?";
         _loc3_.greedy = true;
         _loc3_.params = {};
         _loc3_.callback = this.replyToPVPInvite;
         this.rootClass.ui.ModalStack.addChild(_loc2_);
         this.rootClass.ui.mcPopup.onClose();
         this.rootClass.hideMCPVPQueue();
         _loc2_.init(_loc3_);
      }
      
      public function replyToPVPInvite(param1:Object) : void
      {
         if(param1.accept)
         {
            this.sendPVPInviteAccept();
         }
         else
         {
            this.sendPVPInviteDecline();
         }
      }
      
      public function sendPVPInviteAccept() : void
      {
         this.rootClass.sfc.sendXtMessage("zm","PVPIr",["1"],"str",this.rootClass.world.curRoom);
      }
      
      public function sendPVPInviteDecline() : void
      {
         this.rootClass.sfc.sendXtMessage("zm","PVPIr",["0"],"str",this.rootClass.world.curRoom);
      }
      
      public function sendDuelInvite(param1:String) : void
      {
         this.rootClass.sfc.sendXtMessage("zm","duel",[param1],"str",1);
      }
      
      public function doDuelAccept(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.sfc.sendXtMessage("zm","da",[param1.unm],"str",1);
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","dd",[param1.unm],"str",1);
         }
      }
      
      public function getWarzoneByName(param1:String) : *
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.PVPMaps.length)
         {
            if(this.PVPMaps[_loc2_].nam == param1)
            {
               return this.PVPMaps[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getWarzoneByWarzoneName(param1:String) : *
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.PVPMaps.length)
         {
            if(this.PVPMaps[_loc2_].warzone == param1)
            {
               return this.PVPMaps[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setPVPFactionData(param1:Array) : void
      {
         if(param1 != null)
         {
            this.PVPFactions = param1;
         }
         else
         {
            this.PVPFactions = [];
         }
      }
      
      public function attachMovieFront(param1:*) : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Class = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(param1 == null || !this.ldr_map.contentLoaderInfo.applicationDomain.hasDefinition(param1))
         {
            trace("[Load] ERR missing linkage " + param1 + " map " + this.strMapName);
            return null;
         }
         _loc3_ = this.ldr_map.contentLoaderInfo.applicationDomain.getDefinition(param1) as Class;
         _loc4_ = true;
         if(this.FG.numChildren)
         {
            _loc2_ = MovieClip(this.FG.getChildAt(0));
            _loc5_ = _loc2_.constructor as Class;
            if(_loc5_ == _loc3_)
            {
               _loc4_ = false;
            }
         }
         if(_loc4_)
         {
            this.removeMovieFront();
            _loc2_ = MovieClip(this.FG.addChild(new _loc3_()));
            this.FG.mouseChildren = true;
         }
         return _loc2_;
      }
      
      public function attachMovieFrontMenu(param1:*) : MovieClip
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Class = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         _loc3_ = this.getClass(param1) as Class;
         _loc4_ = true;
         if(this.FG.numChildren)
         {
            _loc2_ = MovieClip(this.FG.getChildAt(0));
            _loc5_ = _loc2_.constructor as Class;
            if(_loc5_ == _loc3_)
            {
               _loc4_ = false;
            }
         }
         if(_loc4_)
         {
            this.removeMovieFront();
            _loc2_ = MovieClip(this.FG.addChild(new _loc3_()));
            this.FG.mouseChildren = true;
         }
         return _loc2_;
      }
      
      public function removeMovieFront() : *
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(this.FG.numChildren > 0 && _loc1_ < 100)
         {
            _loc1_++;
            this.FG.removeChildAt(0);
         }
         if(getTimer() - this.mfLoadTS >= 50)
         {
            this.rootClass.ldrMC.closeHistory(this.FG);
         }
         this.rootClass.stage.focus = null;
      }
      
      public function getMovieFront() : *
      {
         if(this.FG.numChildren > 0 && this.FG.getChildAt(0) != null)
         {
            return this.FG.getChildAt(0);
         }
         return null;
      }
      
      public function isMovieFront(param1:String) : Boolean
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Class = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(param1 == null || !this.ldr_map.contentLoaderInfo.applicationDomain.hasDefinition(param1))
         {
            return false;
         }
         _loc3_ = this.ldr_map.contentLoaderInfo.applicationDomain.getDefinition(param1) as Class;
         _loc4_ = false;
         if(this.FG.numChildren)
         {
            _loc2_ = MovieClip(this.FG.getChildAt(0));
            _loc5_ = _loc2_.constructor as Class;
            if(_loc5_ == _loc3_)
            {
               _loc4_ = true;
            }
         }
         return _loc4_;
      }
      
      public function loadMovieFront(param1:String, param2:String = "Game Files") : void
      {
         this.removeMovieFront();
         this.rootClass.ldrMC.loadFile(this.FG,param1,param2);
         this.mfLoadTS = getTimer();
      }
      
      public function showPreL() : *
      {
         if(this.preLMC == null || !MovieClip(this).contains(this.preLMC))
         {
            this.preLMC = new PreL();
            addChild(this.preLMC);
            this.preLMC.x = 960 / 2 - this.preLMC.width / 2;
            this.preLMC.y = 550 / 2 - this.preLMC.height / 2;
         }
      }
      
      public function toggleFPS() : void
      {
         this.rootClass.ui.mcFPS.visible = !this.rootClass.ui.mcFPS.visible;
      }
      
      private function calculateFPS() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         try
         {
            if(this.fpsTS != 0)
            {
               _loc1_ = getTimer();
               _loc2_ = _loc1_ - this.fpsTS;
               _loc3_ = 0;
               if(this.ticklist.length == this.TICK_MAX)
               {
                  _loc3_ = int(this.ticklist.shift());
               }
               this.ticklist.push(_loc2_);
               this.ticksum = this.ticksum + _loc2_ - _loc3_;
               _loc4_ = 1000 / (this.ticksum / this.ticklist.length);
               if(this.rootClass.ui.mcFPS.visible)
               {
                  this.rootClass.ui.mcFPS.txtFPS.text = _loc4_.toPrecision(4);
               }
               if(this.rootClass.userPreference.data.quality == "AUTO" && this.ticklist.length == this.TICK_MAX && ++this.fpsQualityCounter % 24 == 0)
               {
                  this.fpsArrayQuality.push(_loc4_);
                  if(this.fpsArrayQuality.length == 5)
                  {
                     _loc5_ = 0;
                     _loc6_ = 0;
                     while(_loc6_ < this.fpsArrayQuality.length)
                     {
                        _loc5_ = _loc5_ + this.fpsArrayQuality[_loc6_];
                        _loc6_++;
                     }
                     _loc7_ = _loc5_ / this.fpsArrayQuality.length;
                     _loc8_ = int(this.arrQuality.indexOf(this.rootClass.stage.quality));
                     if(_loc7_ < 12 && _loc8_ > 0)
                     {
                        this.rootClass.stage.quality = this.arrQuality[_loc8_ - 1];
                     }
                     if(_loc7_ >= 12 && _loc8_ < 2)
                     {
                        this.rootClass.stage.quality = this.arrQuality[_loc8_ + 1];
                     }
                     this.fpsArrayQuality = [];
                  }
               }
            }
            this.fpsTS = getTimer();
         }
         catch(e:*)
         {
         }
      }
      
      public function markZSortDirty() : void
      {
         this._zSortDirty = true;
      }
      
      public function onZmanagerEnterFrame(param1:Event) : *
      {
         var zMC:MovieClip = null;
         var i:int = 0;
         var j:int = 0;
         var nowTS:int = 0;
         var k:int = 0;
         var nowTime:uint = 0;
         var actionDisplayed:Boolean = false;
         var mcIndex:int = 0;
         var spellChild:DisplayObject = null;
         var spell:MovieClip = null;
         var tot_monster:* = undefined;
         var col_monster:* = undefined;
         var now:Number = NaN;
         var evt:Event = param1;
         this.calculateFPS();
         this._zSortFrameCount++;
         if(!this._zSortDirty && this._zSortFrameCount < Z_SORT_INTERVAL)
         {
            return;
         }
         this._zSortFrameCount = 0;
         this._zSortDirty = false;
         ZSortItemPool.releaseAll(this.zSortArr);
         this.zSortArr.length = 0;
         i = 0;
         while(i < this.CHARS.numChildren)
         {
            zMC = MovieClip(this.CHARS.getChildAt(i));
            this.zSortArr.push(ZSortItemPool.getItem(zMC,zMC.y));
            i++;
         }
         this.zSortArr.sort(function(param1:ZSortItem, param2:ZSortItem):Number
         {
            return param1.oy - param2.oy;
         });
         j = 0;
         while(j < this.zSortArr.length)
         {
            zMC = this.zSortArr[j].mc;
            mcIndex = this.CHARS.getChildIndex(zMC);
            if(mcIndex != j)
            {
               this.CHARS.swapChildrenAt(mcIndex,j);
            }
            j++;
         }
         nowTS = getTimer();
         k = this.CHARS.numChildren - 1;
         while(k >= 0)
         {
            spellChild = this.CHARS.getChildAt(k);
            if(Boolean(spellChild.hasOwnProperty("fxDeadline")) && nowTS > MovieClip(spellChild).fxDeadline)
            {
               try
               {
                  this.CHARS.removeChildAt(k);
                  MovieClip(spellChild).stop();
                  this.rootClass.recursiveStop(MovieClip(spellChild));
               }
               catch(eFX:Error)
               {
               }
            }
            else if(Boolean(spellChild.hasOwnProperty("isSpell")) && Boolean(MovieClip(spellChild).isSpell))
            {
               spell = MovieClip(spellChild);
               if(spell.hasOwnProperty("_disposed") && spell._disposed || spell.tMC == null || spell.tMC.parent == null || spell.currentFrame == spell.totalFrames)
               {
                  spell.killSpell();
               }
            }
            k--;
         }
         if(this.strMapName == "trickortreat" && this.strFrame == "Enter")
         {
            if(this.CHARS.getChildByName("mcPlayerNPCTrickOrTreat"))
            {
               this.CHARS.setChildIndex(this.CHARS.getChildByName("mcPlayerNPCTrickOrTreat"),this.CHARS.numChildren - 1);
            }
            else
            {
               try
               {
                  tot_monster = this.getMonsters(1)[0].pMC;
                  if(tot_monster)
                  {
                     this.CHARS.setChildIndex(tot_monster,this.CHARS.numChildren - 1);
                  }
               }
               catch(e:*)
               {
               }
            }
         }
         else if(this.strMapName == "caroling" && this.strFrame == "Enter")
         {
            if(this.CHARS.getChildByName("mcPlayerNPCCaroling"))
            {
               this.CHARS.setChildIndex(this.CHARS.getChildByName("mcPlayerNPCCaroling"),this.CHARS.numChildren - 1);
            }
            else
            {
               try
               {
                  col_monster = this.getMonsters(1)[0].pMC;
                  if(col_monster)
                  {
                     this.CHARS.setChildIndex(col_monster,this.CHARS.numChildren - 1);
                  }
               }
               catch(e:*)
               {
               }
            }
         }
         if(this.EFAO.xpc++ > this.EFAO.xpn)
         {
            this.EFAO.xpc = 0;
            try
            {
               if(this.rootClass.stage == null)
               {
                  this.killTimers();
                  this.killListeners();
                  return;
               }
               now = Number(new Date().getTime());
               if(this.rootClass.stage != null && this.myAvatar.objData.iBoostXP != null)
               {
                  if(this.rootClass.ui.mcPortrait.iconBoostXP.boostTS + this.rootClass.ui.mcPortrait.iconBoostXP.iBoostXP * 1000 < now + 1000)
                  {
                     this.rootClass.sfc.sendXtMessage("zm","serverUseItem",["-","xpboost"],"str",-1);
                  }
               }
               if(this.rootClass.stage != null && this.myAvatar.objData.iBoostG != null)
               {
                  if(this.rootClass.ui.mcPortrait.iconBoostG.boostTS + this.rootClass.ui.mcPortrait.iconBoostG.iBoostG * 1000 < now + 1000)
                  {
                     this.rootClass.sfc.sendXtMessage("zm","serverUseItem",["-","gboost"],"str",-1);
                  }
               }
               if(this.rootClass.stage != null && this.myAvatar.objData.iBoostRep != null)
               {
                  if(this.rootClass.ui.mcPortrait.iconBoostRep.boostTS + this.rootClass.ui.mcPortrait.iconBoostRep.iBoostRep * 1000 < now + 1000)
                  {
                     this.rootClass.sfc.sendXtMessage("zm","serverUseItem",["-","repboost"],"str",-1);
                  }
               }
               if(this.rootClass.stage != null && this.myAvatar.objData.iBoostCP != null)
               {
                  if(this.rootClass.ui.mcPortrait.iconBoostCP.boostTS + this.rootClass.ui.mcPortrait.iconBoostCP.iBoostCP * 1000 < now + 1000)
                  {
                     this.rootClass.sfc.sendXtMessage("zm","serverUseItem",["-","cpboost"],"str",-1);
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         if(!this.combatDisplayTime)
         {
            this.combatDisplayTime = getTimer();
         }
         nowTime = uint(getTimer());
         actionDisplayed = false;
         if(nowTime - this.combatDisplayTime >= 250)
         {
            if(this.actionResults.length > 0)
            {
               this.showActionImpact(this.actionResults.shift());
               actionDisplayed = true;
            }
            if(this.actionResultsAura.length > 0)
            {
               this.showAuraImpact(this.actionResultsAura.shift());
               actionDisplayed = true;
            }
            if(this.actionResultsMon.length > 0)
            {
               this.showActionImpact(this.actionResultsMon.shift());
               actionDisplayed = true;
            }
            if(actionDisplayed)
            {
               this.combatDisplayTime = getTimer();
            }
         }
      }
      
      public function iaTrigger(param1:MovieClip) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         if(this.coolDown("doIA"))
         {
            _loc2_ = [];
            _loc2_.push(param1.iaType);
            _loc2_.push(param1.name);
            if("iaPathMC" in param1)
            {
               _loc2_.push(this.myAvatar.dataLeaf.strFrame);
            }
            else
            {
               _loc2_.push(param1.iaFrame);
            }
            if("iaStr" in param1)
            {
               _loc2_.push(param1.iaStr);
            }
            if("iaPathMC" in param1)
            {
               _loc2_.push(param1.iaPathMC);
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc3_++;
            }
            this.rootClass.sfc.sendXtMessage("zm","ia",_loc2_,"str",1);
         }
      }
      
      public function actCastRequest(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         _loc2_ = ["castr"];
         _loc3_ = [];
         switch(param1.typ)
         {
            case "sia":
               if(this.coolDown("doIA"))
               {
                  _loc4_ = {};
                  _loc4_.typ = "sia";
                  _loc4_.callback = this.actCastTrigger;
                  _loc4_.args = param1;
                  _loc4_.dur = Number(param1.sAccessCD);
                  _loc4_.txt = param1.sMsg;
                  this.rootClass.ui.mcCastBar.fOpenWith(_loc4_);
                  _loc3_.push(1);
                  _loc3_.push(param1.ID);
               }
         }
         if(_loc3_.length > 0)
         {
            this.rootClass.sfc.sendXtMessage("zm",_loc2_,_loc3_,"str",1);
         }
      }
      
      public function actCastTrigger(param1:Object) : void
      {
         switch(param1.typ)
         {
            case "sia":
               this.siaTrigger(param1);
         }
      }
      
      public function siaTrigger(param1:Object) : void
      {
         this.rootClass.sfc.sendXtMessage("zm",["castt"],[],"str",1);
      }
      
      public function uoTreeLeaf(param1:*) : Object
      {
         if(this.uoTree[param1.toLowerCase()] == null)
         {
            this.uoTree[param1.toLowerCase()] = {};
         }
         return this.uoTree[param1.toLowerCase()];
      }
      
      public function myLeaf() : Object
      {
         return this.uoTreeLeaf(this.rootClass.sfc.myUserName);
      }
      
      public function uoTreeLeafSet(param1:*, param2:Object) : *
      {
         var _loc3_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this.uoTree[param1.toLowerCase()] == null)
         {
            this.uoTree[param1.toLowerCase()] = {};
         }
         _loc3_ = this.uoTree[param1.toLowerCase()];
         var _loc4_:* = [];
         for(var _loc9_ in param2)
         {
            _loc5_ = _loc9_;
            _loc9_;
            _loc3_[_loc5_] = param2[_loc5_];
            _loc6_ = this.getAvatarByUserName(param1);
            if(_loc6_ != null && _loc6_.objData != null)
            {
               _loc6_.objData[_loc5_] = param2[_loc5_];
            }
         }
      }
      
      public function manageAreaUser(param1:String, param2:String) : void
      {
         var _loc3_:int = 0;
         param1 = param1.toLowerCase();
         if(param2 == "+")
         {
            if(this.areaUsers.indexOf(param1) == -1)
            {
               this.areaUsers.push(param1);
            }
         }
         else
         {
            _loc3_ = int(this.areaUsers.indexOf(param1));
            if(_loc3_ > -1)
            {
               this.areaUsers.splice(_loc3_,1);
            }
         }
         this.rootClass.updateAreaName();
      }
      
      public function updateAreaUserCount() : void
      {
      }
      
      public function setAllCloakVisibility() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Avatar = null;
         _loc1_ = this.getUsersByCell(this.myAvatar.dataLeaf.strFrame);
         for each(var _loc5_ in _loc1_)
         {
            _loc2_ = _loc5_;
            _loc5_;
            _loc2_.pMC.setCloakVisibility(_loc2_.dataLeaf.showCloak);
         }
      }
      
      public function queueDungeon(param1:String) : void
      {
         if(this.coolDown("dungeonQueue"))
         {
            this.rootClass.sfc.sendXtMessage("zm","dungeonQueue",[param1],"str",this.curRoom);
         }
      }
      
      public function rejoinDungeon() : void
      {
         if(this.coolDown("dungeonRejoin"))
         {
            this.rootClass.sfc.sendXtMessage("zm","dungeonRejoin",[],"str",this.curRoom);
         }
      }
      
      public function coolDown(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         _loc2_ = this.lock[param1];
         _loc3_ = new Date();
         _loc4_ = _loc3_.getTime();
         _loc5_ = _loc4_ - _loc2_.ts;
         if(_loc5_ < _loc2_.cd)
         {
            this.rootClass.chatF.pushMsg("warning","Action taken too quickly, try again in a moment.","SERVER","",0);
            return false;
         }
         _loc2_.ts = _loc4_;
         return true;
      }
      
      public function copyAvatarMC(param1:MovieClip) : void
      {
         var copier:AvatarMCCopier = null;
         var mcChar:MovieClip = param1;
         copier = new AvatarMCCopier(this);
         try
         {
            copier.copyTo(mcChar);
         }
         catch(e:Error)
         {
            rootClass.debugMessage("copyAvatarMC failed: " + e.message);
            copier.forceComplete();
         }
      }
      
      public function doLoadPet(param1:Avatar) : Boolean
      {
         if(!this.rootClass.uoPref.bPet && param1 == this.myAvatar)
         {
            return false;
         }
         if(param1 != this.myAvatar && this.hideOtherPets)
         {
            return false;
         }
         return true;
      }
      
      public function get Scale() : Number
      {
         return this.SCALE;
      }
      
      public function get bankinfo() : BankController
      {
         return this.bankController;
      }
   }
}

