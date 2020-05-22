| writer path |
path := (CfsPath named: '<insert path to root retro-games-vast local repo here>').
writer := TonelWriter new.
writer
	addLatestConfigurationMapNamed: 'Retro Games';
	addApplicationsFromConfigurationMaps.
writer writeProjectInto: path.
