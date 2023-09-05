import Foundation

class LaunchManager: ObservableObject {
    static let shared = LaunchManager()
    
    @Published var updateAuthority: Bool = false
    @Published var isAuthority: Bool = true
    @Published var showAuthority: Bool = false
}
