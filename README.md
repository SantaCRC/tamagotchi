![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) 

# Serial Port Tamagotchi
This is a Tamagotchi that lives in the ASIC world. Made for a TinyTapeout4 

# How to use
To use this project, you need to connect a serial port to in[0] and out[0] of the chip. Then, open a serial terminal.

## objetive
As a normal Tamagotchi game, the objetive is to keep your pet alive. You can do this by feeding it, playing with it, and cleaning it's poop. If you don't do this, your pet will die.

## controls
In this table you can see the controls of the game:
| Key | Action |
| --- | --- |
| `e` | Feed your pet |
| `p` | Play with your pet |
| `b` | Clean your pet's poop |
| `t` | Talk with your Tamagotchi |
| `s` | Sleep |
| `w` | Wake up |

## states
The Tamagotchi has 2 states:
- Awake: In this state, you can play with your pet, feed it, clean it's poop, and talk with it.
- Sleep: In this state, you can't do anything with your pet. It will sleep until you awake them `w`, and then it will wake up.

## needs
The Tamagotchi has 5 needs:
- Hunger: If your pet is hungry, you need to feed it `e`.
- Happiness: If your pet is sad, you need to play with it `p`.
- Hygiene: If your pet is dirty, you need to clean it's poop `b`.
- Energy: If your pet is tired, you need to let it sleep `s`.
- Social: If your pet is lonely, you need to talk with it `t`.

## death
If you don't take care of your pet, it will die. To revive it, you need to reset the game.

# Animations
For every state the Tamagotchi has an animation. Here you can see them:
| State | Animation |
| --- | --- |
| Awake/normal | ![picture 1](images/85213b3fccad68a4514f4539f9f3eb33c2b94928280457c1e3fa535f72cc02b3.png)|
| Sleep |  ![picture 2](images/2d855852f527f15682be931ec3ac42b25b59667f173582e45dbf8281c3df7b15.png)|
| Dead | ![dead](images/d3995d06a678aa63d5249022531cb040412afb064b4fa816612a7366378edc01.png) |
| Hungry | ![![revive](images/revive.gif) 1](images/41da8ccd67a5408e97dc32218f401963bc25e5097a26b31d44dcad26a90605c9.png)|
| Sad | ![picture 4](images/c2d052094b6141d0fc0fd3e62b2066bb007d0798cf714db3219fd34d2ff2553d.png)  |
| Dirty | ![picture 5](images/e9c5fd6232ee7e732bc88a89e2629686d538ce320f9bf8d4ab58aebc6b27cb03.png) |
| Tired | ![tired](images/tired.gif) |
| Lonely | ![lonely](images/lonely.gif) |


  
