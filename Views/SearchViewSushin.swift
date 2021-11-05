//
//  SearchViewSushin.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/05.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Search View")
                .font(.system(size: 40, weight: .heavy, design: .serif))
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            HStack {
                TextField("Search ...", text: $text)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.text = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
        }
    }
}

struct SearchViewSushin: View {
    @ObservedObject var sushinViewModel = SushinViewModel()
    @State var text: String = ""
    

    var body: some View {
        NavigationView{
            VStack {
                SearchBar(text: $text)
                Spacer(minLength: 20)
                VStack(alignment: .leading) {
                    Text("Best Book")
                        .font(.system(size: 25, weight: .heavy, design: .serif))
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    GeometryReader { geometry in
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(sushinViewModel.bookModels) { model in
                                    NavigationLink(destination: DetailView(libModel: model)) {
                                        SushinView(booksModel: model)
                                            .padding([.leading, .trailing])
                                    }
                                }
                            }
                            .frame(height: geometry.size.height)
                            .onAppear(perform: {
                                db = Firestore.firestore()
                                sushinViewModel.makeList() // best book으로 필터링된 책 리스트를 만드는 모델이 들어가야됨
                            })
                        }
                    }
                }
                
                
                
                
                
                Divider()
                VStack (alignment: .leading) {
                    Text("New Book")
                        .font(.system(size: 25, weight: .heavy, design: .serif))
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    GeometryReader { geometry in
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(sushinViewModel.bookModels) { model in
                                    SushinView(booksModel: model)
                                        .padding([.leading, .trailing])
                                }
                            }
                            .frame(height: geometry.size.height)
                            //                            .onAppear(perform: {
                            //                                db = Firestore.firestore()
                            //                                sushinViewModel.makeList() // new book으로 필터링된 책 리스트를 만드는 모델이 들어가야됨
                            //                            })
                        }
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct SearchViewSushin_Previews: PreviewProvider {
    static var previews: some View {
        SearchViewSushin()
    }
}

