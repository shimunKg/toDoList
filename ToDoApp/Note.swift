//
//  Note.swift
//  ToDoApp
//
//  Created by Nikola Jovanovic Simunic on 9.3.24..
//

import Foundation

struct Note {
    var title: String
    var description: String
    let id: UUID
    
    func toNoteModel() -> NoteModel {
        NoteModel(title: title, description: description, id: id)
    }
    
    static var empty: Note = Note(title: "", description: "", id: UUID())
}

struct NoteModel: Codable, Identifiable {
    let title: String
    let description: String
    let id: UUID
    
    func toDomainModel() -> Note {
        Note(title: title, description: description, id: id)
    }
}
