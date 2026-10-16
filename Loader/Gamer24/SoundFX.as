package
{
   import flash.events.*;
   import flash.media.*;
   import flash.system.ApplicationDomain;
   
   public class SoundFX extends EventDispatcher
   {
      private var sfx:Object;
      
      private var assetsDomain:ApplicationDomain;
      
      private var activeChannels:Vector.<SoundChannel>;
      
      public var stf:SoundTransform;
      
      public var bSoundOn:Boolean = true;
      
      public function SoundFX(param1:ApplicationDomain)
      {
         this.sfx = {};
         this.activeChannels = new Vector.<SoundChannel>();
         this.stf = new SoundTransform(0.7,0);
         super();
         this.assetsDomain = param1;
         var _loc2_:Array = ["Achievement","Bad","Click","ClickBig","ClickMagic","Coins","Energy","Evil","Fire","Good","Heal","Hit1","Hit2","Hit3","Miss","VeryGood","Water","Wind"];
      }
      
      public function playSound(param1:String) : void
      {
         var channel:SoundChannel = null;
         var AssetClass:Class = null;
         var strSound:String = param1;
         if(this.bSoundOn)
         {
            if(this.sfx[strSound] != null)
            {
               channel = this.sfx[strSound].play(0,0,this.stf);
            }
            else
            {
               try
               {
                  if(this.assetsDomain.hasDefinition(strSound))
                  {
                     AssetClass = this.assetsDomain.getDefinition(strSound) as Class;
                     this.sfx[strSound] = new AssetClass();
                     channel = this.sfx[strSound].play(0,0,this.stf);
                  }
                  else
                  {
                     trace("[Load] ERR SoundFX: definition \'" + strSound + "\' not found in assetsDomain");
                  }
               }
               catch(e:Error)
               {
                  trace("[Load] ERR SoundFX: " + e.message);
               }
            }
            if(channel != null)
            {
               this.activeChannels.push(channel);
               channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete,false,0,true);
            }
         }
      }
      
      private function onSoundComplete(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.target as SoundChannel;
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         var _loc3_:int = int(this.activeChannels.indexOf(_loc2_));
         if(_loc3_ >= 0)
         {
            this.activeChannels.splice(_loc3_,1);
         }
      }
      
      public function stopAll() : void
      {
         var _loc1_:SoundChannel = null;
         for each(_loc1_ in this.activeChannels)
         {
            _loc1_.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
            _loc1_.stop();
         }
         this.activeChannels.length = 0;
      }
      
      public function soundOn() : void
      {
         this.bSoundOn = true;
      }
      
      public function soundOff() : void
      {
         this.bSoundOn = false;
      }
   }
}

