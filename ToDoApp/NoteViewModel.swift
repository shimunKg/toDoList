//
//  NoteViewModel.swift
//  ToDoApp
//
//  Created by Nikola Jovanovic Simunic on 20.3.24..
//

import SwiftUI

final class ToDoListViewModel: ObservableObject {
    
    @Published var isAddNewSheetActive = false
    @Published var newNote = Note.empty
    @Published private(set) var notes: [Note] = []
    @Published private(set) var error: AppError?
    // this is handling only the errors that are occuring during the adding the note
//    @Published private(set) var addNoteError: NoteError?
    private var addNoteUseCase: AddNoteUseCase
    private var fetchAllUseCase: FetchAllNotesUseCase
    
    init(
        addNoteUseCase: AddNoteUseCase,
        fetchAllUseCase: FetchAllNotesUseCase
    ) {
        self.addNoteUseCase = addNoteUseCase
        self.fetchAllUseCase = fetchAllUseCase
    }
    
    @MainActor
    func fetchAll() async {
        do {
            notes = try await fetchAllUseCase.fetchNotes()
        } catch let error as NoteError {
            self.error = .noteError(error)
        } catch {
            self.error = .other(error)
        }
    }
    
    private func validateNote(note: Note) async throws {
        if note.title.isEmpty {
            throw NoteError.emptyTitle
        } else if note.description.isEmpty {
            throw NoteError.emptyDescription
        }
    }
    
    private func resetNote() {
        newNote = Note.empty
        isAddNewSheetActive = false
        error = nil
    }
    
    @MainActor
    func addNew(note: Note) async {
        do {
            try await validateNote(note: note)
            try await addNoteUseCase.addNote(note: note)
            await fetchAll()
            resetNote()
        } catch let error as NoteError {
            self.error = AppError.noteError(error)
        } catch {
            self.error = .other(error)
        }
    }
}
