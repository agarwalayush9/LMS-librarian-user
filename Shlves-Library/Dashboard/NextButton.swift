//
//  NextButton.swift
//  Shlves-Library
//
//  Created by Sahil Raj on 14/07/24.
//

import SwiftUI

struct nextButton: View {
    @Binding var nextPopOver1 : Bool
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    print("pressed2")
                    nextPopOver1.toggle()
                    
                }, label: {
                    CustomButton(systemImage: "",
                                 width: 92,
                                 height: 42,
                                 title: "Next",
                                 colorName: "CustomButtonColor")
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .inset(by: -2)
                            .stroke(Color("cardIconColor"), lineWidth: 4)
                            
                    )
                }).sheet(isPresented: $nextPopOver1, content: {
                    CreateNextUserForm()
                })
                
            }.padding([.trailing, .bottom], 90)
        }
    }
}
