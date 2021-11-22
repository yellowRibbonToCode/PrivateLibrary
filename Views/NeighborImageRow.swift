//
//  NeighborImageRow.swift
//  동네북
//
//  Created by sushin on 2021/11/19.
//


import SwiftUI
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct  BookMarkButton: View {
    let bookuid : String
    @State var bookmark : Bool
    init (bookuid: String)
    {
        self.bookuid = bookuid
        let bookmarks = UserDefaults.standard.array(forKey: "bookmark") as? [String] ?? [String]()
        self.bookmark = bookmarks.contains(bookuid)
    }
    
    var body: some View {
        Button(action: {
            if bookmark {
                bookmark = false
                deletebookmarkdb()
                print("deletebookmarkdb success")
            }
            else {
                bookmark = true
                setbookmarkdb()
                print("setbookmarkdb success")
            }
        }) {
            if bookmark {
                Image("bookmark-p")
            }
            else {
                Image("bookmark-p-blank-small")
            }
        }
    }
    
    func deletebookmarkdb() {
        var bookmarks = UserDefaults.standard.array(forKey: "bookmark") as? [String] ?? [String]()
        while let index = bookmarks.firstIndex(of: bookuid) {
            bookmarks.remove(at: index)
        }
        UserDefaults.standard.set(bookmarks, forKey: "bookmark")
        print(bookmarks)
    }
    
    func setbookmarkdb() {
        var bookmarks = UserDefaults.standard.array(forKey: "bookmark") as? [String] ?? [String]()
        bookmarks.append(bookuid)
        UserDefaults.standard.set(bookmarks, forKey: "bookmark")
        print(bookmarks)
    }
}

struct NeighborImageRow: View {
    var libModel: ViewModel
    @ObservedObject var books: NeighborViewModel
    
    
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10){
            ZStack(alignment: .topTrailing ){
                if let image = libModel.image {
                    image
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width / 2.3 , height:UIScreen.main.bounds.width / 2.3)
                        .cornerRadius(19)
                        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: 6, x: 0, y: 3)
                }
                BookMarkButton(bookuid: libModel.id)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
            }
            HStack {
                if libModel.bookname.count > 15 {
                    Text(libModel.bookname.prefix(14) + "…")
                        .font(Font.custom("S-CoreDream-6Bold", size: 15))
                        .foregroundColor(.mainBlue)
                    +
                    Text(" ")
                    +
                    Text(libModel.title)
                        .font(Font.custom("S-CoreDream-3Light", size: 15))
                        .foregroundColor(.black)
                }
                else {
                    Text(libModel.bookname)
                        .font(Font.custom("S-CoreDream-6Bold", size: 15))
                        .foregroundColor(.mainBlue)
                    +
                    Text(" ")
                    +
                    Text(libModel.title)
                    
                        .font(Font.custom("S-CoreDream-3Light", size: 15))
                        .foregroundColor(.black)
                }
            }
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .frame(height: 45, alignment: .topLeading)
            .truncationMode(.tail)
        }
    }
}
