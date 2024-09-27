import Foundation
import SwiftUI

struct AddCatView: View {
    @Binding var cats: [Cat]
    @Binding var newCatName: String
    @Environment(
        \.dismiss
    ) var dismiss
    @State private var showErrorMessage = false // 控制错误信息的显示
    var body: some View {
        NavigationView {
            VStack {
                TextField(
                    "输入新的猫咪名字",
                    text: $newCatName
                )
                .padding()
                .textFieldStyle(
                    RoundedBorderTextFieldStyle()
                ).onChange(of: newCatName) {
                    // 当用户开始输入时，隐藏错误信息
                    if !newCatName.isEmpty {
                        showErrorMessage = false
                    }
                }
                
                if showErrorMessage {
                    Text(
                        "请输入新的猫咪名字"
                    )
                    .foregroundColor(
                        .red
                    )
                    .font(
                        .caption
                    )
                    .padding(
                        .top,
                        4
                    )
                }
                
                Spacer()
                
                Button(
                    "添加猫咪"
                ) {
                    if newCatName.isEmpty {
                       
                        showErrorMessage = true
                    } else {
                        let newCat = Cat(
                            name: newCatName,
                            sounds: [],
                            description: ""
                        )
                        cats.append(
                            newCat
                        )
                        newCatName = ""  
                        showErrorMessage = false  
                        dismiss()
                    }
                    
                }
                .padding()
                
            }
            .navigationTitle(
                Text(
                    "新增猫咪"
                ).font(
                    .headline
                )
            )  
            .navigationBarTitleDisplayMode(
                .inline
            )
            .navigationBarItems(leading: Button("取消") { 
                dismiss()
            }.font(.headline))  
        }
    }
}
