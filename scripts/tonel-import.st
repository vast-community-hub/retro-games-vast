| loader path |
path := ((CfsPath named: CfsDirectoryDescriptor getcwd) append: '..\tonel-repos\retro-games-vast').
loader := TonelLoader readFromPath: path.
loader
	beUnattended.
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
