return {
	"tris203/precognition.nvim",
	event = "VeryLazy",
	opts = {
		startVisible = true,
		hints = {
			["^"] = { text = "^", prio = 2 },
			["$"] = { text = "$", prio = 1 },
			["w"] = { text = "w", prio = 10 },
			["b"] = { text = "b", prio = 9 },
			["e"] = { text = "e", prio = 8 },
			["W"] = { text = "W", prio = 7 },
			["B"] = { text = "B", prio = 6 },
			["E"] = { text = "E", prio = 5 },
		},
	},
}
