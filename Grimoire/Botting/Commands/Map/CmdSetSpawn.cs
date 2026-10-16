using Grimoire.Game;
using System;
using System.Threading.Tasks;

namespace Grimoire.Botting.Commands.Map
{
    public class CmdSetSpawn : IBotCommand
    {
        public Task Execute(IBotEngine instance)
        {
            Player.SetSpawnPoint();
            return Task.CompletedTask;
        }

        public override string ToString()
        {
            return "Set Spawnpoint";
        }
    }
}