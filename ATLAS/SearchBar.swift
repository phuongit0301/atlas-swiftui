//
//  SearchBar.swift
//  ATLAS
//
//  Created by phuong phan on 18/06/2023.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            _text = text
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
