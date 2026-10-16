package
{
   import fl.motion.Color;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class questBtn extends Sprite
   {
      public var txtQuest:TextField;
      
      public var qFill:MovieClip;
      
      private var sceneID:int;
      
      private var core:apopCore;
      
      private var colorData:Color;
      
      private var available:Boolean;
      
      private var accepted:Boolean;
      
      private var iconClass:Class;
      
      private var rootClass:MovieClip;
      
      internal var iconMC:DisplayObject;
      
      internal var trans:ColorTransform;
      
      private var questText:String;
      
      public function questBtn(param1:apopCore, param2:Object, param3:MovieClip)
      {
         this.colorData = new Color();
         super();
         this.rootClass = param3;
         this.core = param1;
         this.sceneID = param2.sceneID;
         this.accepted = param2.accepted;
         this.available = param2.available;
         this.questText = param2.strText;
         this.update(param2.accepted,param2.available,param2.complete);
         this.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
      }
      
      public function update(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this.txtQuest.text = this.questText;
         if(this.iconMC != null)
         {
            this.removeChild(this.iconMC);
         }
         if(param1)
         {
            this.txtQuest.appendText(" - In Progress");
            this.txtQuest.textColor = 16777215;
            this.qFill.visible = true;
            this.trans = this.qFill.transform.colorTransform;
            this.trans.color = 41728;
            this.qFill.transform.colorTransform = this.trans;
            this.iconClass = this.rootClass.world.getClass("iwd1");
            this.iconMC = this.addChild(new this.iconClass());
            this.iconMC.scaleX *= 0.3;
            this.iconMC.scaleY *= 0.3;
            this.iconMC.x = 30 - this.iconMC.width >> 1;
            this.iconMC.y = 18 - this.iconMC.height >> 1;
         }
         else if(param2)
         {
            this.txtQuest.textColor = 239875;
            this.qFill.visible = false;
            this.iconClass = this.rootClass.world.getClass("ime1");
            this.iconMC = this.addChild(new this.iconClass());
            this.iconMC.scaleX *= 0.3;
            this.iconMC.scaleY *= 0.3;
            this.iconMC.x = 30 - this.iconMC.width >> 1;
            this.iconMC.y = 18 - this.iconMC.height >> 1;
         }
         else if(param3)
         {
            this.txtQuest.appendText(" - Complete");
            this.txtQuest.textColor = 16777215;
            this.qFill.visible = true;
            this.trans = this.qFill.transform.colorTransform;
            this.trans.color = 41728;
            this.qFill.transform.colorTransform = this.trans;
            this.iconClass = this.rootClass.world.getClass("iCheck");
            this.iconMC = this.addChild(new this.iconClass());
            this.iconMC.scaleX *= 0.3;
            this.iconMC.scaleY *= 0.3;
            this.iconMC.x = 30 - this.iconMC.width >> 1;
            this.iconMC.y = 18 - this.iconMC.height >> 1;
         }
         else
         {
            this.txtQuest.textColor = 16777215;
            this.iconClass = this.rootClass.world.getClass("iLock");
            this.qFill.visible = true;
            this.trans = this.qFill.transform.colorTransform;
            this.trans.color = 15601937;
            this.qFill.transform.colorTransform = this.trans;
            this.iconMC = this.addChild(new this.iconClass());
            this.iconMC.scaleX *= 0.3;
            this.iconMC.scaleY *= 0.3;
            this.iconMC.x = 30 - this.iconMC.width >> 1;
            this.iconMC.y = 18 - this.iconMC.height >> 1;
         }
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(this.available)
         {
            this.core.showScene(this.sceneID,false,true);
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         this.colorData.brightness = -0.28;
         this.transform.colorTransform = this.colorData;
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.colorData.brightness = 0;
         this.transform.colorTransform = this.colorData;
      }
      
      public function get ID() : int
      {
         return this.sceneID;
      }
   }
}

