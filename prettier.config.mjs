import carbonPrettierSettings from 'prettier-config-carbon'

export default {
	$schema: 'https://json.schemastore.org/prettierrc',
	...carbonPrettierSettings, // Carbon prettier plus overrides...
	arrowParens: 'avoid',
	semi: false,
	tabWidth: 2,
	singleQuote: true,
	printWidth: 100,
	trailingComma: 'none',
	useTabs: true,
	pluginSearchDirs: ['.'] // Find plugins in node_modules
}
