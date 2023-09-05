import ManagedSettings
import ManagedSettingsUI
import UIKit

fileprivate let imageName = "Shield"
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.

        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            icon: UIImage(named: imageName),
            title: ShieldConfiguration.Label(text: "Blocked by\nAppShield", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Dismiss", color: .white)
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return ShieldConfiguration(
            icon: UIImage(named: imageName),
            title: ShieldConfiguration.Label(text: "High Tide!! Bring your parents!!", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Dismiss", color: .black)
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}

