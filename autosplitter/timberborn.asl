state("Timberborn") {}

startup {
    settings.Add("forester",                    true, "Forester");
    settings.Add("gear_workshop",               true, "Gear Workshop");
    settings.Add("tappers_shack",               true, "Tapper''s Shack");
    settings.Add("observatory",                 true, "Observatory");
    settings.Add("smelter_woodworkshop",        true, "Smelter + Wood Workshop");
    settings.Add("research_earth_recultivator", true, "Research Earth Recultivator");
    settings.Add("earth_recultivator",          true, "Earth Recultivator (Launch)");

    vars.LogPath = System.IO.Path.Combine(
        System.Environment.GetFolderPath(System.Environment.SpecialFolder.Desktop),
        "asl_debug.log");
    System.IO.File.WriteAllText(vars.LogPath, "startup ran\n");

    vars.FilePath = System.IO.Path.GetFullPath(System.IO.Path.Combine(
        System.Environment.GetFolderPath(System.Environment.SpecialFolder.LocalApplicationData),
        "..", "LocalLow", "Mechanistry", "Timberborn", "autosplitter_state.json"));

    vars.GameId      = "";
    vars.PrevGameId  = "";
    vars.Buildings     = new System.Collections.Generic.HashSet<string>();
    vars.PrevBuildings = new System.Collections.Generic.HashSet<string>();
    vars.EarthRecultivatorResearched = false;
    vars.PrevEarthRecultivatorResearched = false;
    vars.WonderActivated = false;
    vars.PrevWonderActivated = false;
    vars.LastGameId  = "";
    vars.Fired       = new System.Collections.Generic.HashSet<string>();
    vars.ModMissing  = false;

    vars.ForesterTemplates = new System.Collections.Generic.HashSet<string> {
        "Forester.Folktails", "Forester.IronTeeth"
    };
    vars.GearWorkshopTemplates = new System.Collections.Generic.HashSet<string> {
        "GearWorkshop.Folktails", "GearWorkshop.IronTeeth"
    };
    vars.TappersShackTemplates = new System.Collections.Generic.HashSet<string> {
        "TappersShack.Folktails", "TappersShack.IronTeeth"
    };
    vars.ObservatoryTemplates = new System.Collections.Generic.HashSet<string> {
        "Observatory.Folktails"
    };
    vars.SmelterTemplates = new System.Collections.Generic.HashSet<string> {
        "Smelter.Folktails", "Smelter.IronTeeth"
    };
    vars.WoodWorkshopTemplates = new System.Collections.Generic.HashSet<string> {
        "WoodWorkshop.Folktails", "WoodWorkshop.IronTeeth"
    };
}

update {
    vars.PrevGameId                      = vars.GameId;
    vars.PrevBuildings                   = vars.Buildings;
    vars.PrevEarthRecultivatorResearched = vars.EarthRecultivatorResearched;
    vars.PrevWonderActivated             = vars.WonderActivated;

    if (!System.IO.File.Exists(vars.FilePath)) {
        if (!vars.ModMissing) {
            var procs = System.Diagnostics.Process.GetProcessesByName("Timberborn");
            if (procs.Length > 0) {
                vars.ModMissing = true;
                System.Windows.Forms.MessageBox.Show(
                    "Timberborn is running but the autosplitter mod is not installed.\n\n" +
                    "Install \"Autosplitter State Export\" from Thunderstore (or via r2modman) and restart the game.",
                    "Timberborn Autosplitter — Mod Missing",
                    System.Windows.Forms.MessageBoxButtons.OK,
                    System.Windows.Forms.MessageBoxIcon.Warning);
            }
        }
        return;
    }
    vars.ModMissing = false;

    try {
        var text = System.IO.File.ReadAllText(vars.FilePath);

        int s, e;

        s = text.IndexOf("gameId") + 9;
        e = text.IndexOf("\"", s);
        vars.GameId = text.Substring(s, e - s);

        s = text.IndexOf("finishedBuildings") + 20;
        e = text.IndexOf("]", s);
        var arrText = text.Substring(s, e - s);
        var buildings = new System.Collections.Generic.HashSet<string>();
        foreach (var item in arrText.Split(',')) {
            var t = item.Trim().Trim('"');
            if (t.Length > 0) buildings.Add(t);
        }
        vars.Buildings = buildings;

        s = text.IndexOf("earthRecultivatorResearched") + 29;
        vars.EarthRecultivatorResearched = (s >= 29 && s < text.Length && text[s] == 't');

        s = text.IndexOf("wonderActivated") + 17;
        vars.WonderActivated = (s >= 17 && s < text.Length && text[s] == 't');

        if (vars.GameId != vars.PrevGameId)
            System.IO.File.AppendAllText(vars.LogPath, "gameId=" + vars.GameId + " buildings=" + vars.Buildings.Count + "\n");

    } catch (System.Exception ex) {
        System.IO.File.AppendAllText(vars.LogPath, "error: " + ex.Message + "\n");
    }
}

start {
    if (vars.GameId != "" && vars.GameId != vars.LastGameId) {
        vars.LastGameId = vars.GameId;
        vars.Fired.Clear();
        System.IO.File.AppendAllText(vars.LogPath, "START gameId=" + vars.GameId + "\n");
        return true;
    }
    return false;
}

reset {
    return false;
}

split {
    if (settings["forester"] && !vars.Fired.Contains("forester")
            && !vars.PrevBuildings.Overlaps(vars.ForesterTemplates)
            && vars.Buildings.Overlaps(vars.ForesterTemplates)) {
        vars.Fired.Add("forester");
        System.IO.File.AppendAllText(vars.LogPath, "SPLIT forester\n");
        return true;
    }
    if (settings["gear_workshop"] && !vars.Fired.Contains("gear_workshop")
            && !vars.PrevBuildings.Overlaps(vars.GearWorkshopTemplates)
            && vars.Buildings.Overlaps(vars.GearWorkshopTemplates)) {
        vars.Fired.Add("gear_workshop");
        System.IO.File.AppendAllText(vars.LogPath, "SPLIT gear_workshop\n");
        return true;
    }
    if (settings["tappers_shack"] && !vars.Fired.Contains("tappers_shack")
            && !vars.PrevBuildings.Overlaps(vars.TappersShackTemplates)
            && vars.Buildings.Overlaps(vars.TappersShackTemplates)) {
        vars.Fired.Add("tappers_shack");
        System.IO.File.AppendAllText(vars.LogPath, "SPLIT tappers_shack\n");
        return true;
    }
    if (settings["observatory"] && !vars.Fired.Contains("observatory")
            && !vars.PrevBuildings.Overlaps(vars.ObservatoryTemplates)
            && vars.Buildings.Overlaps(vars.ObservatoryTemplates)) {
        vars.Fired.Add("observatory");
        System.IO.File.AppendAllText(vars.LogPath, "SPLIT observatory\n");
        return true;
    }
    if (settings["smelter_woodworkshop"] && !vars.Fired.Contains("smelter_woodworkshop")) {
        bool prevHasBoth = vars.PrevBuildings.Overlaps(vars.SmelterTemplates) && vars.PrevBuildings.Overlaps(vars.WoodWorkshopTemplates);
        bool currHasBoth = vars.Buildings.Overlaps(vars.SmelterTemplates) && vars.Buildings.Overlaps(vars.WoodWorkshopTemplates);
        if (!prevHasBoth && currHasBoth) {
            vars.Fired.Add("smelter_woodworkshop");
            System.IO.File.AppendAllText(vars.LogPath, "SPLIT smelter_woodworkshop\n");
            return true;
        }
    }
    if (settings["research_earth_recultivator"] && !vars.Fired.Contains("research_earth_recultivator")
            && !vars.PrevEarthRecultivatorResearched && vars.EarthRecultivatorResearched) {
        vars.Fired.Add("research_earth_recultivator");
        System.IO.File.AppendAllText(vars.LogPath, "SPLIT research_earth_recultivator\n");
        return true;
    }
    if (settings["earth_recultivator"] && !vars.Fired.Contains("earth_recultivator")
            && !vars.PrevWonderActivated && vars.WonderActivated) {
        vars.Fired.Add("earth_recultivator");
        System.IO.File.AppendAllText(vars.LogPath, "SPLIT earth_recultivator (launch)\n");
        return true;
    }
    return false;
}