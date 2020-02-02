//
//  BulletinBoard.swift
//  INEZ
//
//  Created by Veit Progl on 25.11.19.
//  Copyright © 2019 Veit Progl. All rights reserved.
//

import SwiftUI
import KeyboardObserving

// swiftlint:disable empty_parentheses_with_trailing_closure multiple_closures_with_trailing_closure
class BulletinModel: ObservableObject {
    @Published var show: Bool

    init(show: Bool) {
        self.show = show
    }
}

struct BulletinBoardExample: View {
    @State private var isShowingAlert = false
    @State private var text = ""
    var body: some View {
        NavigationView() {
            ZStack() {
                List() {
                    Button(action: {
                        self.isShowingAlert.toggle()
                    }) {
                        Text("wwwerr").foregroundColor(.blue)
                    }
                    ForEach(0..<20) { _ in
                        Text("www")
                    }
                }.addBoard(board: {Text("eer")}, isShowing: self.$isShowingAlert)
            }.navigationBarTitle("BulletinBoard")
        }
    }
}

struct BulletinBoard<Presenting, Board>: View where Presenting: View, Board: View {
    @Binding var isShowing: Bool
    let presenting: Presenting
    let boardItem: () -> Board
    @GestureState private var offset: CGSize = .zero
    @State private var text = ""

    var body: some View {
        let drag = DragGesture()
            .updating($offset) { value, state, _ in
                if value.translation.height >= -(UIScreen.main.bounds.height - 500) {
                    state = value.translation
                }
            }
            .onEnded({ value in
                print(value.translation.height)
                if value.translation.height >= 200 {
                    print("dismiss")
                    self.isShowing = false
                    self.dismissKeyboard()
                }
            })
        return ZStack() {
                VStack() {
                    VStack() {
                        Spacer()
                        VStack() {
                            self.boardItem()
                                .padding([.bottom], 35)
                                .frame(minWidth: 0, maxWidth: 400, minHeight: 300, alignment: Alignment.bottom)
                        }
                         .frame(minWidth: 0, maxWidth: 400, minHeight: 300, alignment: Alignment.center)
                         .background(Color("background"))
                         .cornerRadius(35)
                         .offset(y: self.offset.height)
                         .padding(5)
                         .gesture(drag)
                         .animation(.spring())
                    }
                    .opacity(isShowing ? 1 : 0)
                    .keyboardObserving()
                    .animation(.spring())
                }.zIndex(2)

                presenting
                    .overlay(
                    EmptyView()
                        .background(Color.black)
                        .edgesIgnoringSafeArea([.all])
                        .opacity(self.isShowing ? 0.65 : 0)
                        .animation(.easeInOut(duration: 0.1))
                )
        }.edgesIgnoringSafeArea(.bottom)
    }

    func dismissKeyboard() {
        UIApplication.shared.windows.first?.endEditing(true)
    }

}

extension View {
    func addBoard<Board: View>(@ViewBuilder board: @escaping () -> Board, isShowing: Binding<Bool>) -> some View {
        BulletinBoard(isShowing: isShowing, presenting: self, boardItem: board)
    }
}

struct BulletinBoard_Previews: PreviewProvider {
    static var previews: some View {
        BulletinBoardExample()
    }
}
