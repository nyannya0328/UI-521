//
//  Home.swift
//  UI-521
//
//  Created by nyannyan0328 on 2022/03/28.
//

import SwiftUI

struct Home: View {
    @State var progress : CGFloat = 0
    @State var characters : [Character] = characters_
    @State var shuffledRows : [[Character]] = []
    @State var rows : [[Character]] = []
    
    @State var animatedWrongText : Bool = false
    @State var dropCount : CGFloat = 0
    var body: some View {
        VStack(spacing:20){
            
            TopBar()
            
            
            VStack(alignment:.leading,spacing: 20){
                
                Text("From the Sentece")
                    .font(.body)
                    .fontWeight(.ultraLight)
                
                Image("Character")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing,80)
                
                
                
            }
            .padding(.top,20)
            
            
            DropArea()
                .padding(.vertical,15)
            
            DragArea()
            
            if progress == 1{//
                Button {
                    
                } label: {
                 
                    Text("Horrah Completed!")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background{
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color("Green"))
                        }
                }
                .padding(.top,30)
            }
               
            
         
            
        }
        .padding()
        .onAppear {
            
            
            
            if rows.isEmpty{
                
                characters = characters.shuffled()
                shuffledRows = generateGrid()
                characters = characters_
                rows = generateGrid()
                
            }
        }
        .offset(x: animatedWrongText ? -30 : 0)
        
    }
    @ViewBuilder
    func DropArea()->some View{
        
        VStack(spacing:15){
            
            ForEach($rows,id:\.self){$row in
                
                
                HStack(spacing:10){
                    
                    
                    ForEach($row){$item in
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical,5)
                            .padding(.horizontal,item.padding)
                            .opacity(item.isShowing ? 1 : 0)
                            .background(
                            
                            
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
                            
                            )
                          
                        
                            .background(
                            
                            
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(.gray)
                                    .opacity(item.isShowing ? 1 : 0)
                            
                            )
                            .onDrop(of: [.url], isTargeted: .constant(false)) { provider in
                                
                                
                                if let first = provider.first{
                                    
                                    let _ = first.loadObject(ofClass: URL.self) { value, err in
                                        
                                        guard let url = value else{return}
                                        
                                        if item.id == "\(url)"{
                                            
                                            
                                            dropCount += 1
                                            
                                            let progress = (dropCount / CGFloat( characters.count))
                                            
                                            
                                            withAnimation {
                                                item.isShowing = true
                                                
                                                updateShuffuledArray(character: item)
                                                
                                                self.progress = progress
                                                
                                            }
                                            
                                            
                                        }
                                        else{
                                            
                                            aniamtedView()
                                        }
                                        
                                        
                                    }
                                }
                                
                                
                                return false
                            }
                    }
                    
                    
                }
                if rows.last != row{
                    
                    Divider()
                }
                
            }
        }
        
        
    }
    
    @ViewBuilder
    func DragArea()->some View{
        
        VStack(spacing:15){
            
            ForEach(shuffledRows,id:\.self){row in
                
                
                HStack(spacing:10){
                    
                    
                    ForEach(row){item in
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical,5)
                            .padding(.horizontal,item.padding)
                            .background{
                                
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(.gray)
                                
                            }
                          
                            .onDrag({
                                
                                return .init(contentsOf: URL(string: item.id))!
                                
                            })
                        
                            .background{
                                
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.35) : .clear)
                                
                                
                            }
                           
                    }
                    
                    
                }
                if shuffledRows.last != row{
                    
                    Divider()
                }
                
            }
        }
        
        
        
    }
    
  
    @ViewBuilder
    func TopBar()->some View{
        
        HStack{
            
            Button {
                
            } label: {
                
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.gray.opacity(0.6))
            }
            
            
            GeometryReader{proxy in
                
                ZStack(alignment:.leading){
                    
                    Capsule()
                        .fill(.gray.opacity(0.4))
                    
                    Capsule()
                        .fill(Color("Green"))
                        .frame(width: proxy.size.width * progress)
                    
                    
                    
                }
                
            }
            .frame(height:25)
            
            
            
            Button {
                
            } label: {
                
                Image(systemName: "suit.heart.fill")
                    .font(.title3)
                    .foregroundColor(.red)
            }
            
            
            

            
        }
        
    }
    
    func generateGrid()->[[Character]]{
        
        
        for item in characters.enumerated(){
            
            
            let textSize = textSize(character: item.element)
            
            characters[item.offset].textSize = textSize
        }
        
        var gridArray : [[Character]] = []
        var tempArray : [Character] = []
        
        var currentWidth : CGFloat = 0
        
        let totalScreenWidth = UIScreen.main.bounds.width - 30
        
        for character in characters {
            
            
            currentWidth += character.textSize
            
            if currentWidth < totalScreenWidth{
                
                tempArray.append(character)
            }
            else{
                
                
                gridArray.append(tempArray)
                tempArray = []
                currentWidth = character.textSize
                tempArray.append(character)
            }
        }
        
        if !tempArray.isEmpty{
            
            gridArray.append(tempArray)
        }
        
        return gridArray
        
    }
    
    
    func textSize(character : Character)->CGFloat{
        
        
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font:font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        return size.width + (character.padding * 2) + 15
        
        
    }
    
    
    
    func updateShuffuledArray(character : Character){
        
        for index in shuffledRows.indices{
            
            for subIndex in shuffledRows[index].indices{
                
                if shuffledRows[index][subIndex].id == character.id{
                    
                    shuffledRows[index][subIndex].isShowing = true
                    
                    
                }
                
                
                
            }
            
            
        }
        
        
        
    }
    
    func aniamtedView(){
        
        
        withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)){
            
            animatedWrongText = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)){
                
                animatedWrongText = false
            }
            
        }
        
      
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
