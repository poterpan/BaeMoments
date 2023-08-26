//
//  PostsView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/4.
//

import SwiftUI
import Combine
import PopupView

struct NewEventView: View {
    @State var title = ""
    @State var date = Date()
    
    var onClose: () -> Void

    let colors: [StoryColor] = [
            .init(name: "贴心粉", color: Color.pink),
            .init(name: "沉稳蓝", color: Color.blue),
            .init(name: "活泼绿", color: Color.green),
            .init(name: "神秘紫", color: Color.purple),
            .init(name: "元气橘", color: Color.orange)
        ]
        
    @State private var selectedColor: Int = 0

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(hex: "C9E2F7"))
                    .frame(height: 60)
                Text("高光时刻")
                    .font(
                        Font.custom("Lato", size: 20)
                            .weight(.bold)
                    )
                    .foregroundColor(.black)
            }
            TextField("", text: $title)
                .placeholder(when: title.isEmpty) {
                        Text("标题").foregroundColor(Color(hex: "858585"))
                }
                .padding(.vertical,10)
                .padding(.horizontal)
                .background(Color(hex: "D9D9D9"))
                .cornerRadius(8)
                .padding(.horizontal, 32)
                .padding(.top, 30)

            
            Menu {
                ForEach(0 ..< colors.count) { index in
                    Button(action: {
                        self.selectedColor = index
                    }) {
                        HStack {
                            Text(colors[index].name)
                            Spacer().frame(width: 50)
                            Circle()
                            .fill(colors[selectedColor].color)
                        }
                    }
                }
            } label: {
                HStack {
                    Text("故事颜色")
                    Spacer()
                    Image(systemName: "arrow.down")
                }
                .foregroundColor(Color(hex: "858585"))
                .padding(.vertical,10)
                .padding(.horizontal)
                .background(Color(hex: "D9D9D9"))
                .cornerRadius(8)
                .padding(.horizontal, 32)
            }
            
            
            
            Image("calendar")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .padding(.vertical, 30)
            
            Button(action: { onClose() }, label: {
                HStack{
                    Text("確定")
                        .font(.system(size: 24))
                        .bold()
                        .kerning(2)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 30)
                }
                .foregroundColor(.white)
                .padding(.vertical,8)
                .padding(.horizontal)
                .background(Color(hex: "8FBDE4"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.10), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            })
            .padding(.bottom, 40)
            
        }
        .frame(width: 330)
        .background( Rectangle().foregroundColor(Color(hex: "EFEFEF")) )
        
    }
}

#Preview {
    NewEventView() {
        
    }
}

struct StoryColor: Identifiable {
    var id: String { name }
    let name: String
    let color: Color
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
