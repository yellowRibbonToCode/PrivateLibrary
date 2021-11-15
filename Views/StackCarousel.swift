//
//  StackCarousel.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/10.
//
//
//import SwiftUI
//
//
//struct StackCarousel: View {
//    
//    @State var books: [ViewModel]
//    
//    @State var showDetailPage: Bool = false
//    @State var currentBook: ViewModel?
//    
//    @Namespace var animation
//    
//    @State var showDetailContent: Bool = false
//    
//    var body: some View {
//        
//        VStack {
//            
//            HStack (alignment: .bottom){
//                
//                VStack(alignment: .leading) {
//                    
//                    Text("Saved Book")
//                        .font(.largeTitle.bold())
//                    
//                    Label {
//                        Text("Sushin")
//                    } icon: {
//                        Image(systemName: "circle.fill")
//                    }
//                }
//                
//                Spacer()
//                
//                Text("Updated 1:30 PM")
//                    .font(.caption2)
//                    .fontWeight(.light)
//            }
//            
//            GeometryReader {proxy in
//                
//                let size = proxy.size
//                
//                let trailingBooksToShown: CGFloat = 2
//                let trailingSpaceofEachBooks: CGFloat = 20
//                
//                ZStack {
//                    ForEach(books) { book in
//                        InfiniteStackedBookView(books: $books, book: book, trailingBooksToShown: trailingBooksToShown, trailingSpaceofEachBooks: trailingSpaceofEachBooks, animation: animation, showDetailPage: $showDetailPage)
//                            .onTapGesture {
//                                withAnimation(.spring()) {
//                                    currentBook = book
//                                    showDetailPage = true
//                                }
//                            }
//                    }
//                }
//                .padding(.leading,10)
//                .padding(.trailing,(trailingBooksToShown * trailingSpaceofEachBooks))
//                .frame(height: size.height / 1.6)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//            }
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//        .overlay(
//            DetailPage()
//        )
//    }
//    
//    @ViewBuilder
//    func DetailPage()->some View {
//        ZStack {
//            
//            if let currentBook = currentBook,showDetailPage {
//                
//                Rectangle()
//                    .fill(Color.gray)
//                    .matchedGeometryEffect(id: currentBook.id, in: animation)
//                    .ignoresSafeArea()
//                
//                VStack(alignment: .leading, spacing: 15) {
//                    
//                    Button {
//                        withAnimation {
//                            showDetailContent = false
//                            showDetailPage = false
//                        }
//                    } label: {
//                        Image(systemName: "xmark")
//                            .foregroundColor(.black)
//                            .padding(10)
//                            .background(Color.white.opacity(0.6))
//                            .clipShape(Circle())
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    
//                    Text(currentBook.author)
//                        .font(.callout)
//                        .fontWeight(.semibold)
//                        .padding(.top)
//                    Text(currentBook.name)
//                        .font(.title.bold())
//                    
//                    ScrollView(.vertical, showsIndicators: false) {
//                        Text(currentBook.content)
//                            .padding(.top)
//                    }
//                }
//                .opacity(showDetailContent ? 1 : 0)
//                .foregroundColor(.white)
//                .padding()
//                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
//                .onAppear{
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                        withAnimation{
//                            showDetailContent = true
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//struct InfiniteStackedBookView: View {
//    
//    @Binding var books: [ViewModel]
//    var book: ViewModel
//    var trailingBooksToShown: CGFloat
//    var trailingSpaceofEachBooks: CGFloat
//    
//    var animation: Namespace.ID
//    @Binding var showDetailPage: Bool
//    
//    @GestureState var isDragging: Bool = false
//    @State var offset: CGFloat = .zero
//    
//    var body: some View {
//        
//        VStack (alignment: .leading, spacing: 15){
//            
//            Text(book.name)
//                .font(.caption)
//                .fontWeight(.semibold)
//            
//            Text(book.bookname)
//                .font(.title.bold())
//                .padding(.top)
//            
//            Spacer()
//            
//            Label {
//                Image(systemName: "arrow.right")
//            } icon: {
//                Text("Read More")
//            }
//            .font(.system(size: 15, weight: .semibold))
//            .frame(maxWidth: .infinity, alignment: .trailing)
//        }
//        .padding()
//        .padding(.vertical,10)
//        .foregroundColor(.black)
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
//        .background(
//            ZStack {
////                book.image
//                RoundedRectangle(cornerRadius: 0)
//                    .fill(Color.mainBrown)
//                    .opacity(1)
//                    .matchedGeometryEffect(id: book.id, in: animation)
//                    .border(Color.brown, width: 4)
//            }
//        )
//        .padding(.trailing, -getPadding())
//        .padding(.vertical, getPadding())
//        .zIndex(Double(CGFloat(books.count) - getIndex()))
//        .rotationEffect(.init(degrees: getRotation(angle: 10)))
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .contentShape(Rectangle())
//        .offset(x: offset)
//        .gesture(
//            
//            DragGesture()
//                .updating($isDragging, body: { _, out, _ in
//                    out = true
//                })
//                .onChanged({ value in
//                    
//                    var translation = value.translation.width
//                    translation = books.first?.id == book.id ? translation : 0
//                    translation = isDragging ? translation : 0
//                    translation = (translation < 0 ? translation : 0)
//                    offset = translation
//                })
//                .onEnded({ value in
//                    
//                    let width = UIScreen.main.bounds.width
//                    let bookPassed = -offset > (width / 2)
//                    
//                    withAnimation (.easeInOut(duration: 0.2)){
//                        
//                        if bookPassed {
//                            offset = -width
//                            removeAndPutBack()
//                        }
//                        else {
//                            offset = .zero
//                        }
//                    }
//                })
//        )
//    }
//    
//    func removeAndPutBack() {
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            
//            var updatedBook = book
//            updatedBook.id = UUID().uuidString
//            
//            books.append(updatedBook)
//            
//            withAnimation{
//                
//                books.removeFirst()
//            }
//            
//            
//        }
//    }
//    
//    func getRotation(angle: Double)->Double {
//        
//        let width = UIScreen.main.bounds.width - 50
//        let progress = offset / width
//        
//        return Double(progress) * angle
//    }
//    
//    func getPadding()->CGFloat {
//        
//        let maxPadding = trailingBooksToShown * trailingSpaceofEachBooks
//        
//        let bookPadding = getIndex() * trailingSpaceofEachBooks
//        
//        return (getIndex() <= trailingBooksToShown ? bookPadding : maxPadding)
//    }
//    
//    func getIndex()->CGFloat {
//        
//        let index = books.firstIndex { book in
//            return self.book.id == book.id
//        } ?? 0
//        
//        return CGFloat(index)
//    }
//}
//
//
//struct StackCarousel_Previews: PreviewProvider {
//    static var previews: some View {
//        let sushin = [ViewModel( id: "E6NmChMW3d",  useruid: "useruid", name: "sushin", email: "email", bookname: "awefawefasdf ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, index: 0),
//                      ViewModel( id: "QQ2ld1dFx",  useruid: "useruid", name: "hekang", email: "email", bookname: "ㅇㅁㄴㄹㅁㅈㄹㅁㄴㅇ ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, index: 1),
//                      ViewModel( id: "ZwXtQtvCUb",  useruid: "useruid", name: "jinbekim", email: "email", bookname: "234235235234 ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, index: 2),
//                      ViewModel( id: "xfetUITBC3k",  useruid: "useruid", name: "bomkim", email: "email", bookname: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹ ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, index: 3)]
//        StackCarousel(books: sushin)
//    }
//}
