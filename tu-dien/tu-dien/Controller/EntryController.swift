//
//  EntryController.swift
//  tu-dien
//
//  Created by BtoW on 1/20/19.
//

import UIKit

class EntryController: UIViewController {

    @IBOutlet weak var contentTextView: UITextView!
    //    var testModel = Entry("Hello", content: "Xin Chao")
    
    var entry: Entry!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let entry = self.entry {
            navigationItem.title = entry.title
            contentTextView.text = entry.content
//            print(entry.content)
        }
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
