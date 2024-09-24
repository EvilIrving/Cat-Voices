# Cat-Voices

音频剪辑逻辑

1. EditView.swift 页面获取 audio 音频文件

    ```swift
    EditView(audioFile: binding(for: audioFile))
    ```

2. 创建副本 audioFile Comform to AudioFile , 副本文件名为原始文件名_副本, 副本文件位于原始文件文件夹下.
4. 拖拽左侧滑块, 调整 start 值,  拖拽右侧滑块,调整 end 值.
5. 点击播放按钮,播放副本文件,播放 start 到 end 区间的音频.
6. 点击保存按钮,保存副本文件,保存 start 到 end 区间的音频到原始文件文件夹下, 删除原始文件.
7. 将副本文件 链接到 原始资源文件中.
