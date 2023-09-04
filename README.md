![GDS Workflow Badge](../../workflows/gds/badge.svg) ![Docs Workflow Badge](../../workflows/docs/badge.svg) ![Test Workflow Badge](../../workflows/test/badge.svg) [![wakatime](https://wakatime.com/badge/github/SantaCRC/tamagotchi.svg)](https://wakatime.com/badge/github/SantaCRC/tamagotchi)

# Serial Port Tamagotchi

Welcome to the world of ASIC Tamagotchi! This Tamagotchi is designed for the TinyTapeout4.

## How to Use

To interact with this project, you'll need to connect a serial port to `in[0]` and `out[0]` of the chip. Then, open a serial terminal.

## Objective

Just like a traditional Tamagotchi game, your objective is to keep your pet alive and happy. You can achieve this by feeding it, playing with it, and cleaning up after it. Neglecting these responsibilities will result in your pet's demise.

## Controls

Here are the controls for the game:

| Key | Action |
| --- | --- |
| `e` | Feed your pet |
| `p` | Play with your pet |
| `b` | Clean up your pet's poop |
| `t` | Talk to your Tamagotchi |
| `s` | Put your Tamagotchi to sleep |
| `w` | Wake up your Tamagotchi |

## States

Your Tamagotchi can be in one of two states:

- **Awake**: In this state, you can interact with your pet, including feeding, playing, cleaning, and talking to it.
- **Sleep**: During this state, your pet is resting, and you can't interact with it. To wake it up, press `w`.

## Needs

Your Tamagotchi has five basic needs:

1. **Hunger**: Feed your pet (`e`) when it's hungry.
2. **Happiness**: Play with your pet (`p`) to keep it happy.
3. **Hygiene**: Clean up your pet's poop (`b`) to maintain cleanliness.
4. **Energy**: Let your pet sleep (`s`) when it's tired.
5. **Social**: Talk to your Tamagotchi (`t`) to alleviate loneliness.

## Death

Failure to address your pet's needs will result in its death. You can revive it by resetting the game.

# Animations

Each Tamagotchi state has a corresponding animation:

| State          | Animation                                                  |
| -------------- | ---------------------------------------------------------- |
| Awake/Normal   | ![Awake/Normal](images/66efdfbfdad870bac365949b05fcfa1401c199cff2b7ba865e3ecdbf287da581.png) |
| Sleep          | ![Sleep](images/2d855852f527f15682be931ec3ac42b25b59667f173582e45dbf8281c3df7b15.png) |
| Dead           | ![Dead](images/d3995d06a678aa63d5249022531cb040412afb064b4fa816612a7366378edc01.png) |
| Hungry         | ![Hungry](images/41da8ccd67a5408e97dc32218f401963bc25e5097a26b31d44dcad26a90605c9.png) |
| Sad            | ![Sad](images/c2d052094b6141d0fc0fd3e62b2066bb007d0798cf714db3219fd34d2ff2553d.png) |
| Dirty          | ![Dirty](images/e9c5fd6232ee7e732bc88a89e2629686d538ce320f9bf8d4ab58aebc6b27cb03.png) |
| Tired          | ![Tired](images/85213b3fccad68a4514f4539f9f3eb33c2b94928280457c1e3fa535f72cc02b3.png) |
| Lonely         | ![Lonely](images/fc6c7cbbc8e8e087690882441b156bb722557afaf1b373eb3db590bbd96b542a.png) |
