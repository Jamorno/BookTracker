//
//  BookTrackerViewModel.swift
//  BookTracker
//
//  Created by Jamorn Suttipong on 27/1/2568 BE.
//

import Foundation
import CoreData
import SwiftUI

class BookTrackerViewModel: ObservableObject {
    
    @Published var books: [Book] = []
    
    //for add new book
    @Published var title: String = ""
    @Published var author: String = ""
    @Published var date: Date = Date()
    
    //for book image
    @Published var image: UIImage?
    
    //for book status
    @Published var status: BookStatusModel = .unread
    
    //for date
    private var dateFormattter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        return formatter
    }
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchBook()
    }
    
    func fetchBook() {
        let request: NSFetchRequest<Book> = Book.fetchRequest()
        
        do {
            books = try viewContext.fetch(request)
        } catch {
            print("DEBUG: Error fetching book \(error.localizedDescription)")
        }
    }
    
    func addBook(title: String, author: String, status: BookStatusModel, date: Date, image: UIImage?) {
        let newBook = Book(context: viewContext)
        newBook.title = title
        newBook.author = author
        newBook.status = status.rawValue
        newBook.date = date
        
        //for image -> convert UIImage to data
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            newBook.image = imageData
        }
        
        saveContext()
        fetchBook()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
            fetchBook()
        } catch {
            print("DEBUG: Cannot to save context \(error.localizedDescription)")
        }
    }
    
    func deletedBook(book: Book) {
        viewContext.delete(book)
        saveContext()
        fetchBook()
    }
    
    func updateBookStatus(book: Book) {
        guard let currentStatus = BookStatusModel(rawValue: book.status ?? "") else {
            return
        }
        
        switch currentStatus {
        case .unread:
            book.status = BookStatusModel.reading.rawValue
        case .reading:
            book.status = BookStatusModel.read.rawValue
        case .read:
            return
        }
        
        saveContext()
        fetchBook()
    }
    
    func updateBookImage(book: Book, image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            book.image = imageData
        }
        
        saveContext()
        fetchBook()
    }
    
    func removeBookImage(book: Book) {
        book.image = nil
        saveContext()
        fetchBook()
    }
    
    func formattedDate(from date: Date?) -> String {
        guard let date = date else {
            return "No Date"
        }
        return dateFormattter.string(from: date)
    }
}
