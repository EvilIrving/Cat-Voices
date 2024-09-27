//
//  Enum.swift
//  Voices
//
//  Created by Actor on 2024/9/24.
//

//定义的 Enum
import Foundation



enum FileCopyError: Error {
    case fileDoesNotExist
    case fileExistsAndOverwriteDisabled
    case copyFailed(Error)
}