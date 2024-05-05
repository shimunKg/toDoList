//
//  ToDoAppTests.swift
//  ToDoAppTests
//
//  Created by Nikola Jovanovic Simunic on 9.3.24..
//

import XCTest
import SwiftUI
@testable import ToDoApp

final class ToDoAppTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_create_new_note_should_be_success() async {
        // Given
        let sut = createSUT()
        let note = Note(title: "test", description: "test desc", id: UUID())
        sut.activeNote = note
        // When
        await sut.addNew(note: note)
        // Then
        XCTAssertEqual(sut.allNotes.last?.title, note.title)
    }
    
    func test_create_new_note_should_fail_with_empty_description() async {
        // Given
        let sut = createSUT()
        let note = Note(title: "test", description: "", id: UUID())
        sut.activeNote = note
        // When
        await sut.addNew(note: note)
        // Then
        XCTAssertEqual(sut.error, AppError.noteError(.emptyDescription))
    }
    
    private func createSUT() -> ToDoListViewModel {
        ToDoListViewModel(
            addNoteUseCase: AddNoteUseCaseTest(),
            fetchAllUseCase: FetchAllNotesUseCaseTest()
        )
    }
}

struct AddNoteUseCaseTest: AddNoteUseCase {
    func addNote(note: Note) async throws {
        print("\(note) should be added to userDefaults!!!")
    }
}

struct FetchAllNotesUseCaseTest: FetchAllNotesUseCase {
    func fetchNotes() async throws -> [Note] {
        [Note(title: "test", description: "desc test", id: UUID())]
    }
}
