# Timberborn Autosplitter

Automatic splits for [Timberborn](https://store.steampowered.com/app/1062090/Timberborn/) speedruns in LiveSplit.

## How it works

Timberborn provides no way for external tools to observe what is happening in an active game — there are no exported stats, no live API, and the autosave files are only written periodically. This makes it impossible for a tool like LiveSplit to know when you built a Forester, researched a technology, or activated a Wonder.

This project solves that with two components:

**`mod/` — Timberborn game mod**
A small mod that hooks into Timberborn's own systems and exports live game state to a JSON file on your machine every 0.5 seconds. It tracks population, log counts, which buildings have been completed, which technologies have been researched, and whether the Wonder has been activated. It also generates a unique run ID each time you start a new game, which is what LiveSplit uses to detect that a new run has begun.

**`autosplitter/` — LiveSplit ASL script**
A script for LiveSplit's Scriptable Auto Splitter component that reads the JSON file produced by the mod. It watches for changes to the run ID to start the timer, then monitors the building and research state to fire splits at the right moments. Each split is individually toggleable so you can adapt the layout to different categories.

---

## Installation

### 1. Install the mod

Timberborn mods are distributed through [Thunderstore](https://thunderstore.io/c/timberborn/), not Steam Workshop. Install **Autosplitter State Export** via **r2modman** or the **Timberborn in-game mod browser** — both place the mod in the correct location automatically.

For manual installation, drop `Code.dll` and `manifest.json` into:

```
%USERPROFILE%\Documents\Timberborn\Mods\AutosplitterStateExport\
```

The mod writes a file to:

```
%APPDATA%\..\LocalLow\Mechanistry\Timberborn\autosplitter_state.json
```

This updates every 0.5 seconds while a game is running.

### 2. Set up LiveSplit

1. Right-click LiveSplit → **Edit Splits**.
2. Set **Game Name** to `Timberborn` and **Run Category** to `Wonder`.
3. LiveSplit will prompt you to activate the auto splitter — click **Activate**.
4. Add your split names to match the splits listed below.

LiveSplit downloads and manages the autosplitter script automatically — no files to configure.

---

## Splits

All splits are toggleable in the LiveSplit auto splitter settings panel.

| Split | Trigger |
|---|---|
| Forester | Forester's Hut finished |
| Gear Workshop | Gear Workshop finished |
| Tapper's Shack | Tapper's Shack finished |
| Observatory | Observatory finished |
| Smelter + Wood Workshop | Both finished (either order) |
| Research Earth Recultivator | Science unlocked |
| Earth Recultivator (Launch) | Wonder activated |

Splits fire once per run and work for both Folktails and Iron Teeth.

The timer starts automatically when a new game is detected (new `gameId` in the state file).

---

## State file format

Advanced users and tool developers can read the JSON directly:

```json
{
  "mapName": "Canyon",
  "faction": "Folktails",
  "day": 14,
  "logs": 42,
  "adults": 12,
  "children": 3,
  "finishedBuildings": ["Forester.Folktails", "GearWorkshop.Folktails"],
  "earthRecultivatorResearched": false,
  "wonderActivated": false,
  "gameId": "a3f2c1d0"
}
```

`gameId` is a random 8-character hex string, regenerated each time a new game starts.

---

## Building from source

Requires .NET SDK and a Timberborn install.

1. Clone this repo.
2. Open `mod/TimberbornAutosplitter.csproj` and update `GameRoot` to your install path if it differs from the Steam default:
   ```xml
   <GameRoot>C:\Program Files (x86)\Steam\steamapps\common\Timberborn</GameRoot>
   ```
3. Build the project — it will automatically deploy to your mods folder and copy the ASL to `Documents\Timberborn\`.

---

## LiveSplit layout

`autosplitter/generate_layout.py` generates a `timberborn.lsl` pre-configured with the correct ASL path for your machine:

```
python autosplitter/generate_layout.py
```

Open the resulting `timberborn.lsl` in LiveSplit via **Open Layout**.
