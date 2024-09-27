import SwiftUI
struct AboutView: View {
    @Environment(\.dismiss) var dismiss // 获取 dismiss 环境变量
    
    var body: some View {
        NavigationView{
            VStack {
                Text("App介绍").font(.title).padding()
                Text("这是一款帮助你记录猫咪声音的应用。").padding()
                Text("开发者介绍").font(.title).padding()
                Text("开发者是一名热爱编程和猫咪的工程师。").padding()
                
                
                Spacer()
            }
            .padding()
            .navigationTitle(Text("关于我们").font(.headline)) // 设置标题大小
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("取消") {
                dismiss()
            }.font(.headline)) // 设置取消按钮字体大小
        }
        
    }
}
