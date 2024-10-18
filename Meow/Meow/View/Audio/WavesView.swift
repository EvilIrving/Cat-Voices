import SwiftUI

struct WavesView: View {
    let waves: [Float]
    let progress: Double  // 当前播放进度（0.0 到 1.0）
    let barSpacing: CGFloat = 5

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: barSpacing) {
                    if waves.isEmpty {
                        Text("加载中...")
                            .foregroundColor(.white)
                    } else {
                        ForEach(0..<waves.count, id: \.self) { index in
                            WaveBar(
                                height: geometry.size.height
                                    * normalizedHeight(for: waves[index]),
                                fillPercentage: fillPercentage(
                                    for: index, progress: progress)
                            )
                            .frame(
                                width: (geometry.size.width * 0.6 - CGFloat(
                                    waves.count - 1) * barSpacing)
                                    / CGFloat(waves.count))  // 设置波形条宽度
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }

    private func normalizedHeight(for wave: Float) -> CGFloat {  // 将样本值标准化到0-1范围
        let maxSample = waves.max() ?? 1.0  // 获取最大样本值，如果为nil则使用1.0
        return CGFloat(wave / maxSample)  // 返回标准化后的高度
    }

    private func fillPercentage(for index: Int, progress: Double) -> Double {
        let pointProgress = progress * Double(waves.count)  // 将进度转换为样本索引
        let difference = pointProgress - Double(index)  // 计算当前进度与波形条索引的差值
        return min(max(difference, 0), 1)  // 将结果限制在0到1之间
    }
}

struct WaveBar: View {
    let height: CGFloat
    let fillPercentage: Double
    let cornerRadius: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.accentColor)

                Rectangle()
                    .fill(Color.black)
                    .frame(width: geometry.size.width * CGFloat(fillPercentage))
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .frame(height: height)
            .frame(maxHeight: geometry.size.height, alignment: .center)
        }
    }
}
