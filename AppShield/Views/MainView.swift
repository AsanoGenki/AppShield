import SwiftUI

struct MainView: View {
    @EnvironmentObject var launchManager : LaunchManager
    @State private var selection: Tab = .home
    @AppStorage("hour") var savehour = 0
    @AppStorage("minute") var saveminute = 0
    enum Tab {
        case home
        case timer
    }
    var body: some View {
        
        if (launchManager.showAuthority) {
            TabView(selection: $selection) {
                HomePage()
                    .environment(\.locale, Locale(identifier: "en_US"))
                    .tabItem{
                        if selection == .home{
                            Image(systemName: "shield.fill")
                                .environment(\.symbolVariants, .fill)
                            Text("Blocking")
                        } else {
                            Image(systemName: "shield")
                                .environment(\.symbolVariants, .none)
                            Text("Blocking")
                        }
                        
                    }
                    .tag(Tab.home)
                TimerView(stopwatch: Stopwatch(hours: savehour, minutes: saveminute))
                    .tabItem{
                        if selection == .timer{
                            Image(systemName: "bolt.fill")
                                .environment(\.symbolVariants, .fill)
                            Text("Strict Mode")
                        } else {
                            Image(systemName: "bolt")
                                .environment(\.symbolVariants, .none)
                            Text("Strict Mode")
                        }
                        
                    }
                    .tag(Tab.timer)

                    }

            }
    }
}

