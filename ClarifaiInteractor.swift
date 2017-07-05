//
//  ClarifaiInteractor.swift
//  Badalementini
//
//  Created by Lord Summerisle on 7/4/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import Foundation
import Clarifai

class ClarifAIInteractor {
    
    private struct Constants {
        static let appID = "4v3ZeDGdMESTRvdGubWRykNCjh7WfZhHmKrPO7lp"
        static let appSecret = "1Yno0WviiL1DAEl545qGwmnKSep9AstjKWcxTNz3"
        static let general = "general-v1.3"
    }
    
    class func analyzeImageByURL(imageURL: String, handler: @escaping (_ clarifAIResult: [ClarifaiConcept]?, _ error: Error?) -> () ) {
        let clarifAI = ClarifaiApp(appID: Constants.appID, appSecret: Constants.appSecret)
        let clarifAIImage = ClarifaiImage(url: imageURL)
        
        clarifAI?.getModelByName(Constants.general, completion: { (model, error) in
            model?.predict(on: [clarifAIImage] as! [ClarifaiImage], completion: { (outputs, error) in
                
                if error != nil {
                    handler(nil, error!)
                } else {
                    if let concepts = outputs?.first?.concepts {
                       handler(concepts, nil)
                    }
                }
            })
        })
    }
    
    class func analyzeImageByBytes(imageByte: UIImage, handler: @escaping (_ clarifAIResult: [ClarifaiConcept]?, _ error: Error?) -> () ) {
        let clarifAI = ClarifaiApp(appID: Constants.appID, appSecret: Constants.appSecret)
        let clarifAIImage = ClarifaiImage(image: imageByte)
        
        clarifAI?.getModelByName(Constants.general, completion: { (model, error) in
            model?.predict(on: [clarifAIImage] as! [ClarifaiImage], completion: { (outputs, error) in
                
                if error != nil {
                    handler(nil, error!)
                } else {
                    if let concepts = outputs?.first?.concepts {
                        handler(concepts, nil)
                    }
                }
            })
        })
    }
}
