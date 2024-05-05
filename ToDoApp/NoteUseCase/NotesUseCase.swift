//
//  NotesUseCase.swift
//  ToDoApp
//
//  Created by Nikola Jovanovic Simunic on 10.3.24..
//

import Foundation
import SwiftUI

protocol FetchAllNotesUseCase {
    func fetchNotes() async throws -> [Note]
}

protocol RemoveNoteUseCase {
    func removeNote() async throws
}

protocol EditNoteUseCase {
    func editNote() async throws
}

protocol AddNoteUseCase {
    func addNote(note: Note) async throws
}

