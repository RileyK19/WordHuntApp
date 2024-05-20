//
//  ContentView.swift
//  WordHuntApp
//
//  Created by Riley Koo on 5/20/24.
//

import SwiftUI

struct ContentView: View {
//    @State var words: [String: Int]?
//    @State var wordsModel: Model = Model()
//    @State var words: [String] = ["no words yet..."]
    var body: some View {
        mainView()
        
//        VStack {
//            ScrollView {
//                Text("test")
////                ForEach(Array(words?.keys ?? ["no keys" : 1].keys), id: \.self) { key in
////                    Text("heres a word: \(key)")
////                }
//                ForEach(Array(0..<words.count), id:\.self) { x in
//                    Text(words[x])
//                }
//            }
//            .onAppear {
//                getWords()
//            }
//        }
//        .padding()
        
    }
//    func setArray() {
//        words = wordsModel.getSeperated()
//    }
//    func getWords() {
//        wordsModel.load(file: "Words")
//        
//        setArray()
//        
////        guard let url = URL(string: "https://raw.githubusercontent.com/dwyl/english-words/master/words_dictionary.json")
////        else {
////            print("error")
////            words = nil
////            return
////        }
////        do {
////            let (data, _) = try await URLSession.shared.data(from: url)
////            if let decodedResponse = try? JSONDecoder().decode([String : Int].self, from: data) {
////                words = decodedResponse
////            }
////        } catch {
////            print("Invalid data")
////        }
//    }
}
