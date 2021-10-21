//
//  ContentView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/21.
//
// YelloRibbontoCode
import SwiftUI

struct ContentView: View {
    
    @State private var selection = false;
    @State var showComposer : Bool = false;
    @State var text: String = "";
    @State var showComposerRuler : Bool = false;
    init() {
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundColor = UIColor(Color(red: 136/255, green: 83/255, blue: 24/255))
//            UITabBar.appearance().tintColor = UIColor(Color.red)
        UITabBar.appearance().barTintColor = UIColor(Color(red: 136/255, green: 83/255, blue: 24/255)) // custom color.
    }
    var items = Product.sampleList
    
    var body: some View {
       
        
        NavigationView {
            TabView(selection: $selection) {
                List (items, id:\.name){
                    item in
                    HStack {
                        Image("turtlerock")
                            .resizable()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 7)
                            .frame(width:30, height:30)
                        
                        Text(item.name)
        //
                        Text("\(item.price)")
                        Text(item.category)
                            .padding(5)
                            .background(Color.gray)
                            .clipShape(Rectangle())
                            .cornerRadius(10)
//                            .overlay(
//                                Ellipse()
//                                .stroke(Color.gray, lineWidth: 4)
//
//                            )
                            .allowsTightening(true)
                            .foregroundColor(.white)
                            
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            
                            
                    }
                }
                .tabItem{
                    Image(systemName: "book.fill")
                    Text("Library")
                }
                Text("list").tabItem {
                    Image(systemName: "person.fill")
                    Text("My Library") }
            }
            .accentColor(.white)
            .navigationTitle("주변 도서관")
            .toolbar(content: {
                ToolbarItemGroup (placement: .principal) {
                    ModalButtonMagnifyingGlass(show: $showComposer, text: $text)
                }
            })
            //            .navigationBarItems(leading: ModalButtonMagnifyingGlass(show: $showComposer, text: $text), trailing: ModalButtonRuler(show: $showComposerRuler))
            //
            .navigationBarItems(trailing: ModalButtonRuler(show: $showComposerRuler))
        }
    }
}

fileprivate struct ModalButtonMagnifyingGlass: View {
    @Binding var show: Bool
    @Binding var text : String
    
    var body: some View {
        HStack {
            TextField("검색어를 넣어주세요" , text : self.$text)
                .multilineTextAlignment(.center)
                .padding([.top, .bottom], 7)
                .frame(minWidth:300)
                .background(Color(.systemGray6))
                .cornerRadius(50)
                .overlay(
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(UIColor(Color(red: 136/255, green: 83/255, blue: 24/255))))
                            .padding()
                        Spacer()
                    })
//
//                    Button(action: {self.show = true}, label: {
//                        Image(systemName: "magnifyingglass.circle")
//                    })
                    
            //                    .accentColor(Color(UIColor(Color(red: 136/255, green: 83/255, blue: 24/255))))
            //            })
        }
    }
}

fileprivate struct ModalButtonRuler: View {
    @Binding var show: Bool
    
    var body: some View {
        Button(action: {self.show = true}, label: {
            Image(systemName: "ruler")
                .foregroundColor(Color(red: 136/255, green: 83/255, blue: 24/255))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()

    }
}
