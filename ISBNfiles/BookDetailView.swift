import SwiftUI

struct BookDetailView: View {
    let book: BookDetails
    @State private var quantity: Int = 1
    let dummyImage = UIImage(named: "dummyBookImage") // Add a dummy image to your assets

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Display book image or dummy image
            if let imageUrl = book.imageUrl, let imageData = try? Data(contentsOf: imageUrl), let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            } else {
                Image(uiImage: dummyImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            Text(book.title)
                .font(.custom("DMSans-ExtraBold", size: 35))
            
            if let authors = book.authors {
                Text("Authors: \(authors.joined(separator: ", "))")
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
            
            if let categories = book.categories {
                Text("Categories: \(categories.joined(separator: ", "))")
                    .font(.custom("DMSans_18pt-Bold", size: 18))
            }
            
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
                    // Handle done action
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
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: BookDetails(
            title: "Sample Book",
            authors: ["Author One", "Author Two"],
            description: "This is a sample description of the book.",
            publisher: "Sample Publisher",
            publishedDate: "2023-01-01",
            pageCount: 300,
            categories: ["Category One", "Category Two"],
            averageRating: 4.5,
            imageUrl: nil // Add a valid URL here to preview
        ))
    }
}
