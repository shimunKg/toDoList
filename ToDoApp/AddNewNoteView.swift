//
//  AddNewNoteView.swift
//  ToDoApp
//
//  Created by Nikola Jovanovic Simunic on 11.3.24..
//

import SwiftUI

struct AddNewNoteView: View {
    
    @Binding var titleText: String
    @Binding var descriptionText: String
    var onAddTapped: () -> Void
    
    var body: some View {
        VStack {
            TextField("Enter title here", text: $titleText)
            TextField("Enter description here", text: $descriptionText)
            Button("Add the note") {
                onAddTapped()
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    AddNewNoteView(titleText: .constant(""), descriptionText: .constant("")) {
        print("tapped on add!")
    }
}
