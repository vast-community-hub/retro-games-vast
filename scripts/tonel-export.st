| writer path |
path := ((CfsPath named: CfsDirectoryDescriptor getcwd) append: '..\tonel-repos\retro-games-vast').
writer := TonelWriter new.
writer
	addLatestConfigurationMapNamed: 'Retro Games';
	addApplicationsFromConfigurationMaps.
writer writeProjectInto: path.
