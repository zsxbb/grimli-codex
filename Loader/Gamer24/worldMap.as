package
{
   import flash.display.MovieClip;
   import flash.text.*;
   import flash.utils.getQualifiedClassName;
   
   public class worldMap extends MovieClip
   {
      public var rootClass:*;
      
      private var worldObject:Object;
      
      private var areaObject:Object;
      
      private var nodeObject:Object;
      
      private var cutsceneObject:Object;
      
      public function worldMap(param1:Object)
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:Number = NaN;
         var _loc12_:String = null;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:Object = null;
         var _loc21_:String = null;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
         var _loc24_:* = undefined;
         var _loc25_:* = undefined;
         var _loc26_:* = undefined;
         var _loc27_:Array = null;
         var _loc28_:String = null;
         var _loc29_:String = null;
         var _loc30_:* = undefined;
         super();
         worldObject = param1;
         worldObject.areas = new Array();
         areaObject = new Object();
         nodeObject = new Object();
         cutsceneObject = new Object();
         var _loc4_:* = "m";
         for(_loc5_ in worldObject)
         {
            if(getQualifiedClassName(worldObject[_loc5_]) == "Object")
            {
               _loc3_ = _loc4_ + worldObject[_loc5_].regionID;
               worldObject.areas.push(_loc3_);
               areaObject[_loc3_] = new Object();
               areaObject[_loc3_] = worldObject[_loc5_];
               areaObject[_loc3_].mapTitle = worldObject[_loc5_].regionName;
               areaObject[_loc3_].nodes = new Array();
               for(_loc16_ in worldObject[_loc5_])
               {
                  if(getQualifiedClassName(worldObject[_loc5_][_loc16_]) == "Array" && _loc16_ != "nodes")
                  {
                     _loc17_ = 0;
                     while(_loc17_ < worldObject[_loc5_][_loc16_].length)
                     {
                        _loc2_ = String(worldObject[_loc5_][_loc16_][_loc17_].mapName).toLowerCase() + worldObject[_loc5_].regionID;
                        nodeObject[_loc2_] = new Object();
                        nodeObject[_loc2_] = worldObject[_loc5_][_loc16_][_loc17_];
                        nodeObject[_loc2_].area = String(_loc3_);
                        areaObject[_loc3_].nodes.push(_loc2_);
                        nodeObject[_loc2_].cuts = new Array();
                        for(_loc18_ in worldObject[_loc5_][_loc16_][_loc17_])
                        {
                           if(getQualifiedClassName(worldObject[_loc5_][_loc16_][_loc17_][_loc18_]) == "Array" && _loc18_ != "cuts")
                           {
                              _loc19_ = 0;
                              while(_loc19_ < worldObject[_loc5_][_loc16_][_loc17_][_loc18_].length)
                              {
                                 _loc20_ = worldObject[_loc5_][_loc16_][_loc17_][_loc18_][_loc19_];
                                 if(_loc20_.qsIndex == nodeObject[_loc2_].qsValue)
                                 {
                                    _loc21_ = _loc2_ + "c" + String(_loc19_);
                                    cutsceneObject[_loc21_] = new Object();
                                    cutsceneObject[_loc21_].node = _loc2_;
                                    cutsceneObject[_loc21_] = _loc20_;
                                    nodeObject[_loc2_].cuts.push(_loc21_);
                                 }
                                 _loc19_++;
                              }
                           }
                        }
                        _loc17_++;
                     }
                  }
               }
            }
         }
         _loc6_ = ",";
         _loc7_ = ":";
         for(_loc13_ in worldObject)
         {
            for(_loc22_ in worldObject[_loc13_])
            {
               if(_loc22_ == "description")
               {
                  _loc8_ = String(worldObject[_loc13_][_loc22_]);
                  _loc10_ = _loc8_.split(_loc6_);
                  _loc23_ = 0;
                  while(_loc23_ < _loc10_.length)
                  {
                     _loc9_ = _loc10_[_loc23_];
                     _loc11_ = Number(_loc9_.indexOf(_loc7_));
                     if(_loc11_ > -1)
                     {
                        _loc12_ = _loc9_.slice(0,_loc11_);
                        worldObject[_loc13_][_loc12_] = _loc9_.slice(_loc11_ + 1,_loc9_.length);
                     }
                     else if(_loc9_ != "")
                     {
                        worldObject[_loc13_][_loc9_] = "";
                     }
                     _loc23_++;
                  }
                  _loc10_ = null;
               }
            }
         }
         for(_loc14_ in areaObject)
         {
            for(_loc24_ in areaObject[_loc14_])
            {
               if(_loc24_ == "strExtra")
               {
                  _loc8_ = String(areaObject[_loc14_][_loc24_]);
                  _loc10_ = _loc8_.split(_loc6_);
                  _loc25_ = 0;
                  while(_loc25_ < _loc10_.length)
                  {
                     _loc9_ = _loc10_[_loc25_];
                     _loc11_ = Number(_loc9_.indexOf(_loc7_));
                     if(_loc11_ > -1)
                     {
                        _loc12_ = _loc9_.slice(0,_loc11_);
                        areaObject[_loc14_][_loc12_] = _loc9_.slice(_loc11_ + 1,_loc9_.length);
                     }
                     else if(_loc9_ != "")
                     {
                        areaObject[_loc14_][_loc9_] = "";
                     }
                     _loc25_++;
                  }
                  _loc10_ = null;
               }
            }
         }
         for(_loc15_ in nodeObject)
         {
            for(_loc26_ in nodeObject[_loc15_])
            {
               switch(_loc26_)
               {
                  case "minLevel":
                  case "maxLevel":
                  case "qsValue":
                  case "questMin":
                  case "questMax":
                     nodeObject[_loc15_][_loc26_] = Number(nodeObject[_loc15_][_loc26_]);
                     break;
                  case "bUpgrade":
                     if(typeof nodeObject[_loc15_][_loc26_] == "string")
                     {
                        if(nodeObject[_loc15_][_loc26_] == "False" || nodeObject[_loc15_][_loc26_] == "false")
                        {
                           nodeObject[_loc15_][_loc26_] = false;
                        }
                        else
                        {
                           nodeObject[_loc15_][_loc26_] = true;
                        }
                     }
                     break;
                  case "strExtra":
                     _loc8_ = String(nodeObject[_loc15_][_loc26_]);
                     _loc27_ = null;
                     _loc27_ = _loc8_.split(_loc6_);
                     _loc30_ = 0;
                     while(_loc30_ < _loc27_.length)
                     {
                        _loc28_ = _loc27_[_loc30_];
                        _loc11_ = Number(_loc28_.indexOf(_loc7_));
                        if(_loc11_ > -1)
                        {
                           _loc29_ = _loc28_.slice(0,_loc11_);
                           nodeObject[_loc15_][_loc29_] = _loc28_.slice(_loc11_ + 1,_loc28_.length);
                        }
                        else if(_loc28_ != "")
                        {
                           nodeObject[_loc15_][_loc28_] = "";
                        }
                        _loc30_++;
                     }
                     break;
               }
            }
         }
      }
      
      internal function get World() : Object
      {
         return worldObject;
      }
      
      internal function get Areas() : Object
      {
         return areaObject;
      }
      
      internal function get Nodes() : Object
      {
         return nodeObject;
      }
      
      internal function get Cutscenes() : Object
      {
         return cutsceneObject;
      }
      
      internal function specificArea(param1:String) : Object
      {
         if(areaObject[param1] != null)
         {
            return areaObject[param1];
         }
         return null;
      }
      
      internal function getAreaNameByTitle(param1:String) : String
      {
         var _loc2_:* = undefined;
         for(_loc2_ in areaObject)
         {
            if(areaObject[_loc2_].mapTitle != undefined)
            {
               if(areaObject[_loc2_].mapTitle == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      internal function getAreaByTitle(param1:String) : Object
      {
         var _loc2_:* = undefined;
         for(_loc2_ in areaObject)
         {
            if(areaObject[_loc2_].mapTitle != undefined)
            {
               if(areaObject[_loc2_].mapTitle == param1)
               {
                  return areaObject[_loc2_];
               }
            }
         }
         return null;
      }
      
      internal function getAreaByLink(param1:String) : Object
      {
         var _loc2_:* = undefined;
         for(_loc2_ in areaObject)
         {
            if(areaObject[_loc2_].strLink != undefined)
            {
               if(areaObject[_loc2_].strLink == param1)
               {
                  return areaObject[_loc2_];
               }
            }
         }
         return null;
      }
      
      internal function specificNode(param1:String) : Object
      {
         if(nodeObject[param1] != null)
         {
            return nodeObject[param1];
         }
         return null;
      }
      
      internal function specificCutscene(param1:String) : Object
      {
         if(cutsceneObject[param1] != null)
         {
            return cutsceneObject[param1];
         }
         return null;
      }
   }
}

