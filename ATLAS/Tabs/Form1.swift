//
//  Form.swift
//  ATLAS
//
//  Created by phuong phan on 21/05/2023.
//

import Foundation
import SwiftUI

struct Form1: View {
    @State private var addNote: String = ""
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextField("Add Note 12123213", text: $addNote)
        }.background(.white)
    }
}
