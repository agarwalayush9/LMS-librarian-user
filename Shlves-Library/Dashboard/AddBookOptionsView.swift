//
//  AddBookOptionsView.swift
//  Shlves-Library
//
//  Created by Sahil Raj on 12/07/24.
//

import SwiftUI

struct AddBookOptionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddBookDetails = false
    @State private var showingISBN = false
    @State private var inviteSent = false
    var addBook: (Book) -> Void
    var books: [Book] // Pass existing books
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Add Books")
                    .font(.custom("DMSans-ExtraBold", size: 32))
                    .fontWeight(.bold)
                
                VStack(spacing: 30) {
                    NavigationLink(destination: ContentView(), isActive: $showingISBN) {
                        Button(action: {
                            // Action for ISBN Code Scanning
                            showingISBN = true
                        }) {
                            VStack {
                                Image(systemName: "barcode.viewfinder")
                                    .font(.system(size: 65))
                                    .foregroundColor(.black)
                                    .padding(.bottom)
                                
                                Text("Using ISBN Code Scanning")
                                    .font(.custom("DMSans-Bold", size: 20))
                                    .foregroundColor(.black)
                            }
                            .padding(.all, 20)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 3))
                        }
                    }
                    
                    Button(action: {
                        // Action for Batch Upload
                    }) {
                        VStack {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 65))
                                .foregroundColor(.black)
                                .padding(.bottom)
                            Text("Batch Upload (CSV, Spreadsheet)")
                                .font(.custom("DMSans-Bold", size: 20))
                                .foregroundColor(.black)
                        }
                        .padding(.all, 20)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 3))
                    }
                    
                    Button(action: {
                        showingAddBookDetails = true
                    }) {
                        VStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 65))
                                .foregroundColor(.black)
                                .padding(.bottom)
                            Text("Enter Details Manually")
                                .font(.custom("DMSans-Bold", size: 20))
                                .foregroundColor(.black)
                        }
                        .padding(.all, 20)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 1, green: 0.74, blue: 0.28), lineWidth: 3))
                    }
                    .sheet(isPresented: $showingAddBookDetails) {
                        AddBookDetailsView(addBook: addBook, books: books)
                    }
                }
                .padding(.bottom)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .frame(maxWidth: 500) // Limit the width of the pop-up
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct AddBookOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookOptionsView(addBook: { _ in }, books: [])
    }
}
