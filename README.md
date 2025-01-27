## Gentouranos overlay
This is a small project for me to have the packages I miss from the repo and existing overlays.  
Although I try to do my best, you shouldn't expect any of my packages to build nor run on your system.  
If you have the knowledge to fix what I'm trying to do, **don't hesistate to write a PR**, it'll be much appreciated !!  

## Enable this overlay
Using the `app-eselect/eselect-repository` tool, execute `sudo eselect repository add gentouranos git https://github.com/OuraN2O/gentouranos`.  
Then sync with `sudo emaint sync -r gentouranos`

## Ebuilds that don't currently work/Help wanted  
- `app-misc/Anki-25.01_beta1` : Can build on my main machine but not on my laptop. When builds, screen doesn't work (maybe vulkan dependancy problem)
- `app-misc/pinokio-3.3.29` : Draft
