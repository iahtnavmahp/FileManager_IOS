//
//  HomeViewController.swift
//  FileManager_IOS
//
//  Created by Pham Van Thai on 15/04/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var dataSave: String = ""
    var fileIO = DocumentManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        
        // 1. Ghi String vào file trong document
        // 2. Ghi append một string khác vào file ở bước 1, đọc file và in chuỗi đã ghi
        //        fileIO.writeString(dataSave: "test", documentName: "dataString.txt")
        //        print(fileIO.readString(documentName: "dataString.txt"))
        // 3. Ghi Dictionary vào file trong document, sau đó ghi mở rộng thêm một string khác vào document, Đọc và in dữ liệu từ file đã ghi
        //        fileIO.writeDictionary(dataSave: "thaipv", documentName: "dataDictionary.txt")
        //        print(fileIO.readString(documentName: "dataDictionary.txt"))
        // 4. Viết code kiểm tra một file có tồn tại hay không
        //        let pathFile = fileIO.getDocumentFilePath(fileName: "MyAppFiles/dataDictionary.txt")
        //        print(pathFile.checkFileExist())
        //        fileIO.readDataJson()
        // 5. Tạo folder Document/Images, Ghi 10 ảnh vào thư mục Document/Images, đặt tên ảnh image1...10.png
        // 6. Viết code đọc và hiển thị 10 ảnh lên giao diện: Có tên và ảnh, độ phân giải ảnh.
        // 7. Viết code tự động cập nhật danh sách ảnh nếu có file ảnh bị xoá trong thư mục Document/Images
        // 8. Viết code xoá ảnh image1.png, kiểm tra màn hình tự động cập nhật lại danh sách ảnh đã xoá ảnh 1
        //       let _ = fileIO.createForderDocumentsDirectory(folderName: "Images")
        //        fileIO.getListImage() { done in
        //            if done {
        //                self.load()
        //            }
        //        }
        // 9. Viết code kiểm tra và xoá thư mục Document/Images
        //        fileIO.deleteFileFromDocument(fileName: "Images")
        // 10. Viết code ghi một chuỗi JSON vào thư mục Temp/ sau đó đọc file và in chuỗi JSON
        //        fileIO.saveDataJsonToTemp()
        //        fileIO.readDataJson()
    }
    
    func configTableView(){
        let nib = UINib(nibName: "DetailTableViewCell", bundle: .main)
        myTableView.register(nib, forCellReuseIdentifier: "DetailTableViewCell")
        myTableView.delegate = self
        myTableView.dataSource = self
    }
    
    func load(){
        fileIO.getImageFromDocument() {done in
            if done {
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            }
        }
    }
    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileIO.lisImgResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        cell.resolutionLabel?.text = fileIO.lisImgResult[indexPath.row].resolution
        cell.titleLabel?.text = fileIO.lisImgResult[indexPath.row].name
        cell.avatarImg.image = fileIO.lisImgResult[indexPath.row].image
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        fileIO.lisImgResult.remove(at: indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        fileIO.deleteFileFromDocument(fileName: "Images/image\(indexPath.row).png")
    }
}
extension HomeViewController: CheckReferenceDocumentDelegate {
    func pushCountReference(idx: Int) {
        if idx - 2 != fileIO.lisImgResult.count {
            load()
        }
    }
}
