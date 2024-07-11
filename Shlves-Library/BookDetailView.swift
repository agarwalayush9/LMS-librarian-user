//
//  BookDetailView.swift
//  Barcode
//
//  Created by Mohit Kumar Gupta on 11/07/24.
//

import SwiftUI

struct BookDetailView: View {
    let book: BookDetails

    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            // Add more fields as needed
            Spacer()
        }
        .padding()
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: BookDetails(title: "Sample Book", description: ""))
    }
}

