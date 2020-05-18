<p align="center">
<!---<img src="assets/logos/128x128.png">-->
 <h1 align="center">Retro Games for VASmalltalk</h1>
  <p align="center">
    Retro games implemented with VASmalltalk!
    <!---
    <br>
    <a href="docs/"><strong>Explore the docs »</strong></a>
    <br>
    -->
    <br>
    <a href="https://github.com/vast-community-hub/retro-games-vast/issues/new?labels=Type%3A+Defect">Report a defect</a>
    |
    <a href="https://github.com/vast-community-hub/retro-games-vast/issues/new?labels=Type%3A+Feature">Request feature</a>
  </p>
</p>


Small collection of retro games (Pacman, Snake, BattleShip, etc.) implemented with VASmalltalk. Excellent examples for showing what you can do and for learning GUI development. Watch out [some screenshots](assets/screenshots/) to get an idea!

<img width="500" alt="Retro Games Collage" src="assets/screenshots/retro-games-vast-collage.png">

## License
- The code is licensed under [MIT](LICENSE).
- The documentation is licensed under [CC BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/).


## Installation

1. Install [VA Smalltalk 9.2.x or newer](https://www.instantiations.com/products/vasmalltalk/download.html).
2. Install Tonel support in your development image following [this guide](https://github.com/vasmalltalk/tonel-vast#installation).
3. Load the desired Configuration Maps of this project either from the context menu or via a script (mind that you may need to update the path so that it points to your local clone):
```smalltalk
| loader path |
path := ((CfsPath named: CfsDirectoryDescriptor getcwd) append: '..\tonel-repos\retro-games-vast').
loader := TonelLoader readFromPath: path.
loader
	beUnattended.
	useGitVersion.
loader loadAllMapsWithRequiredMaps.
```

## Playing

Below is a script to start each game. They all have the same API:

```smalltalk
BattleshipWindow new open.
LightCyclesWindow new open.
MastermindWindow new open.
MinesweeperWindow new open.
PacmanWindow new open.
SnakeWindow new open.
STCalculator new open.
TowerOfHanoiWindow new open.
```

## Contributing

Check the [Contribution Guidelines](CONTRIBUTING.md)


## Acknowledgments

- [Lee Clayberg](https://github.com/LeeClayberg) for all the initial development of this project.
