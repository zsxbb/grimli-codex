package liteAssets.draw
{
   import com.adobe.utils.*;
   import fl.controls.List;
   import fl.controls.TextInput;
   import fl.data.*;
   import fl.events.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class travelMenu extends MovieClip
   {
      public var btnAdd:SimpleButton;
      
      public var btnClose:SimpleButton;
      
      public var btnDel:SimpleButton;
      
      public var btnDown:SimpleButton;
      
      public var btnExpand:SimpleButton;
      
      public var btnTravel:SimpleButton;
      
      public var btnUp:SimpleButton;
      
      public var frame:MovieClip;
      
      public var listTravel:List;
      
      public var txtExpand:TextField;
      
      public var txtInfo:TextField;
      
      public var txtTravel:TextInput;
      
      internal var mapRegex:RegExp;
      
      internal var rootClass:MovieClip;
      
      private var lObj:Object;
      
      private var lIndex:int;
      
      public function travelMenu(param1:MovieClip)
      {
         this.mapRegex = /^[a-z0-9]{2,25}(-[1-9][0-9]{0,14})?$/i;
         super();
         this.rootClass = param1;
         this.txtExpand.mouseEnabled = false;
         this.frame.addEventListener(MouseEvent.MOUSE_DOWN,this.onDrag,false,0,true);
         this.frame.addEventListener(MouseEvent.MOUSE_UP,this.onStopDrag,false,0,true);
         this.btnAdd.addEventListener(MouseEvent.CLICK,this.onBtnAdd,false,0,true);
         this.btnDel.addEventListener(MouseEvent.CLICK,this.onBtnDel,false,0,true);
         this.btnUp.addEventListener(MouseEvent.CLICK,this.onBtnUp,false,0,true);
         this.btnDown.addEventListener(MouseEvent.CLICK,this.onBtnDown,false,0,true);
         this.btnTravel.addEventListener(MouseEvent.CLICK,this.onBtnTravel,false,0,true);
         this.btnExpand.addEventListener(MouseEvent.CLICK,this.onBtnExpand,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onBtnClose,false,0,true);
         if(this.rootClass.litePreference.data.travelList)
         {
            this.listTravel.dataProvider = new DataProvider(this.rootClass.litePreference.data.travelList);
         }
         var _loc2_:* = this.rootClass.litePreference.data.keys["Travel Menu\'s Travel"] == null ? "" : this.rootClass.keyDict[this.rootClass.litePreference.data.keys["Travel Menu\'s Travel"]];
         this.txtInfo.text = "\"" + _loc2_ + "\" to travel to the next map in the list!";
         this.__setProp_txtTravel_mcTravel_Layer1_0();
      }
      
      public function onBtnClear(param1:MouseEvent) : void
      {
         this.listTravel.dataProvider.removeAll();
         this.rootClass.litePreference.data.travelList = this.listTravel.dataProvider.toArray();
         this.rootClass.litePreference.flush();
         this.rootClass.stage.focus = null;
      }
      
      public function onBtnExpand(param1:MouseEvent) : void
      {
         this.txtExpand.text = this.txtExpand.text == "+" ? "-" : "+";
         var _loc2_:int = 0;
         if(this.frame.visible)
         {
            while(_loc2_ < this.numChildren)
            {
               if(this.getChildAt(_loc2_).name != "btnExpand" && this.getChildAt(_loc2_).name != "txtExpand")
               {
                  this.getChildAt(_loc2_).visible = false;
               }
               _loc2_++;
            }
         }
         else
         {
            while(_loc2_ < this.numChildren)
            {
               this.getChildAt(_loc2_).visible = true;
               _loc2_++;
            }
         }
         this.rootClass.stage.focus = null;
      }
      
      public function onDrag(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      public function onStopDrag(param1:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      public function onBtnClose(param1:MouseEvent) : void
      {
         parent.removeChild(this);
         this.rootClass.stage.focus = null;
      }
      
      public function onBtnAdd(param1:MouseEvent) : void
      {
         if(this.txtTravel.text != "" && Boolean(this.mapRegex.test(this.txtTravel.text)))
         {
            this.listTravel.dataProvider.addItem({"label":StringUtil.trim(this.txtTravel.text)});
            this.rootClass.litePreference.data.travelList = this.listTravel.dataProvider.toArray();
            this.rootClass.litePreference.flush();
         }
         this.txtTravel.text = "";
         this.rootClass.stage.focus = null;
      }
      
      public function onBtnDel(param1:MouseEvent) : void
      {
         if(this.listTravel.selectedIndex > -1)
         {
            this.listTravel.dataProvider.removeItemAt(this.listTravel.selectedIndex);
            this.rootClass.litePreference.data.travelList = this.listTravel.dataProvider.toArray();
            this.rootClass.litePreference.flush();
         }
         this.listTravel.selectedIndex = 0;
         this.rootClass.stage.focus = null;
      }
      
      public function onBtnUp(param1:MouseEvent) : void
      {
         if(this.listTravel.selectedIndex == -1)
         {
            return;
         }
         if(this.listTravel.selectedIndex != -1 && this.listTravel.selectedIndex != 0)
         {
            this.lObj = this.listTravel.selectedItem;
            this.lIndex = this.listTravel.selectedIndex - 1;
            this.listTravel.dataProvider.removeItem(this.listTravel.selectedItem);
            this.listTravel.dataProvider.addItemAt(this.lObj,this.lIndex);
            this.listTravel.selectedIndex = this.lIndex;
         }
         this.rootClass.stage.focus = null;
      }
      
      public function onBtnDown(param1:MouseEvent) : void
      {
         if(this.listTravel.selectedIndex == -1)
         {
            return;
         }
         if(this.listTravel.selectedIndex < this.listTravel.length - 1)
         {
            this.lObj = this.listTravel.selectedItem;
            this.lIndex = this.listTravel.selectedIndex + 1;
            this.listTravel.dataProvider.removeItem(this.listTravel.selectedItem);
            this.listTravel.dataProvider.addItemAt(this.lObj,this.lIndex);
            this.listTravel.selectedIndex = this.lIndex;
         }
         this.rootClass.stage.focus = null;
      }
      
      public function dispatchTravel() : void
      {
         this.btnTravel.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
      }
      
      public function onBtnTravel(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(this.listTravel.length < 1)
         {
            return;
         }
         if(this.listTravel.selectedIndex == -1)
         {
            this.listTravel.selectedIndex = 0;
         }
         if(this.rootClass.world.myAvatar.dataLeaf.intState == 0)
         {
            this.rootClass.MsgBox.notify("You are dead!");
         }
         else if(!this.rootClass.world.myAvatar.invLoaded || !this.rootClass.world.myAvatar.pMC.artLoaded())
         {
            this.rootClass.MsgBox.notify("Character still being loaded.");
         }
         else if(this.rootClass.world.coolDown("tfer"))
         {
            _loc2_ = this.listTravel.selectedItem.label;
            this.rootClass.MsgBox.notify("Joining " + _loc2_);
            _loc3_ = "Enter";
            _loc4_ = "Spawn";
            this.rootClass.world.setReturnInfo(_loc2_,_loc3_,_loc4_);
            this.rootClass.sfc.sendXtMessage("zm","cmd",["tfer",this.rootClass.sfc.myUserName,_loc2_,_loc3_,_loc4_],"str",this.rootClass.world.curRoom);
            if(this.rootClass.world.strAreaName.indexOf("battleon") < 0 || this.rootClass.world.strAreaName.indexOf("battleontown") > -1)
            {
               this.rootClass.menuClose();
            }
            ++this.listTravel.selectedIndex;
            if(this.listTravel.selectedIndex > this.listTravel.length - 1)
            {
               this.listTravel.selectedIndex = 0;
            }
         }
         else
         {
            this.rootClass.MsgBox.notify("Not able to travel yet, please wait.");
         }
         this.rootClass.stage.focus = null;
      }
      
      internal function __setProp_txtTravel_mcTravel_Layer1_0() : *
      {
         try
         {
            this.txtTravel["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtTravel.displayAsPassword = false;
         this.txtTravel.editable = true;
         this.txtTravel.enabled = true;
         this.txtTravel.maxChars = 50;
         this.txtTravel.restrict = "";
         this.txtTravel.text = "";
         this.txtTravel.visible = true;
         try
         {
            this.txtTravel["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

