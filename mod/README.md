# Autosplitter State Export

A mod for Timberborn speedrunners. Exports live game state to a JSON file every 0.5 seconds so that LiveSplit can automatically split on key in-game events.

Timberborn has no built-in way for external tools to observe an active game — there are no live stats, no API, and autosaves only write periodically. This mod hooks into the game's own systems to bridge that gap.

## Required for

The [Timberborn LiveSplit autosplitter](https://github.com/MHVandborg/timberborn_speedrun) — currently supports the **Wonder (Any%)** category for both Folktails and Iron Teeth.

## What it tracks

- Current day
- Adult and child population
- Total logs across all districts
- Which buildings have been completed
- Whether the Earth Recultivator has been researched
- Whether the Wonder has been activated
- A unique run ID that resets each time a new game starts

## Installation

Install via r2modman or drop `Code.dll` and `manifest.json` into:

```
%USERPROFILE%\Documents\Timberborn\Mods\AutosplitterStateExport\
```

Once installed, the mod writes to:

```
%APPDATA%\..\LocalLow\Mechanistry\Timberborn\autosplitter_state.json
```

## Setting up LiveSplit

1. Right-click LiveSplit → **Edit Splits**
2. Set **Game Name** to `Timberborn` and **Run Category** to `Wonder`
3. LiveSplit will prompt you to activate the autosplitter — click **Activate**

If the autosplitter is not yet registered in LiveSplit, follow the manual setup instructions in the [GitHub repo](https://github.com/MHVandborg/timberborn_speedrun).

## State file format

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
