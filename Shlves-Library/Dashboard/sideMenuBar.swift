import SwiftUI
import FirebaseAuth


struct test: View {
    let sections = Sections.section
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sections) { section in
                    Section(header: Text(section.sectionHeader)) {
                        ForEach(section.menuItem) { item in
                            HStack {
                               // Image(systemName: item.optionIcon)
                                //    .foregroundColor(.blue) // Adjust the color if needed
                                Text(item.option)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Menu")
        }
    }
}

// here
struct menuContent: View {
    @Binding var isLoggedIn: Bool
    let items = Sections.section
    
    
    var body: some View {
        ZStack {
            Color(.white)
            
                VStack(alignment: .leading, spacing: 0) {
                    Text("Librarian")
                        .padding(.top, 20)
                    .font(
                    Font.custom("DM Sans", size: 34)
                    .weight(.bold))
                    .padding([.top, .leading], 25)
                    List{
                        ForEach(items){ item in
                            Section(header: Text(item.sectionHeader)
                                .font(
                                Font.custom("DM Sans", size: 20)
                                .weight(.bold)
                                )){
                                VStack(alignment: .leading, spacing: 15){
                                    ForEach(item.menuItem){ idi in
                                        HStack{
                                            Image(idi.optionIcon)
                                                .frame(width: 24, height: 24)
                                            Text(idi.option)
                                                .font(Font.custom("DM Sans", size: 17))
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                        
                        
                        //here
                    }
                    .listSectionSeparator(.hidden)
                    
                    VStack(alignment: .center){
                        ContactButton(contactTo: "Admin")
                            .padding([.top,.bottom,],8)
                        Divider()
                        LibrarianProfile(isLoggedIn: $isLoggedIn,userName: "User",
                                         post: "Librarian",
                                         porfileImage: "person.fill")
                        
                    }
                    .padding(.all, 30)
                }
            }
            Spacer()
        }
    }




struct sideMenu: View {
    @Binding var isLoggedIn: Bool
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.ignoresSafeArea().opacity(0.0001))
            .onTapGesture {
                toggleMenu()
            }
            
            HStack {
                menuContent(isLoggedIn: $isLoggedIn)
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default, value: menuOpened)
                Spacer()
            }
        }
    }
}

struct ContactButton : View {
    var contactTo : String
    
    var body: some View {
        
        HStack{
            Image(systemName: "headphones")
                .padding(.leading, 8)
            Text("Contact \(contactTo)")
                .font(.system(size: 17, weight: .regular, design: .default))
                .padding(.all, 4)
        }
        .padding(.all, 11)
        .frame(width: 232, alignment: .leading)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(Color("CustomButtonColor"), lineWidth: 1)
        )
    }
}

struct LogOutButton : View {
    @Binding var isLoggedIn: Bool
    var body: some View {
        HStack{
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .frame(width: 17, height: 17)
                .foregroundColor(Color.white)
            Text("Log Out")
                .foregroundStyle(Color.white)

                
        }
        .padding(.all)
        .frame(width: .infinity, height: 50)
        .background(Color("CustomButtonColor"))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            do {
                try Auth.auth().signOut()
                isLoggedIn = false
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
}



struct LibrarianProfile: View {
    @Binding var isLoggedIn: Bool
    var userName : String
    var post : String
    var porfileImage : String
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: .infinity, height: 110)
                .foregroundColor(.clear)
                .background(.clear)
            HStack {
                HStack{
                    Rectangle()
                        .frame(width: 40, height: 40,alignment: .leading)
                        .foregroundColor(.clear)
                        .background(
                            Image(systemName: "\(porfileImage)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipped()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .padding(.trailing,16)
                    VStack(alignment: .leading){
                        Text(userName)
                            .font(.system(size: 16,
                                          weight: .bold,
                                          design: .default))
                            .foregroundStyle(Color.black)
                            .frame(width: .infinity,alignment: .topLeading)
                        Text(post)
                            .font(.system(size: 16,
                                          weight: .bold,
                                          design: .default))
                            .foregroundStyle(Color.gray)
                            .frame(width: .infinity,alignment: .topLeading)
                    }
                }
                .padding(.trailing,16)
                LogOutButton(isLoggedIn: $isLoggedIn)
            }
            
        }
                 
    }
}




#Preview("test") {
    test()
}
