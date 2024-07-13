//
//  FinalButton.swift
//  Shlves-Library
//
//  Created by Sahil Raj on 14/07/24.
//

import SwiftUI

struct finalButton: View {
    @Binding var nextPopOver2: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    print("pressed3")
                    nextPopOver2.toggle()
                }, label: {
                    CustomButton(systemImage: "", width: 92, height: 42, title: "Next", colorName: "CustomButtonColor")
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .inset(by: -2)
                                .stroke(Color("cardIconColor"), lineWidth: 4)
                        )
                })
                .sheet(isPresented: $nextPopOver2) {
                    CreateFinalUserForm()
                }
            }
            .padding([.trailing, .bottom], 90)
        }
    }
}
