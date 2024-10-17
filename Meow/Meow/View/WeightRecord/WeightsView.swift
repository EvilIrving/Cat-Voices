import SwiftData
import SwiftUI

struct WeightsView: View {
    @Query private var weights: [Weight]
    @AppStorage("weightUnit") private var weightUnit: String = "kg"
    @State private var isPresentingNewWeightView = false
    @State private var weightToEdit: Weight?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(weights) { weight in
                    WeightRowView(weight: weight, weightUnit: weightUnit, onEdit: {
                        weightToEdit = weight
                        isPresentingNewWeightView = true
                    })
                }
            }
            .navigationTitle("体重记录").toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresentingNewWeightView = true }) {
                        Label("添加体重记录", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewWeightView) {
                NewAndEditWeightView(weightToEdit: weightToEdit)
                    .onDisappear { weightToEdit = nil }
            }
        }
    }
}

struct WeightRowView: View {
    let weight: Weight
    let weightUnit: String
    let onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("体重: \(weight.formattedWeightInKg) \(weightUnit)")
            HStack {
                Text("\(weight.date, formatter: dateFormatter)")
                Spacer()
                Text(weight.cat.name)
                Spacer()
                Image(systemName: "square.and.pencil.circle")
                    .foregroundColor(.blue)
                    .font(.title)
                    .onTapGesture(perform: onEdit)
            }
        }
    }
}

// 日期格式化器
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()
