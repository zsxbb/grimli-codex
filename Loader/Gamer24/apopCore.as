package
{
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class apopCore extends Sprite
   {
      public var mcBG:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var txtName:TextField;
      
      public var txtTitle:TextField;
      
      private var rootClass:MovieClip;
      
      private var apopData:Object;
      
      private var apopScenes:Object;
      
      private var currentScene:apopScene;
      
      private var nullScene:apopScene;
      
      private var questArray:Array;
      
      private var mcNPC:MovieClip;
      
      private var finalX:Number;
      
      public function apopCore(param1:MovieClip, param2:Object)
      {
         var _loc3_:apopScene = null;
         var _loc4_:Array = null;
         var _loc7_:uint = 0;
         this.apopScenes = new Object();
         this.questArray = new Array();
         super();
         this.rootClass = param1;
         this.txtName.text = param2.strName;
         this.txtTitle.text = param2.strTitle;
         var _loc5_:uint = 0;
         while(_loc5_ < param2.arrScenes.length)
         {
            _loc3_ = new apopScene(this.rootClass,param2.arrScenes[_loc5_],this);
            if(_loc3_.ID != -1)
            {
               this.apopScenes[_loc3_.ID] = _loc3_;
               if(param2.arrScenes[_loc5_].arrQuests != null)
               {
                  _loc4_ = String(param2.arrScenes[_loc5_].arrQuests).split(",");
                  _loc7_ = 0;
                  while(_loc7_ < _loc4_.length)
                  {
                     _loc3_ = new apopScene(this.rootClass,{
                        "bType":true,
                        "sceneID":_loc4_[_loc7_],
                        "bStart":false,
                        "qID":_loc4_[_loc7_]
                     },this);
                     if(_loc3_.ID != -1)
                     {
                        this.apopScenes["q" + String(_loc3_.ID)] = _loc3_;
                     }
                     _loc7_++;
                  }
               }
            }
            _loc5_++;
         }
         this.nullScene = new apopScene(this.rootClass,{
            "bType":false,
            "strText":"This text is broken, please report this bug using the bug tracker. http://www.artix.com/bugs",
            "ID":-1,
            "bStart":false
         },this);
         this.nullScene.x = 5;
         this.nullScene.y = 60;
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.showScene(this.getStartScene());
         var _loc6_:Class = this.rootClass.world.map.getNPC(param2.strNpc);
         this.mcNPC = this.addChildAt(new _loc6_() as MovieClip,0) as MovieClip;
         this.finalX = this.mcNPC.x - 80;
         this.mcNPC.y += 130;
         this.mcNPC.x -= 160;
         this.addEventListener(Event.ENTER_FRAME,this.animateNPC,false,0,true);
      }
      
      private function getStartScene() : int
      {
         var _loc1_:apopScene = null;
         var _loc2_:apopScene = null;
         var _loc3_:* = undefined;
         for(_loc3_ in this.apopScenes)
         {
            if(this.apopScenes[_loc3_].Start)
            {
               _loc2_ = this.apopScenes[_loc3_];
               if(!_loc2_.Locked)
               {
                  if(_loc1_ == null)
                  {
                     _loc1_ = _loc2_;
                  }
                  else if(_loc2_.ID > _loc1_.ID)
                  {
                     _loc1_ = _loc2_;
                  }
               }
            }
         }
         return _loc1_ != null ? _loc1_.ID : -1;
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         this.rootClass.removeApop();
      }
      
      private function animateNPC(param1:Event) : void
      {
         this.mcNPC.x += 10;
         if(this.mcNPC.x >= this.finalX)
         {
            this.mcNPC.x = this.finalX;
            this.removeEventListener(Event.ENTER_FRAME,this.animateNPC);
         }
      }
      
      public function showScene(param1:int, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:int = -1;
         if(this.currentScene != null)
         {
            _loc4_ = param2 ? -1 : this.currentScene.ID;
            this.removeChild(this.currentScene);
         }
         this.currentScene = param3 ? this.apopScenes["q" + String(param1)] : this.apopScenes[param1];
         if(this.currentScene != null)
         {
            this.currentScene.x = 15;
            this.currentScene.y = 60;
            this.currentScene.init(_loc4_);
            this.addChild(this.currentScene);
            this.mcBG.height = this.currentScene.mcGold.height + 80;
         }
         else
         {
            this.currentScene = this.nullScene;
            this.addChild(this.nullScene);
         }
      }
      
      public function questComplete(param1:int) : void
      {
         if(this.currentScene.ID == param1)
         {
            this.currentScene.Back();
         }
      }
      
      public function getScene(param1:int) : *
      {
         return this.apopScenes[param1];
      }
      
      public function getQuestScene(param1:String) : *
      {
         return this.apopScenes[param1];
      }
   }
}

