using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Timberborn.BlockSystem;
using Timberborn.Common;
using Timberborn.GameDistricts;
using Timberborn.GameFactionSystem;
using Timberborn.GameWonderCompletion;
using Timberborn.InventorySystem;
using Timberborn.Population;
using Timberborn.ScienceSystem;
using Timberborn.SingletonSystem;
using Timberborn.TemplateSystem;
using Timberborn.TimeSystem;
using Timberborn.Wonders;
using UnityEngine;

namespace Autosplitter {
    public class AutosplitterService : ILoadableSingleton, IUpdatableSingleton {
        private static readonly string StateFilePath = Path.GetFullPath(Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
            "..", "LocalLow", "Mechanistry", "Timberborn", "autosplitter_state.json"));

        private const float WriteInterval = 0.5f;

        private readonly EventBus _eventBus;
        private readonly DistrictCenterRegistry _districtCenterRegistry;
        private readonly PopulationService _populationService;
        private readonly IDayNightCycle _dayNightCycle;
        private readonly MapNameService _mapNameService;
        private readonly FactionService _factionService;

        private readonly HashSet<string> _finishedBuildings = new();
        private float _writeTimer;
        private string _gameId = "";
        private bool _earthRecultivatorResearched = false;
        private bool _wonderActivated = false;

        public AutosplitterService(
            EventBus eventBus,
            DistrictCenterRegistry districtCenterRegistry,
            PopulationService populationService,
            IDayNightCycle dayNightCycle,
            MapNameService mapNameService,
            FactionService factionService) {
            _eventBus = eventBus;
            _districtCenterRegistry = districtCenterRegistry;
            _populationService = populationService;
            _dayNightCycle = dayNightCycle;
            _mapNameService = mapNameService;
            _factionService = factionService;
        }

        public void Load() {
            _eventBus.Register(this);
        }

        [OnEvent]
        public void OnNewGame(NewGameInitializedEvent e) {
            _gameId = Guid.NewGuid().ToString("N")[..8];
            _finishedBuildings.Clear();
            _earthRecultivatorResearched = false;
            _wonderActivated = false;
            WriteState();
        }

        [OnEvent]
        public void OnBuildingFinished(EnteredFinishedStateEvent e) {
            var templateSpec = e.BlockObject.GetComponent<TemplateSpec>();
            if (templateSpec != null)
                _finishedBuildings.Add(templateSpec.TemplateName);
            WriteState();
        }

        [OnEvent]
        public void OnBuildingDemolished(ExitedFinishedStateEvent e) {
            var templateSpec = e.BlockObject.GetComponent<TemplateSpec>();
            if (templateSpec != null)
                _finishedBuildings.Remove(templateSpec.TemplateName);
            WriteState();
        }

        [OnEvent]
        public void OnBuildingUnlocked(BuildingUnlockedEvent e) {
            try {
                if (e.BuildingSpec?.Blueprint?.Name == "EarthRecultivator.Folktails")
                    _earthRecultivatorResearched = true;
            } catch { }
            WriteState();
        }

        [OnEvent]
        public void OnWonderActivated(WonderActivatedEvent e) {
            _wonderActivated = true;
            WriteState();
        }

        public void UpdateSingleton() {
            _writeTimer -= Time.deltaTime;
            if (_writeTimer > 0f) return;
            _writeTimer = WriteInterval;
            WriteState();
        }

        private (int logs, string debug) CountLogs() {
            int total = 0;
            var districts = _districtCenterRegistry.FinishedDistrictCenters;
            int nullRegistries = 0;
            int totalInventories = 0;
            foreach (var district in districts) {
                var registry = district.GetComponent<DistrictInventoryRegistry>();
                if (registry == null) { nullRegistries++; continue; }
                var withStock = registry.ActiveInventoriesWithStock("Log");
                totalInventories += withStock.Count;
                foreach (var inv in withStock)
                    total += inv.AmountInStock("Log");
            }
            string debug = $"districts:{districts.Count} nullRegistries:{nullRegistries} invWithLogs:{totalInventories}";
            return (total, debug);
        }

        private void WriteState() {
            try {
                var pop = _populationService.GlobalPopulationData;
                var (logs, logDebug) = CountLogs();
                var sb = new StringBuilder();
                sb.Append('{');
                sb.Append($"\"mapName\":\"{Escape(_mapNameService.Name)}\",");
                sb.Append($"\"faction\":\"{Escape(_factionService.Current.Id)}\",");
                sb.Append($"\"day\":{_dayNightCycle.DayNumber},");
                sb.Append($"\"logs\":{logs},");
                sb.Append($"\"adults\":{pop.NumberOfAdults},");
                sb.Append($"\"children\":{pop.NumberOfChildren},");
                sb.Append("\"finishedBuildings\":[");
                sb.Append(string.Join(",", _finishedBuildings.Select(b => $"\"{Escape(b)}\"")));
                sb.Append("],");
                sb.Append($"\"earthRecultivatorResearched\":{(_earthRecultivatorResearched ? "true" : "false")},");
                sb.Append($"\"wonderActivated\":{(_wonderActivated ? "true" : "false")},");
                sb.Append($"\"gameId\":\"{_gameId}\",");
                sb.Append($"\"_debug\":\"{Escape(logDebug)}\"");
                sb.Append('}');
                File.WriteAllText(StateFilePath, sb.ToString());
            } catch {
                // never crash the game
            }
        }

        private static string Escape(string? s) =>
            (s ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"");
    }
}
