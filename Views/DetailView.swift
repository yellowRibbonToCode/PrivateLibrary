//
//  LandmarkDetail.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/24.
//

import SwiftUI
//import AlertToast


struct DetailView: View {
    var libModel: ViewModel
    static var taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    @State private var showAlert = false
    var body: some View {
        
        
        ScrollView(.vertical, showsIndicators: false){
            VStack {
                GeometryReader {g in
                    let yOffset = g.frame(in: .global).minY > 0 ? -g.frame(in: .global).minY :0
                    ZStack (alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                        libModel.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: g.size.width, height: g.size.height - yOffset)
                            .offset(y: yOffset)
                        
                        .overlay(Color.gray
                                    .opacity(0.5)
                                    .frame(width: g.size.width, height: g.size.height - yOffset)
                                    .offset(y: yOffset))
                        HStack {
                            Text(libModel.bookName)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                            Spacer()
                            Text(libModel.bookWriter)
                                .font(.headline)
                                .padding([.trailing])
                            
                        }
                        .foregroundColor(.white)
                        .offset(y: yOffset)
                        .padding([.leading, .bottom])
                        
                        
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 2)
                VStack(alignment: .leading) {
                    HStack {
                        Text(libModel.name)
                            .font(.body)
                            .padding([.leading])
                        Spacer()
                        HStack {
                            Button {
                                UIPasteboard.general.string = libModel.email
                                showAlert.toggle()
                            }
                        label:{
                            Rectangle()
                                .frame(width: 60, height: 17)
                                .foregroundColor(.green)
                                .opacity(0.3)
                                .cornerRadius(10)
                                .overlay(Text("교환")
                                        .foregroundColor(.black))
                                        .font(.footnote)
                        }
                        .alert(isPresented: $showAlert){
                            Alert(title: Text("Alert"), message: Text("email address is copied"))
                        }
                        .opacity(libModel.isChangable ? 1 : 0)
                        Button {
                                UIPasteboard.general.string = libModel.email
                                showAlert.toggle()
                            }
                        label:{
                            Rectangle()
                                .frame(width: 60, height: 17)
                                .foregroundColor(.red)
                                .opacity(0.3)
                                .cornerRadius(10)
                                .overlay(Text("구매")
                                            .font(.footnote)
                                            .foregroundColor(.black))
                        }
                        .alert(isPresented: $showAlert){
                            Alert(title: Text("Alert"), message: Text("email address is copied"))
                        }
                        .opacity(libModel.isTradable ? 1 : 0)
                        }
                    }
                    .padding([.trailing])
                }
                .padding([.top, .bottom])
                Spacer()
                Divider()
                Text(libModel.abstract)
                    .font(.body)
                    .fontWeight(.heavy)
                    .padding()
                Text(libModel.content)
                    .font(.body)
                    .padding()
                    .padding([.leading, .trailing], 20)
                HStack {
                    Spacer()
                    Text("\(libModel.createdDate, formatter: Self.taskDateFormat)")
                        .padding([.trailing, .bottom])
                }
            }
        }
        .navigationBarTitleDisplayMode(.automatic)
        .edgesIgnoringSafeArea(.top)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(libModel: ModelData().library[1])
    }
}
