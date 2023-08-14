//
//  LaunchScreenView.swift
//  TestProject
//
//  Created by Tunde Adegoroye on 19/03/2022.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @State private var isActive = false
    @State private var bounceCount = 0
    @State private var bounceCountrandom1 = 0
    @State private var bounceCountrandom2 = 0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack { // 使用 ZStack 来重叠图片
                Image("loadback")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all) // 忽略安全区域，使图片填充整个屏幕
                
                Image("loadhert") // 前景图片
                    .resizable()
                    .scaledToFit()
                    .scaledToFit()
                    .scaleEffect(0.1) // 0.5 表示缩小为原始尺寸的一半
                    .offset(x: -350, y: -500)
                    .offset(x: CGFloat(bounceCount) * 370, y: CGFloat(bounceCount) * CGFloat(bounceCount) * 250) // 根据 bounceCount 控制向右跳跃的距离
                    .onAppear() {
                        bounceImage()
                    }
                    .offset(x: CGFloat(bounceCountrandom1)  , y: CGFloat(bounceCountrandom2) ) // 根据 bounceCount 控制向右跳跃的距离
                    .onTapGesture() {
                        bounceImagerandom()
                    }
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
        
    }
    
    func bounceImage() {
        withAnimation(.interpolatingSpring(stiffness: 500, damping: 20).speed(0.5)) { // 启动动画
            if bounceCount < 3 {
                // 向右跳跃
                bounceCount += 1
            } else {
                // 移动到指定位置
                bounceCount = 0
            }
        }
    }
    
    func bounceImagerandom() {
        withAnimation(.interpolatingSpring(stiffness: 500, damping: 20).speed(0.5)) { // 启动动画
            bounceCountrandom1 = Int.random(in: -100...100)
            bounceCountrandom2 = Int.random(in: -100...100)// 生成1到100之间的随机整数
            
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

