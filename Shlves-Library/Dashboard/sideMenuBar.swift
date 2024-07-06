import SwiftUI

struct MenuItem: Identifiable {
    var id: String { option }
    var option: String
    
    static var menuItem: [MenuItem] {
        [
            MenuItem(option: "One"),
            MenuItem(option: "Two"),
            MenuItem(option: "Three"),
            MenuItem(option: "Four"),
        ]
    }
}

struct menuContent: View {
    let items = MenuItem.menuItem
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 33/255.0,
                          green: 33/255.0,
                          blue: 33/255,
                          alpha: 1))
            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(items) { item in
                    Text(item.option)
                        .foregroundColor(.white)
                        .padding()
                }
            }
            Spacer()
        }
    }
}


struct sideMenu: View {
    let width: CGFloat
    let menuOpened: Bool
    let toggleMenu: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.ignoresSafeArea().opacity(0.25))
            .onTapGesture {
                toggleMenu()
            }
            
            HStack {
                menuContent()
                    .frame(width: width)
                    .offset(x: menuOpened ? 0 : -width)
                    .animation(.default, value: menuOpened)
                Spacer()
            }
        }
    }
}

#Preview {
    LibrarianDashboard()
}
