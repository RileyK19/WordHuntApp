//
//  File.swift
//  WordHuntApp
//
//  Created by Riley Koo on 5/20/24.
//

import Foundation

//struct word: Decodable {
//    public let words: [String : Int]
//}

//class Model: ObservableObject {
//    @Published var data: String = ""
//    init() { self.load(file: "Words") }
//    func load(file: String) {
//        if let textFileUrl = Bundle.main.url(forResource: file, withExtension: "txt") {
//                if let contents = try? String(contentsOf: textFileUrl) {
//                    data = contents
//                }
//            }
//        
////        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
////            do {
////                let contents = try String(contentsOfFile: filepath)
////                DispatchQueue.main.async {
////                    self.data = contents
////                }
////            } catch let error as NSError {
////                print(error.localizedDescription)
////            }
////        } else {
////            print("File not found")
////        }
//    }
//    func getSeperated() -> [String] {
//        return data.components(separatedBy: "\n")
//    }
//}
