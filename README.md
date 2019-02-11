# Materia-theme-colorschemes
Materia-colorschemes is a shell script that can be used to modify/customize/tweak the original Materia theme [nana-4/materia-theme](https://github.com/nana-4/materia-theme/tree/v20181125). Here are some features:
- A pre-defined list of color schemes include but not limited to (solarized, gruvbox, tomorrow,...,etc)
- A convenient way to Apply different color scheme base on pre-defined color schemes(see ./materia.sh -l)
- Create a custom theme with different colors of your choice (see ./materia.sh -h)
- Change almost every details until you get satisfied (see ./materia.sh -h)
- Ability to render assets based on the new color scheme (see ./materia.sh -h)

Here are some tweaks 
- Remove the white border on the top of the titlebar 
- Remove the titlebar shadow and make it flatter
- Thinner titlebar default to 34px (you can change it) 
- Enhanced inverse/selection color
- Auto color the Dash board based on the new color scheme
- Better line separator based on the fg color

### List pre-defined color schemes 
```sh
$./materia.sh --list
scheme-template:    color size     fg      bg      bg2     bg3     sbg     sfg     tbg     tfg     accent btn2-fg hl tbh
solarized-light:    light compact #3c3836 #fdf6e3 #eee8d5 #e9e1c9 #2196f3 #ffffff #bdbdbd #073642 #2196f3 #ffffff 0  34px 
solarized-dark:      dark compact #eee8d5 #002b36 #073642 #09343e #dc322f #ffffff #05262e #eee8d5 #dc322f default 0  34px
gruvbox-light:      light compact #3c3836 #fbf1c7 #ebdbb2 #d5c4a1 #458588 #f9f5d7 #a89984 #282828 #458588 #FFFFFF 0  34px
gruvbox-dark:        dark compact #ebdbb2 #282828 #3c3836 #32302f #458588 #ebdbb2 #83a598 #32302f #fb4934 default 0  34px
tomorrow:           light compact #4d4d4c #ffffff #f2f2f2 #e4e4e4 #3e999f #ffffff #BCAAA4 #282828 #3e999f default 0  34px
tomorrow-night:      dark compact #cccccc #001e33 #000f1a #00001a #515151 #f2777a #404040 #cccccc #f2777a #303030 1  34px
n30x-darkw:          dark compact #00997a #252525 #2a2a2a #2d2d2d #323232 #9575cd #404040 #000000 #c2185b #1a1a1a 1  34px
n30x-darkg:          dark compact #6c7043 #252525 #2a2a2a #2d2d2d #323232 #b49a31 #1a1a1a #b49a31 #963d97 #000000 1  34px
n30x-light:         light compact #424242 #fafafa #f5f5f5 #eeeeee #03a9f4 #ffffff #78909c #ffffff #e91e63 default 0  34px
n30x-grey:          light compact #424242 #e0e0e0 #d9d9d9 #cccccc #cccccc #000000 #bfbfbf #000000 #0288d1 default 1  34px

Use './materia.sh --scheme scheme_name' to install the scheme.
```
Note: you can add as many as you want of color schemes to `colorschemes` file. To add your own color schemes please follow the format listed in the file (`colorschemes`).

## Installation
1. Download Materia theme version v20181125 from [nana-4/materia-theme-v20181125](https://github.com/nana-4/materia-theme/tree/v20181125).
2. Download [Materia-colorschemes-v20181125](https://github.com/n3oxmind/Materia-theme-colorschemes/tree/v20181125).
3. Copy the contents of Materia-colorschemes(step 2) to Materia theme(step 1).
4. cd to  `materia-theme-20181125` and run `./materia.sh --help` form more information and usage examples.

### Install from a pre-defined color schemes
```sh
$ ./materia.sh --scheme solarized-light
$ ./materia.sh --scheme n30x-dark
$ ./materia.sh --scheme gruvbox-light
```
### Install from a pre-defined color scheme with few changes
```sh
$ ./materia.sh --scheme solarized-light --sbg c70000    # use solarized color scheme with different selection bg
$ ./materia.sh --scheme gruvbox-light --accent 0073e6   # use gruvbox color scheme with different accent color
$ ./materia.sh --scheme gruvbox-light --tbg 424242 --tfg      # use gruvbox color scheme with different titlebar bg and fg color
```
Note: You can change as many colors as you want until you get satisfied (see `./materia.sh -h` for more information)

### Create your own custom theme
```sh
$ ./materia.sh -c light -s compact --bg 4d4d4d
$ ./materia.sh -c light -s compact --bg 111111 --bg2 222222 --bg3 333333 ...
```
Note: You dont have to specify all the colors, if you just specified the `--bg` the script will generate the missing colors for you
see `./materia.sh --help` for more information.

