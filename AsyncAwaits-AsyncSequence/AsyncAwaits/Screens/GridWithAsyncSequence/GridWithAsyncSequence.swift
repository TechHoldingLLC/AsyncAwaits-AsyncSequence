//
//  GridWithAsyncSequence.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 13/02/23.
//

import UIKit

class GridWithAsyncSequence: UIViewController {
    
    //MARK: - IBOutlets

    @IBOutlet weak var gridCollectionView: UICollectionView!
    
    //MARK: - Variables
    var activityIndicator = UIActivityIndicatorView()
    var imageData: [Data] = []
    
    //MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpCollectionView()
        loadData()
    }
    
    //MARK: - Common Methods
    
    private func setUpCollectionView() {
         gridCollectionView.delegate = self
         gridCollectionView.dataSource = self

         let layout = UICollectionViewFlowLayout()
         layout.itemSize = CGSize(width: 128.0, height: 128.0)
         layout.scrollDirection = .vertical
         layout.minimumLineSpacing = 2
         layout.minimumInteritemSpacing = 2

         gridCollectionView
               .setCollectionViewLayout(layout, animated: true)
       }
    
    //MARK: - Data
    
    private func loadData(){
        startBarButtonIndicator()
        Task{
            let urlString = "https://source.unsplash.com/random"
            let urls: [URL] = Array(0...40).map { _ in
                URL(string: urlString)
            }.compactMap({ $0 })
            
            for try await data in DataSequence(urls: urls){
                self.imageData.append(data)
                gridCollectionView.reloadData()
            }
            stopBarButtonIndicator()
        }
    }

}

//MARK: - UICollectionViewDataSource/UICollectionViewDelegate

extension GridWithAsyncSequence: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.reusableIdentifier, for: indexPath) as! GridCell
        cell.img.image = UIImage(data: imageData[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        return CGSize(width: (screenWidth/3)-6, height: (screenWidth/3)-6);
    }
}

//MARK: - Loader as UIBarButtonItem

extension GridWithAsyncSequence{
    
    func startBarButtonIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.color = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }

    func stopBarButtonIndicator() {
        activityIndicator.stopAnimating()
    }
}
