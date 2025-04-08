import SwiftUI

struct CustomInputField<T: Numeric>: View {
    @StateObject private var languageManager = LanguageManager.shared

    let label: String
    let placeholder: String
    let suffix: String
    @Binding var value: T?
    let formatter: NumberFormatter
    
    init(
        label: String,
        placeholder: String,
        suffix: String,
        value: Binding<T?>,
        formatter: NumberFormatter = CustomInputField.defaultFormatter()
    ) {
        self.label = label
        self.placeholder = placeholder
        self.suffix = suffix
        self._value = value
        self.formatter = formatter
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text(label.localised(using: languageManager.selectedLanguage))
                .frame(width: 60, alignment: .leading)
            
            HStack(spacing: 8) {
                TextField(placeholder.localised(using: languageManager.selectedLanguage), text: formattedBinding)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity)
                
                Text(suffix)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var formattedBinding: Binding<String> {
        Binding<String>(
            get: {
                if let number = value {
                    return formatter.string(from: NSNumber(value: Double("\(number)")!)) ?? ""
                }
                return ""
            },
            set: { newValue in
                if let number = formatter.number(from: newValue) {
                    value = number.doubleValue as? T
                } else {
                    value = nil
                }
            }
        )
    }
    
    private static func defaultFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
}
