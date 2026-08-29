using Bindito.Core;

namespace Autosplitter {
    [Context("Game")]
    public class AutosplitterConfigurator : Configurator {
        protected override void Configure() {
            Bind<AutosplitterService>().AsSingleton();
        }
    }
}
