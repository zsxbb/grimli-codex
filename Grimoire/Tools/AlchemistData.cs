using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;
using Newtonsoft.Json;

namespace Grimoire.Tools
{
    public class AlchemyRecipe
    {
        [JsonProperty("Potion Name")]
        public string PotionName { get; set; }

        [JsonProperty("Reagent 1")]
        public string Reagent1 { get; set; }

        [JsonProperty("Reagent 1 ID")]
        public string Reagent1Id { get; set; }

        [JsonProperty("Reagent 2")]
        public string Reagent2 { get; set; }

        [JsonProperty("Reagent 2 ID")]
        public string Reagent2Id { get; set; }

        [JsonProperty("Alchemy Rune")]
        public string AlchemyRune { get; set; }

        [JsonProperty("Trait")]
        public string Trait { get; set; }

        [JsonIgnore]
        public bool HasReagent2 =>
            !string.IsNullOrEmpty(Reagent2) &&
            !Reagent2.Equals("None", StringComparison.OrdinalIgnoreCase) &&
            !string.IsNullOrEmpty(Reagent2Id);

        public string GetPacketStart()
        {
            string p1 = Reagent1Id ?? "";
            string p2 = HasReagent2 ? (Reagent2Id ?? "") : "";
            string rune = AlchemyRune ?? "";
            string trait = Trait ?? "";

            return $"%xt%zm%crafting%1%alchStart%{p1}%{p2}%{rune}%1%{trait}%";
        }

        public string GetPacketComplete()
        {
            return "%xt%zm%crafting%1%alchDone%";
        }

        public override string ToString()
        {
            return PotionName ?? "Unknown Potion";
        }
    }

    public static class AlchemistData
    {
        public const int DragonRunestoneId = 7132;
        public const string DragonRunestoneName = "Dragon Runestone";

        private static List<AlchemyRecipe> _recipes;

        public static List<AlchemyRecipe> Recipes
        {
            get
            {
                if (_recipes == null)
                {
                    LoadRecipes();
                }
                return _recipes;
            }
        }

        private static void LoadRecipes()
        {
            try
            {
                string jsonToParse = RawJson;
                string localFile = Path.Combine(Application.StartupPath, "packet_alchemy.json");
                if (File.Exists(localFile))
                {
                    try
                    {
                        string external = File.ReadAllText(localFile);
                        if (!string.IsNullOrWhiteSpace(external))
                            jsonToParse = external;
                    }
                    catch { }
                }

                _recipes = JsonConvert.DeserializeObject<List<AlchemyRecipe>>(jsonToParse) ?? new List<AlchemyRecipe>();
            }
            catch
            {
                _recipes = new List<AlchemyRecipe>();
            }
        }

        public static readonly string RawJson = @"[
  {""Potion Name"": ""Accuracy Elixir"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Aim Elixir"", ""Reagent 1"": ""Nimblestem"", ""Reagent 1 ID"": ""11469"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Velocity Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Eva""},
  {""Potion Name"": ""Vial of Antitoxins"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Vigor Potion"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Dragon Scale"", ""Reagent 2 ID"": ""11475"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Volatile Temper Agent"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Dragon Scale"", ""Reagent 2 ID"": ""11475"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Wise Tonic"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Wis""},
  {""Potion Name"": ""Balance Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Lemurphant Tears"", ""Reagent 2 ID"": ""11479"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Battle Elixir"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Body Tonic"", ""Reagent 1"": ""Roc Tongue"", ""Reagent 1 ID"": ""11471"", ""Reagent 2"": ""Chaoroot"", ""Reagent 2 ID"": ""11481"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""End""},
  {""Potion Name"": ""Brave Tonic"", ""Reagent 1"": ""Lemurphant Tears"", ""Reagent 1 ID"": ""11479"", ""Reagent 2"": ""Roc Tongue"", ""Reagent 2 ID"": ""11471"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Brawn Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Dragon Scale"", ""Reagent 2 ID"": ""11475"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Bright Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Brilliance Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Brute Tonic"", ""Reagent 1"": ""Fish Oil"", ""Reagent 1 ID"": ""11467"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Chance Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Chaos Entity"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Courage Tonic"", ""Reagent 1"": ""Roc Tongue"", ""Reagent 1 ID"": ""11471"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Cunning Tonic"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Destruction Elixir"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Dried Slime"", ""Reagent 2 ID"": ""11474"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Divine Elixir"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""hOu""},
  {""Potion Name"": ""Elusion Elixir"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Eradication Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Necrot"", ""Reagent 2 ID"": ""11480"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Essence Potion"", ""Reagent 1"": ""Necrot"", ""Reagent 1 ID"": ""11480"", ""Reagent 2"": ""Arashtite Ore"", ""Reagent 2 ID"": ""11473"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Fate Tonic"", ""Reagent 1"": ""Dried Slime"", ""Reagent 1 ID"": ""11474"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Luc""},
  {""Potion Name"": ""Finesse Tonic"", ""Reagent 1"": ""Nimblestem"", ""Reagent 1 ID"": ""11469"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Foresight Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Dragon Scale"", ""Reagent 2 ID"": ""11475"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Fortitude Tonic"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Roc Tongue"", ""Reagent 2 ID"": ""11471"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""End""},
  {""Potion Name"": ""Fortune Tonic"", ""Reagent 1"": ""Fish Oil"", ""Reagent 1 ID"": ""11467"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Glowing Temper Agent"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Dragon Scale"", ""Reagent 2 ID"": ""11475"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Honor Potion"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Dragon Scale"", ""Reagent 2 ID"": ""11475"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Insight Tonic"", ""Reagent 1"": ""Fish Oil"", ""Reagent 1 ID"": ""11467"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Judgment Tonic"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Wis""},
  {""Potion Name"": ""Karma Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Keen Elixir"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Lesser Runic Salve"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Searbush"", ""Reagent 2 ID"": ""11468"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Life Potion"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Dragon Scale"", ""Reagent 2 ID"": ""11475"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Malevolence Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Dried Slime"", ""Reagent 2 ID"": ""11474"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Malice Potion"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Dragon Scale"", ""Reagent 2 ID"": ""11475"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Mastery Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Dex""},
  {""Potion Name"": ""Medicinal Salve"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Might Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Str""},
  {""Potion Name"": ""Mind Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Piercing Elixir"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Power Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Renew Elixir"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Lemurphant Tears"", ""Reagent 2 ID"": ""11479"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Revitalize Elixir"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Lemurphant Tears"", ""Reagent 2 ID"": ""11479"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Runic Salve"", ""Reagent 1"": ""Fish Oil"", ""Reagent 1 ID"": ""11467"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Sage Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Chaos Entity"", ""Reagent 2 ID"": ""11482"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Int""},
  {""Potion Name"": ""Sharp Elixir"", ""Reagent 1"": ""Fish Oil"", ""Reagent 1 ID"": ""11467"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Skill Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Soul Potion"", ""Reagent 1"": ""Necrot"", ""Reagent 1 ID"": ""11480"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Dam""},
  {""Potion Name"": ""Stinging Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Striking Elixir"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Swiftness Elixir"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Trueshot Elixir"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unknown Alloy"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Arashtite Ore"", ""Reagent 2 ID"": ""11473"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Battle Elixir"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Body Tonic"", ""Reagent 1"": ""Roc Tongue"", ""Reagent 1 ID"": ""11471"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Brave Tonic"", ""Reagent 1"": ""Ice Vapor"", ""Reagent 1 ID"": ""11478"", ""Reagent 2"": ""Roc Tongue"", ""Reagent 2 ID"": ""11471"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Brawn Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Bright Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Brilliance Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Dried Slime"", ""Reagent 2 ID"": ""11474"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Brute Tonic"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Chance Tonic"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Courage Tonic"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Roc Tongue"", ""Reagent 2 ID"": ""11471"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Cunning Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Fate Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Finesse Tonic"", ""Reagent 1"": ""Ice Vapor"", ""Reagent 1 ID"": ""11478"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Foresight Tonic"", ""Reagent 1"": ""Moglin Tears"", ""Reagent 1 ID"": ""11472"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Fortitude Tonic"", ""Reagent 1"": ""Ice Vapor"", ""Reagent 1 ID"": ""11478"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Fortune Tonic"", ""Reagent 1"": ""Trollola Nectar"", ""Reagent 1 ID"": ""11476"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Insight Tonic"", ""Reagent 1"": ""Fish Oil"", ""Reagent 1 ID"": ""11467"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Judgment Tonic"", ""Reagent 1"": ""Moglin Tears"", ""Reagent 1 ID"": ""11472"", ""Reagent 2"": ""Lemurphant Tears"", ""Reagent 2 ID"": ""11479"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Karma Tonic"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Keen Elixir"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Malevolence Elixir"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Searbush"", ""Reagent 2 ID"": ""11468"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Mastery Tonic"", ""Reagent 1"": ""Nimblestem"", ""Reagent 1 ID"": ""11469"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Might Tonic"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Chaos Entity"", ""Reagent 2 ID"": ""11482"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Mind Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Piercing Elixir"", ""Reagent 1"": ""Ice Vapor"", ""Reagent 1 ID"": ""11478"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Power Tonic"", ""Reagent 1"": ""Ice Vapor"", ""Reagent 1 ID"": ""11478"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Sage Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Roc Tongue"", ""Reagent 2 ID"": ""11471"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Sharp Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Dried Slime"", ""Reagent 2 ID"": ""11474"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Skill Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Stinging Elixir"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Swiftness Elixir"", ""Reagent 1"": ""Nimblestem"", ""Reagent 1 ID"": ""11469"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Velocity Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Basic Wise Tonic"", ""Reagent 1"": ""Moglin Tears"", ""Reagent 1 ID"": ""11472"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Potent Battle Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""APw""},
  {""Potion Name"": ""Potent Accuracy Elixir"", ""Reagent 1"": ""Nimblestem"", ""Reagent 1 ID"": ""11469"", ""Reagent 2"": ""Doomatter"", ""Reagent 2 ID"": ""11477"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Potent Aim Elixir"", ""Reagent 1"": ""Nimblestem"", ""Reagent 1 ID"": ""11469"", ""Reagent 2"": ""Doomatter"", ""Reagent 2 ID"": ""11477"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Potent Balance Elixir"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Potent Eradication Elixir"", ""Reagent 1"": ""Moglin Tears"", ""Reagent 1 ID"": ""11472"", ""Reagent 2"": ""Necrot"", ""Reagent 2 ID"": ""11480"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Potent Honor Potion"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Chaos Entity"", ""Reagent 2 ID"": ""11482"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Dam""},
  {""Potion Name"": ""Potent Malice Potion"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Chaos Entity"", ""Reagent 2 ID"": ""11482"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Dam""},
  {""Potion Name"": ""Potent Destruction Elixir"", ""Reagent 1"": ""Dried Slime"", ""Reagent 1 ID"": ""11474"", ""Reagent 2"": ""Necrot"", ""Reagent 2 ID"": ""11480"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""mRe""},
  {""Potion Name"": ""Potent Malevolence Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Searbush"", ""Reagent 2 ID"": ""11468"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""SPw""},
  {""Potion Name"": ""Potent Revitalize Elixir"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Lemurphant Tears"", ""Reagent 2 ID"": ""11479"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""hRe""},
  {""Potion Name"": ""Potent Life Potion"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Searbush"", ""Reagent 2 ID"": ""11468"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Hea""},
  {""Potion Name"": ""Potent Renew Elixir"", ""Reagent 1"": ""Ice Vapor"", ""Reagent 1 ID"": ""11478"", ""Reagent 2"": ""Lemurphant Tears"", ""Reagent 2 ID"": ""11479"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Potent Striking Elixir"", ""Reagent 1"": ""Lemurphant Tears"", ""Reagent 1 ID"": ""11479"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Battle Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Body Tonic"", ""Reagent 1"": ""Roc Tongue"", ""Reagent 1 ID"": ""11471"", ""Reagent 2"": ""Chaoroot"", ""Reagent 2 ID"": ""11481"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""End""},
  {""Potion Name"": ""Unstable Brave Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Roc Tongue"", ""Reagent 2 ID"": ""11471"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Brawn Tonic"", ""Reagent 1"": ""Rhison Blood"", ""Reagent 1 ID"": ""11470"", ""Reagent 2"": ""Searbush"", ""Reagent 2 ID"": ""11468"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Bright Tonic"", ""Reagent 1"": ""Dried Slime"", ""Reagent 1 ID"": ""11474"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Brilliance Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Brute Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Chance Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Courage Tonic"", ""Reagent 1"": ""Fish Oil"", ""Reagent 1 ID"": ""11467"", ""Reagent 2"": ""Roc Tongue"", ""Reagent 2 ID"": ""11471"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Cunning Tonic"", ""Reagent 1"": ""Ice Vapor"", ""Reagent 1 ID"": ""11478"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Fate Tonic"", ""Reagent 1"": ""Dried Slime"", ""Reagent 1 ID"": ""11474"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Luc""},
  {""Potion Name"": ""Unstable Finesse Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Foresight Tonic"", ""Reagent 1"": ""Lemurphant Tears"", ""Reagent 1 ID"": ""11479"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Fortitude Tonic"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Roc Tongue"", ""Reagent 2 ID"": ""11471"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""End""},
  {""Potion Name"": ""Unstable Fortune Tonic"", ""Reagent 1"": ""Rhison Blood"", ""Reagent 1 ID"": ""11470"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Insight Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Judgment Tonic"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Jera"", ""Trait"": ""Wis""},
  {""Potion Name"": ""Unstable Karma Tonic"", ""Reagent 1"": ""Rhison Blood"", ""Reagent 1 ID"": ""11470"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Keen Elixir"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Fish Oil"", ""Reagent 2 ID"": ""11467"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Malevolence Elixir"", ""Reagent 1"": ""Lemurphant Tears"", ""Reagent 1 ID"": ""11479"", ""Reagent 2"": ""Searbush"", ""Reagent 2 ID"": ""11468"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Mastery Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Dex""},
  {""Potion Name"": ""Unstable Might Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Str""},
  {""Potion Name"": ""Unstable Mind Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""None"", ""Reagent 2 ID"": """", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Piercing Elixir"", ""Reagent 1"": ""Nimblestem"", ""Reagent 1 ID"": ""11469"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Power Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Rhison Blood"", ""Reagent 2 ID"": ""11470"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Sage Tonic"", ""Reagent 1"": ""Arashtite Ore"", ""Reagent 1 ID"": ""11473"", ""Reagent 2"": ""Chaos Entity"", ""Reagent 2 ID"": ""11482"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Int""},
  {""Potion Name"": ""Unstable Sharp Elixir"", ""Reagent 1"": ""Fish Oil"", ""Reagent 1 ID"": ""11467"", ""Reagent 2"": ""Trollola Nectar"", ""Reagent 2 ID"": ""11476"", ""Alchemy Rune"": ""Uruz"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Skill Tonic"", ""Reagent 1"": ""Chaos Entity"", ""Reagent 1 ID"": ""11482"", ""Reagent 2"": ""Lemurphant Tears"", ""Reagent 2 ID"": ""11479"", ""Alchemy Rune"": ""Fehu"", ""Trait"": ""Moose""},
  {""Potion Name"": ""Unstable Velocity Elixir"", ""Reagent 1"": ""Doomatter"", ""Reagent 1 ID"": ""11477"", ""Reagent 2"": ""Nimblestem"", ""Reagent 2 ID"": ""11469"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Eva""},
  {""Potion Name"": ""Unstable Wise Tonic"", ""Reagent 1"": ""Chaoroot"", ""Reagent 1 ID"": ""11481"", ""Reagent 2"": ""Moglin Tears"", ""Reagent 2 ID"": ""11472"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""Wis""},
  {""Potion Name"": ""Unstable Divine Elixir"", ""Reagent 1"": ""Dragon Scale"", ""Reagent 1 ID"": ""11475"", ""Reagent 2"": ""Lemurphant Tears"", ""Reagent 2 ID"": ""11479"", ""Alchemy Rune"": ""Gebo"", ""Trait"": ""hOu""}
]";
    }
}
