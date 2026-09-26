# Chase Game (working title)

A 3D single-player parkour racing game built in Godot. Players control fantasy champions, each with four unique movement abilities, through story-driven levels: A-to-B races, escapes from pursuers, and chases after targets. The first character in development is **Sable**, a shadow cat-folk thief from the twilight city of Umbral.

Current milestone: **Sable's movement controller and a greybox rooftop test level.**

## Engine and language

- **Godot 4.7.2 stable.** Only use Godot 4.x APIs. Never use Godot 3 syntax. Common mistakes to avoid:
  - `@export`, `@onready`, `@tool` (not `export`, `onready`, `tool`)
  - `await` (not `yield`)
  - `CharacterBody3D` with the built-in `velocity` property and `move_and_slide()` with no arguments (not `KinematicBody`)
  - `signal_name.connect(callable)` and `signal_name.emit()` (not `connect("signal", self, "method")` or `emit_signal`)
  - `Node3D` (not `Spatial`), `instantiate()` (not `instance()`)
- **GDScript only**, with static typing everywhere: typed variables, parameters, and return types (`func jump(force: float) -> void:`).
- Physics engine: **Jolt**.

## Project structure

```
res://
  characters/
    sable/            # Sable's scene, scripts, abilities
  player/             # Shared player controller, camera, state machine
    states/           # One script per movement state
  abilities/          # Base Ability class and shared ability logic
  levels/
    test/             # Greybox test levels
  ui/
  autoloads/          # Singletons (none yet)
  assets/             # Models, textures, audio
```

## Conventions

- File and folder names: `snake_case` (`player_controller.gd`, `wall_run_state.gd`).
- Class names: `PascalCase` via `class_name`.
- Signals: past tense (`landed`, `ability_activated`, `state_changed`).
- Private members start with an underscore (`_coyote_timer`).
- All gameplay tuning values (speeds, jump heights, timings, cooldowns) are `@export` variables, grouped with `@export_group`, so they can be tuned in the editor while playing. Never hard-code tuning numbers inside logic.
- Prefer composition: small focused nodes and scripts over large ones. Keep scripts under roughly 300 lines.
- Use signals to communicate upward and direct method calls to communicate downward.

## Architecture

- **Player:** `CharacterBody3D` with a third-person camera (`SpringArm3D` + `Camera3D`).
- **Movement:** a node-based state machine. Each state (idle, run, jump, fall, slide, wall run, etc.) is its own script extending a base `State` class with `enter()`, `exit()`, `physics_update(delta)`, and `handle_input(event)`.
- **Abilities (later):** a base `Ability` class handling cooldowns and activation. Each ability extends it. Characters will be defined by `Resource` files listing their stats and four abilities.
- **Input actions** (defined in Project Settings > Input Map): `move_forward`, `move_back`, `move_left`, `move_right`, `jump`, `slide`, `ability_1`, `ability_2`, `ability_3`, `ability_4`. Mouse controls the camera. Gamepad support should work through the same actions.

## Verifying changes

After making changes, check the project loads without script errors:

```
godot --headless --path . --quit
```

(If `godot` isn't on the PATH, ask the developer for the executable location.)

Claude cannot playtest. After movement or feel changes, summarise what changed and which `@export` values the developer should try tuning.

## Workflow rules

- Make changes in small, focused steps and commit after each working step with a clear message.
- Never edit files in the `.godot/` folder (it's generated and gitignored).
- Commit `.uid` files alongside their scripts.
- Small edits to `.tscn` files are fine. For complex scene layouts, describe the node structure so the developer can build it in the editor, or build it in code.
- Ask before adding third-party addons.