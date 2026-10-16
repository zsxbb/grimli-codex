package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class ChatBase
   {
      public var rootClass:*;
      
      public var chn:Object;
      
      public var myMsgs:Array;
      
      public var myMsgsI:int = 0;
      
      public var pmSourceA:Array;
      
      public var pmI:int = 0;
      
      public var pmNm:String = "";
      
      protected var pmMode:int = 0;
      
      public var ignoreList:SharedObject;
      
      public var mute:Object;
      
      public var legalChars:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*_+-=:\"?,./;\'\\|<>() ";
      
      public var legalCharsStrict:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
      
      public var markChars:String = "~!@#$%^&*()_+-=:\"<>?,.;\'\\";
      
      public var strictComparisonChars:String = "~!@#$%^&*()_+-=:\"<>?,.;\'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";
      
      public var strictComparisonCharsB:String = "~!#%^&()_+-=:\"<>?,.;\'\\ÇüéâäåçêëèïîìÄÅæÆôöòûùÿ֣¥áíóúñ?£ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝß";
      
      public var illegalStrings:Array;
      
      public var modWhisperCheckList:Array;
      
      public var unsendable:Array;
      
      public var emailWarning:String = "WARNING: Never give your email or password to anyone else. Moderators have gold names. If a player does not have a gold name they are NOT a moderator or staff member.";
      
      public var regExpA:RegExp;
      
      public var regExpE:RegExp;
      
      public var regExpI:RegExp;
      
      public var regExpO:RegExp;
      
      public var regExpU:RegExp;
      
      public var regExpSPACE:RegExp;
      
      protected var regExpMod:RegExp;
      
      public var regExpURL:RegExp;
      
      public var t:Timer;
      
      public var windowTimer:Timer;
      
      public function ChatBase()
      {
         this.chn = new Object();
         this.myMsgs = [];
         this.pmSourceA = [];
         this.ignoreList = SharedObject.getLocal("ignoreList","/");
         this.mute = {
            "ts":0,
            "cd":0,
            "timer":new Timer(0,1)
         };
         this.illegalStrings = ["&#","www","http","https","ftp",".com",".c0m",".net",".org",".de",".ru",".sg",".ph",".tk","dotcom","freegold","freecoins","freeadventurecoins","freelevels","freeitems","freeupgrades","gmail","yahoo","hotmail","aol","formfacil","email","password"];
         this.modWhisperCheckList = ["trade","free","acs","member","pass","login","user","imamod","iamamod","i\'mamod","account"];
         this.unsendable = ["@"];
         this.regExpA = /(a{2,})/gi;
         this.regExpE = /(e{2,})/gi;
         this.regExpI = /(i{2,})/gi;
         this.regExpO = /(o{2,})/gi;
         this.regExpU = /(u{2,})/gi;
         this.regExpSPACE = /(\s{2,})/gi;
         this.regExpMod = /(\(|<)mod(era(t|d)or)?(>|\))/gi;
         this.regExpURL = new RegExp("\\bhttps://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]","gi");
         this.t = new Timer(500,1);
         this.windowTimer = new Timer(60000,1);
         super();
         this.initChannels();
      }
      
      protected function initChannels() : void
      {
         this.chn.cur = {};
         this.chn.lastPublic = {};
         this.chn.xt = "zm";
         this.chn.zone = {};
         this.chn.trade = {};
         this.chn.moderator = {};
         this.chn.warning = {};
         this.chn.server = {};
         this.chn.event = {};
         this.chn.whisper = {};
         this.chn.party = {};
         this.chn.guild = {};
         this.chn.wheel = {};
         this.chn.zone.col = 10275581;
         this.chn.trade.col = 13827476;
         this.chn.moderator.col = 16763955;
         this.chn.warning.col = 11010048;
         this.chn.server.col = 65535;
         this.chn.event.col = 65280;
         this.chn.whisper.col = 16711935;
         this.chn.party.col = 52479;
         this.chn.guild.col = 10092288;
         this.chn.wheel.col = 16763955;
         this.chn.zone.colStr = "9CCAFD";
         this.chn.trade.colStr = "D2FD94";
         this.chn.moderator.colStr = "FFCC33";
         this.chn.warning.colStr = "A80000";
         this.chn.server.colStr = "00FFFF";
         this.chn.event.colStr = "00FF00";
         this.chn.whisper.colStr = "FF00FF";
         this.chn.party.colStr = "00CCFF";
         this.chn.guild.colStr = "99FF00";
         this.chn.wheel.colStr = "FFCC33";
         this.chn.zone.str = "zone";
         this.chn.trade.str = "trade";
         this.chn.moderator.str = "moderator";
         this.chn.warning.str = "warning";
         this.chn.server.str = "server";
         this.chn.event.str = "event";
         this.chn.whisper.str = "whisper";
         this.chn.party.str = "party";
         this.chn.guild.str = "guild";
         this.chn.wheel.str = "wheel";
         this.chn.zone.typ = "message";
         this.chn.trade.typ = "message";
         this.chn.moderator.typ = "whisper";
         this.chn.warning.typ = "server";
         this.chn.server.typ = "server";
         this.chn.event.typ = "event";
         this.chn.whisper.typ = "whisper";
         this.chn.party.typ = "message";
         this.chn.guild.typ = "message";
         this.chn.wheel.typ = "whisper";
         this.chn.zone.tag = "";
         this.chn.trade.tag = "";
         this.chn.moderator.tag = "Moderator";
         this.chn.warning.tag = "";
         this.chn.server.tag = "";
         this.chn.whisper.tag = "Whisper";
         this.chn.event.tag = "";
         this.chn.party.tag = "Party";
         this.chn.guild.tag = "Guild";
         this.chn.wheel.tag = "Wheel of Doom";
         this.chn.zone.rid = 0;
         this.chn.trade.rid = 0;
         this.chn.moderator.rid = 0;
         this.chn.warning.rid = 0;
         this.chn.server.rid = 0;
         this.chn.event.rid = 0;
         this.chn.whisper.rid = 0;
         this.chn.party.rid = 32123;
         this.chn.guild.rid = 0;
         this.chn.wheel.rid = 0;
         this.chn.zone.act = 1;
         this.chn.trade.act = 0;
         this.chn.moderator.act = 1;
         this.chn.warning.act = 1;
         this.chn.server.act = 1;
         this.chn.event.act = 1;
         this.chn.whisper.act = 1;
         this.chn.party.act = 0;
         this.chn.guild.act = 0;
         this.chn.wheel.act = 1;
         this.chn.cur = this.chn.zone;
         this.chn.lastPublic = this.chn.cur;
         if(this.ignoreList.data.users == undefined)
         {
            this.ignoreList.data.users = [];
         }
      }
      
      public function isIgnored(param1:String) : Boolean
      {
         if(this.ignoreList.data.users == null)
         {
            return false;
         }
         var _loc2_:String = param1.toLowerCase();
         var _loc3_:int = 0;
         while(_loc3_ < this.ignoreList.data.users.length)
         {
            if(this.ignoreList.data.users[_loc3_].toLowerCase() == _loc2_)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function addIgnore(param1:String) : Boolean
      {
         var username:String = param1;
         if(this.isIgnored(username))
         {
            return false;
         }
         this.ignoreList.data.users.push(username);
         try
         {
            this.ignoreList.flush();
         }
         catch(e:Error)
         {
            trace("[Chat] ERR addIgnore: ignoreList flush: " + e.message);
         }
         return true;
      }
      
      public function removeIgnore(param1:String) : Boolean
      {
         var username:String = param1;
         var lowerName:String = username.toLowerCase();
         var i:int = 0;
         while(i < this.ignoreList.data.users.length)
         {
            if(this.ignoreList.data.users[i].toLowerCase() == lowerName)
            {
               this.ignoreList.data.users.splice(i,1);
               try
               {
                  this.ignoreList.flush();
               }
               catch(e:Error)
               {
                  trace("[Chat] ERR removeIgnore: ignoreList flush: " + e.message);
               }
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function hasIllegalString(param1:String) : Boolean
      {
         var _loc2_:String = param1.toLowerCase();
         var _loc3_:int = 0;
         while(_loc3_ < this.illegalStrings.length)
         {
            if(_loc2_.indexOf(this.illegalStrings[_loc3_]) > -1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function hasModImpersonation(param1:String) : Boolean
      {
         var _loc2_:String = param1.toLowerCase();
         var _loc3_:int = 0;
         while(_loc3_ < this.modWhisperCheckList.length)
         {
            if(_loc2_.indexOf(this.modWhisperCheckList[_loc3_]) > -1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function validateChars(param1:String, param2:Boolean = false) : String
      {
         var _loc6_:String = null;
         var _loc3_:String = param2 ? this.legalCharsStrict : this.legalChars;
         var _loc4_:String = "";
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = param1.charAt(_loc5_);
            if(_loc3_.indexOf(_loc6_) > -1)
            {
               _loc4_ += _loc6_;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function unmuteMe(param1:Event = null) : void
      {
      }
      
      public function getChannelByStr(param1:String) : Object
      {
         switch(param1.toLowerCase())
         {
            case "zone":
               return this.chn.zone;
            case "trade":
               return this.chn.trade;
            case "moderator":
               return this.chn.moderator;
            case "warning":
               return this.chn.warning;
            case "server":
               return this.chn.server;
            case "event":
               return this.chn.event;
            case "whisper":
               return this.chn.whisper;
            case "party":
               return this.chn.party;
            case "guild":
               return this.chn.guild;
            case "wheel":
               return this.chn.wheel;
            default:
               return this.chn.zone;
         }
      }
      
      protected function initCannedChat(param1:XMLList) : MovieClip
      {
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         var _loc9_:int = 0;
         var _loc10_:MovieClip = null;
         var _loc11_:MovieClip = null;
         var _loc12_:int = 0;
         var _loc13_:MovieClip = null;
         var _loc14_:MovieClip = null;
         var _loc2_:MovieClip = new MovieClip();
         var _loc3_:Number = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length())
         {
            _loc7_ = new CannedOption();
            _loc7_.y = _loc4_ * 23;
            _loc7_.addEventListener(MouseEvent.ROLL_OVER,this.onCannedRollOver,false,0,true);
            _loc7_.addEventListener(MouseEvent.ROLL_OUT,this.onCannedRollOut,false,0,true);
            _loc7_.txtChat.text = param1[_loc4_].@display;
            if(_loc7_.txtChat.textWidth > _loc3_)
            {
               _loc3_ = Number(_loc7_.txtChat.textWidth);
            }
            if(param1[_loc4_].children().length() > 0)
            {
               _loc7_.mcMore.visible = true;
               _loc7_.strID = param1[_loc4_].@id;
               _loc7_.addEventListener(MouseEvent.CLICK,this.onCannedSubClick,false,0,true);
               _loc8_ = new MovieClip();
               _loc9_ = 0;
               while(_loc9_ < param1[_loc4_].children().length())
               {
                  _loc10_ = new CannedOption();
                  _loc10_.y = _loc9_ * 23;
                  _loc10_.addEventListener(MouseEvent.ROLL_OVER,this.onCannedRollOver,false,0,true);
                  _loc10_.addEventListener(MouseEvent.ROLL_OUT,this.onCannedRollOut,false,0,true);
                  _loc10_.txtChat.text = param1[_loc4_].children()[_loc9_].@display;
                  if(param1[_loc4_].children()[_loc9_].children().length() > 0)
                  {
                     _loc10_.mcMore.visible = true;
                     _loc10_.strID = param1[_loc4_].children()[_loc9_].@id;
                     _loc10_.addEventListener(MouseEvent.CLICK,this.onCannedSubClick,false,0,true);
                     _loc11_ = new MovieClip();
                     _loc12_ = 0;
                     while(_loc12_ < param1[_loc4_].children()[_loc9_].children().length())
                     {
                        _loc13_ = new CannedOption();
                        _loc13_.y = _loc12_ * 23;
                        _loc13_.addEventListener(MouseEvent.ROLL_OVER,this.onCannedRollOver,false,0,true);
                        _loc13_.addEventListener(MouseEvent.ROLL_OUT,this.onCannedRollOut,false,0,true);
                        _loc13_.txtChat.text = param1[_loc4_].children()[_loc9_].children()[_loc12_].@display;
                        _loc13_.mcMore.visible = false;
                        _loc13_.strMsg = param1[_loc4_].children()[_loc9_].children()[_loc12_].@text;
                        _loc13_.strID = param1[_loc4_].children()[_loc9_].children()[_loc12_].@id;
                        _loc11_.addChild(_loc13_);
                        _loc13_.addEventListener(MouseEvent.CLICK,this.onCannedMsgClick,false,0,true);
                        _loc12_++;
                     }
                     _loc10_.mcSub = _loc11_;
                     _loc10_.addChild(_loc11_);
                     _loc11_.x = _loc10_.txtChat.width;
                     _loc11_.visible = false;
                  }
                  else
                  {
                     _loc10_.mcMore.visible = false;
                     _loc10_.strMsg = param1[_loc4_].children()[_loc9_].@text;
                     _loc10_.strID = param1[_loc4_].children()[_loc9_].@id;
                     _loc10_.addEventListener(MouseEvent.CLICK,this.onCannedMsgClick,false,0,true);
                  }
                  _loc8_.addChild(_loc10_);
                  _loc9_++;
               }
               _loc7_.mcSub = _loc8_;
               _loc7_.addChild(_loc8_);
               _loc8_.x = _loc7_.txtChat.width;
               _loc8_.visible = false;
            }
            else
            {
               _loc7_.mcMore.visible = false;
               _loc7_.strMsg = param1[_loc4_].@text;
               _loc7_.strID = param1[_loc4_].@id;
               _loc7_.addEventListener(MouseEvent.CLICK,this.onCannedMsgClick,false,0,true);
            }
            _loc2_.addChild(_loc7_);
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.numChildren)
         {
            _loc14_ = MovieClip(_loc2_.getChildAt(_loc5_));
            _loc14_.txtChat.width = _loc3_ + 6;
            _loc14_.bg.width = _loc3_ + 20;
            _loc5_++;
         }
         var _loc6_:BevelFilter = new BevelFilter(1,45,0,1,0,1,0,0,1,3);
         _loc2_.filters = [_loc6_];
         return _loc2_;
      }
      
      protected function onCannedRollOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         _loc2_.bg.transform.colorTransform = new ColorTransform(1,1,1,1,25,25,25,0);
      }
      
      protected function onCannedRollOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         _loc2_.bg.transform.colorTransform = new ColorTransform();
      }
      
      protected function onCannedSubClick(param1:MouseEvent) : void
      {
      }
      
      protected function onCannedMsgClick(param1:MouseEvent) : void
      {
      }
   }
}

