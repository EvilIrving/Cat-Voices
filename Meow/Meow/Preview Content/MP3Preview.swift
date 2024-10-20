import Foundation
import SwiftData
import SwiftUI

@MainActor
struct MP3Preview {
    let container: ModelContainer
    let cats: [Cat]
    let audios: [Audio]  // 音频数组

    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(
            for: Cat.self, Audio.self, configurations: config)

        // 创建示例猫咪
        let cat = Cat(
            name: "攀岩咪", breed: .americanShorthair, birthDate: Date(),
            adoptionDate: Date(), gender: .female, neuteringStatus: .neutered,
            currentStatus: .present)

        // 保存猫咪到容器中
        container.mainContext.insert(cat)

        var tempAudios: [Audio] = []

        // 创建示例音频
        //        let audioFiles = ["numbers_01", "numbers_02", "numbers_03"]
        let audioFiles = ["numbers_3s_01", "numbers_3s_02", "numbers_3s_03"]
        let audioNames = ["01 很高兴的声音.mp3", "02 生气的声音.mp3", "03 撒娇的声音.mp3"]

        for (index, fileName) in audioFiles.enumerated() {
            if let audioFileURL = Bundle.main.url(
                forResource: fileName, withExtension: "mp3")
            {
                let audio = Audio(url: audioFileURL, name: audioNames[index])
                cat.addAudio(audio)  // 使用 Cat 的 addAudio 方法添加音频
                tempAudios.append(audio)
                container.mainContext.insert(audio)

                // 异步更新音频时长和波形
                Task {
                    await audio.updateDuration()
                    await audio.generateWaves()
                }
            } else {
                print("无法找到音频文件：\(fileName).mp3")
                // 创建一个虚拟的音频对象
                let dummyAudio = Audio(
                    url: URL(string: "dummy://\(fileName).mp3")!,
                    name: "虚拟音频 \(index + 1)")
                cat.addAudio(dummyAudio)  // 使用 Cat 的 addAudio 方法添加音频
                tempAudios.append(dummyAudio)
                container.mainContext.insert(dummyAudio)
            }
        }

        // 设置属性
        self.cats = [cat]
        self.audios = tempAudios
    }
}
