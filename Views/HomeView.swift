//
//  HomeView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/10/26.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore


struct HomeView: View {
    
    @State var index = 0
    @State var addbook = false
    //    var db: Firestore!
    
    var body: some View {
        VStack (spacing: 0){
             NavigationView {
                    ZStack{
                        if self.index == 0 {
                            FirstTabView()
                        }
                        else if self.index == 1{
                            SearchView()
//                            TempSecondTap()
                        }
                        else if self.index == 2{
                            ChatList()
                        }
                        else{
                            ProfileScene()
                        }
                    }
//                    .navigationBarHidden(true)
            }
                    CircleTab(index: self.$index)
        }
            .edgesIgnoringSafeArea(.bottom)
        }
//    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct CircleTab : View {
    @Binding var index : Int
    @State var showAdd = false

    var body : some View{
        HStack(spacing: 0){
            Button(action: {
                self.index = 0
            }) {
                VStack{
                    if self.index != 0{
                        Image("home-alt-p")
//                            .resizable()
//                            .frame(width: 33, height: 33)
                            .renderingMode(.template)
                            .foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        Image("home-alt-p")
//                            .resizable()
//                            .frame(width: 33, height: 33)
                            .foregroundColor(Color.mainBlue)
                    }
                }
            }
            Spacer()
            Button(action: {
                self.index = 1
            }) {
                VStack{
                    if self.index != 1{
                        Image("search-g")
                            .renderingMode(.template)
                            .foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        Image("search-p")
                    }
                }
            }
            Spacer()
                        Button(action: {
                            self.showAdd.toggle()

                        }) {
                            Image("plus-p")
                        }
                        .fullScreenCover(isPresented: $showAdd) {
                            AddBookInfoView()
                        }
            Spacer()
            Button(action: {
                self.index = 2
            }) {
                VStack{
                    if self.index != 2{
                        Image("chat-g")
                    }
                    else{
                        Image("chat-p")
                    }
                }
            }
            Spacer()
            Button(action: {
                self.index = 3
            }) {
                VStack{
                    if self.index != 3{
                        Image("user-g")
                    }
                    else{
                        Image("user-p")
                    }
                }
            }
            
        }
        .frame(height: UIScreen.main.bounds.height / 12)
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
            .background(Color(red: 0.961, green: 0.961, blue: 0.961))
    }
}
