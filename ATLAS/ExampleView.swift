//
//  ExampleView.swift
//  ATLAS
//
//  Created by phuong phan on 28/05/2023.
//

import Foundation
import SwiftUI

struct User: Identifiable {
    let id: Int
    var name: String
    var score: Int
}

struct ExampleView: View {
    @State private var users = [
            User(id: 1, name: "Taylor Swift", score: 90),
            User(id: 2, name: "Justin Bieber", score: 80),
            User(id: 3, name: "Adele Adkins", score: 85)
        ]
    
    var body: some View {
        VStack {
            Text("Example View").foregroundColor(Color.black)
            Table(users) {
                        TableColumn("Name", value: \.name)
                        TableColumn("Score") {
                            Text(String($0.score))
                        }
                    }
        }
        
    }
}
