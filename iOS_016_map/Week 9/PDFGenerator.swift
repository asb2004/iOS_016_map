//
//  PDFGenerator.swift
//  iOS_016_map
//
//  Created by DREAMWORLD on 24/04/24.
//

import Foundation
import UIKit
import PDFKit

class PDFCreator: NSObject {
    
    let title: String
    let body: String
    let image: UIImage
    
    init(title: String, body: String, image: UIImage) {
      self.title = title
      self.body = body
      self.image = image
    }
    
    func createFlyer() -> Data {
        
        let pdfMetaData = [
            kCGPDFContextCreator: "Flyer Builder",
            kCGPDFContextAuthor: "raywenderlich.com"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { (context) in
            context.beginPage()
            
            let titleBottom = addTitle(pageRect: pageRect)
            let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom)
            addBodyText(pageRect: pageRect, textTop: imageBottom)
            
        }

        return data
        
    }
    
//    func addTitle(pageRect: CGRect) -> CGFloat {
//
//        let titleFont = UIFont.systemFont(ofSize: 30.0, weight: .bold)
//
//        let titleAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: titleFont]
//
//        let attributedTitle = NSAttributedString(
//                string: title,
//                attributes: titleAttributes
//            )
//
//        let titleStringSize = attributedTitle.size()
//
//        let titleStringRect = CGRect(
//                x: (pageRect.width - titleStringSize.width) / 2.0,
//                y: 40,
//                width: titleStringSize.width,
//                height: titleStringSize.height
//            )
//
//        attributedTitle.draw(in: titleStringRect)
//
//        return titleStringRect.origin.y + titleStringRect.size.height
//    }
    
    func addTitle(pageRect: CGRect) -> CGFloat {
        let titleFont = UIFont.systemFont(ofSize: 30.0, weight: .bold)
        
        // Define the maximum width for the title block
        let maxTitleWidth = pageRect.width - 40.0 // Assuming 20pt margins on each side
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: titleFont
        ]
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: titleAttributes
        )
        
        // Define a bounding rect for the title text
        let titleBoundingRect = CGRect(
            x: 20.0, // Left margin
            y: 40.0, // Top margin
            width: maxTitleWidth,
            height: CGFloat.greatestFiniteMagnitude
        )
        
        // Calculate the size required to draw the title within the bounding rect
        let titleStringRect = attributedTitle.boundingRect(
            with: titleBoundingRect.size,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        // Center the title horizontally within the page
        let centeredTitleRect = CGRect(
            x: (pageRect.width - titleStringRect.width) / 2.0,
            y: titleBoundingRect.origin.y,
            width: titleStringRect.width,
            height: titleStringRect.height
        )
        
        // Draw the title
        attributedTitle.draw(in: centeredTitleRect)
        
        // Return the bottom Y coordinate of the title
        return centeredTitleRect.origin.y + centeredTitleRect.size.height
    }
    
    func addBodyText(pageRect: CGRect, textTop: CGFloat) {
        let textFont = UIFont.systemFont(ofSize: 20.0, weight: .regular)
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let textAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont
            ]
        let attributedText = NSAttributedString(
                string: body,
                attributes: textAttributes
            )
       
        let textRect = CGRect(
                x: 20,
                y: textTop + 20,
                width: pageRect.width - 40,
                height: pageRect.height - textTop - 40
            )
        
        if textRect.height < attributedText.accessibilityFrame.height {
            print("long")
        }
        
        attributedText.draw(in: textRect)
    }
    
    func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
      
        let maxHeight = pageRect.height * 0.4
        let maxWidth = pageRect.width * 0.8

        let aspectWidth = maxWidth / image.size.width
        let aspectHeight = maxHeight / image.size.height
        let aspectRatio = min(aspectWidth, aspectHeight)

        let scaledWidth = image.size.width * aspectRatio
        let scaledHeight = image.size.height * aspectRatio

        let imageX = (pageRect.width - scaledWidth) / 2.0
        let imageRect = CGRect(x: imageX, y: imageTop + 20,
                             width: scaledWidth, height: scaledHeight)

        image.draw(in: imageRect)
        return imageRect.origin.y + imageRect.size.height
    }
    
}
