package
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   public dynamic class dummyMC extends MovieClip
   {
      public var backfoot:MovieClip;
      
      public var backhair:MovieClip;
      
      public var backhand:MovieClip;
      
      public var backrobe:MovieClip;
      
      public var backshin:MovieClip;
      
      public var backshoulder:MovieClip;
      
      public var backthigh:MovieClip;
      
      public var cape:MovieClip;
      
      public var chest:MovieClip;
      
      public var frontfoot:MovieClip;
      
      public var fronthand:MovieClip;
      
      public var frontshin:MovieClip;
      
      public var frontshoulder:MovieClip;
      
      public var frontthigh:MovieClip;
      
      public var head:MovieClip;
      
      public var hip:MovieClip;
      
      public var idlefoot:MovieClip;
      
      public var robe:MovieClip;
      
      public var weapon:MovieClip;
      
      public var avtMC:*;
      
      public var rootClass:*;
      
      public var AssetClass:*;
      
      public var spellFX:*;
      
      public var rand:int;
      
      public var strSpell:String;
      
      public var spells:Array;
      
      public function dummyMC()
      {
         super();
      }
      
      public function showIdleFoot() : *
      {
         this.frontfoot.visible = false;
         this.idlefoot.visible = true;
      }
      
      public function showFrontFoot() : *
      {
         this.idlefoot.visible = false;
         this.frontfoot.visible = true;
      }
   }
}

