//
//  HomeView.swift
//  BookTracker
//
//  Created by Jamorn Suttipong on 27/1/2568 BE.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @ObservedObject var viewModel = BookTrackerViewModel(context: PersistenceController.shared.container.viewContext)
    
    @State private var showSheet: Bool = false
    @State private var statusSelection: BookStatusModel = .unread
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("color1")
                    .ignoresSafeArea()
                
                VStack(spacing: 5) {
                    HeaderView(statusSelection: $statusSelection)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 5) {
                            ForEach(viewModel.books.filter{ $0.status == statusSelection.rawValue}) {book in
                                BookRowView(viewModel: viewModel, book: book)
                            }
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32, height: 32)
                                .foregroundStyle(Color("color3"))
                                .padding()
                                .background(Color("color6"))
                                .clipShape(Circle())
                                .padding()
                        }
                        .sheet(isPresented: $showSheet) {
                            AddNewBookView(viewModel: viewModel)
                                .presentationDetents([.fraction(0.4)])
                                .presentationDragIndicator(.visible)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
