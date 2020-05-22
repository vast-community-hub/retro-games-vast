| loader path |
path := (CfsPath named: '<insert path to root retro-games-vast local repo here>').
loader := TonelLoader readFromPath: path.
loader
	beUnattended;
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
