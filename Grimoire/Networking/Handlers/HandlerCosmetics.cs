using Grimoire.Botting;
using Grimoire.Game;
using Newtonsoft.Json.Linq;
using System;

namespace Grimoire.Networking.Handlers
{
    public class HandlerCosmetics : IJsonMessageHandler
    {
        public string[] HandledCommands { get; } = new string[2]
        {
            "initUserDatas",
            "initUserData"
        };

        public void Handle(JsonMessage message)
        {
            try
            {
                JToken dataObj = message.DataObject;
                if (dataObj == null)
                    return;

                JToken aToken = dataObj["a"];
                if (aToken is JArray array)
                {
                    foreach (JToken userToken in array)
                    {
                        ProcessUserToken(userToken);
                    }
                }
                else if (dataObj["data"] != null)
                {
                    ProcessUserToken(dataObj);
                }
            }
            catch { }
        }

        private void ProcessUserToken(JToken userToken)
        {
            try
            {
                int uid = userToken["uid"]?.Value<int>() ?? 0;
                JToken data = userToken["data"] ?? userToken;
                string username = data["strUsername"]?.Value<string>();
                JToken eqpToken = data["eqp"];

                if (!string.IsNullOrEmpty(username))
                {
                    // Also update World player dictionary
                    World.UpdatePlayerFromData(username, uid, data);
                }

                if (eqpToken != null && eqpToken.Type == JTokenType.Object)
                {
                    string json = eqpToken.ToString(Newtonsoft.Json.Formatting.None);
                    var equips = CosmeticEquipment.ParseEquips(json);
                    if (equips != null && equips.Count > 0)
                    {
                        if (!string.IsNullOrEmpty(username))
                        {
                            CosmeticEquipment.StoreInCache(username, equips);
                        }
                        if (uid > 0)
                        {
                            CosmeticEquipment.StoreInCache(uid.ToString(), equips);
                        }
                    }
                }
            }
            catch { }
        }
    }
}
