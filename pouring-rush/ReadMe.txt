# Pouring Rush

A 2D game developed with **Godot Engine 4**.

---

## 📌 Features & Architecture

* **Modular Components:** Independent, self-contained components for mechanics like knockback, hitboxes, and hurtboxes.
* **Character State Machine:** State-driven movement, combat, and damage handling.
* **Game Mode Management:** Centralized game loops, controller handling, and state management.
* **UI & Menus:** Pause system, settings, volume controls, and main menu screens.

---

## 🚀 Getting Started

### Prerequisites

* [Godot Engine 4.x](https://godotengine.org/download)

### How to Run

1. **Clone or download** this repository to your local machine.
2. Launch **Godot 4**.
3. Click **Import**, navigate to the project directory, and select `project.godot`.
4. Press **F5** (or the Play button) to start the game from the main scene.

---

## 📁 Project Structure

```text
pouring-rush/
├── assets/
│   ├── sound/              # Sound effects and audio
│   └── visual/             # Sprites, tiles, and UI textures
├── character/              # Player character scenes, scripts, and state machine
├── components/             # Reusable gameplay components (knockback, hurtboxes, etc.)
├── game_mode/              # Core game modes, state management, and controllers
├── main/                   # Main game entry scenes and logic
├── ui/                     # UI components, menus, and settings screens
└── world/                  # Environment, tilemaps, and level layout scenes

## How to play

    *You need to connect a controller/controllers to play
    
    (You can use almost every controller, but here i will explain the controlls with a Nintendo Switch controller)
    
    Left Joy-stick = Movement
    Right Joy-stick = Aim
    Left bumper = Jump / double jump
    Right bumper = Basic shot
    Right trigger = Special shot 1
    Left trigger = Special shot 2
    "A" button = Utility move
    "B" button = Tech
    "X" button = Interact
    "Y" button = Reload basic shot