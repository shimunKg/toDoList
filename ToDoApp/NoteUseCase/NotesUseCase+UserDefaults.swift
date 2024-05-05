//
//  NotesUseCase+UserDefaults.swift
//  ToDoApp
//
//  Created by Nikola Jovanovic Simunic on 20.3.24..
//

import Foundation

struct FetchAllNotesUseCaseUserDefaults: FetchAllNotesUseCase {
    func fetchNotes() async throws -> [Note] {
        let notesData = UserDefaults.standard.data(forKey: "notes") ?? Data()
        do {
            let decoded = try JSONDecoder().decode([NoteModel].self, from: notesData)
            return decoded.map { $0.toDomainModel() }
        } catch {
            throw AppError.noteError(.noteFetchError)
        }
    }
}

struct AddNoteUseCaseUserDefaults: AddNoteUseCase {
    func addNote(note: Note) async throws {
        let notesData = UserDefaults.standard.data(forKey: "notes") ?? Data()
        var notes = (try? JSONDecoder().decode([NoteModel].self, from: notesData)) ?? []
        notes.append(note.toNoteModel())
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
}
