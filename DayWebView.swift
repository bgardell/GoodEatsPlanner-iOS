//
//  DayWebView.swift
//  MealTracker
//
//  Created by bgardell on 11/20/16.
//  Copyright © 2016 bgardell. All rights reserved.
//

import UIKit

class DayWebView: UIViewController {
    
    var dayHtmlString : String? // MODEL

    @IBOutlet weak var dayHtml: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayHtml.loadHTMLString(dayHtmlString!, baseURL: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
