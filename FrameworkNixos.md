# Installing NixOS on a Framework 13

The DIY build took 10 minutes and was completely painless. Very impressed.
https://guides.frame.work/Guide/Framework+Laptop+13+(AMD+Ryzen%E2%84%A2+7040+Series)+DIY+Edition+Quick+Start+Guide/211

I then downloaded the text-based NixOS image and burned it on a microSD drive (with the etcher tool recommended in the NixOS guide). As I found out after some unsuccessfull attempts, booting from USB required me to press F2 upon boot and to disable secure Boot: https://wiki.nixos.org/wiki/Hardware/Framework/Laptop_13

I chose the text-based installer because I remember being overwhelmed by Gnome and KDE and their 1000s of dependencies, and because I remember a blissful and painless time with a custom, very manageable Arch Linux (Xmonad, PCmanFM, yay etc.).

I chose the option to run the installer from RAM to prevent wear on the SD card and making it quick. No idea if this made any difference though, but it worked.

wpa_cli is horrible but it connected me to the WiFi. Kudos to Framework for choosing a Wifi module compatible out of the box with Linux!

Then the installation was just creating and customizing my config.nix, and voilá :-)

Installation was quite quick despite my slow internet. Maybe 2 minutes.



----


Update (2025-05-29)

Many packages are not in the nixOS repository and their readme says I should use `nix-env`. When I search for info about the differences between declarative installation through the nixos configuration and imperative `nix-env`, everyone warns against using `nix-env` because it has severe flaws and will inevitably lead to weird issues.

https://stop-using-nix-env.privatevoid.net/

What to do? The only way seems to manually declare all dependencies of those non-nixOS packages with custom nix expressions. Then I can also share them. This feels quite cumbersome.

For packages that I don't expect to keep, the "experimental" flakes way (`nix profile ...` command) seems to be the way to go.

> Thanks to Flakes, it also allows you to easily install packages from package collections other than nixpkgs. 
