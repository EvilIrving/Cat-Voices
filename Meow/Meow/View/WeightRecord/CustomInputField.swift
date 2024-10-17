import SwiftUI

struct CustomInputField<T>: View where T: Numeric {
    let label: String
    let placeholder: String
    let suffix: String
    @Binding var value: T?
    var formatter: NumberFormatter
    
    init(
        label: String,
        placeholder: String,
        suffix: String,
        value: Binding<T?>,
        formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            // 允许空值
//            formatter.hasThousandSeparators = false
            return formatter
        }()
    ) {
        self.label = label
        self.placeholder = placeholder
        self.suffix = suffix
        self._value = value
        self.formatter = formatter
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // 左侧标签
            Text(label)
                .frame(width: 60, alignment: .leading)
            
            // 输入框区域
            HStack(spacing: 8) {
                // 使用中间变量处理可选值的转换
                let binding = Binding<String>(
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
                
                TextField(placeholder, text: binding)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity)
                
                // 后缀单位
                Text(suffix)
                    .foregroundColor(.secondary)
            }
        }
    }
}
