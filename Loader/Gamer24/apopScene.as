package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class apopScene extends Sprite
   {
      public var mcBackground:MovieClip;
      
      public var bMask:MovieClip;
      
      public var bMask2:MovieClip;
      
      public var mcGold:MovieClip;
      
      public var tbBold:TextField;
      
      public var mcScene2:MovieClip;
      
      public var mcScene:MovieClip;
      
      private var rootClass:MovieClip;
      
      private var bQuest:Boolean;
      
      private var intBack:int = -1;
      
      private var qID:int;
      
      private var questTitle:String;
      
      private var parent_:apopCore;
      
      private var initialized:Boolean = false;
      
      public var accepted:Boolean = false;
      
      private var complete:Boolean = false;
      
      private var tbTitle:TextField;
      
      private var tbDesc:TextField;
      
      private var tbQuestO:TextField;
      
      private var tbReward:TextField;
      
      private var tbCoinExp:TextField;
      
      private var ID_:int = -1;
      
      private var curY:Number;
      
      private var btns:apopBtn;
      
      private var start_:Boolean = false;
      
      private var locked:Boolean = false;
      
      private var qData:Object;
      
      private var arrQuest:Array;
      
      private var arrBtns:Array;
      
      private var questBtns:Array;
      
      private var item:Object;
      
      public function apopScene(param1:MovieClip, param2:Object, param3:apopCore)
      {
         var _loc4_:Sprite = null;
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:mcObjective = null;
         var _loc8_:MovieClip = null;
         var _loc9_:* = undefined;
         var _loc10_:String = null;
         var _loc11_:Class = null;
         var _loc12_:MovieClip = null;
         var _loc13_:MovieClip = null;
         this.titleFormat = new TextFormat("Arial",16,null,true);
         this.descFormat = new TextFormat("Arial",12);
         this.questFormat = new TextFormat("Arial",9,null,true);
         this.coinFormat = new TextFormat("Arial",12,null,true);
         this.btnAccept = {
            "intAction":9,
            "buttonText":"Begin Quest",
            "buttonID":-1,
            "strIcon":"iidesign"
         };
         this.btnTurnin = {
            "intAction":11,
            "buttonText":"Turnin",
            "buttonID":-1,
            "strIcon":"iCheck"
         };
         this.btnAbandon = {
            "intAction":12,
            "buttonText":"Abandon",
            "buttonID":-1,
            "strIcon":"iTrash",
            "width":148
         };
         this.btnBack = {
            "intAction":10,
            "buttonText":"Back",
            "strIcon":"iArrow",
            "buttonID":-1
         };
         this.rewardTypes = ["itemsS","itemsC","itemsR","itemsrand"];
         this.questBtns = new Array();
         super();
         if(param2.sceneID != null)
         {
            this.rootClass = param1;
            this.parent_ = param3;
            this.bQuest = param2.bType;
            if(param2.arrQuests != null)
            {
               this.arrQuest = String(param2.arrQuests).split(",");
            }
            if(param2.sBtns != null)
            {
               this.arrBtns = param2.sBtns;
            }
            this.tbBold.visible = false;
            this.bMask.visible = false;
            this.bMask2.visible = false;
            this.ID_ = param2.sceneID;
            this.start_ = param2.bStart;
            if(param2.strLock != null)
            {
               this.locked = this.decodeLock(param2.strLock);
            }
            if(this.bQuest)
            {
               this.qID = param2.qID;
               this.qData = this.rootClass.world.questTree[param2.qID];
               this.tbTitle = new TextField();
               this.tbTitle.defaultTextFormat = this.titleFormat;
               this.tbTitle.embedFonts = true;
               this.tbTitle.antiAliasType = AntiAliasType.ADVANCED;
               this.tbTitle.text = this.qData.sName;
               this.questTitle = this.qData.sName;
               this.tbTitle.width = 283;
               this.tbTitle.mouseEnabled = false;
               this.mcScene.addChild(this.tbTitle);
               this.tbDesc = new TextField();
               this.tbDesc.defaultTextFormat = this.descFormat;
               this.tbDesc.embedFonts = true;
               this.tbDesc.wordWrap = true;
               this.tbDesc.multiline = true;
               this.tbDesc.width = 283;
               this.tbDesc.antiAliasType = AntiAliasType.ADVANCED;
               this.tbDesc.text = this.qData.sDesc;
               this.tbDesc.mouseEnabled = false;
               this.tbDesc.y = 22;
               this.mcScene.addChild(this.tbDesc);
               this.tbDesc.height = this.tbDesc.textHeight + 10;
               this.curY = this.tbDesc.y + this.tbDesc.height;
               if(this.qData.turnin != null)
               {
                  this.tbQuestO = new TextField();
                  this.tbQuestO.defaultTextFormat = this.questFormat;
                  this.tbQuestO.embedFonts = true;
                  this.tbQuestO.antiAliasType = AntiAliasType.ADVANCED;
                  this.tbQuestO.width = 283;
                  this.tbQuestO.text = "QUEST OBJECTIVES";
                  this.tbQuestO.mouseEnabled = false;
                  this.tbQuestO.y = this.curY;
                  this.mcScene.addChild(this.tbQuestO);
                  this.curY += 15;
                  _loc6_ = 0;
                  while(_loc6_ < this.qData.turnin.length)
                  {
                     _loc5_ = this.rootClass.world.invTree[this.qData.turnin[_loc6_].ItemID];
                     _loc7_ = new mcObjective();
                     _loc7_.x = 1;
                     _loc7_.y = this.curY;
                     this.curY += 18.25;
                     _loc7_.txtObjective.text = _loc5_.sName + " " + _loc5_.iQty + "/" + this.qData.turnin[_loc6_].iQty;
                     if(_loc5_.iQty >= this.qData.turnin[_loc6_].iQty)
                     {
                        _loc7_.txtObjective.textColor = 2518295;
                     }
                     else
                     {
                        _loc7_.txtObjective.textColor = 8198940;
                     }
                     this.mcScene.addChild(_loc7_);
                     _loc6_++;
                  }
               }
               this.curY += 7;
               this.tbReward = new TextField();
               this.tbReward.defaultTextFormat = this.questFormat;
               this.tbReward.embedFonts = true;
               this.tbReward.antiAliasType = AntiAliasType.ADVANCED;
               this.tbReward.width = 283;
               this.tbReward.text = "REWARDS";
               this.tbReward.y = this.curY;
               this.tbReward.mouseEnabled = false;
               this.mcScene.addChild(this.tbReward);
               this.curY += 17;
               _loc4_ = new iCoin();
               _loc4_.x = 2;
               _loc4_.y = this.curY;
               _loc4_.width = _loc4_.height = 17;
               this.mcScene.addChild(_loc4_);
               this.tbCoinExp = new TextField();
               this.tbCoinExp.defaultTextFormat = this.coinFormat;
               this.tbCoinExp.embedFonts = true;
               this.tbCoinExp.textColor = 5000268;
               this.tbCoinExp.antiAliasType = AntiAliasType.ADVANCED;
               this.tbCoinExp.text = "x" + this.qData.iGold;
               this.tbCoinExp.x = 23;
               this.tbCoinExp.y = this.curY;
               this.tbCoinExp.mouseEnabled = false;
               this.mcScene.addChild(this.tbCoinExp);
               _loc4_ = new iXP();
               _loc4_.x = 79;
               _loc4_.y = this.curY;
               _loc4_.width = 27;
               _loc4_.height = 18;
               this.mcScene.addChild(_loc4_);
               this.tbCoinExp = new TextField();
               this.tbCoinExp.defaultTextFormat = this.coinFormat;
               this.tbCoinExp.embedFonts = true;
               this.tbCoinExp.textColor = 5000268;
               this.tbCoinExp.antiAliasType = AntiAliasType.ADVANCED;
               this.tbCoinExp.text = "x" + this.qData.iExp;
               this.tbCoinExp.x = _loc4_.x + 30;
               this.tbCoinExp.y = this.curY;
               this.tbCoinExp.mouseEnabled = false;
               this.mcScene.addChild(this.tbCoinExp);
               this.curY += 25;
               if(this.qData.oRewards != null)
               {
                  _loc6_ = 0;
                  while(_loc6_ < this.rewardTypes.length)
                  {
                     if(this.qData.oRewards[this.rewardTypes[_loc6_]] != null)
                     {
                        this.tbCoinExp = new TextField();
                        this.tbCoinExp.defaultTextFormat = this.coinFormat;
                        this.tbCoinExp.embedFonts = true;
                        this.tbCoinExp.textColor = 5000268;
                        this.tbCoinExp.antiAliasType = AntiAliasType.ADVANCED;
                        this.tbCoinExp.y = this.curY;
                        this.tbCoinExp.mouseEnabled = false;
                        switch(this.rewardTypes[_loc6_])
                        {
                           case "itemsS":
                           default:
                              this.tbCoinExp.text = "Items:";
                              break;
                           case "itemsC":
                              this.tbCoinExp.text = "You may also choose one of:";
                              break;
                           case "itemsR":
                              this.tbCoinExp.text = "You may also recieve, at random:";
                              break;
                           case "itemsrand":
                              this.tbCoinExp.text = "You will recieve ONE OF THE FOLLOWING ITEMS:";
                        }
                        this.mcScene.addChild(this.tbCoinExp);
                        this.curY += 17;
                        for(_loc9_ in this.qData.oRewards[this.rewardTypes[_loc6_]])
                        {
                           _loc8_ = new mcItem();
                           _loc8_.y = this.curY;
                           _loc5_ = this.qData.oRewards[this.rewardTypes[_loc6_]][_loc9_];
                           _loc8_.txtName.text = _loc5_.sName;
                           _loc8_.txtQty.text = "X" + _loc5_.iQty;
                           this.mcScene.addChild(_loc8_);
                           _loc10_ = "";
                           if(_loc5_.sType.toLowerCase() == "enhancement")
                           {
                              _loc10_ = this.rootClass.getIconBySlot(_loc5_.sES);
                           }
                           else if(_loc5_.sIcon == null || _loc5_.sIcon == "" || _loc5_.sIcon == "none")
                           {
                              if(_loc5_.sLink.toLowerCase() != "none")
                              {
                                 _loc10_ = "iidesign";
                              }
                              else
                              {
                                 _loc10_ = "iibag";
                              }
                           }
                           else
                           {
                              _loc10_ = _loc5_.sIcon;
                           }
                           try
                           {
                              _loc11_ = this.rootClass.world.getClass(_loc10_) as Class;
                              _loc12_ = _loc8_.addChild(new _loc11_()) as MovieClip;
                              _loc12_.scaleX = _loc12_.scaleY = 0.5;
                           }
                           catch(e:Error)
                           {
                           }
                           this.curY += 33;
                        }
                     }
                     _loc6_++;
                  }
               }
               this.curY += 20;
               if(this.curY > 290)
               {
                  _loc13_ = this.addChild(new sBar(this.mcScene,this.bMask,this.rootClass)) as MovieClip;
                  _loc13_.x = 309;
                  _loc13_.y = 25;
                  this.curY = 290;
               }
               this.mcBackground.height = this.curY;
               this.mcBackground.height = this.mcBackground.height < 130 ? 130 : this.mcBackground.height;
               this.curY = this.mcBackground.height + 15;
            }
            else
            {
               this.tbDesc = new TextField();
               this.tbDesc.defaultTextFormat = this.descFormat;
               this.tbDesc.embedFonts = true;
               this.tbDesc.wordWrap = true;
               this.tbDesc.multiline = true;
               this.tbDesc.width = 283;
               this.tbDesc.antiAliasType = AntiAliasType.ADVANCED;
               this.tbDesc.text = param2.strText;
               this.tbDesc.mouseEnabled = false;
               this.mcScene.addChild(this.tbDesc);
               this.tbDesc.height = this.tbDesc.textHeight + 10;
               this.curY = this.tbDesc.height + 15;
               this.mcBackground.height = this.curY;
               this.mcBackground.height = this.mcBackground.height < 130 ? 130 : this.mcBackground.height;
               this.curY = this.mcBackground.height + 15;
               if(this.arrQuest != null)
               {
                  this.tbTitle = new TextField();
                  this.tbTitle.defaultTextFormat = this.titleFormat;
                  this.tbTitle.embedFonts = true;
                  this.tbTitle.antiAliasType = AntiAliasType.ADVANCED;
                  this.tbTitle.text = "Quests";
                  this.tbTitle.width = 283;
                  this.tbTitle.y = this.tbDesc.height;
                  this.tbTitle.mouseEnabled = false;
                  this.mcScene.addChild(this.tbTitle);
                  this.curY = this.tbTitle.y + 22;
                  this.mcBackground.height = this.curY;
               }
            }
         }
      }
      
      private function decodeLock(param1:String) : Boolean
      {
         var lockData:Array = null;
         var qVal:int = 0;
         var fct:Function = null;
         var strLock:String = param1;
         var lockTokens:Array = strLock.split(";");
         var bReturn:Boolean = true;
         var i:uint = 0;
         while(i < lockTokens.length)
         {
            lockData = lockTokens[i].split(",");
            switch(lockData[0])
            {
               case "map":
                  try
                  {
                     fct = this.rootClass.world.map[lockData[1]];
                     return fct(this.ID_);
                  }
                  catch(e:*)
                  {
                     trace("apop function call error: " + e);
                  }
                  break;
               case "qs":
                  qVal = int(this.rootClass.world.getQuestValue(int(lockData[1])));
                  bReturn &&= qVal >= int(lockData[2]);
                  break;
               case "qsb":
                  qVal = int(this.rootClass.world.getQuestValue(int(lockData[1])));
                  bReturn &&= qVal >= int(lockData[2]) && qVal < int(lockData[3]);
                  break;
               case "qip":
                  bReturn &&= Boolean(this.rootClass.world.isQuestInProgress(int(lockData[1])));
                  break;
               case "item":
                  bReturn &&= Boolean(this.rootClass.world.myAvatar.isItemInInventory(int(lockData[1])));
                  break;
            }
            i++;
         }
         return !bReturn;
      }
      
      public function isQuestComplete() : Boolean
      {
         var _loc1_:Object = null;
         if(this.qData.turnin.length < 1)
         {
            return true;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.qData.turnin.length)
         {
            _loc1_ = this.rootClass.world.invTree[this.qData.turnin[_loc2_].ItemID];
            if(_loc1_.iQty < this.qData.turnin[_loc2_].iQty)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function isQuestAvailable() : Boolean
      {
         if(this.qData != null)
         {
            if(this.qData.bGuild != null && this.qData.bGuild == 1)
            {
               if(this.rootClass.world.myAvatar.objData.guild == null)
               {
                  return false;
               }
               if(this.qData.iReqRep > 0 && this.rootClass.world.myAvatar.objData.guild.guildRep < this.qData.iReqRep)
               {
                  return false;
               }
            }
            if(this.qData.sField != null && this.rootClass.world.getAchievement(this.qData.sField,this.qData.iIndex) != 0 || this.qData.iLvl > this.rootClass.world.myAvatar.objData.intLevel || this.qData.bUpg == 1 && !this.rootClass.world.myAvatar.isUpgraded() || this.qData.iSlot >= 0 && this.rootClass.world.getQuestValue(this.qData.iSlot) < Math.abs(this.qData.iValue) - 1 || this.qData.iClass > 0 && this.rootClass.world.myAvatar.getCPByID(this.qData.iClass) < this.qData.iReqCP || this.qData.FactionID > 1 && this.rootClass.world.myAvatar.getRep(this.qData.FactionID) < this.qData.iReqRep)
            {
               return false;
            }
            return true;
         }
         return false;
      }
      
      public function init(param1:int = -1) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:apopScene = null;
         var _loc4_:uint = 0;
         var _loc5_:questBtn = null;
         var _loc6_:uint = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 > -1)
         {
            this.intBack = param1;
         }
         this.btnBack.width = 227;
         if(this.bQuest)
         {
            if(this.initialized)
            {
               return;
            }
            this.accepted = this.rootClass.world.isQuestInProgress(this.qID);
            if(!this.accepted)
            {
               this.btns = new apopBtn(this.rootClass,this.btnAccept,this);
               this.btns.y = this.curY;
               this.btns.x = 50;
               this.addChild(this.btns);
               this.curY += 37;
               this.btns = new apopBtn(this.rootClass,this.btnBack,this);
               this.btns.y = this.curY;
               this.btns.x = 50;
               this.addChild(this.btns);
            }
            else
            {
               _loc2_ = false;
               if(this.isQuestComplete())
               {
                  this.btns = new apopBtn(this.rootClass,this.btnTurnin,this);
                  this.btns.y = this.curY;
                  this.btns.x = 50;
                  this.addChild(this.btns);
                  this.btnBack.width = 148;
                  this.curY += 37;
                  this.btns = new apopBtn(this.rootClass,this.btnBack,this);
                  this.btns.y = this.curY;
                  this.btns.x = 10;
                  this.addChild(this.btns);
                  this.btns = new apopBtn(this.rootClass,this.btnAbandon,this);
                  this.btns.y = this.curY;
                  this.btns.x = 170;
                  this.addChild(this.btns);
               }
               else
               {
                  this.btnBack.width = 148;
                  this.btns = new apopBtn(this.rootClass,this.btnBack,this);
                  this.btns.y = this.curY;
                  this.btns.x = 10;
                  this.addChild(this.btns);
                  this.btns = new apopBtn(this.rootClass,this.btnAbandon,this);
                  this.btns.y = this.curY;
                  this.btns.x = 170;
                  this.addChild(this.btns);
               }
            }
            this.mcGold.height = this.curY + 50;
         }
         else
         {
            if(this.arrQuest != null)
            {
               if(this.initialized)
               {
                  while(_loc4_ < this.questBtns.length)
                  {
                     _loc3_ = this.parent_.getQuestScene("q" + String(this.questBtns[_loc4_].ID));
                     this.questBtns[_loc4_].update(this.rootClass.world.isQuestInProgress(_loc3_.QuestID),_loc3_.isQuestAvailable(),_loc3_.isQuestComplete());
                     _loc4_++;
                  }
               }
               else
               {
                  _loc6_ = 0;
                  while(_loc6_ < this.arrQuest.length)
                  {
                     _loc3_ = this.parent_.getQuestScene("q" + String(this.arrQuest[_loc6_]));
                     _loc5_ = new questBtn(this.parent_,{
                        "sceneID":_loc3_.QuestID,
                        "strText":_loc3_.QuestTitle,
                        "accepted":this.rootClass.world.isQuestInProgress(_loc3_.QuestID),
                        "available":_loc3_.isQuestAvailable(),
                        "complete":_loc3_.isQuestComplete()
                     },this.rootClass);
                     _loc5_.x = 1;
                     _loc5_.y = this.curY;
                     this.questBtns.push(_loc5_);
                     this.mcScene.addChild(_loc5_);
                     this.curY += 18.25;
                     _loc6_++;
                  }
                  this.curY += 30;
                  if(this.curY > 290)
                  {
                     _loc7_ = this.addChild(new sBar(this.mcScene,this.bMask,this.rootClass)) as MovieClip;
                     _loc7_.x = 309;
                     _loc7_.y = 25;
                     this.curY = 290;
                  }
                  this.mcBackground.height = this.curY;
                  this.mcBackground.height = this.mcBackground.height < 130 ? 130 : this.mcBackground.height;
                  this.curY = this.mcBackground.height + 30;
                  this.btns = new apopBtn(this.rootClass,this.btnBack,this);
                  this.btns.y = this.curY;
                  this.btns.x = 50;
                  this.addChild(this.btns);
                  this.curY += 30;
               }
            }
            else if(this.arrBtns != null)
            {
               if(this.initialized)
               {
                  return;
               }
               if(!this.start_)
               {
                  this.arrBtns.push(this.btnBack);
               }
               _loc8_ = int(this.arrBtns.length);
               _loc9_ = 10;
               _loc9_ = 0;
               this.mcScene2.y = this.curY;
               this.bMask2.y = this.curY;
               _loc6_ = 0;
               while(_loc6_ < _loc8_)
               {
                  this.btns = new apopBtn(this.rootClass,this.arrBtns[_loc6_],this);
                  this.btns.y = _loc9_;
                  this.curY += 37;
                  _loc9_ += 37;
                  this.mcScene2.addChild(this.btns);
                  _loc6_++;
               }
               if(this.curY > 360)
               {
                  this.curY = 360;
                  this.bMask2.height = 360 - this.bMask2.y;
                  _loc7_ = this.addChild(new sBar(this.mcScene2,this.bMask2,this.rootClass)) as MovieClip;
                  _loc7_.x = 309;
                  _loc7_.y = this.mcScene2.y + 5;
               }
            }
            else if(!this.start_ && !this.initialized)
            {
               this.btns = new apopBtn(this.rootClass,this.btnBack,this);
               this.btns.y = this.curY;
               this.btns.x = 40;
               this.addChild(this.btns);
               this.curY += 30;
            }
            this.mcGold.height = this.curY + 20;
         }
         this.initialized = true;
      }
      
      public function Back() : void
      {
         this.parent_.showScene(this.intBack,true);
      }
      
      public function get ID() : int
      {
         return this.ID_;
      }
      
      public function get QuestID() : int
      {
         return this.qID;
      }
      
      public function get Start() : Boolean
      {
         return this.start_;
      }
      
      public function get Locked() : Boolean
      {
         return this.locked;
      }
      
      public function get Quest() : Boolean
      {
         return this.bQuest;
      }
      
      public function get QuestTitle() : String
      {
         return this.questTitle;
      }
      
      public function get Parent() : apopCore
      {
         return this.parent_;
      }
   }
}

