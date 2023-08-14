//
//  BaseViewModel.swift
//  BaseViewModel
//
//  Created by Balaji on 31/08/21.
//

import SwiftUI

class BaseViewModel: ObservableObject {
    
    // Tab Bar...
    @Published var currentTab: Tab = .Post
    
    @Published var homeTab = "Sneakers"
    
    // Detail View Properties...
//    @Published var currentProduct: Product?
//    @Published var showDetail = false
}

// Enum Case for Tab Items...
enum Tab: String{
    case Post = "post"
    case Monster = "monster"
    case Timeline = "timeline"
    
    func description() -> String {
        switch self {
        case .Post:
            return "贴文"
        case .Monster:
            return "我的怪兽"
        case .Timeline:
            return "高光时刻"
        }
    }
    
}
