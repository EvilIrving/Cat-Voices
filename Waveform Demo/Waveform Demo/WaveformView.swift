import SwiftUI

struct WaveformView: View {
    let samples: [Float]
    let progress: Double  // 当前播放进度（0.0 到 1.0）
    let barSpacing: CGFloat = 5

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                HStack(spacing: barSpacing) {
                    if samples.isEmpty {
                        Text("加载中...")
                            .foregroundColor(.white)
                    } else {
                        ForEach(0..<samples.count, id: \.self) { index in
                            WaveformBar(
                                height: geometry.size.height
                                    * normalizedHeight(for: samples[index]),
                                fillPercentage: fillPercentage(
                                    for: index, progress: progress)
                            )
                            .frame(
                                width: (geometry.size.width * 0.6 - CGFloat(
                                    samples.count - 1) * barSpacing)
                                    / CGFloat(samples.count))  // 设置波形条宽度
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }

    private func normalizedHeight(for sample: Float) -> CGFloat {  // 将样本值标准化到0-1范围
        let maxSample = samples.max() ?? 1.0  // 获取最大样本值，如果为nil则使用1.0
        return CGFloat(sample / maxSample)  // 返回标准化后的高度
    }

    private func fillPercentage(for index: Int, progress: Double) -> Double {
        let pointProgress = progress * Double(samples.count)  // 将进度转换为样本索引
        let difference = pointProgress - Double(index)  // 计算当前进度与波形条索引的差值
        return min(max(difference, 0), 1)  // 将结果限制在0到1之间
    }
}

struct WaveformBar: View {
    let height: CGFloat
    let fillPercentage: Double
    let cornerRadius: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray)

                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * CGFloat(fillPercentage))
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .frame(height: height)
            .frame(maxHeight: geometry.size.height, alignment: .center)
        }
    }
}
