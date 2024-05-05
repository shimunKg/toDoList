//
//  Errors.swift
//  ToDoApp
//
//  Created by Nikola Jovanovic Simunic on 20.3.24..
//

import Foundation

enum AppError: Error, LocalizedError {
    case noteError(NoteError)
    case other(Error)
    
    var errorDescription: String? {
        switch self {
        case .noteError(let noteError):
            return noteError.description
        case .other(let error):
            return error.localizedDescription
        }
    }
}

extension AppError: Equatable {
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case let (.noteError(left), .noteError(right)):
            return left == right
        case let (.other(left), .other(right)):
            return left.localizedDescription == right.localizedDescription
        default:
            return false
        }
    }
}


enum NoteError: Error {
    case emptyTitle
    case emptyDescription
    case noteFetchError
    case noteSaveError
    
    var description: String {
        switch self {
        case .emptyTitle:
            return "The title cannot be empty."
        case .emptyDescription:
            return "The description cannot be empty."
        case .noteFetchError:
            return "Failed to fetch notes!"
        case .noteSaveError:
            return "Failed to save note!"
        }
    }
}
