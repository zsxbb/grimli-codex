using Grimoire.Botting;
using Grimoire.Tools;
using Grimoire.UI;
using Grimoire.Utils;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;

namespace Grimoire.Game
{
    public class AuraSnapshot
    {
        [JsonProperty("nam")]
        public string Name { get; set; } = string.Empty;

        [JsonProperty("n")]
        public int Stacks { get; set; } = 1;

        [JsonProperty("dur")]
        public double Duration { get; set; }

        [JsonProperty("remaining")]
        public double RemainingTime { get; set; }

        [JsonProperty("persist")]
        public bool Persistent { get; set; }
    }

    public class PlayerAura
    {
        public string Name { get; private set; }
        public double Value { get; set; }
        public int Duration { get; private set; }
        public int ExpireTime { get; private set; }
        public PlayerAura(string name, double value, int duration)
        {
            Name = name;
            Value = value;
            Duration = duration;
            Refresh(value, duration);
        }
        public void Refresh(double value, int duration)
        {
            Value = value;
            Duration = duration;
            ExpireTime = Environment.TickCount + duration * 1000;
        }
        public void Refresh(int duration)
        {
            Duration = duration;
            ExpireTime = Environment.TickCount + duration * 1000;
        }

        public bool IsExpired()
        {
            return Environment.TickCount >= ExpireTime;
        }

        //in miliseconds
        public int RemainingTime()
        {
            int remain = ExpireTime - Environment.TickCount;
            return remain > 0 ? remain : 0;
        }
    }
    public class AuraManager
    {
        public static AuraManager SelfAura { get; } = new AuraManager();
        private static readonly Dictionary<int, AuraManager> _enemyAuras =
        new Dictionary<int, AuraManager>();

        private Dictionary<string, PlayerAura> auras = new
        Dictionary<string, PlayerAura>(StringComparer.OrdinalIgnoreCase);

        private AuraManager() { }
        public static AuraManager EnemyAura(int monsterId)
        {
            if (!_enemyAuras.TryGetValue(monsterId, out AuraManager manager))
            {
                manager = new AuraManager();
                _enemyAuras[monsterId] = manager;
            }
            return manager;
        }
        public static void resetMonsterAura()
        {
            _enemyAuras.Clear();
        }

        public static List<AuraSnapshot> GetSnapshots(string subject = "Self")
        {
            try
            {
                string path = subject.Equals("Self", StringComparison.OrdinalIgnoreCase)
                    ? $"world.uoTree['{Player.Username.ToLower()}'].hudAuras"
                    : "world.myAvatar.target.dataLeaf.hudAuras";

                var raw = Flash.Instance.GetGameObject<Dictionary<string, dynamic>>(path);
                if (raw == null)
                    return new List<AuraSnapshot>();

                List<AuraSnapshot> list = new List<AuraSnapshot>();
                foreach (var kvp in raw)
                {
                    if (kvp.Value == null) continue;
                    list.Add(new AuraSnapshot
                    {
                        Name = kvp.Key,
                        Stacks = kvp.Value.n != null ? (int)kvp.Value.n : 1,
                        Duration = kvp.Value.dur != null ? (double)kvp.Value.dur : 0,
                        Persistent = kvp.Value.persist == true
                    });
                }
                return list;
            }
            catch
            {
                return new List<AuraSnapshot>();
            }
        }

        public static int GetAuraStacks(string auraName, string subject = "Self")
        {
            var snap = GetSnapshots(subject).FirstOrDefault(a => a.Name.EqualsIgnoreCase(auraName));
            if (snap != null)
                return snap.Stacks;

            if (subject.Equals("Self", StringComparison.OrdinalIgnoreCase))
                return (int)SelfAura.GetValue(auraName);

            return 0;
        }

        public void ApplyAura(string name, double value, int duration)
        {
            if (auras.TryGetValue(name, out PlayerAura aura))
                aura.Refresh(value, duration);
            else
                auras[name] = new PlayerAura(name, value, duration);
        }
        public void AuraIncrement(string name)
        {
            if (auras.TryGetValue(name, out PlayerAura aura))
                aura.Value++;
            aura.Refresh(aura.Duration);
        }

        public void RemoveAura(string name)
        {
            auras.Remove(name);
        }

        public bool HasAura(string name)
        {
            if (auras.ContainsKey(name))
                return true;

            var snap = GetSnapshots("Self").FirstOrDefault(a => a.Name.EqualsIgnoreCase(name));
            return snap != null;
        }

        public double GetValue(string name)
        {
            var snap = GetSnapshots("Self").FirstOrDefault(a => a.Name.EqualsIgnoreCase(name));
            if (snap != null)
                return snap.Stacks;

            if (auras.TryGetValue(name, out PlayerAura aura) && !aura.IsExpired())
            {
                if (aura.Value <= 1)
                    aura.Value = 1;
                return aura.Value;
            }

            return 0;
        }

        public int GetRemainingTime(string name)
        {
            return auras.TryGetValue(name, out PlayerAura aura)
                ? aura.RemainingTime()
                : 0;
        }

        public void ClearAllAura(bool forceClean = false)
        {
            Dictionary<string, PlayerAura> addback = new Dictionary<string, PlayerAura>(StringComparer.OrdinalIgnoreCase);
            if (forceClean)
            {
                auras = addback;
                return;
            }

            foreach (PlayerAura aura in auras.Values)
            {
                if (TE.Any(filter => aura.Name.ContainsIgnoreCase(filter)))
                    addback.Add(aura.Name, aura);
            }

            auras = addback;
        }
        private string[] TE = { "Fate", "Sage", "Body", "Might", "Elixir" };

        public void Update()
        {
            var expired = auras
                .Where(a => a.Value.IsExpired())
                .Select(a => a.Key)
                .ToList();

            foreach (var key in expired)
                RemoveAura(key);
        }
    }
}

