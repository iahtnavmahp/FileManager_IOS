//
//  DocumentManager.swift
//  FileManager_IOS
//
//  Created by Pham Van Thai on 13/04/2022.
//

import Foundation
import UIKit

class DocumentManager {
    
    let urlImg = ["https://cdnmedia.webthethao.vn/uploads/2021-10-07/yasuo-chan-long-kiem.jpg",
                  "https://static.zerochan.net/Pyke.%28League.of.Legends%29.full.3589821.jpg",
                  "https://cdnmedia.webthethao.vn/uploads/2021-06-09/zed-hang-hieu.jpg",
                  "https://static.zerochan.net/Pyke.%28League.of.Legends%29.full.3589821.jpg",
                  "https://cdnmedia.webthethao.vn/uploads/img/files/images/fullsize/rong-lee-sin.jpg",
                  "https://esports-news.co.uk/wp-content/uploads/2022/03/battle-cat-jinx-prestige-skin-768x367.jpg.webp",
                  "https://gamek.mediacdn.vn/133514250583805952/2021/7/23/-1627054773972151039442.jpg",
                  "https://gamek.mediacdn.vn/133514250583805952/2021/6/22/photo-1-16243766643521398604530.jpg",
                  "https://lol-skin.weblog.vc/img/wallpaper/splash/Graves_35.webp?1646165530",
                  "https://cdngarenanow-a.akamaihd.net/webmain/static/pss/lol/items_splash/jayce_5.jpg",
                  "https://gamek.mediacdn.vn/133514250583805952/2020/11/24/photo-1-16061876912511244985316.jpg",
                  "https://i.pinimg.com/564x/92/8b/33/928b331c16d1f44bf6bc411694782a3f.jpg",
                  "https://lol-skin.weblog.vc/img/wallpaper/splash/Renekton_26.webp?1646165530"
                  
    ]
    
    var dataString: String = ""
    var dataDictionary: String = ""
    var manager = FileManager.default
    var lisImage: [UIImage] = []
    var lisImgResult: [ImageDetail] = []
    
    func deleteFileFromDocument(fileName: String) {
        let pathFile = getDocumentFilePath(fileName: fileName)
        
        do {
            try manager.removeItem(at: pathFile)
            
        } catch {
            print("err deleteFileFromDocument")
        }
    }
    
    func deleteFileFromTemp(fileName: String) {
        let pathFile = getTempFilePath(fileName: fileName)
        
        do {
            try manager.removeItem(at: pathFile)
            
        } catch {
            print("err deleteFileFromTemp")
        }
    }
    func deleteImageFromDocument(idx: Int, tableView: UITableView) {
        self.lisImgResult.remove(at: idx)
        deleteFileFromDocument(fileName: "Images/image\(idx + 1).png")
        tableView.reloadData()
    }
    
    func getImageFromDocument(completion: @escaping (Bool) -> Void) {
        var count = 0
        DispatchQueue.global().async {
            for i in 1...12 {
                let imageString = "image\(i).png"
                let imagePath = self.getDocumentFilePath(fileName: "Images/" + imageString)
                
                do {
                    let imageData = try Data(contentsOf: imagePath)
                    if let img = UIImage(data: imageData) {
                        let resolution = "\(img.size.width) x \(img.size.height)"
                        let imageDetail = ImageDetail(name: imageString, resolution: resolution, image: img)
                        self.lisImgResult.append(imageDetail)
                        count += 1
                        if count == 12 {
                            completion(true)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(false)
                }                
            }
        }
    }
    
    func getAttributesOfItemDocuments(fileName: String) {
        let fileSupperManPath = getDocumentFilePath(fileName: fileName).path
        do {
            let fileManager = FileManager.default
            let attributes = try fileManager.attributesOfItem(atPath: fileSupperManPath)
            print("File ReferenceCount: ")
            if let referenceCount =  attributes[FileAttributeKey(rawValue: "NSFileReferenceCount" )] as? Int {
                print(referenceCount)
            }
            //            for i in attributes {
            //                print(i)
            //            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getAttributesOfItemTemp(fileName: String) {
        let fileSupperManPath = getTempFilePath(fileName: fileName).path
        do {
            let fileManager = FileManager.default
            let attributes = try fileManager.attributesOfItem(atPath: fileSupperManPath)
            print("File Attributes: ")
            for i in attributes {
                print(i)
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveImage(completion: @escaping (Bool) -> Void) {
        getListImage() { done in
            var count = 0
            if done {
                DispatchQueue.global().async {
                    for (i,e) in self.lisImage.enumerated() {
                        if let data = e.pngData() {
                            let fileName = self.getDocumentFilePath(fileName: "Images").appendingPathComponent("image\(i+1).png")
                            do {
                                try data.write(to: fileName)
                                count += 1
                                if count == self.lisImage.count {
                                    completion(true)
                                }
                            }catch {
                                print(error.localizedDescription)
                                completion(false)
                            }
                        }
                    }
                }
            }
        }
    }
    func getListImage(completion: @escaping (Bool) -> Void) {
        var count = 0
        DispatchQueue.global().async {
            for i in self.urlImg {
                if let url = URL(string: i) {
                    let task = URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let _ = data, error == nil else { return }
                        if let image = UIImage(data: data!) {
                            self.lisImage.append(image)
                            count += 1
                            if count == self.urlImg.count {
                                completion(true)
                            }
                        }
                    }
                    
                    task.resume()
                }
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getTempsDirectory() -> URL {
        let tempDirectoryPath = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        return tempDirectoryPath
    }
    
    func getDocumentFilePath(fileName: String) -> URL {
        let documentPath = getDocumentsDirectory()
        let filePath = documentPath.appendingPathComponent(fileName)
        
        return filePath
    }
    
    func getTempFilePath(fileName: String) -> URL {
        let documentPath = getTempsDirectory()
        let filePath = documentPath.appendingPathComponent(fileName)
        return filePath
    }
    
    func createForderDocumentsDirectory(folderName: String) -> URL {
        let rootFolderURL = getDocumentsDirectory()
        let nestedFolderURL = rootFolderURL.appendingPathComponent(folderName)
        if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
            do {
                try manager.createDirectory(
                    at: nestedFolderURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            }catch {
                print(error.localizedDescription)
            }
        }
        return nestedFolderURL
    }
    func createForderTempDirectory(folderName: String) -> URL {
        let rootFolderURL = getTempsDirectory()
        let nestedFolderURL = rootFolderURL.appendingPathComponent(folderName)
        if !manager.fileExists(atPath: nestedFolderURL.relativePath) {
            do {
                try manager.createDirectory(
                    at: nestedFolderURL,
                    withIntermediateDirectories: false,
                    attributes: nil
                )
            }catch {
                print(error.localizedDescription)
            }
        }
        return nestedFolderURL
    }
    
    func readString(documentName: String) -> String {
        let fileURL = createForderDocumentsDirectory(folderName: "MyAppFiles").appendingPathComponent(documentName)
        if fileURL.checkFileExist() {
            do {
                let data = try Data(contentsOf: fileURL)
                return String(data: data, encoding: .utf8) ?? ""
            } catch {
                print("err readString")
                return ""
            }
            
        }else{
            return ""
        }
    }
    
    func readString(pathURL: URL) -> String {
        if pathURL.checkFileExist() {
            do {
                let data = try Data(contentsOf: pathURL)
                return String(data: data, encoding: .utf8) ?? ""
            } catch {
                print("err readString")
                return ""
            }
            
        }else{
            return ""
        }
        
    }
    
    func writeString(dataSave: String, documentName: String) {
        let fileURL = createForderDocumentsDirectory(folderName: "MyAppFiles").appendingPathComponent(documentName)
        dataString = readString(pathURL: fileURL)
        dataString += dataSave
        do {
            try Data(dataString.utf8).write(to: fileURL)
            
        } catch {
            print("err writeString")
            
        }
        
    }
    
    func writeJson(dataSave: String, fileName: String) {
        let fileURL = getTempsDirectory().appendingPathComponent(fileName)
        
        do {
            try Data(dataSave.utf8).write(to: fileURL)
            
        } catch {
            print("err writeJson")
            
        }
        
    }
    
    func writeDictionary<T: Encodable>(dataSave: T, documentName: String) {
        let fileURL = createForderDocumentsDirectory(folderName: "MyAppFiles").appendingPathComponent(documentName)
        dataDictionary = readString(pathURL: fileURL)
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dataSave) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
                dataDictionary += jsonString
            }
        }
        do {
            try Data(dataDictionary.utf8).write(to: fileURL)
            
        } catch {
            print("err writeDictionary")
            
        }
        
    }
    
    func saveDataJsonToTemp() {
        if let url = URL(string: "https://15a35941-b8c2-4d9f-a8a6-0bbd76865bc0.mock.pstmn.io/person") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let _ = data, error == nil else { return }
                let pathJson = self.getTempFilePath(fileName: "fileJson")
                do {
                    try data?.write(to: pathJson)
                }catch {
                    print("err getDataJsonToSever")
                }
            }
            
            task.resume()
        }
    }
    func readDataJson() {
        let filePath = getTempFilePath(fileName: "fileJson")
        if filePath.checkFileExist() {
            do {
                let data = try Data(contentsOf: filePath)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                
            }catch {
                print("err readDataJson")
            }
        }else {
            print("err readDataJson")
        }
    }
    
}

extension URL {
    func checkFileExist() -> Bool {
        let path = self.path
        if (FileManager.default.fileExists(atPath: path))   {
            print("FILE AVAILABLE")
            return true
        }else        {
            print("FILE NOT AVAILABLE")
            return false;
        }
    }
}
