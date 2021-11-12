//
//  SnapCarousel.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/09.
//

import SwiftUI

struct SnapCarousel: View {
    @EnvironmentObject var UIState: UIStateModel
    var bookModels = [ViewModel]()
    
    var body: some View {
        let spacing: CGFloat = 16
        let widthOfHiddenCards: CGFloat = 62 /// UIScreen.main.bounds.width - 10
        let cardHeight: CGFloat = 279
        
        return Canvas {
            /// TODO: find a way to avoid passing same arguments to Carousel and Item
            Carousel(
                numberOfItems: CGFloat(bookModels.count),
                spacing: spacing,
                widthOfHiddenCards: widthOfHiddenCards
            ) {
                ForEach(bookModels, id: \.self.index) { book in
                    Item(
                        _id: Int(book.index),
                        spacing: spacing,
                        widthOfHiddenCards: widthOfHiddenCards,
                        cardHeight: cardHeight
                    ) {
                                book.image
                    }
                    .foregroundColor(Color.black)
                    .cornerRadius(8)
                    .shadow(color: Color(red: 0.149, green: 0.18, blue: 0.212), radius: 4, x: 0, y: 4)
                    .transition(AnyTransition.slide)
                    .animation(.spring())
                }
            }
        }
    }
}

public class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0
    @Published var screenDrag: Float = 0.0
}

struct Carousel<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat //= 8
    let spacing: CGFloat //= 16
    let widthOfHiddenCards: CGFloat //= 32
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable public init(
numberOfItems: CGFloat,
spacing: CGFloat,
widthOfHiddenCards: CGFloat,
    @ViewBuilder _ items: () -> Items) {
        
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
        
    }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing
        
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)
        
        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.UIState.screenDrag = Float(currentState.translation.width)
            
        }.onEnded { value in
            self.UIState.screenDrag = 0

            if (value.translation.width < -50) &&  self.UIState.activeCard < Int(numberOfItems) - 1 {
                  self.UIState.activeCard = self.UIState.activeCard + 1
                  let impactMed = UIImpactFeedbackGenerator(style: .medium)
                  impactMed.impactOccurred()
            }
            
            if (value.translation.width > 50) && self.UIState.activeCard > 0 {
                  self.UIState.activeCard = self.UIState.activeCard - 1
                  let impactMed = UIImpactFeedbackGenerator(style: .medium)
                  impactMed.impactOccurred()
            }
        })
    }
}

struct Canvas<Content : View> : View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Item<Content: View>: View {
    @EnvironmentObject var UIState: UIStateModel
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var _id: Int
    var content: Content
    
    @inlinable public init(
_id: Int,
spacing: CGFloat,
widthOfHiddenCards: CGFloat,
cardHeight: CGFloat,
    @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
        self.cardHeight = cardHeight
        self._id = _id
    }
    
    var body: some View {
        content
            .frame(width: cardWidth, height: _id == UIState.activeCard ? cardHeight : cardHeight - 60, alignment: .center)
    }
}

struct SnapCarousel_Previews: PreviewProvider {
    static var previews: some View {
        let sushin = [ViewModel( id: "id",  useruid: "useruid", name: "name", email: "email", bookname: "Bookname ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, index: 0),
                      ViewModel( id: "id",  useruid: "useruid", name: "name", email: "email", bookname: "Bookname ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, index: 1),
                      ViewModel( id: "id",  useruid: "useruid", name: "name", email: "email", bookname: "Bookname ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, index: 2),
                      ViewModel( id: "id",  useruid: "useruid", name: "name", email: "email", bookname: "Bookname ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, index: 3)]
        SnapCarousel(bookModels: sushin).environmentObject(UIStateModel())
    }
}
