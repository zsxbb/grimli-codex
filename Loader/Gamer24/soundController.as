package
{
   import flash.display.MovieClip;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   
   public class soundController
   {
      private var rootClass:MovieClip;
      
      private var bSong:Boolean;
      
      private var songOn:Boolean;
      
      public var mChannel:SoundChannel;
      
      private var btnSong:MovieClip;
      
      private var songClass:Sound;
      
      public function soundController(param1:Sound, param2:MovieClip)
      {
         super();
         this.rootClass = param2;
         this.mChannel = new SoundChannel();
         this.mChannel.soundTransform = new SoundTransform(param2.litePreference.data.dOptions["iSoundMusic"] != null ? Number(param2.litePreference.data.dOptions["iSoundMusic"]) : 0.35);
         this.bSong = false;
         this.songClass = param1;
         this.songOn = true;
      }
      
      public function checkSound(param1:MovieClip = null) : void
      {
         if(this.rootClass.mixer.bSoundOn)
         {
            if(this.songOn)
            {
               if(!this.bSong)
               {
                  this.mChannel = this.songClass.play(0,9999,this.mChannel.soundTransform);
                  this.bSong = true;
                  if(param1 != null)
                  {
                     param1.txtMusic.text = "Music On";
                  }
               }
            }
            else if(param1 != null)
            {
               param1.txtMusic.text = "Music Off";
            }
         }
         else if(param1 != null)
         {
            param1.txtMusic.text = "Music Off";
         }
      }
      
      public function stopMusic(param1:MovieClip = null) : void
      {
         SoundMixer.stopAll();
         this.songOn = false;
         if(param1 != null)
         {
            param1.txtMusic.text = "Music Off";
         }
      }
      
      public function buttonClick(param1:MovieClip) : void
      {
         if(this.bSong)
         {
            SoundMixer.stopAll();
            this.songOn = false;
            param1.txtMusic.text = "Music Off";
         }
         else if(this.rootClass.mixer.bSoundOn)
         {
            this.mChannel = this.songClass.play(0,9999,this.mChannel.soundTransform);
            this.songOn = true;
            param1.txtMusic.text = "Music On";
         }
         this.bSong = !this.bSong;
      }
   }
}

