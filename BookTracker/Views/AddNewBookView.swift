//
//  AddNewBookView.swift
//  BookTracker
//
//  Created by Jamorn Suttipong on 28/1/2568 BE.
//

import SwiftUI

struct AddNewBookView: View {
    
    @ObservedObject var viewModel: BookTrackerViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color("color2")
                .ignoresSafeArea()
            
            VStack {
                //title
                TextField("", text: $viewModel.title, prompt: Text("Title").foregroundStyle(Color("color6")))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(lineWidth: 1)
                    }
                
                //author
                TextField("", text: $viewModel.author, prompt: Text("Author").foregroundStyle(Color("color6")))
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(lineWidth: 1)
                    }
                
                Button {
                    viewModel.image = nil
                    viewModel.addBook(title: viewModel.title, author: viewModel.author, status: viewModel.status, date: Date(), image: viewModel.image)
                    viewModel.title = ""
                    viewModel.author = ""
                    dismiss()
                } label: {
                    Text("ADD BOOK")
                        .fontWeight(.semibold)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color("color4"))
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .padding(.vertical)
                }
            }
            .padding()
            .font(.title3)
            .foregroundStyle(Color("color6"))
        }
    }
}

#Preview {
    AddNewBookView(viewModel: BookTrackerViewModel(context: PersistenceController.shared.container.viewContext))
}
