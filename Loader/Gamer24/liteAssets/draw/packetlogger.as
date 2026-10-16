package liteAssets.draw
{
   import fl.controls.TextArea;
   import fl.controls.TextInput;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class packetlogger extends MovieClip
   {
      public var btnClose:MovieClip;
      
      public var input:TextInput;
      
      public var output:TextArea;
      
      private var tf:TextFormat;
      
      public var r:MovieClip;
      
      private var alwaysOn:Boolean = false;
      
      private var scrToBottom:Boolean = false;
      
      private var jsonLimit:int = 0;
      
      private var whiteSpace:RegExp;
      
      private var tabPos:int = 0;
      
      private var separator:RegExp;
      
      private var gdq:RegExp;
      
      private var gtrue:RegExp;
      
      private var gfalse:RegExp;
      
      public function packetlogger(param1:MovieClip)
      {
         this.tf = new TextFormat();
         this.whiteSpace = /\s{2,}/gim;
         this.separator = /[%]+/gim;
         this.gdq = /[&quot;]+/gim;
         this.gtrue = /[true]+/gim;
         this.gfalse = /[false]+/gim;
         super();
         this.visible = false;
         this.r = param1;
         this.r.stage.addChild(this);
         this.name = "packetlogger";
         this.tf.font = "Arial";
         this.tf.size = 18;
         this.output.setStyle("textFormat",this.tf);
         this.tf.size = 25;
         this.input.setStyle("textFormat",this.tf);
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0.9);
         _loc2_.graphics.drawRect(0,0,960,500);
         _loc2_.graphics.endFill();
         var _loc3_:* = new MovieClip();
         _loc3_.addChild(_loc2_);
         this.output.setStyle("upSkin",_loc3_);
         _loc2_ = new Shape();
         _loc2_.graphics.beginFill(16777215,0.9);
         _loc2_.graphics.drawRect(0,0,960,40);
         _loc2_.graphics.endFill();
         _loc3_ = new MovieClip();
         _loc3_.addChild(_loc2_);
         this.input.setStyle("upSkin",_loc3_);
         this.input.addEventListener(KeyboardEvent.KEY_DOWN,this.onInput,false,0,true);
         this.btnClose.addEventListener(MouseEvent.CLICK,this.onHide,false,0,true);
      }
      
      public function onHide(param1:MouseEvent) : void
      {
         this.visible = false;
         this.toggle();
      }
      
      public function onInput(param1:KeyboardEvent) : void
      {
         var _loc2_:String = null;
         if(param1.keyCode == 13)
         {
            _loc2_ = this.input.text.replace(this.whiteSpace,"");
            if(_loc2_.indexOf("/setlimit") == 0)
            {
               this.regular("This command is currently disabled");
            }
            else
            {
               switch(_loc2_)
               {
                  case "/help":
                     this.regular("\tCOMMANDS ---");
                     this.regular("\t/help - COMMANDS");
                     this.regular("\t/autoscr - AUTO SCROLL TO BOTTOM (DEFAULT: OFF)");
                     this.regular("\t/clear - CLEARS SCREEN");
                     this.regular("\t/hide - HIDES SCREEN");
                     this.regular("\t/alwayson - ALWAYS LOG EVEN IF HIDDEN");
                     this.regular("\tENTERING ANYTHING WILL SEND TO THE SERVER");
                     break;
                  case "/alwayson":
                     this.alwaysOn = !this.alwaysOn;
                     this.regular("\tALWAYS ON SET TO: " + this.alwaysOn);
                     break;
                  case "/autoscr":
                     this.scrToBottom = !this.scrToBottom;
                     this.regular("\tAUTO SCROLL TO BOTTOM SET TO: " + this.scrToBottom);
                     break;
                  case "/getlimit":
                     this.regular("\tJSON PRETTY PRINT STRING LIMIT -- " + this.jsonLimit + " CHARACTERS");
                     break;
                  case "/clear":
                     this.output.text = "";
                     break;
                  case "/hide":
                     this.visible = false;
                     this.toggle();
                     break;
                  default:
                     if(this.r.world.myAvatar.isStaff())
                     {
                        this.r.sfc.sendString(this.input.text);
                        this.regular("\tSENT TO SERVER: " + this.input.text);
                     }
               }
            }
            this.input.text = "";
            if(this.scrToBottom)
            {
               this.output.verticalScrollPosition = this.output.maxVerticalScrollPosition;
            }
         }
      }
      
      public function cleanup() : void
      {
         if(this.parent as MovieClip != null)
         {
            (this.parent as MovieClip).removeChild(this);
         }
         this.input.removeEventListener(KeyboardEvent.KEY_DOWN,this.onInput);
         this.r.sfc.removeEventListener("onDebugMessage",this.onLogger);
         this.r.pLoggerUI = null;
      }
      
      public function getTabs() : String
      {
         var _loc1_:* = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.tabPos)
         {
            _loc1_ += "    ";
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function color(param1:String, param2:String) : String
      {
         return "<font face=\"Arial\" size=\"20\" color=\"" + param2 + "\">" + param1 + "</font>";
      }
      
      public function tab(param1:String) : void
      {
         this.output.htmlText += "<font face=\"Arial\" size=\"20\">" + this.getTabs() + param1 + "</font>";
         if(this.scrToBottom)
         {
            this.output.verticalScrollPosition = this.output.textField.maxScrollV;
         }
      }
      
      public function noTab(param1:String) : void
      {
         this.output.htmlText += "<font face=\"Arial\" size=\"20\">" + param1 + "</font>";
         if(this.scrToBottom)
         {
            this.output.verticalScrollPosition = this.output.textField.maxScrollV;
         }
      }
      
      public function regular(param1:String) : void
      {
         this.output.appendText(param1 + "\n");
      }
      
      public function parse(param1:*) : String
      {
         var _loc3_:* = undefined;
         var _loc6_:* = undefined;
         ++this.tabPos;
         var _loc2_:int = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
         }
         if(_loc2_ == 0)
         {
            --this.tabPos;
            return " {}";
         }
         var _loc4_:int = 0;
         var _loc5_:* = " {\n";
         for(_loc6_ in param1)
         {
            _loc5_ += this.getTabs() + ("\"" + this.color(_loc6_,"#BF40BF") + "\":");
            if(param1[_loc6_] is String)
            {
               _loc5_ += " \"" + this.color(param1[_loc6_],"#FF0000") + "\"";
            }
            else if(param1[_loc6_] is Number || param1[_loc6_] is Boolean)
            {
               _loc5_ += " " + this.color(param1[_loc6_],"#FF0000");
            }
            else if(param1[_loc6_] is Object || param1[_loc6_] is Array)
            {
               _loc5_ += this.parse(param1[_loc6_]);
            }
            else
            {
               _loc5_ += " " + this.color(param1[_loc6_],"#FF0000");
            }
            if(_loc4_ + 1 != _loc2_)
            {
               _loc5_ += ",";
            }
            _loc5_ += "\n";
            _loc4_++;
         }
         --this.tabPos;
         return _loc5_ + (this.getTabs() + "}");
      }
      
      internal function raw_parse(param1:*) : String
      {
         var _loc3_:* = undefined;
         var _loc6_:* = undefined;
         ++this.tabPos;
         var _loc2_:int = 0;
         for(_loc3_ in param1)
         {
            _loc2_++;
         }
         if(_loc2_ == 0)
         {
            --this.tabPos;
            return " {}";
         }
         var _loc4_:int = 0;
         var _loc5_:* = " {\n";
         for(_loc6_ in param1)
         {
            _loc5_ += this.getTabs() + ("\"" + _loc6_ + "\":");
            if(param1[_loc6_] is String)
            {
               _loc5_ += " \"" + param1[_loc6_] + "\"";
            }
            else if(param1[_loc6_] is Number || param1[_loc6_] is Boolean)
            {
               _loc5_ += " " + param1[_loc6_];
            }
            else if(param1[_loc6_] is Object || param1[_loc6_] is Array)
            {
               _loc5_ += this.raw_parse(param1[_loc6_]);
            }
            else
            {
               _loc5_ += " " + param1[_loc6_];
            }
            if(_loc4_ + 1 != _loc2_)
            {
               _loc5_ += ",";
            }
            _loc5_ += "\n";
            _loc4_++;
         }
         --this.tabPos;
         return _loc5_ + (this.getTabs() + "}");
      }
      
      private function fixHTML(param1:String) : String
      {
         var _loc2_:RegExp = /[<]+/gim;
         var _loc3_:RegExp = /[>]+/gim;
         var _loc4_:RegExp = /[&]+/gim;
         var _loc5_:RegExp = /["]+/gim;
         var _loc6_:RegExp = /[']+/gim;
         param1 = param1.replace(_loc2_,"&lt;");
         param1 = param1.replace(_loc3_,"&gt;");
         param1 = param1.replace(_loc4_,"&amp;");
         param1 = param1.replace(_loc5_,"&quot;");
         return param1.replace(_loc6_,"&apos;");
      }
      
      public function onLogger(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.params.message;
         if(_loc2_.indexOf("[ RECEIVED ]:") == 0)
         {
            _loc3_ = _loc2_.substr(_loc2_.indexOf("]: ") + 3,_loc2_.lastIndexOf(", (len:") - 14) + "\n";
            if(_loc3_.length > this.jsonLimit)
            {
               if(_loc3_.indexOf("%") != -1)
               {
                  this.regular("\t" + _loc3_);
               }
               else
               {
                  this.regular(this.raw_parse(JSON.parse(_loc3_)));
               }
            }
            else
            {
               this.noTab(this.parse(JSON.parse(_loc3_)));
            }
            this.tabPos = 0;
         }
         else
         {
            _loc3_ = _loc2_.substr(_loc2_.indexOf("]: ") + 3,_loc2_.length);
            if(_loc3_.length > this.jsonLimit)
            {
               this.regular("\t" + _loc3_);
            }
            else
            {
               if(_loc3_.indexOf("%") != -1 && _loc3_.length <= this.jsonLimit)
               {
                  _loc3_ = this.fixHTML(_loc3_);
                  _loc3_ = this.color(_loc3_,"#BF40BF");
                  _loc3_ = _loc3_.replace(this.separator,this.color("%","#FF0000"));
               }
               this.noTab("<br>" + _loc3_);
            }
         }
         if(this.scrToBottom)
         {
            this.output.verticalScrollPosition = this.output.maxVerticalScrollPosition;
         }
      }
      
      public function toggle() : void
      {
         this.r.stage.focus = null;
         if(!this.alwaysOn)
         {
            if(this.visible)
            {
               this.r.sfc.addEventListener("onDebugMessage",this.onLogger,false,0,true);
            }
            else
            {
               this.r.sfc.removeEventListener("onDebugMessage",this.onLogger);
            }
         }
      }
   }
}

