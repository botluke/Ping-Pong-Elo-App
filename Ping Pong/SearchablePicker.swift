//
//  SearchablePicker.swift
//  Ping Pong
//
//  Created by Luke Botros on 4/18/24.
//

import Foundation
import SwiftUI

struct SearchablePicker: View {
    @Binding var selection: Player
    var options: [Player]
    
    @Binding  var searchText: String
    var placeholder: String
    @State private var isSearching = true
    @State private var filteredOptions: [Player] = []
    
    
    var body: some View {
        VStack {
            if isSearching || !searchText.isEmpty {
                
                ForEach(filteredOptions) { option in
                    
                    Button(action: {
                        selection = option
                        isSearching = false
                    }) {
                        Text(option.name)
                    }
                    
                }
                .transition(.slide)
            }
            
            TextField(placeholder, text: $searchText)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .onTapGesture {
                    isSearching = true
                }
                .autocorrectionDisabled()
            
            //Spacer()
            
        }
        .padding()
        .onChange(of: searchText) { oldValue, newValue in
            isSearching = true
            filteredOptions = options.filter{$0.name.lowercased().contains(searchText.lowercased())}
            if options.filter({$0.name.lowercased().contains(searchText.lowercased())}).count >= 1 {
                selection = options.first(where: {$0.name.lowercased().contains(searchText.lowercased())})!
            }
        }
        .onAppear{
            filteredOptions = options.filter{$0.name.lowercased().contains(searchText.lowercased())}
        }
    }
}
