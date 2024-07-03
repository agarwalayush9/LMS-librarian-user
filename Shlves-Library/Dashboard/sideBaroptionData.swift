//
//  sideBaroptionData.swift
//  Shlves-Library
//
//  Created by Abhay singh on 03/07/24.
//

import Foundation

struct sideBarOptions: Identifiable, Equatable {
    var id: String{optionName}
    var optionName : String
    
    static var sideBaroptionList : [sideBarOptions]{
    [
        sideBarOptions(optionName: "Overview"),
        sideBarOptions(optionName: "Books Inventory")
    ]
    }
}


//struct SideMenuBarOptions : View {
//    
//    var optionName : String
//    
//    var body: some View {
//        Text("\(optionName)")
//            .font(.system(size: 17, weight: .regular, design: .default))
//            .padding(.vertical, 10)
//    }
//}
