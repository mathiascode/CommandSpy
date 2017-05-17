g_PluginInfo = {
	Name = "CommandSpy",
	Version = "2",
	Date = "2016-10-12",
	SourceLocation = "https://github.com/mathiascode/CommandSpy",
	Description = [[A plugin for Cuberite that displays commands executed by other players in the chat. To enable and disable CommandSpy, type "/commandspy on" and "/commandspy off" in the chat.]],

	AdditionalInfo =
	{
		{
			Title = "Command Display Colors",
			Contents = [[
			Blue: The player who executed a command has CommandSpy disabled.
			Yellow: The player who executed a command has CommandSpy enabled.
			Purple: A command was executed by the console or a command block.
			]],
		},
	},

	Commands =
	{
		["/commandspy"] =
		{
			HelpString = "Enables or disables CommandSpy.",
			Permission = "commandspy.use",
			Handler = HandleCommandSpyCommand,
			Alias = { "/c", "/cs", "/cspy" },
		},
	},
}
