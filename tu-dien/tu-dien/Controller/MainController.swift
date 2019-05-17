//
//  MainController.swift
//  tu-dien
//
//  Created by BtoW on 1/20/19.
//

import UIKit
import Firebase

class MainController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vietanhButton: UIButton!
    @IBOutlet weak var translateSentencesButton: UIButton!
    @IBOutlet weak var recentWordButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    // MARK: - Property
    var searchController: UISearchController = {
        var searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Nhập từ cần tìm..."
//        searchController.searchBar.tintColor = .black
        searchController.searchBar.autocapitalizationType = .none
        return searchController
    }()
    
    
    
    lazy var db = Firestore.firestore()
    
    var entryArr = [Entry]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //        FirebaseApp.configure()
        //        self.view.backgroundColor = .red
        // Do any additional setup after loading the view.
        
        navigationItem.title = "DICTIONARY"
        navigationController?.navigationBar.barTintColor = UIColor.blue
        //        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        self.setupSearchController()
        self.setupTableView()
        self.showButton(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Register Cell
        self.tableView.register(EntryTableCell.nib, forCellReuseIdentifier: EntryTableCell.identifier)
        
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        navigationItem.searchController = self.searchController
        //        navigationItem.hidesSearchBarWhenScrolling = true
        
        
    }
    
    // MARK: - Navigation
    
    private enum Identifier {
        static let showEntry = "showEntry"
        static let translateSentences = "translateSentences"
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier
        
        if Identifier.showEntry == identifier,
            let entryController = segue.destination as? EntryController, let entry = sender as? Entry  {
            print("In prepare")
            entryController.entry = entry
        }
        else if Identifier.translateSentences == identifier {
            
        }
    }
    
    // MARK: - Method
    // Show and Hide Button
    private func showButton(_ toggle: Bool) {
        self.vietanhButton.isHidden = !toggle
        self.translateSentencesButton.isHidden = !toggle
        self.recentWordButton.isHidden = !toggle
        self.settingButton.isHidden = !toggle
        self.tableView.isHidden = toggle
    }
}


extension MainController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //
        guard !searchText.isEmpty else {return}
        let collection = String(searchText[0])
        //        print("Collection \(collection)")
        
        self.entryArr.removeAll()
        tableView.reloadData()
        //        tableView.beginUpdates()
        
        let endText = searchText + "\u{f8ff}"
        
        db.collection(collection).order(by: "title").start(at: [searchText]).limit(to: 10).end(at: [endText]).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //                    print("\(document.documentID) => \(document.data())")
                    let title = document["title"] as! String
                    let content = document["content"] as! String
                    let entry = Entry(title, content: content)
                    self.entryArr.append(entry)
                    print(entry.content)
                }
                //                print("-----")
                
                self.tableView.reloadData()
                self.showButton(false)
            }
        }
        
        //        tableView.endUpdates()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel")
        self.showButton(true)
    }
}

extension MainController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntryTableCell.identifier, for: indexPath) as? EntryTableCell else {return UITableViewCell()}
        let entry = self.entryArr[indexPath.row]
        cell.titleLabel.text = entry.title
        return cell
    }
}

extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.dequeueReusableCell(withIdentifier: EntryTableCell.identifier, for: indexPath) as? EntryTableCell else {
            fatalError("Cant downcast Cell")
        }
        let entry = self.entryArr[indexPath.row]
        performSegue(withIdentifier: "showEntry", sender: entry)
    }
    
}
