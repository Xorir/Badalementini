//
//  ImageDetailViewController.swift
//  Badalementini
//
//  Created by Lord Summerisle on 6/24/17.
//  Copyright © 2017 ErmanMaris. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    var annotationInfo: Annotation!
    
    @IBOutlet weak var detailImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let metaData = annotationInfo.metaData else { return }
        detailImageView.getCachedImage(urlString: metaData)

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
