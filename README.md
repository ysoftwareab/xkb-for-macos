# xkb-for-macos

PC keyboard layouts for MacOS straight from X11 xkb.

Thanks to [klfc](https://github.com/39aldo39/klfc),
we converted all keyboard layouts from an Ubuntu 20.04 distribution (X11 xkb) to MacOS (keylayout).

Outcome: type on your Mac the same way you would type on a PC.


## Installation

You can either do the following in `/Library/Keyboard Layouts` for all users (recommended)
or `~/Library/Keyboard Layouts` only for your own user.

The preferred way is to clone this git repository

```
sudo rm -rf /Library/Keyboard\ Layouts
sudo git clone https://github.com/ysoftwareab/xkb-for-macos.git /Library/Keyboard\ Layouts
```

but you can also copy individual `y-xkb-<language>.*` files.

You can then activate the `ysoftwareab xkb <language>`
via `System Preferences` - `Keyboard` - `Keyboard (tab)` - `Input Sources`.


## But why?

The reasons stem from the Swedish keyboard layout on MacOS.

Basic keys for programming are a killer to reach:

* `|` is `Right Option + 7`
* `\` is `Shift + Right Option + 7`
* `{` is `Shift + Right Option + 8`
* `}` is `Shift + Right Option + 9`

Same keys on PC:

* `|` is `Right Option + <`
* `\` is `Right Option + +`
* `{` is `Right Option + 7`
* `}` is `Right Option + 0`

Similar issues surface in other languages as you can see in Related Work.

What is different from other initiatives is that this is not a manual conversion.

For a visual diff, please consult the original MacOS keyboard layout [se.pdf](se.pdf)
and the PC keyboard layout [y-xkb-se.pdf](y-xkb-se.pdf), as exported by [Ukelele](https://software.sil.org/ukelele/).


## Related Work

* https://github.com/PetorSFZ/MacOSX-Improved-Swedish-Keyboard-Layout
* https://github.com/skrysmanski/windows-pc-keyboard-layout-mac
* https://github.com/memm74/PC-Tastatur105.keylayout
* https://github.com/cbaggers/backup-uk-keyboard-layouts-for-macos
* https://gist.github.com/IvanRublev/2da1c7447d0458989d4654b5c35c22b4
* https://github.com/fardjad/persian-pc.keylayout
* https://github.com/kalbason/MacOS-Ukrainian-PC-keyboard-layout
* https://github.com/zaki/mac-hun-keyboard


See also

* https://github.com/motform/colemak-se
* https://github.com/AlbertVeli/Swedish-Dvorak--svdvorak--for-OSX
* https://github.com/mw8/white_keyboard_layout
* https://johanegustafsson.net/projects/swerty/
* https://github.com/rollbear/keyboard-layout


## License

[UNLICENSE](UNLICENSE)
