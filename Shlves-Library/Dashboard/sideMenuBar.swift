import SwiftUI
import FirebaseAuth

struct menuContent: View {
  
    let items = Sections.section
    
    var body: some View {
        ZStack {
            Color(.white)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Librarian")
                    .padding(.top, 20)
                    .font(Font.custom("DM Sans", size: 34).weight(.bold))
                    .padding([.top, .leading], 25)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(items) { item in
                            Text(item.sectionHeader)
                                .font(Font.custom("DM Sans", size: 20).weight(.bold))
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(item.menuItem) { idi in
                                    if idi.isClickable {
                                        NavigationLink(destination: idi.destination.navigationBarBackButtonHidden(true)) {
                                            HStack {
                                                Image(idi.optionIcon)
                                                    .frame(width: 24, height: 24)
                                                Text(idi.option)
                                                    .font(Font.custom("DM Sans", size: 17))
                                            }
                                            .padding(.horizontal, 16)
                                            .cornerRadius(8)
                                        }
                                        .buttonStyle(PlainButtonStyle()) // Prevent default button styling
                                    } else {
                                        HStack {
                                            Image(idi.optionIcon)
                                                .frame(width: 24, height: 24)
                                            Text(idi.option)
                                                .font(Font.custom("DM Sans", size: 17))
                                        }
                                        .padding(.horizontal, 16)
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                        }
                    }
                }
                
                LibrarianProfile(userName: "User",
                                 post: "Librarian",
                                 profileImage: "person.fill")
            }
            .padding(.all, 30)
        }
    }
}

struct sideMenu: View {
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack {
            if menuOpened {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.gray.ignoresSafeArea().opacity(0.0000005))
                .onTapGesture {
                    toggleMenu()
                }
            }
            
            HStack {
                menuContent()
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default, value: menuOpened)
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                Spacer()
            }
        }
    }
}

struct LogOutButton: View {
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        HStack {
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
            authManager.signOut()
        }
    }
}

struct LibrarianProfile: View {
    var userName: String
    var post: String
    var profileImage: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: .infinity, height: 110)
                .foregroundColor(.clear)
                .background(.clear)
            HStack {
                HStack {
                    Rectangle()
                        .frame(width: 40, height: 40, alignment: .leading)
                        .foregroundColor(.clear)
                        .background(
                            Image(systemName: "\(profileImage)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipped()
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .padding(.trailing, 16)
                    VStack(alignment: .leading) {
                        Text(userName)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundStyle(Color.black)
                            .frame(width: .infinity, alignment: .topLeading)
                        Text(post)
                            .font(.system(size: 16, weight: .bold, design: .default))
                            .foregroundStyle(Color.gray)
                            .frame(width: .infinity, alignment: .topLeading)
                    }
                }
                .padding(.trailing, 16)
                LogOutButton()
            }
        }
    }
}


#Preview {
    menuContent()
}
