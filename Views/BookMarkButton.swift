//
//  BookMarkButton.swift
//  동네북
//
//  Created by sushin on 2021/11/22.
//

import SwiftUI

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

//struct BookMarkButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BookMarkButton()
//    }
//}
