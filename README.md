# Timberborn Autosplitter

Automatic splits for [Timberborn](https://store.steampowered.com/app/1062090/Timberborn/) speedruns in LiveSplit.

Two components work together:

- **mod/** — a Timberborn mod that writes live game state to a JSON file
- **autosplitter/** — a LiveSplit ASL script that reads that file and triggers splits

---

## Installation

### 1. Install the mod

Install **Autosplitter State Export** via your mod manager (Thunderstore/r2modman) or drop `Code.dll` and `manifest.json` into:

```
%USERPROFILE%\Documents\Timberborn\Mods\AutosplitterStateExport\
```

The mod writes a file to:

```
%APPDATA%\..\LocalLow\Mechanistry\Timberborn\autosplitter_state.json
```

This updates every 0.5 seconds while a game is running.

### 2. Set up LiveSplit

1. Download `autosplitter/timberborn.asl` from this repo.
2. In LiveSplit, right-click → **Edit Layout** → **+** → **Scriptable Auto Splitter**.
3. Double-click the component and point it at the downloaded `timberborn.asl`.
4. Configure your splits in LiveSplit to match the split names below.

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
