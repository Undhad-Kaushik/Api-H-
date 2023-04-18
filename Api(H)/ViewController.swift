//
//  ViewController.swift
//  Api(H)
//
//  Created by undhad kaushik on 05/03/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    
    @IBOutlet weak var ApiTabelView: UITableView!

    var arrCount: [Count] = []
    var arr: Count!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        nibRegister()
        apiH()
    }
    private func nibRegister(){
        let nibFile: UINib = UINib(nibName: "TableViewCell", bundle: nil)
        ApiTabelView.register(nibFile, forCellReuseIdentifier: "cell")
        ApiTabelView.separatorStyle = .none
        ApiTabelView.dataSource = self
        ApiTabelView.delegate = self
    }
    
    private func apiH(){
        AF.request("https://api.publicapis.org/entries",method: .get).responseData{ [self] response in
            debugPrint(response)
            if response.response?.statusCode == 200{
                guard let apiData = response.data else { return }
                do{
                    let result = try JSONDecoder().decode(Count.self, from: apiData)
                    print(result)
                    arr = result
                    ApiTabelView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                print("Wrong")
            }
        }
    }

    
}


struct Count: Decodable{
    var count: Int
    var entries: [Entries]
}

struct Entries: Decodable{
    var api: String
    var description: String
    var auth: String
    var https: Bool
    var cors: String
    var link: String
    var category: String
    
    enum CodingKeys: String , CodingKey{
        case api = "API"
        case description = "Description"
        case auth = "Auth"
        case https = "HTTPS"
        case cors = "Cors"
        case link = "Link"
        case category = "Category"
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr?.entries.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.label1.text = arr.entries[indexPath.row].api
        cell.label2.text = arr.entries[indexPath.row].description
        cell.label3.text = "\(arr.entries[indexPath.row].https)"
        cell.label4.text = arr.entries[indexPath.row].category
        cell.label5.text = arr.entries[indexPath.row].cors
        cell.label6.text = arr.entries[indexPath.row].link

        return cell
    }
}
