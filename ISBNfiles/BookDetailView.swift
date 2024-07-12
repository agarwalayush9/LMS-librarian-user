import SwiftUI

struct BookDetailView: View {
    let book: Book
    @State private var quantity: Int = 1
    @Environment(\.presentationMode) var presentationMode
    let dummyImage = UIImage(named: "dummyBookImage") // Add a dummy image to your assets
    
    // State for showing alerts
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Display book image or dummy image
            if let imageUrl = URL(string: book.bookCover), let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            } else if let dummyImage = dummyImage {
                Image(uiImage: dummyImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            } else {
                Color.gray
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            Text(book.bookTitle)
                .font(.custom("DMSans-ExtraBold", size: 35))
            
            if !book.author.isEmpty {
                Text("Authors: \(book.author)")
                    .font(.custom("DMSans_18pt-Bold", size: 18))
            }
            
            if let publisher = book.publisher {
                Text("Publisher: \(publisher)")
                    .font(.custom("DMSans_18pt-Bold", size: 18))
            }
            
            if let publishedDate = book.publishedDate {
                Text("Published Date: \(publishedDate)")
                    .font(.custom("DMSans_18pt-Bold", size: 18))
            }
            
            if let pageCount = book.pageCount {
                Text("Page Count: \(pageCount)")
                    .font(.custom("DMSans_18pt-Bold", size: 18))
            }
            
            Text("Genre: \(book.genre.rawValue)") // Display genre using rawValue
                .font(.custom("DMSans_18pt-Bold", size: 18))
            
            if let averageRating = book.averageRating {
                Text("Average Rating: \(averageRating)")
                    .font(.custom("DMSans_18pt-Bold", size: 18))
            }
            
            if let description = book.description {
                Text(description)
                    .font(.custom("DMSans_18pt-SemiBold", size: 17))
                    .padding(.top, 10)
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    if quantity > 1 {
                        quantity -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
                
                Text("\(quantity)")
                    .font(.custom("DMSans_18pt-Bold", size: 18))
                    .frame(width: 50, height: 50)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    quantity += 1
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Button(action: {
                    saveBook()
                    
                }) {
                    Text("Done")
                        .font(.custom("DMSans_18pt-Bold", size: 18))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveBook() {
        DataController.shared.addBook(book) { result in
            switch result {
            case .success:
                // Optionally handle success
                DispatchQueue.main.async {
                                    presentationMode.wrappedValue.dismiss()
                                }
                print("Book saved successfully.")
            case .failure(let error):
                // Handle failure, show alert
                showAlert = true
                alertMessage = error.localizedDescription
                print("Failed to save book: \(error.localizedDescription)")
            }
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book(
            id: UUID(),
            bookCode: "1234567890",
            bookCover: "https://example.com/book-cover.jpg", // Add a valid URL here to preview
            bookTitle: "Sample Book",
            author: "Author One",
            genre: .Fiction,
            issuedDate: "2023-01-01",
            returnDate: "2023-02-01",
            status: "Available",
            quantity: nil,
            description: "This is a sample description of the book.",
            publisher: "Sample Publisher",
            publishedDate: "2023-01-01",
            pageCount: 300,
            averageRating: 4.5
        ))
    }
}
