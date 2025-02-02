//
//  BookRowView.swift
//  BookTracker
//
//  Created by Jamorn Suttipong on 27/1/2568 BE.
//

import SwiftUI

struct BookRowView: View {
    
    @ObservedObject var viewModel: BookTrackerViewModel
    
    @State private var offsets: CGFloat = 0
    @State private var showImagePicker: Bool = false
    
    let book: Book
    
    var body: some View {
        ZStack {
            //deleted button
            HStack {
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.deletedBook(book: book)
                    }
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color("color6"))
                        .frame(width: 100)
                        .frame(maxHeight: .infinity)
                        .background(Color("color3"))
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
            }
            
            HStack {
                //choose image
                Button(action: {
                    showImagePicker = true
                }) {
                    ZStack(alignment: .topTrailing) {
                        if let image = book.image, let uiImage = UIImage(data: image) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                            
                            Button {
                                viewModel.removeBookImage(book: book)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color("color3"))
                            }
                            .offset(x: 13, y: -13)
                            
                        } else {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .foregroundStyle(Color("color1"))
                        }
                    }
                }
                .sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: $viewModel.image)
                        .onDisappear {
                            if let selectedImage = viewModel.image {
                                viewModel.updateBookImage(book: book, image: selectedImage)
                            }
                        }
                }
                
                VStack(alignment: .leading) {
                    Text(book.title ?? "Unknow Title")
                        .font(.title)
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(book.author ?? "Unknow Author")
                            Text("Status: \(book.status ?? "No Status")")
                            Text(viewModel.formattedDate(from: book.date))
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.updateBookStatus(book: book)
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.forward.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 36)
                                .foregroundStyle(Color("color2"))
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(Color("color1"))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .background(Color("color5"))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            
            //slide to deleted
            .offset(x: offsets)
            .gesture(
                DragGesture()
                    .onChanged {gesture in
                        if gesture.translation.width < 0 {
                            offsets = max(gesture.translation.width, -100)
                        } else if gesture.translation.width > 10 {
                            offsets = 0
                        }
                    }
                    .onEnded {_ in
                        if offsets < -50 {
                            offsets = -100
                        } else {
                            withAnimation {
                                offsets = 0
                            }
                        }
                    }
            )
        }
        .animation(.spring(), value: offsets)
    }
}

#Preview {
    BookRowView(viewModel: BookTrackerViewModel(context: PersistenceController.shared.container.viewContext), book: .bookPreview)
}

extension Book {
    static var bookPreview: Book {
        let context = PersistenceController.preview.container.viewContext
        let book = Book(context: context)
        book.title = "Sample Title"
        book.author = "Sample Autor"
        book.status = BookStatusModel.unread.rawValue
        book.date = Date()
        
        return book
    }
}
