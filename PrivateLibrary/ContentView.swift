//
//  ContentView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/21.
//
// YelloRibbontoCode
import SwiftUI



struct ContentView: View {
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color(red: 136/255, green: 83/255, blue: 24/255)) // custom color.
        UITabBar.appearance().tintColor = UIColor(Color.red)
    }
    
    @State private var selection = false;
    var body: some View {
        TabView(selection: $selection) {
            Text("featured").tabItem {
                Image(systemName: "book.fill")
                Text("First")
            }
            Text("list").tabItem {
                Image(systemName: "person.fill")
                Text("List") }
        }
        .accentColor(.white)
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
