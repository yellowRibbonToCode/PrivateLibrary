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
//        if addbook {
//            AddBookInfoView()
//        }
//        else{
        VStack {
            NavigationView {
                    ZStack{
                        if self.index == 0
                        {
                            ImageGridView()
                        }
                        else if self.index == 1{
                            Color.orange
                        }
                        else if self.index == 2{
                            Color.orange
                        }
                        else{
                            ProfileScene()
                        }
                        NavigationLink(destination: AddBookInfoView(), label: {AddBookInfoButtonImage()})
                            .padding(.leading,300)
                            .padding(.top, 600)
                            
//                            .padding([.bottom], 20)
//                            .padding([.leading], 300)
    //                    Button(action: {
    //                        addbook = true
    //                    }, label: {
    //                        AddBookInfoButtonImage()
    //                    })
                    }
                    .navigationBarHidden(true)
            }
                    CircleTab(index: self.$index)
                        .padding([.leading, .trailing], 30)
                        
        }
//            .edgesIgnoringSafeArea(.top)
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
    var body : some View{
        HStack{
            Button(action: {
                self.index = 0
            }) {
                VStack{
                    if self.index != 0{
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
//                            .padding()
//                            .background(Color(hue: 0.069, saturation: 0.193, brightness: 0.992))
//                            .clipShape(Circle())
//                            .offset(y: -20)
//                            .padding(.bottom, -20)
                        //                        Text("Home").foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                    }
                }
            }
            Spacer()
            Button(action: {
                self.index = 1
            }) {
                VStack{
                    if self.index != 1{
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
//                            .padding()
//                            .background(Color(hue: 0.069, saturation: 0.193, brightness: 0.992))
//                            .clipShape(Circle())
//                            .offset(y: -20)
//                            .padding(.bottom, -20)
                        //                        Text("Search").foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                    }
                }
            }
            Spacer()
            Button(action: {
                self.index = 3
            }) {
                VStack{
                    if self.index != 3{
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
//                            .padding()
//                            .background(Color(hue: 0.069, saturation: 0.193, brightness: 0.992))
//                            .clipShape(Circle())
//                            .offset(y: -20)
//                            .padding(.bottom, -20)
                        //                        Text("My Page").foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                    }
                }
            }
            
        }
            .frame(height: 30)
            .padding([.leading, .trailing])
//            .padding(.vertical,-10)
//            .padding(.horizontal, 25)]
            .background(Color.white)
            .animation(.spring())
    }
}
