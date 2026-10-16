using Grimoire.Botting;
using Grimoire.Game;
using Grimoire.Game.Data;
using Grimoire.Tools;
using Grimoire.UI;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Grimoire.Networking.Handlers
{
    public class HandlerDropItem : IJsonMessageHandler
    {
        public string[] HandledCommands
        {
            get;
        } = new string[1]
        {
            "dropItem"
        };

        public void Handle(JsonMessage message)
        {
            JObject data = (JObject)message.DataObject;
            if (data != null)
            {
                Flash.HandleDropItemData(data);
            }
        }
    }
}