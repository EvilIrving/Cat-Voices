//
//  utils.swift
//  audiodemo
//
//  Created by Actor on 2024/9/23.
//

import Foundation


enum FileCopyError: Error {
    case fileDoesNotExist
    case fileExistsAndOverwriteDisabled
    case copyFailed(Error)
}

func copyFile(from sourceURL: URL, withOverwrite overwrite: Bool = false) throws -> (String,URL){
    let fileManager = FileManager.default
    
    do {
        // 检查源文件是否存在
        guard fileManager.fileExists(atPath: sourceURL.path) else {
            throw FileCopyError.fileDoesNotExist
        }
        
        // 创建目标文件 URL，文件名后添加“副本”
        let destinationFolderURL = sourceURL.deletingLastPathComponent()
        let destinationFileName = "副本\(sourceURL.lastPathComponent)"
        let destinationURL = destinationFolderURL.appendingPathComponent(destinationFileName)
         
        // 尝试复制文件
        try fileManager.copyItem(at: sourceURL, to: destinationURL)
        return (destinationFileName , destinationURL)
    } catch {
        throw FileCopyError.copyFailed(error)
    }
}
