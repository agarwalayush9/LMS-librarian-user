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
                    .onTapGesture {
                        isShowing.toggle()
                    }
                        HStack{
                            VStack(alignment: .leading){
                                SideBarOptions()
                                
                                Spacer()
                            }
                            .background(.white)
                        }
            }
        }
    }}

#Preview {
    sideMenuBar(isShowing: .constant(true))
}
