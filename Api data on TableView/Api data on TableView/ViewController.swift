//
//  ViewController.swift
//  Api data on TableView
//
//  Created by apple on 11/01/19.
//  Copyright © 2019 Seraphic. All rights reserved.
//

import UIKit


struct jsonData: Decodable{
    var id : Int
    var name : String
    var username : String
    var email : String
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var Sort: UIBarButtonItem!
    
    var flag = 0
    var filteredArray = [[String]](repeating: [], count: 26)
    var sectionTitle = [String]() //["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var alphabeticalData = [String : [String]]()
    
    
    @IBAction func changeSort(_ sender: Any) {
        if flag == 0
        {
            flag = 1
            Sort.title = "Sort A-Z"

        }else if flag == 1
        {
            flag = 0
            Sort.title = "Sort Z-A"
        }
        filteredArray.reverse()
        sectionTitle.reverse()
        APITableView.reloadData()
    }
    
    
    var NameArr = [String]()
    var names = [jsonData]()
    
    @IBOutlet weak var APITableView: UITableView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Sort.title = "Sort Z-A"
        APITableView.delegate = self
        APITableView.dataSource = self
            self.getData { (x) in
                if x {
                    DispatchQueue.main.async {
                        self.APITableView.reloadData()
                    }
                }
            }
        }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray[section].count
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  APITableView.dequeueReusableCell(withIdentifier: "cell") as! APITableViewCell
        print(indexPath.section,"",indexPath.row)
        cell.APILabel?.text! = self.filteredArray[indexPath.section][indexPath.row]
        return cell
    }
    
    
    func getData (completion: @escaping (Bool) -> () ){
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")
        URLSession.shared.dataTask(with: url!) { (data, _, _) in
            do{
            self.names = try JSONDecoder().decode([jsonData].self, from: data!)
                self.NameArr = self.names.map({$0.name})
                print(self.NameArr)
//                let username = self.names.map({$0.username})
                let email = self.names.map({$0.email})

//                self.NameArr.append(contentsOf: username)
                self.NameArr.append(contentsOf: email)

                self.NameArr.sort()
                var prevInitial: Character? = nil
                self.filteredArray = [[String]]()
                for names in self.NameArr
                {
                    if names.first != prevInitial {
                        self.filteredArray.append([])
                        self.sectionTitle.append(String(names.first!).uppercased())
                        prevInitial = names.first
                    }
                    self.filteredArray[self.filteredArray.endIndex - 1].append(names)
                }
//                self.filteredArray = [self.NameArr.filter({ (element) -> Bool in
//                    return element.starts(with: "A")
//                })]
                DispatchQueue.main.async {
                    self.APITableView.reloadData()
                }
                print(self.filteredArray)
                 print(self.sectionTitle)
                completion(true)
            } catch _ {
            }
        }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(NameArr[indexPath.row], "Selected !")
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitle
    }

}

