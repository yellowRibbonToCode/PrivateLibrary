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
    //    var db: Firestore!
    
    
    
    var body: some View {
        
        
        VStack(spacing: 0){
            ZStack{
                if self.index == 0
                {
                    ImageGridView()
                }
                else if self.index == 1{
                    TestView()
                }
                else if self.index == 2{
                    DBTestList()
                }
                else{
                    Color.orange
                }
            }
            CircleTab(index: self.$index)
        }
        .edgesIgnoringSafeArea(.top)
    }
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
                            .frame(width: 30, height: 28)
                            .foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                            .padding()
                            .background(Color(hue: 0.069, saturation: 0.193, brightness: 0.992))
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Home").foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                    }
                }
                
                
            }
            
            Spacer(minLength: 15)
            
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
                            .frame(width: 30, height: 28)
                            .foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                            .padding()
                            .background(Color(hue: 0.069, saturation: 0.193, brightness: 0.992))
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Search").foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                    }
                }
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 2
                
            }) {
                
                VStack{
                    
                    if self.index != 2{
                        
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 25, height: 23)
                            .foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 30, height: 28)
                            .foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                            .padding()
                            .background(Color(hue: 0.069, saturation: 0.193, brightness: 0.992))
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("Likes").foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                    }
                }
            }
            
            Spacer(minLength: 15)
            
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
                            .frame(width: 30, height: 28)
                            .foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                            .padding()
                            .background(Color(hue: 0.069, saturation: 0.193, brightness: 0.992))
                            .clipShape(Circle())
                            .offset(y: -20)
                            .padding(.bottom, -20)
                        
                        Text("My Page").foregroundColor(Color(hue: 0.074, saturation: 0.99, brightness: 0.492))
                    }
                }
            }
            
        }.padding(.vertical,-10)
            .padding(.horizontal, 25)
            .background(Color.white)
            .animation(.spring())
    }
}
