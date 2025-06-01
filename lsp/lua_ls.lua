return {
	cmd = {
		'/home/christopher-wood/projects/lua-language-server/bin/lua-language-server',
	},
	settings = {
		Lua = {
			misc = {
				parameters = {
					"--develop=true",
					"--dbgport=11428",
				}
			}
		},
	},
	filetypes = { 'lua' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'selene.yml',
		'.git',
	},
}
