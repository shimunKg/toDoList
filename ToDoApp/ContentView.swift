//
//  ContentView.swift
//  ToDoApp
//
//  Created by Nikola Jovanovic Simunic on 9.3.24..
//

import SwiftUI

struct ContentView: View {
    
    @State private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    @State private var offset: CGPoint = CGPoint()
    @StateObject private var viewModel = ToDoListViewModel(
        addNoteUseCase: AddNoteUseCaseUserDefaults(),
        fetchAllUseCase: FetchAllNotesUseCaseUserDefaults()
    )
    
    var body: some View {
        ZStack {
            OffsetObservingScrollView(offset: $offset) {
                Button("Add new") {
                    viewModel.isAddNewSheetActive = true
                }
                Text(viewModel.activeNote.title)
                VStack {
                    ForEach(viewModel.allNotes, id: \.id) { note in
                        Text(note.title)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .task {
                await viewModel.fetchAll()
            }
            .sheet(isPresented: $viewModel.isAddNewSheetActive,
                   content: {
                Text(viewModel.error?.errorDescription ?? "")
                AddNewNoteView(
                    titleText: $viewModel.activeNote.title,
                    descriptionText: $viewModel.activeNote.description,
                    onAddTapped: {
                        Task {
                            await viewModel.addNew(
                                note: viewModel.activeNote
                            )
                        }
                    }
                )
                .presentationDetents([.medium, .fraction(0.33)])
                .presentationDragIndicator(.visible)
            })
            
            Circle()
                .overlay {
                    Text(String(Int(offset.y)))
                        .font(.system(size: 13))
                        .foregroundStyle(Color.white)
                }
                .frame(width: max(30, 70 + CGFloat(Int(offset.y))))
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottomTrailing
                )
                .padding(.trailing, 25)
                .offset(
                    x: position.width + dragOffset.width,
                    y: position.height + dragOffset.height
                )
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            position.width += value.translation.width
                            position.height += value.translation.height
                            dragOffset = .zero
                        }
                )
        }
        .background(Color.red)
        .onTapGesture {
            print("test")
        }
    }
}

#Preview {
    ContentView()
}
