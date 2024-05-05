//
//  ContentView.swift
//  ToDoApp
//
//  Created by Nikola Jovanovic Simunic on 9.3.24..
//

import SwiftUI

private extension PositionObservingView {
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }
        
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            // No-op
        }
    }
}

struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
            })
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
}

struct OffsetObservingScrollView<Content: View>: View {
    var axes: Axis.Set = [.vertical]
    var showsIndicators = true
    @Binding var offset: CGPoint
    @ViewBuilder var content: () -> Content
    
    private let coordinateSpaceName = UUID()
    
    var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            PositionObservingView(
                coordinateSpace: .named(coordinateSpaceName),
                position: Binding(
                    get: { offset },
                    set: { newOffset in
                        offset = CGPoint(
                            x: -newOffset.x,
                            y: -newOffset.y
                        )
                    }
                ),
                content: content
            )
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}

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
                Text(viewModel.newNote.title)
                VStack {
                    ForEach(viewModel.notes, id: \.id) { note in
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
                    titleText: $viewModel.newNote.title,
                    descriptionText: $viewModel.newNote.description,
                    onAddTapped: {
                        Task {
                            await viewModel.addNew(
                                note: viewModel.newNote
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(.trailing, 25)
                .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height) // Apply the combined offset
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            position.width += value.translation.width
                            position.height += value.translation.height
                            dragOffset = .zero // Reset the drag offset
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
