//
//  RxViewController.swift
//  W4_GCD
//
//  Created by Beomcheol Kwon on 2021/01/19.
//

import RxSwift
import RxCocoa
import SwiftyJSON
import UIKit

class RxViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let operationQueue = OperationQueue()
    let memberObservable = BehaviorRelay<[Member]>(value: [])
    let date = Date()
    
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
        print(#function, Thread.current)
        getData(MEMBER_LIST_URL)
            .bind(to: memberObservable)
            .disposed(by: disposeBag)
        
        memberObservable
            .bind(to: tableView.rx.items(cellIdentifier: "MemberTableViewCell", cellType: MemberTableViewCell.self)) { [weak self] index, item, cell in
                cell.nameLabel.text = item.name
                cell.ageLabel.text = "\(item.age)"
                cell.jobLabel.text = item.job
                cell.avatarImageView.image = nil
                self?.getImage(from: item.avatar)
                    .bind(to: cell.avatarImageView.rx.image)
                    .disposed(by: self!.disposeBag)
            }
            .disposed(by: disposeBag)
        tableView.layoutIfNeeded()
        
        loadButton.setTitle("Done", for: .disabled)
        loadButton.isEnabled = false
        
    }
    
    func getData(_ url: String) -> Observable<Members> {
        
        return Observable.create() { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
                print(#function, Thread.current)
                guard let data = data else {
                    emitter.onError(error!)
                    return
                }
                
                do {
                    let members = try JSONDecoder().decode(Members.self, from: data)
                    emitter.onNext(members)
                } catch let error {
                    emitter.onError(error)
                }
                
                emitter.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create() {
                task.cancel()
            }
        }
        
    }
    
    func getImage(from url: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                guard let data = data,
                      let image = UIImage(data: data) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

class MemberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
}
