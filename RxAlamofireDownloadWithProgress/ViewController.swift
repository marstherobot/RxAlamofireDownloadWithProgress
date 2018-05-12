//
//  ViewController.swift
//  RxAlamofireDownloadWithProgress
//
//  Created by Marius Pop on 12/05/2018.
//  Copyright © 2018 SwiftUni. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire

class ViewController: UIViewController {
    private let bag = DisposeBag()

    // Props to: http://www.drawingsofdogs.co.uk/ for the image
    private let targetURL = "https://i.imgur.com/D7TW5Ec.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    lazy var downloadRequest = request(.get, targetURL)
        .flatMap { request -> Observable<(Data?, RxProgress)> in
            let dataPart = request.rx.data()
                .map { d -> Data? in d }
                .startWith(nil as Data?)
            let progressPart = request.rx.progress()
            
            return Observable.combineLatest(dataPart, progressPart) { ($0, $1) }
        }
        .asDriver(onErrorJustReturn: (nil, RxProgress(bytesWritten: 0, totalBytes: 1)))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.rx.tap
            .subscribe(onNext:{ [unowned self] in
                self.downloadData()
            })
            .disposed(by: bag)
    }
    
    func downloadData() {
        // we remove the cache because we want to be able to
        // observe the download progress multiple times
        URLCache.shared.removeAllCachedResponses()

        downloadRequest
            .map { _, progress in
                guard progress.totalBytes != 0 else { return "0.0" } // avoid division by 0
                
                let prog = (Double(progress.bytesWritten) * 100.0) / Double(progress.totalBytes)
                let prettyProgress = String(format: "%.1f", prog)
                return prettyProgress
            }
            .drive(progressLabel.rx.text)
            .disposed(by: bag)
        
        downloadRequest
            .filter { data, _ in
                data != nil
            }
            .map { data, _ in UIImage(data: data!) }
            .drive(imageView.rx.image)
            .disposed(by: bag)
    }
}

