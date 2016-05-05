//
//  ViewControllerPDF.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/4/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerPDF: UIViewController, UIDocumentInteractionControllerDelegate {

    var path = ""
    var page : Int = 1
    var maxPages: Int!
    var pageHeight : CGFloat!
    var url : NSURL!
   
    
    @IBOutlet weak var imgViewPdf: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        path = NSBundle.mainBundle().pathForResource("file", ofType: "pdf")!
        
        url = NSURL.fileURLWithPath(path)
        
        imgViewPdf.image = drawPDFfromURL(url)
        
     
        
    
        
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }

    
    func drawPDFfromURL(url: NSURL) -> UIImage? {
        guard let document = CGPDFDocumentCreateWithURL(url) else { return nil }
        guard let page = CGPDFDocumentGetPage(document, page) else { return nil }
        
        let pageRect = CGPDFPageGetBoxRect(page, .MediaBox)
        
        UIGraphicsBeginImageContextWithOptions(pageRect.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context,pageRect)
        
        CGContextTranslateCTM(context, 0.0, pageRect.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CGContextDrawPDFPage(context, page);
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        maxPages = CGPDFDocumentGetNumberOfPages(document)
        
        return img
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
