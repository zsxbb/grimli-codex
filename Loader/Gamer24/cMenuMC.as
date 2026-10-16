package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.net.*;
   import flash.text.*;
   import liteAssets.draw.*;
   
   public class cMenuMC extends MovieClip
   {
      public var cnt:MovieClip;
      
      internal var world:MovieClip;
      
      internal var fData:Object = null;
      
      internal var isOpen:Boolean = false;
      
      internal var fMode:String;
      
      internal var mc:MovieClip;
      
      internal var rootClass:MovieClip;
      
      internal var iHi:Number = -1;
      
      internal var iSel:Number = -1;
      
      internal var iCT:ColorTransform;
      
      public function cMenuMC()
      {
         super();
         this.mc = MovieClip(this);
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.mc.cnt.iproto.visible = false;
         this.mc.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOn);
         this.mc.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         this.fData = {};
         this.fData.params = {};
         this.fData.user = ["Char Page","Is Staff?","Hide Helm","Hide Cape","Hide Weapon","Hide Player","Whisper","Add Friend","Go To","Invite","Report","Delete Friend","Ignore","Close"];
         this.fData.friend = ["Char Page","Is Staff?","Whisper","Add Friend","Go To","Invite","Report","Delete Friend","Ignore","Close"];
         this.fData.party = ["Char Page","Whisper","Add Friend","Go To","Remove","Summon","Promote","Report","Delete Friend","Ignore","Close"];
         this.fData.self = ["Char Page","Reputation","Leave Party","Disband Party","Close"];
         this.fData.pvpqueue = ["Leave Queue","Close"];
         this.fData.offline = ["Char Page","Delete Friend","Close"];
         this.fData.ignored = ["Unignore","Close"];
         this.fData.mons = ["View Drops","Wiki Monster","Hide Monster","Close"];
         this.fData.cl = [];
         this.fData.clc = [];
      }
      
      public function fOpenWith(param1:*, param2:*) : *
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         this.isOpen = true;
         this.fMode = param1.toLowerCase();
         this.fData.params = param2;
         this.mc.cnt.mHi.visible = false;
         this.iCT = this.mc.cnt.mHi.transform.colorTransform;
         this.iCT.color = 13434675;
         this.mc.cnt.mHi.transform.colorTransform = this.iCT;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < 13)
         {
            _loc7_ = this.mc.cnt.getChildByName("i" + _loc3_);
            if(_loc7_ != null)
            {
               _loc7_.removeEventListener(MouseEvent.CLICK,this.itemClick);
               _loc7_.removeEventListener(MouseEvent.MOUSE_OVER,this.itemMouseOver);
               this.mc.cnt.removeChild(_loc7_);
            }
            _loc3_++;
         }
         var _loc4_:* = 0;
         delete this.fData.cl;
         delete this.fData.clc;
         var _loc5_:* = this.fData.params.strUsername.toLowerCase();
         var _loc6_:* = this.rootClass.world.uoTree[_loc5_];
         this.fData.cl = this.rootClass.copyObj(this.fData[this.fMode]);
         this.fData.clc = [];
         _loc3_ = 0;
         while(_loc3_ < this.fData.cl.length)
         {
            if(this.fData.cl[_loc3_] == "Add Friend" && Boolean(this.rootClass.world.myAvatar.isFriend(this.fData.params.ID)))
            {
               this.fData.cl.splice(_loc3_,1);
               _loc3_--;
            }
            if(this.fData.cl[_loc3_] == "Delete Friend" && !this.rootClass.world.myAvatar.isFriend(this.fData.params.ID))
            {
               this.fData.cl.splice(_loc3_,1);
               _loc3_--;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.fData.cl.length)
         {
            if(_loc5_ == this.rootClass.sfc.myUserName)
            {
            }
            if(this.rootClass.world.getAvatarByUserName(_loc5_))
            {
               if(this.fData.cl[_loc3_] == "Ignore" && Boolean(this.rootClass.chatF.isIgnored(_loc5_)))
               {
                  this.fData.cl[_loc3_] = "Unignore";
               }
               if(this.fData.cl[_loc3_] == "Hide Helm" && !this.rootClass.world.getAvatarByUserName(_loc5_).pMC.mcChar.head.helm.visible)
               {
                  this.fData.cl[_loc3_] = "Show Helm";
               }
               if(this.fData.cl[_loc3_] == "Hide Cape" && !this.rootClass.world.getAvatarByUserName(_loc5_).pMC.mcChar.cape.visible)
               {
                  this.fData.cl[_loc3_] = "Show Cape";
               }
               if(this.fData.cl[_loc3_] == "Hide Player" && !this.rootClass.world.getAvatarByUserName(_loc5_).pMC.mcChar.visible)
               {
                  this.fData.cl[_loc3_] = "Show Player";
               }
               if(this.fData.cl[_loc3_] == "Hide Weapon" && !this.rootClass.world.getAvatarByUserName(_loc5_).pMC.mcChar.weapon.visible)
               {
                  this.fData.cl[_loc3_] = "Show Weapon";
               }
            }
            if(this.fData.params.target)
            {
               if(this.fData.cl[_loc3_] == "Freeze Monster" && Boolean(this.fData.params.target.noMove))
               {
                  this.fData.cl[_loc3_] = "UnFreeze Monster";
               }
               if(this.fData.cl[_loc3_] == "Hide Monster" && !this.fData.params.target.getChildAt(1).visible)
               {
                  this.fData.cl[_loc3_] = "Show Monster";
               }
            }
            _loc8_ = this.mc.cnt.addChild(new cProto());
            _loc8_.name = "i" + _loc3_;
            _loc8_.y = this.mc.cnt.iproto.y + _loc3_ * 14;
            this.iCT = _loc8_.transform.colorTransform;
            _loc9_ = true;
            switch(this.fData.cl[_loc3_].toLowerCase())
            {
               case "add friend":
                  if(this.rootClass.world.getAvatarByUserName(_loc5_) != null && this.rootClass.world.getAvatarByUserName(_loc5_).objData != null && (this.rootClass.world.getAvatarByUserName(_loc5_).isStaff() && !this.rootClass.world.myAvatar.isStaff()))
                  {
                     _loc9_ = false;
                  }
                  break;
               case "go to":
                  if(!(Boolean(this.rootClass.world.isPartyMember(_loc5_)) || Boolean(this.rootClass.world.myAvatar.isFriend(this.fData.params.ID))))
                  {
                     _loc9_ = false;
                  }
                  break;
               case "ignore":
                  if(_loc5_ == this.rootClass.sfc.myUserName)
                  {
                     _loc9_ = false;
                  }
                  break;
               case "invite":
                  if(_loc5_ == this.rootClass.sfc.myUserName || _loc6_ == null || this.rootClass.world.getAvatarByUserName(_loc5_) != null && this.rootClass.world.getAvatarByUserName(_loc5_).objData != null && (this.rootClass.world.getAvatarByUserName(_loc5_).isStaff() && !this.rootClass.world.myAvatar.isStaff()) || Boolean(this.rootClass.world.isPartyFull()) || Boolean(this.rootClass.world.isPartyMember(this.fData.params.strUsername)) || this.rootClass.world.bPvP && _loc6_.pvpTeam != this.rootClass.world.myAvatar.dataLeaf.pvpTeam || this.rootClass.world.partyMembers.length > 0 && this.rootClass.world.partyOwner.toLowerCase() != this.rootClass.sfc.myUserName)
                  {
                     _loc9_ = false;
                  }
                  break;
               case "leave party":
                  if(this.rootClass.world.partyMembers.length == 0)
                  {
                     _loc9_ = false;
                  }
                  break;
               case "remove":
                  if(this.rootClass.world.partyOwner.toLowerCase() != this.rootClass.sfc.myUserName)
                  {
                     this.fData.cl[_loc3_] = "Leave Party";
                  }
                  break;
               case "private: on":
               case "private: off":
               case "promote":
                  if(this.rootClass.world.partyOwner != this.rootClass.world.myAvatar.objData.strUsername)
                  {
                     _loc9_ = false;
                  }
                  break;
               case "inspect":
                  if(_loc6_ == null || _loc6_.strFrame != this.rootClass.world.strFrame)
                  {
                     _loc9_ = false;
                  }
            }
            if(_loc9_)
            {
               this.iCT.color = 10066329;
               _loc8_.addEventListener(MouseEvent.CLICK,this.itemClick,false,0,true);
               _loc8_.buttonMode = true;
            }
            else
            {
               this.iCT.color = 6710886;
            }
            _loc8_.addEventListener(MouseEvent.MOUSE_OVER,this.itemMouseOver,false,0,true);
            this.fData.clc.push(this.iCT.color);
            _loc8_.ti.text = this.fData.cl[_loc3_];
            if(_loc8_.ti.textWidth > _loc4_)
            {
               _loc4_ = _loc8_.ti.textWidth;
            }
            _loc8_.transform.colorTransform = this.iCT;
            _loc8_.ti.width = _loc8_.ti.textWidth + 5;
            _loc8_.hit.width = _loc8_.ti.x + _loc8_.ti.textWidth + 2;
            _loc3_++;
         }
         this.mc.cnt.bg.height = this.mc.cnt.getChildByName(String("i" + (this.fData.cl.length - 1))).y + 26;
         this.mc.cnt.bg.width = _loc4_ + 20;
         this.mc.x = MovieClip(parent).mouseX - 5;
         this.mc.y = MovieClip(parent).mouseY - 5;
         if(this.mc.x + this.mc.cnt.bg.width > 960)
         {
            this.mc.x = MovieClip(parent).mouseX - this.mc.cnt.bg.width;
         }
         if(this.mc.y + this.mc.cnt.bg.height > 500)
         {
            this.mc.y = 500 - this.mc.cnt.bg.height;
         }
         this.mc.gotoAndPlay("in");
      }
      
      public function fClose() : *
      {
         this.isOpen = false;
         if(this.mc.currentFrame != 1)
         {
            if(this.mc.currentFrame == 10)
            {
               this.mc.gotoAndPlay("out");
            }
            else
            {
               this.mc.gotoAndStop("hold");
            }
         }
      }
      
      private function itemMouseOver(param1:MouseEvent) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = MovieClip(param1.currentTarget);
         this.iHi = int(_loc2_.name.substr(1));
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.fData.cl.length)
         {
            _loc4_ = this.mc.cnt.getChildByName("i" + _loc3_);
            this.iCT = _loc4_.transform.colorTransform;
            if(_loc3_ == this.iHi)
            {
               if(_loc2_.hasEventListener(MouseEvent.CLICK))
               {
                  this.iCT.color = 16777215;
                  this.cnt.mHi.visible = true;
                  this.cnt.mHi.y = _loc4_.y + 3;
               }
               else
               {
                  this.cnt.mHi.visible = false;
               }
            }
            else
            {
               this.iCT.color = this.fData.clc[_loc3_];
            }
            _loc4_.transform.colorTransform = this.iCT;
            _loc3_++;
         }
      }
      
      private function itemClick(param1:MouseEvent) : *
      {
         var action:String = null;
         var strUsername:String = null;
         var playerMC:* = undefined;
         var mDrops:* = undefined;
         var mcCharPage:charPage = null;
         var modal:* = undefined;
         var modalO:* = undefined;
         var nam:String = null;
         var val:int = 0;
         var e:MouseEvent = param1;
         var ti:* = MovieClip(e.currentTarget);
         this.iSel = int(ti.name.substr(1));
         this.iCT = this.mc.cnt.mHi.transform.colorTransform;
         this.iCT.color = 16763955;
         this.mc.cnt.mHi.transform.colorTransform = this.iCT;
         this.fClose();
         action = this.fData.cl[this.iSel];
         strUsername = this.fData.params.strUsername;
         switch(action.toLowerCase())
         {
            case "view drops":
               this.rootClass.mixer.playSound("Click");
               mDrops = new monsterDrops(this.rootClass,this.fData.params.ID,this.fData.params.strUsername);
               try
               {
                  this.rootClass.ui.addChildAt(mDrops,this.rootClass.ui.getChildIndex(this.rootClass.ui.ToolTip));
               }
               catch(eDrops:Error)
               {
                  rootClass.ui.addChild(mDrops);
               }
               break;
            case "wiki monster":
               navigateToURL(new URLRequest("http://aqwwiki.wikidot.com/" + this.fData.params.target.pname.ti.text),"_blank");
               break;
            case "freeze monster":
               this.fData.params.target.noMove = true;
               break;
            case "unfreeze monster":
               this.fData.params.target.noMove = false;
               break;
            case "hide helm":
               playerMC = this.rootClass.world.getAvatarByUserName(strUsername);
               playerMC.pMC.mcChar.head.helm.visible = false;
               playerMC.pMC.mcChar.head.hair.visible = true;
               playerMC.pMC.mcChar.backhair.visible = playerMC.pMC.bBackHair;
               break;
            case "show helm":
               playerMC = this.rootClass.world.getAvatarByUserName(strUsername);
               playerMC.pMC.mcChar.head.helm.visible = true;
               playerMC.pMC.mcChar.head.hair.visible = false;
               playerMC.pMC.mcChar.backhair.visible = false;
               break;
            case "hide cape":
               playerMC = this.rootClass.world.getAvatarByUserName(strUsername);
               playerMC.pMC.mcChar.cape.visible = false;
               break;
            case "show cape":
               playerMC = this.rootClass.world.getAvatarByUserName(strUsername);
               playerMC.pMC.mcChar.cape.visible = true;
               break;
            case "hide monster":
               this.fData.params.target.getChildAt(1).visible = false;
               break;
            case "show monster":
               this.fData.params.target.getChildAt(1).visible = true;
               break;
            case "show weapon":
               playerMC = this.rootClass.world.getAvatarByUserName(strUsername);
               playerMC.pMC.mcChar.weapon.visible = true;
               if(playerMC.pMC.pAV.getItemByEquipSlot("Weapon").sType == "Dagger")
               {
                  playerMC.pMC.mcChar.weaponOff.visible = true;
               }
               break;
            case "show player":
               playerMC = this.rootClass.world.getAvatarByUserName(strUsername);
               playerMC.pMC.mcChar.visible = true;
               playerMC.pMC.pname.visible = true;
               playerMC.pMC.shadow.visible = true;
               break;
            case "hide weapon":
               playerMC = this.rootClass.world.getAvatarByUserName(strUsername);
               playerMC.pMC.mcChar.weapon.visible = false;
               playerMC.pMC.mcChar.weaponOff.visible = false;
               break;
            case "hide player":
               playerMC = this.rootClass.world.getAvatarByUserName(strUsername);
               playerMC.pMC.mcChar.visible = false;
               playerMC.pMC.pname.visible = false;
               playerMC.pMC.shadow.visible = false;
               break;
            case "char page":
               this.rootClass.mixer.playSound("Click");
               mcCharPage = new charPage(this.rootClass,strUsername);
               this.rootClass.ui.addChild(mcCharPage);
               break;
            case "is staff?":
               this.rootClass.world.isModerator(strUsername);
               break;
            case "reputation":
               this.rootClass.mixer.playSound("Click");
               this.rootClass.showFactionInterface();
               break;
            case "whisper":
               this.rootClass.chatF.openPMsg(strUsername);
               break;
            case "ignore":
               this.rootClass.chatF.ignore(strUsername);
               this.rootClass.chatF.pushMsg("server","You are now ignoring user " + strUsername + ".","SERVER","",0);
               break;
            case "unignore":
               this.rootClass.chatF.unignore(strUsername);
               this.rootClass.chatF.pushMsg("server","User " + strUsername + " is no longer being ignored.","SERVER","",0);
               break;
            case "report":
               this.rootClass.ui.mcPopup.fOpen("Report",{"unm":strUsername});
               break;
            case "close":
               if(this.fMode == "user" || this.fMode == "party")
               {
                  this.rootClass.world.cancelTarget();
               }
               break;
            case "add friend":
               if(this.rootClass.world.myAvatar.friends.length >= this.rootClass.iMaxFriends)
               {
                  this.rootClass.chatF.pushMsg("server","You are too popular! (" + String(this.rootClass.iMaxFriends) + " friends max)","SERVER","",0);
               }
               else
               {
                  this.rootClass.world.requestFriend(strUsername);
               }
               break;
            case "delete friend":
               modal = new ModalMC();
               modalO = {};
               modalO.strBody = "Are you sure you want to delete " + strUsername + " from your friends list?";
               modalO.params = {
                  "id":this.fData.params.ID,
                  "unm":strUsername
               };
               modalO.callback = this.confirmDeleteFriend;
               modalO.glow = "red,medium";
               this.rootClass.ui.ModalStack.addChild(modal);
               modal.init(modalO);
               break;
            case "go to":
               this.rootClass.world.goto(strUsername);
               break;
            case "invite":
               this.rootClass.world.partyInvite(strUsername);
               break;
            case "remove":
               this.rootClass.world.partyKick(strUsername);
               break;
            case "leave party":
               this.rootClass.world.partyLeave();
               break;
            case "disband party":
               this.rootClass.world.partyDisband();
               break;
            case "private: on":
            case "private: off":
               nam = action.toLowerCase().split(": ")[0];
               val = action.toLowerCase().split(": ")[1] == "on" ? 1 : 0;
               this.rootClass.world.partyUpdate(nam,val);
               break;
            case "promote":
               this.rootClass.world.partyPromote(strUsername);
               break;
            case "summon":
               this.rootClass.world.partySummon(strUsername);
               break;
            case "leave queue":
               this.rootClass.world.requestPVPQueue("none");
         }
      }
      
      private function confirmDeleteFriend(param1:Object) : *
      {
         if(param1.accept)
         {
            this.rootClass.world.deleteFriend(param1.id,param1.unm);
         }
      }
      
      private function mouseOn(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).cnt.gotoAndStop("hold");
      }
      
      private function mouseOut(param1:MouseEvent) : *
      {
         MovieClip(param1.currentTarget).cnt.gotoAndPlay("out");
      }
   }
}

