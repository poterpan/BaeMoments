//
//  PostsView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/4.
//

import SwiftUI
import Combine

struct MonsterView: View {
    @ObservedObject var viewModel = CharacterViewModel()

    @State private var progressValue: Float = 0.5
    
    var level: Int {
        viewModel.calculateLevelAndPercentage().level
    }
    
    var percentage: Double {
        viewModel.calculateLevelAndPercentage().percentage
    }

    var body: some View {
        VStack {
//            let (level, percentage) = viewModel.calculateLevelAndPercentage()
            Text("我的怪兽")
                .bold()
                .font(.custom("Helvetica", size: 24))
                .padding(30)
            
            Text("Experience Points: \(viewModel.experiencePoints)")
                .font(.caption)
            
            Image("lv\(level)")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            

            Image("shadow")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            
            HStack{
                Text("LV \(level)")
                    .font(.system(size:20,weight: .bold))
                
                ZStack {
                    GeometryReader { geometry in
                        
                        ZStack(alignment: .leading) {
                            
                            RoundedRectangle(cornerRadius: 20)  // 背景圓角視圖
                                .foregroundColor(Color.gray.opacity(0.3))
                                .frame(height: 22)
                            
                            RoundedRectangle(cornerRadius: 20)  // 進度條視圖
                                .foregroundColor(Color.yellow)
                                .frame(width: CGFloat(self.percentage) * geometry.size.width, height: 22)
                            
                        }
                        
                    }
                }
                .padding(.horizontal, 5)
                .frame(height: 22)

                Text("\(Int(percentage*100))%")
                    .font(.system(size:20,weight: .bold))
                
            }
            .padding()

            
            ScrollView {
                Button {
                    viewModel.experiencePoints += 40
                } label: {
                    Image("mission1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 325)
                }

                Button {
                    viewModel.experiencePoints += 20
                } label: {
                    Image("mission2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 325)
                }
                
            }
        }
    }
}

#Preview {
    MonsterView()
}

class CharacterViewModel: ObservableObject {
    @Published var experiencePoints: Int = 0
    
    func calculateLevelAndPercentage() -> (level: Int, percentage: Double) {
        var level = 1
        var nextLevelXP = 100  // Experience points required for Level 1
        var prevLevelXP = 0
        
        // Find the current level based on experience points
        while experiencePoints >= nextLevelXP {
            level += 1
            prevLevelXP = nextLevelXP
            nextLevelXP *= 2
        }
        
        // Calculate the percentage of completion towards the next level
        let percentage = ((Double(experiencePoints) - Double(prevLevelXP)) / (Double(nextLevelXP) - Double(prevLevelXP)))
        
        return (level, percentage)
    }
}
