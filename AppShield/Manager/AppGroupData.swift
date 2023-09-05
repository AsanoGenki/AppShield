import Foundation
import ManagedSettings
import FamilyControls
import UIKit
import DeviceActivity
import SQLite3

struct AppGroupData {
    static func save(_ value: Encodable, key:String) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(value) {
            let str = String(data: data, encoding: .utf8)!
            UserDefaults.standard.setValue(str, forKey: key)
        }
    }
    static func find<T: Decodable>(_ type: T.Type, key:String) -> T? {
        if let applicationToken = UserDefaults.standard.value(forKey: key) as? String {
            let jsonData = applicationToken.data(using: .utf8)
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(type, from: jsonData!) {
                return result
            }
        }
        return nil
    }
}
