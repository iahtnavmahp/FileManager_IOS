//
//  ViewController.swift
//  FileManager_IOS
//
//  Created by Pham Van Thai on 13/04/2022.
//

import UIKit

class ViewController: UIViewController {
  
    @IBOutlet weak var myTableView: UITableView!
    
    var dataSave: String = ""
    var fileIO = DocumentManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       load()
        configTableView()
//        for i in 1...13 {
//            print(fileIO.getDocumentFilePath(fileName: "Images/image\(i).png").checkFileExist())
//        }
//        let dic = [12:23]
//        fileIO.writeDictionary(dataSave: dic, documentName: "dataDictionary.txt")
//        print(fileIO.readString(documentName: "dataDictionary.txt"))
//        let encoder = JSONEncoder()
//        if let jsonData = try? encoder.encode(dic) {
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                print(jsonString)
//            }
//        }
//        fileIO.writeString(dataSave: "2706 ", documentName: "dataString.txt")
//        print(fileIO.readString(documentName: "dataString.txt"))
//        fileIO.writeString(dataSave: "thaisaker", documentName: "test.txt")
        //        let fileContent = "Custom Folder"
        //        let customFileName = "dataString.txt"
        //
        //        do {
        //            try fileIO.write(fileContent, toDocumentNamed: customFileName, customFoder: "MyAppFiles")
        //        } catch {
        //            print(error.localizedDescription)
        //        }
//        let urlD = fileIO.getDocumentFilePath(fileName: "MyAppFiles/dataString.txt")
//        var dataString: String = "clo clo"
//        do {
//            let data = try Data(contentsOf: urlD)
//            dataSave = String(data: data, encoding: .utf8) ?? ""
//            print("Content File: \(dataSave)")
//        } catch {
//            print(error.localizedDescription)
//        }
//        dataString += dataSave
//        do {
//            try Data(dataString.utf8).write(to: urlD)
//
//
//        } catch {
//            print("Can not write file")
//
//        }
//
//        do {
//            let data = try Data(contentsOf: urlD)
//            dataSave = String(data: data, encoding: .utf8) ?? ""
//            print("Content File: \(dataSave)")
//        } catch {
//            print(error.localizedDescription)
//        }
    }
    func configTableView(){
        let nib = UINib(nibName: "DetailTableViewCell", bundle: .main)
        myTableView.register(nib, forCellReuseIdentifier: "DetailTableViewCell")
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    func load(){
        fileIO.getImageFromDocumentDirectory() {done in
            if done {
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileIO.lisImgResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        cell.titleLabel?.text = "img\(indexPath.row)"
        cell.avatarImg.image = fileIO.lisImgResult[indexPath.row]
        return cell
    }
}



