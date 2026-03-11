# NixOS-files

### Salty's NixOS Configuration Files

> [!WARNING]
> This is my personal configuration of NixOS! 
> It's actively being worked on and made specifically for my needs.
> This is my first go at using anything like NixOS so be warned, it's all jank!

## Why NixOS?
I was a windows user ever since I started using a computer, so I'm building this config up in order of having an equal (and in many cases better) experience than using windows for *ALL* my tasks, since **NixOS** is declaritive by it's very nature, I felt it was the most suited for me to learn and grow both my programing knowledge and linux knowledge (*having a repo to track progress also helps a lot which is nice*).

## How NixOS?
I remember hearing horror stories from the person that introduced me to NixOS about people making their *ENTIRE* configuration a single `.nix` file. I didn't want to be one of those people, since it makes it harder to work on the config, and harder to identify where mistakes happen. It also makes it harder to implement multiple hosts for a single config like I want. So to put it short I've structured my configuration into modules that can be turned on and off on any particular host on demand.


### The Future
My current plan is to have it so that my config is as flexible as possible for *ANY* use-case I demand of it, and to be able to run on *ANY* system I so choose to use, without over-complicating the config as a whole. One of the main goals I want to achieve with my NixOS config is that it will be easy to pick up and modify to your liking if need be.

Any help is appreciated and welcomed!