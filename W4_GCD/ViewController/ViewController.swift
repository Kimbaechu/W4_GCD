//
//  ViewController.swift
//  W4_GCD
//
//  Created by Beomcheol Kwon on 2021/01/21.
//

import UIKit

class ViewController: UIViewController {
    
    let date = Date()
    var members = Members()
    var images = [UIImage]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var loadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global(qos: .background).async {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                DispatchQueue.main.async {
                    self?.timeLabel.text = "\(Date().timeIntervalSince(self!.date))"
                }
            }
            RunLoop.current.run()
        }
    }
    
    @IBAction func load(_ sender: Any) {
        getData(MEMBER_LIST_URL)
    }
    
    func getData(_ url: String) {
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            print(#function, Thread.current)
            guard let data = data else {
                fatalError()
            }
            
            do {
                let members = try JSONDecoder().decode(Members.self, from: data)
                self.members = members
                DispatchQueue.main.async { [weak self] in
                    self?.updateUI()
                }
            } catch {
                fatalError()
            }
        }
        task.resume()
    }
    
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            print(#function, Thread.current)
            self?.tableView.reloadData()
            self?.tableView.layoutIfNeeded()
            self?.loadButton.setTitle("Done", for: .disabled)
            //            self?.loadButton.setTitle("\(arc4random())", for: .normal)
            self?.loadButton.isEnabled = false
        }
    }
    
    
    //내부에서 image처리하는 방법 찾기
    func getImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        
        let member = members[indexPath.row]
        cell.nameLabel.text = member.name
        cell.ageLabel.text = "\(member.age)"
        cell.jobLabel.text = member.job
        cell.avatarImageView.image = nil
        
        let imageURL = member.avatar
        let cacheKey = NSString(string: imageURL)
        
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            cell.avatarImageView.image = cachedImage
        } else {
            
            getImage(from: imageURL) { image in
                guard let image = image else { return }
                cell.avatarImageView.image = image
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
            }
        }
        return cell
    }
    
}
