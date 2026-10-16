package org.sepy.ColorPicker
{
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   
   public class ColorPicker2 extends MovieClip
   {
      private static var ADV_PANEL_DEPTH:Number = 5;
      
      public static var version:String = "2.2";
      
      public static var DOWN_LEFT:String = "DL";
      
      public static var DOWN_RIGHT:String = "DR";
      
      public static var UP_LEFT:String = "UL";
      
      public static var UP_RIGHT:String = "UR";
      
      private static var MIN_WIDTH:Number = 130;
      
      public var cpicker:MovieClip;
      
      private var _colors:Array;
      
      private var _opening_color:Number;
      
      private var _color:Number;
      
      private var _direction:String;
      
      private var _columns:Number = 21;
      
      private var panel:MovieClip;
      
      private var _baseColors:Array;
      
      private var selectedColorMC:MovieClip;
      
      public var _opened:Boolean;
      
      private var _allowUserColor:Boolean;
      
      private var keyListener:Object;
      
      private var advancedColor:MovieClip;
      
      private var noColor:MovieClip;
      
      public var advancedColorPanel:MovieClip;
      
      private var _useAdvColors:Boolean;
      
      private var _useNoColor:Boolean;
      
      private var newMC:MovieClip;
      
      private var newClass:*;
      
      private var hover:Boolean = false;
      
      private var hoverColor:uint;
      
      public var m_fillType:String = "linear";
      
      public var m_colors:Array;
      
      public var m_alphas:Array;
      
      public var m_ratios:Array;
      
      public var m_matrix:Object;
      
      public function ColorPicker2()
      {
         this._colors = [];
         this.m_colors = [16711680,16776960,65280,65535,255,16711935,16711680];
         this.m_alphas = [100,100,100,100,100,100,100];
         this.m_ratios = [0,42,64,127,184,215,255];
         this.m_matrix = {
            "matrixType":"box",
            "x":0,
            "y":0,
            "w":175,
            "h":187,
            "r":0
         };
         super();
         this._color = 0;
         this._allowUserColor = true;
         this._baseColors = [16711935,65535,16776960,255,65280,16711680,16777215,13421772,10066329,6710886,3355443,0];
         this._colors = this.getStandardColors();
         this.initComponent();
      }
      
      public static function ColorToString(param1:Number) : String
      {
         var _loc2_:String = Math.abs(param1).toString(16);
         while(_loc2_.length < 6)
         {
            _loc2_ = "0" + _loc2_;
         }
         return _loc2_.toUpperCase();
      }
      
      public static function StringToColor(param1:String) : Number
      {
         return parseInt(param1,16);
      }
      
      public static function ColorToRGB(param1:Number) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.red = param1 >> 16 & 0xFF;
         _loc2_.green = param1 >> 8 & 0xFF;
         _loc2_.blue = param1 & 0xFF;
         return _loc2_;
      }
      
      private function initComponent() : void
      {
         this.useHandCursor = false;
         this.cpicker.nocolor_face.visible = false;
         this.cpicker.addEventListener(MouseEvent.CLICK,this.openMC,false,0,true);
      }
      
      public function setIsOpened(param1:Boolean) : void
      {
         if(param1 && !this._opened)
         {
            this._opening_color = this._color;
            this.attachPanel();
            this._opened = true;
         }
         else
         {
            if(this.panel != null)
            {
               this.removeChild(this.panel);
               this.panel = null;
               stage.removeEventListener(MouseEvent.CLICK,this.onClickOutside,false);
            }
            if(this.advancedColorPanel != null)
            {
               this.removeChild(this.advancedColorPanel);
               this.advancedColorPanel = null;
            }
            this._opened = false;
         }
      }
      
      public function getIsOpened() : Boolean
      {
         return this._opened || this.advancedColorPanel != null;
      }
      
      private function colorMC(param1:MovieClip, param2:uint) : void
      {
         var _loc3_:* = ColorToRGB(param2);
         param1.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_.red,_loc3_.green,_loc3_.blue,0);
      }
      
      private function attachPanel() : void
      {
         this.panel = new MovieClip();
         this.panel.name = "panel";
         this.newMC = new MovieClip();
         this.newMC.name = "backgrounds";
         this.panel.addChild(this.newMC);
         this.newMC = new MovieClip();
         this.newMC.name = "colors";
         this.panel.colors = this.panel.addChild(this.newMC);
         this.newMC.x = 3;
         this.newMC.y = 26;
         this.newMC.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutColors,false,0,true);
         this.populateColorPanel();
         var _loc1_:Number = (this.newMC.width < ColorPicker2.MIN_WIDTH ? ColorPicker2.MIN_WIDTH : this.newMC.width) + 6 + this.newMC.x;
         var _loc2_:Number = this.newMC.height + 6 + this.newMC.y;
         var _loc3_:MovieClip = this.panel.getChildByName("backgrounds") as MovieClip;
         _loc3_.graphics.lineStyle(1,16777215,100);
         _loc3_.graphics.beginFill(13947080,100);
         _loc3_.graphics.moveTo(0,0);
         _loc3_.graphics.lineTo(_loc1_,0);
         _loc3_.graphics.lineStyle(1,8421504,100);
         _loc3_.graphics.lineTo(_loc1_,_loc2_);
         _loc3_.graphics.lineTo(0,_loc2_);
         _loc3_.graphics.lineStyle(1,16777215,100);
         _loc3_.graphics.lineTo(0,0);
         _loc3_.graphics.endFill();
         _loc3_.graphics.lineStyle(1,0,100);
         _loc3_.graphics.moveTo(_loc1_ + 1,0);
         _loc3_.graphics.lineTo(_loc1_ + 1,_loc2_ + 1);
         _loc3_.graphics.lineTo(0,_loc2_ + 1);
         this.newMC = new ColorDisplay() as MovieClip;
         this.newMC.name = "color_display";
         this.panel.addChild(this.newMC);
         this.newMC.color = this.selectedColor;
         this.colorMC(this.newMC,this.selectedColor);
         this.newMC.x = 3;
         this.newMC.y = 3;
         this.newMC.addEventListener(MouseEvent.CLICK,this.onClicks,false,0,true);
         this.newMC = new ColorInput();
         this.newMC.name = "color_input";
         this.panel.addChildAt(this.newMC,1);
         this.newMC.color = this.selectedColor;
         this.newMC.x = 48;
         this.newMC.y = 3;
         var _loc4_:MovieClip = this.panel.getChildByName("colors") as MovieClip;
         this.newMC = new face_borders();
         this.newMC.name = "face_borders";
         var _loc5_:ColorTransform = this.newMC.transform.colorTransform;
         _loc5_.color = 16777215;
         this.newMC.transform.colorTransform = _loc5_;
         _loc4_.face_borders = _loc4_.addChild(this.newMC);
         if(this.selectedColorMC == null)
         {
            this.newMC.visible = false;
         }
         else
         {
            this.newMC.x = this.selectedColorMC.x;
            this.newMC.y = this.selectedColorMC.y;
         }
         switch(this.direction)
         {
            case ColorPicker2.DOWN_LEFT:
               this.panel.x = this.cpicker.x - this.panel.width + this.cpicker.width;
               this.panel.y = this.cpicker.y + this.cpicker.height + 5;
               break;
            case ColorPicker2.UP_LEFT:
               this.panel.x = this.cpicker.x - this.panel.width + this.cpicker.width;
               this.panel.y = this.cpicker.y - this.panel.height - 5;
               break;
            case ColorPicker2.UP_RIGHT:
               this.panel.x = this.cpicker.x;
               this.panel.y = this.cpicker.y - this.panel.height - 5;
               break;
            default:
               this.panel.x = this.cpicker.x;
               this.panel.y = this.cpicker.y + this.cpicker.height + 5;
         }
         if(this.useNoColorSelector)
         {
            this.noColor = new NoColorButton() as MovieClip;
            this.noColor.name = "NoColorButton";
            this.panel.addChild(this.noColor);
            this.noColor.x = this.panel.width - this.noColor.width - 7;
            this.noColor.y = 3;
         }
         if(this.useAdvancedColorSelector)
         {
            this.advancedColor = new AdvancedColorButton() as MovieClip;
            this.advancedColor.name = "advancedColor";
            this.panel.addChild(this.advancedColor);
            this.advancedColor.x = this.panel.width - this.advancedColor.width - 7;
            this.advancedColor.y = 3;
            if(this.useNoColorSelector)
            {
               this.noColor.x = this.advancedColor.x - this.noColor.width - 4;
            }
         }
         this.addChild(this.panel);
         stage.addEventListener(MouseEvent.CLICK,this.onClickOutside,false,0,true);
      }
      
      public function onRollOutColors(param1:MouseEvent) : void
      {
         if(this.panel != null)
         {
            this.panel.colors.face_borders.visible = false;
         }
         this.updateColors(this.selectedColor,true);
      }
      
      public function onClickOutside(param1:MouseEvent) : void
      {
         if(this.advancedColorPanel == null)
         {
            if(!(Boolean(this.panel.contains(DisplayObject(param1.target))) || this.cpicker.contains(DisplayObject(param1.target))))
            {
               this.setIsOpened(false);
            }
         }
      }
      
      private function onClicks(param1:MouseEvent) : void
      {
         this.click(param1.currentTarget as MovieClip);
      }
      
      private function populateColorPanel() : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:MovieClip = null;
         var _loc8_:Object = null;
         var _loc1_:Array = this._colors.slice();
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:MovieClip = this.panel.getChildByName("colors") as MovieClip;
         while(_loc1_.length)
         {
            _loc2_ = Number(_loc1_.shift());
            _loc8_ = ColorToRGB(_loc2_);
            _loc3_ = new ColorBox(_loc8_) as MovieClip;
            _loc3_.name = "single_" + _loc6_;
            _loc7_.addChild(_loc3_);
            _loc3_.addEventListener(MouseEvent.ROLL_OVER,this.over,false,0,true);
            _loc3_.addEventListener(MouseEvent.ROLL_OUT,this.out,false,0,true);
            _loc3_.addEventListener(MouseEvent.CLICK,this.onClicks,false,0,true);
            if(_loc2_ == this.selectedColor)
            {
               this.selectedColorMC = _loc3_;
            }
            if(_loc6_ % this._columns == 0 && _loc6_ > 0)
            {
               _loc5_ += _loc3_.height;
               _loc4_ = 0;
            }
            _loc3_.x = _loc4_;
            _loc3_.y = _loc5_;
            _loc4_ += _loc3_.width;
            _loc6_++;
         }
      }
      
      public function getStandardColors() : Array
      {
         var _loc11_:* = undefined;
         var _loc1_:Array = [];
         var _loc2_:Number = 16777215;
         var _loc3_:Number = 13056;
         var _loc4_:Number = 3277056;
         var _loc5_:Number = 10027263;
         var _loc6_:Number = 51;
         var _loc7_:Number = 10026753;
         var _loc8_:Number = _loc2_;
         var _loc9_:Number = _loc2_;
         var _loc10_:* = 0;
         while(_loc10_ < 12)
         {
            _loc11_ = 0;
            while(_loc11_ < 21)
            {
               if(_loc11_ > 0)
               {
                  if(_loc11_ == 18)
                  {
                     _loc8_ = 0;
                  }
                  else if(_loc11_ == 19)
                  {
                     _loc8_ = Number(this._baseColors[_loc10_]);
                  }
                  else if(_loc11_ == 20)
                  {
                     _loc8_ = 0;
                  }
                  else if(_loc11_ % 6 == 0 && _loc11_ > 0)
                  {
                     _loc8_ -= _loc4_;
                  }
                  else
                  {
                     _loc8_ -= _loc3_;
                  }
               }
               _loc1_.push(_loc8_);
               _loc11_++;
            }
            if(_loc10_ == 5)
            {
               _loc9_ -= _loc7_;
            }
            else
            {
               _loc9_ -= _loc6_;
            }
            _loc8_ = _loc9_;
            _loc10_++;
         }
         _loc1_.reverse();
         return _loc1_;
      }
      
      public function set selectedColor(param1:Number) : void
      {
         this._color = param1;
         this.updateColors(param1,true);
         this.updateface();
      }
      
      public function get selectedColor() : Number
      {
         if(this.hover)
         {
            return this.hoverColor;
         }
         return this._color;
      }
      
      public function set direction(param1:String) : *
      {
         this._direction = param1;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set columns(param1:Number) : void
      {
         this._columns = param1;
      }
      
      public function get columns() : Number
      {
         return this._columns;
      }
      
      public function set allowUserColor(param1:Boolean) : *
      {
         this._allowUserColor = param1;
      }
      
      public function get allowUserColor() : Boolean
      {
         return this._allowUserColor;
      }
      
      public function set colors(param1:Array) : *
      {
         this._colors = param1;
      }
      
      public function get colors() : Array
      {
         return this._colors;
      }
      
      public function get useAdvancedColorSelector() : Boolean
      {
         return this._useAdvColors;
      }
      
      public function set useAdvancedColorSelector(param1:Boolean) : void
      {
         this._useAdvColors = param1;
      }
      
      public function get useNoColorSelector() : Boolean
      {
         return this._useNoColor;
      }
      
      public function set useNoColorSelector(param1:Boolean) : void
      {
         this._useNoColor = param1;
      }
      
      public function setAdvancedColorsMatrix(param1:String, param2:Array, param3:Array, param4:Array) : void
      {
         this.m_fillType = param1;
         this.m_colors = param2;
         this.m_alphas = param3;
         this.m_ratios = param4;
      }
      
      public function getRGB() : String
      {
         return ColorPicker2.ColorToString(this.selectedColor);
      }
      
      private function RGBtoColor(param1:Object) : int
      {
         var _loc2_:* = 0;
         _loc2_ = (_loc2_ | param1.red) << 16;
         _loc2_ |= param1.green << 8;
         return _loc2_ | param1.blue;
      }
      
      private function updateColors(param1:Number, param2:Boolean) : *
      {
         var _loc4_:MovieClip = null;
         if(param1 < 0)
         {
            this.cpicker.nocolor_face.visible = true;
         }
         else
         {
            this.cpicker.nocolor_face.visible = false;
         }
         var _loc3_:* = ColorToRGB(param1);
         if(this.panel != null)
         {
            _loc4_ = MovieClip(this.panel.getChildByName("color_display"));
            _loc4_.transform.colorTransform = new ColorTransform(1,1,1,1,_loc3_.red,_loc3_.green,_loc3_.blue,0);
            if(param2)
            {
               _loc4_ = MovieClip(this.panel.getChildByName("color_input"));
               _loc4_.color = param1;
            }
         }
      }
      
      private function updateface() : void
      {
         var _loc1_:* = ColorToRGB(this.selectedColor);
         this.cpicker.face.transform.colorTransform = new ColorTransform(1,1,1,1,_loc1_.red,_loc1_.green,_loc1_.blue,0);
      }
      
      private function over(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget as MovieClip;
         var _loc3_:* = _loc2_.color;
         this.hover = true;
         this.hoverColor = this.RGBtoColor(_loc3_);
         this.updateColors(this.hoverColor,true);
         _loc2_ = MovieClip(this.panel.getChildByName("colors")).getChildByName("face_borders");
         _loc2_.x = MovieClip(param1.currentTarget).x;
         _loc2_.y = MovieClip(param1.currentTarget).y;
         _loc2_.visible = true;
         this.dispatchEvent(new Event("ROLL_OVER"));
      }
      
      private function out(param1:MouseEvent) : *
      {
         this.hover = false;
         this.dispatchEvent(new Event("ROLL_OUT"));
      }
      
      public function click(param1:MovieClip) : *
      {
         var _loc2_:* = undefined;
         if(param1 == this.advancedColor)
         {
            this.setIsOpened(false);
            this.createAdvancedColorPanel(this.selectedColor);
            this.selectedColor = this._opening_color;
         }
         else
         {
            _loc2_ = param1.color;
            this.selectedColor = this.RGBtoColor(_loc2_);
            try
            {
               this.setIsOpened(false);
            }
            catch(e:*)
            {
            }
            this.dispatchEvent(new Event("CHANGE"));
         }
      }
      
      private function createAdvancedColorPanel(param1:Number) : void
      {
         this.advancedColorPanel = new AdvColorPanel(ColorToRGB(param1)) as MovieClip;
         this.advancedColorPanel.name = "advancedColorPanel";
         this.addChild(this.advancedColorPanel);
         switch(this.direction)
         {
            case ColorPicker2.DOWN_LEFT:
               this.advancedColorPanel.x = this.cpicker.x - this.advancedColorPanel.width + this.cpicker.width;
               this.advancedColorPanel.y = this.cpicker.y + this.cpicker.height + 5;
               break;
            case ColorPicker2.UP_LEFT:
               this.panel.x = this.cpicker.x + this.cpicker.width - this.advancedColorPanel.width;
               this.panel.y = this.cpicker.y - this.advancedColorPanel.height - 5;
               break;
            case ColorPicker2.UP_RIGHT:
               this.panel.x = this.cpicker.x;
               this.panel.y = this.cpicker.y - this.advancedColorPanel.height - 5;
               break;
            case ColorPicker2.DOWN_RIGHT:
            default:
               this.advancedColorPanel.x = this.cpicker.x;
               this.advancedColorPanel.y = this.cpicker.y + this.cpicker.height + 5;
         }
      }
      
      public function unload(param1:MovieClip) : *
      {
         this.removeChild(this.advancedColorPanel);
      }
      
      public function changed(param1:String) : *
      {
         if(param1.charAt(0) == "#")
         {
            param1 = param1.substr(1);
         }
         this._color = ColorPicker2.StringToColor(param1);
         this.updateColors(this._color,false);
      }
      
      public function openMC(param1:MouseEvent) : void
      {
         this.setIsOpened(!this.getIsOpened());
      }
   }
}

