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
    var lisImgResult: [UIImage] = []
    func getImageFromDocumentDirectory(completion: @escaping (Bool) -> Void) {
        var count = 0
        DispatchQueue.global().async {
            for i in 1...13 {
                let imagePath = self.getDocumentFilePath(fileName: "Images/image\(i).png")
  
                do {
                    let imageData = try Data(contentsOf: imagePath)
                    if let img = UIImage(data: imageData) {
                        self.lisImgResult.append(img)
                        count += 1
                        if count == 13 {
                            completion(true)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                
                
                
                
                
                
                
                
            }
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
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data!) {
                                self.lisImage.append(image)
                                count += 1
                                if count == self.urlImg.count {
                                    completion(true)
                                }
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
    
    func getDocumentFilePath(fileName: String) -> URL {
        let documentPath = getDocumentsDirectory()
        let filePath = documentPath.appendingPathComponent(fileName)
        
        return filePath
    }
    
    func createForder(folderName: String) -> URL {
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
    
    func readString(documentName: String) -> String {
        let fileURL = createForder(folderName: "MyAppFiles").appendingPathComponent(documentName)
        if fileURL.checkFileExist() {
            do {
                let data = try Data(contentsOf: fileURL)
                return String(data: data, encoding: .utf8) ?? ""
            } catch {
                print("Can not read file")
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
                print("Can not read file")
                return ""
            }
            
        }else{
            return ""
        }
        
    }
    
    func writeString(dataSave: String, documentName: String) {
        let fileURL = createForder(folderName: "MyAppFiles").appendingPathComponent(documentName)
        dataString = readString(pathURL: fileURL)
        dataString += dataSave
        do {
            try Data(dataString.utf8).write(to: fileURL)
            
        } catch {
            print("Can not write file")
            
        }
        
    }
    func writeDictionary<T: Encodable>(dataSave: T, documentName: String) {
        let fileURL = createForder(folderName: "MyAppFiles").appendingPathComponent(documentName)
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
            print("Can not write file")
            
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
