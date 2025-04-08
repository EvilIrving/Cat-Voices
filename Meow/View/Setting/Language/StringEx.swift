import Foundation

// extension String {
//     func localized(using languageCode: String) -> String {
//         guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
//               let bundle = Bundle(path: path) else {
//             return self.localized()
//         }
//         return self.localized(bundle: bundle)
//     }
    
//     private func localized(bundle: Bundle) -> String {
//         return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
//     }
// }

// extension String {
//     private func localized() -> String {
//         return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//     }
// }


// youtube  

extension String {
    func localised(using languageCode: String) -> String {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, comment: "")
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}