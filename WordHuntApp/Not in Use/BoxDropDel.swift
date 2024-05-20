////
////  BoxDropDel.swift
////  WordHuntApp
////
////  Created by Riley Koo on 5/20/24.
////
//
//import SwiftUI
//
//struct BoxDropDelegate: DropDelegate {
//    let item: box
//    @Binding var listData: grid
//    @Binding var current: box?
//
//    func dropEntered(info: DropInfo) {
//        if listData.isNextTo(b1: item, b2: current ?? box()) && !item.isSelected {
//            listData.select(box: item)
//        }
//    }
//
//    func dropUpdated(info: DropInfo) -> DropProposal? {
//        return DropProposal(operation: .cancel)
//    }
//
//    func performDrop(info: DropInfo) -> Bool {
//        listData.deselect()
//        self.current = nil
//        return true
//    }
//}
