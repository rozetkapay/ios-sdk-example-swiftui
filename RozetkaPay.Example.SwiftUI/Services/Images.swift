//
//  Images.swift
//  RozetkaPay.Example.SwiftUI
//
//  Created by Ruslan Kasian Dev on 29.05.2025.
//

import UIKit
import SwiftUI

enum Images: String {
    
    case arrowLeft = "chevron.left"
    
    case plus
    case checkmark
    case checkmarkSquareFill
    case square
    
    case cartItemFirst
    case cartItemSecond
    case cartItemThird
    case cartItemFourth
    
    case cartItemFifth
    case cartItemSixth
    case cartItemSeventh
    case cartItemEighth
    
    case paymentSystemDefault
    case paymentSystemMastercard
    case paymentSystemVisa
    case paymentSystemProstir
    
    
}

//MARK: - Public Methods and Properties
extension Images {
    var name: String {
        return self.camelCaseToDotCase()
    }
    
    func image() -> UIImage? {
        return self.loadUIImage()
    }
    
    func image() -> Image {
        return self.loadSwiftUIImage()
    }
}

//MARK: - Private Methods
private extension Images {
    func loadSwiftUIImage() -> Image {

        if UIImage(named: self.name, in: .main, with: nil) != nil {
            return Image(self.name, bundle: .main)
        }
        
        return Image(systemName: self.name)
    }
    
    func loadUIImage() -> UIImage? {
        if let image = UIImage(
            named: self.name,
            in: .main,
            with: nil
        ) {
            return image
        }
        
        return UIImage(systemName: self.name)
    }
    
    func camelCaseToDotCase() -> String {
        var result = ""
        for (index, character) in self.rawValue.enumerated() {
            if character.isUppercase {
                if index != 0 {
                    result.append(".")
                }
                result.append(character.lowercased())
            } else {
                result.append(character)
            }
        }
        return result
    }
}
