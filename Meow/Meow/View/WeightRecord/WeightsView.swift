import SwiftData
import SwiftUI

struct WeightsView: View {
    @StateObject private var languageManager = LanguageManager.shared

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
            .navigationTitle("Weight Record".localised(using: languageManager.selectedLanguage)).toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isPresentingNewWeightView = true }) {
                        Label("Add Weight Record".localised(using: languageManager.selectedLanguage), systemImage: "plus")
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
    @StateObject private var languageManager = LanguageManager.shared
    let weight: Weight
    let weightUnit: String
    let onEdit: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(String(format: "Weight: %@ %@".localised(using: languageManager.selectedLanguage), weight.formattedWeightInKg, weightUnit))
            HStack {
                // TODO: 日期本地化
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
