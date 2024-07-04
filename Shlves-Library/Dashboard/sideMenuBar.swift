//
//  sideMenuBar.swift
//  Shlves-Library
//
//  Created by Abhay singh on 03/07/24.
//

import SwiftUI

struct sideMenuBar: View {
    @Binding var isShowing : Bool
    
    var body: some View {
        ZStack{
            if isShowing{
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .background(ignoresSafeAreaEdges: .all)
                    .onTapGesture {
                        isShowing.toggle()
                    }
                        HStack{
                            VStack(alignment: .leading){
                                SideBarOptions()
                                
                                Spacer()
                            }
                            .background(Color.white)
                            .frame(width: 400)
                            .offset(x: isShowing ? 0 : -300)
                            .animation(.easeInOut(duration: 0.3),
                                       value: isShowing)
                            Spacer()
                        }
            }
        }
        .transition(.move(edge: .leading))
        .animation(.easeInOut, value: isShowing)
    }}

#Preview {
    sideMenuBar(isShowing: .constant(true))
}
