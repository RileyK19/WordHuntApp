//
//  UI.swift
//  WordHuntApp
//
//  Created by Riley Koo on 5/20/24.
//

import SwiftUI

import AudioToolbox

struct gridView: View {
    @Binding var grid: grid
    @State var current: box? = nil
    @State var offsets: [CGSize] = [.zero, .zero, .zero, .zero, .zero,
                                    .zero, .zero, .zero, .zero, .zero,
                                    .zero, .zero, .zero, .zero, .zero,
                                    .zero, .zero, .zero, .zero, .zero,
                                    .zero, .zero, .zero, .zero, .zero]
    let squareSide: CGFloat = 150
    @State var lastOffset: CGSize = .zero
    
    @State var curX = 0
    @State var curY = 0
    
    @Binding var score: Int
    @State var wordsSubmitted: [String] = []
    
    var body: some View {
        VStack {
            Spacer()
            Text("Score: \(score)")
                .font(.title2.bold())
            Spacer()
            Text("\(grid.lettersSelected)")
                .font(.title2.bold())
                .textCase(.uppercase)
                .foregroundStyle(
                    (isReal(word: grid.lettersSelected) && grid.lettersSelected.count > 2) ? (wordsSubmitted.contains(grid.lettersSelected) ? .yellow : .green) : .primary
                )
            Spacer()
            ForEach(Array(0..<gridSize), id:\.self) { y in
                HStack {
                    Spacer()
                        .frame(width: 20)
                    ForEach(Array(0..<gridSize), id:\.self) { x in
                            Text("\(grid.boxes[x + gridSize*y].letter)")
                                .font(.title2.bold())
                                .textCase(.uppercase)
                                .frame(width: 65, height: 65)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: 75, height: 75)
                                        .foregroundStyle((offsets[x+gridSize*y] == .zero) ? .blue : .green)
                                        .opacity(0.75)
                                )
                                .padding(4)
                            .gesture(
                                DragGesture()
                                    .onChanged {
                                        if current != nil {
                                            grid.select(box: current!)
                                            
                                            offsets[curX + gridSize*curY] = $0.translation
                                            
                                            
                                            let tmpW = $0.translation.width-lastOffset.width
                                            let tmpH = $0.translation.height-lastOffset.height
                                            
                                            var yOff = ((abs(tmpH) < squareSide/2) || abs(tmpH) > 3*squareSide/2 || abs(tmpW) > 3*squareSide/2) ? 0 : Int(tmpH/abs(tmpH))
                                            var xOff = (abs(tmpW) < squareSide/2 || abs(tmpW) > 3*squareSide/2 || abs(tmpH) > 3*squareSide/2) ? 0 : Int(tmpW/(abs(tmpW)))
                                            
                                            if xOff != 0 && abs(tmpH) > squareSide/4 && abs(tmpH) < squareSide/2 {
                                                yOff = Int(tmpH/abs(tmpH))
                                            }
                                            
                                            if yOff != 0 && abs(tmpW) > squareSide/4 && abs(tmpW) < squareSide/2 {
                                                xOff = Int(tmpW/abs(tmpW))
                                            }
                                            
                                            if (xOff != 0 || yOff != 0) &&
                                                (curY + yOff < gridSize) &&
                                                (curX + xOff < gridSize) &&
                                                (curY + yOff > -1) &&
                                                (curX + xOff > -1) &&
                                                grid.isNextTo(b1: current!, b2: (grid.boxes[curX + xOff + gridSize*(curY + yOff)])) &&
                                                !grid.boxes[curX + xOff + gridSize*(curY + yOff)].isSelected
                                            {
                                                
                                                lastOffset = $0.translation
                                                
                                                grid.select(x: curX + xOff, y: curY + yOff)
                                                current = grid.boxes[curX + xOff + gridSize*(curY + yOff)]
                                                
                                                curX += xOff
                                                curY += yOff
                                            }
                                        } else {
                                            current = (current==nil) ? grid.boxes[x + gridSize*y] : current
                                            curX = x
                                            curY = y
                                        }
                                    }
                                    .onEnded { value in
                                        if isReal(word: grid.lettersSelected) && grid.lettersSelected.count > 2 && !wordsSubmitted.contains(grid.lettersSelected) {
                                            score += calcScore(grid.lettersSelected.count)
                                            wordsSubmitted.append(grid.lettersSelected)
                                            
//                                            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }
                                        }
                                        
                                        offsets = []
                                        for _ in 0..<gridSize*gridSize {
                                            offsets.append(.zero)
                                        }
                                        grid.deselect()
                                        current = nil
                                        lastOffset = .zero
                                    }
                            )
                    }
                    Spacer()
                        .frame(width: 20)
                }
            }
            Spacer()
        }
        .onAppear{
            grid.deselect()
            offsets = []
            for _ in 0..<gridSize*gridSize {
                offsets.append(.zero)
            }
        }
        .onDisappear {
            current = nil
            offsets = [.zero, .zero, .zero, .zero, .zero,
                                            .zero, .zero, .zero, .zero, .zero,
                                            .zero, .zero, .zero, .zero, .zero,
                                            .zero, .zero, .zero, .zero, .zero,
                                            .zero, .zero, .zero, .zero, .zero]
            lastOffset = .zero
            
            curX = 0
            curY = 0
            
            wordsSubmitted = []
        }
    }
}

func calcScore(_ length: Int) -> Int {
    switch length {
    case 0: return 0
    case 1: return 0
    case 2: return 0
    case 3: return 100
    case 4: return 400
    case 5: return 800
    case 6: return 1400
    case 7: return 1800
    case 8: return 2200
    default: return (length - 8) * 400 + 2200
    }
}
