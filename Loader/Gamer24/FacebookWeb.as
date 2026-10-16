package
{
   import flash.display.MovieClip;
   
   public class FacebookWeb
   {
      public var fb:FBListener;
      
      public var rootClass:MovieClip;
      
      public var extInterface:ExternalCalls;
      
      public function FacebookWeb()
      {
         super();
      }
      
      public function InitListener(param1:MovieClip) : *
      {
         this.rootClass = param1;
         this.fb = new FBListener(param1);
         this.extInterface = param1.extCall;
      }
      
      public function FBMessage(param1:*, param2:*) : *
      {
         trace("sendMessage: " + param1 + " --- retVal: " + param2);
         this.fb.handleFBEvent(param1,param2);
      }
      
      public function Login() : void
      {
         this.extInterface.fbLogin();
      }
      
      public function Logout() : void
      {
         this.fb.fbLogout();
         this.fb.logoutFromFB();
      }
   }
}

