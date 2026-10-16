using System.Threading.Tasks;

namespace Grimoire.Botting.Commands.Misc
{
	public class CmdProvoke : IBotCommand
	{
		public bool Set { get; set; }

		public Task Execute(IBotEngine instance)
		{
			OptionsManager.ProvokeMonsters = Set;
			return Task.CompletedTask;
		}

		public override string ToString()
		{
			if (Set)
			{
				return "Provoke ON";
			}
			else
			{
				return "Provoke OFF";
			}
		}
	}
}
