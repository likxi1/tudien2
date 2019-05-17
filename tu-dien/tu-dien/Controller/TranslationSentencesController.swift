//
//  TranslationSentencesController.swift
//  tu-dien
//
//  Created by BtoW on 1/26/19.
//

import UIKit

class TranslationSentencesController: UIViewController {

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var outputTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextView.text = "Input Anything..."
        outputTextView.text = ""
        
        inputTextView.delegate = self
        title = "Translation"
//        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func translateAction(_ sender: Any) {
        TranslateServices.shared.translate(inputTextView.text) { (result, err) in
            if let result = result {
                let trans = result.sentences.first?.trans
                self.outputTextView.text = trans
            }
            else {
                self.outputTextView.text = "Loi"
            }
        }
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

extension TranslationSentencesController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.inputTextView.text = ""
    }
}
