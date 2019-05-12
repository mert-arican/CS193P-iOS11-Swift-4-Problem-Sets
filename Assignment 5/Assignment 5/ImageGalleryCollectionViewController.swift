//
//  ImageGalleryCollectionViewController.swift
//  Assignment 5
//
//  Created by Mert Arıcan on 30.04.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate, UICollectionViewDelegateFlowLayout, ImageCollectionViewCellDelegate {
    
    var urls = [URL]()
    
    var aspectRatios = [String:CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dropDelegate = self
        self.collectionView.dragDelegate = self
        collectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(adjustWidth(_:))))
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.url = urls[indexPath.item]
            imageCell.delegate = self
            return imageCell
        }
        return cell
    }
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 4 * scale
        if let aspectRatio = aspectRatios[urls[indexPath.item].absoluteString] {
            let size = CGSize(width: width , height: width/aspectRatio )
            return size
        }
        return CGSize(width: width, height: width)
    }
    
    var scale: CGFloat = 1.0 {
        didSet { flowLayout?.invalidateLayout() }
    }
    
    @objc private func adjustWidth(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case.began: sender.scale = scale
        case .changed, .ended : scale = sender.scale
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        if let url = (collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.url {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: NSURL(string: url.absoluteString) ?? NSURL()))
            dragItem.localObject = url
            return [dragItem]
        } else {
            return []
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if session.localDragSession != nil {
            return true
        } else {
            return (session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal.init(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: urls.count, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if (item.dragItem.localObject as? NSURL) != nil {
                    collectionView.performBatchUpdates({
                        urls.insert(urls.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropPlaceholderCell"))
                var aspectRatio = CGFloat() ; var imageLoadFailed = false
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let image = image as? UIImage {
                        aspectRatio = image.size.width / image.size.height
                    } else {
                        placeholderContext.deletePlaceholder()
                        imageLoadFailed = true
                    }
                }
                guard !imageLoadFailed else { return }
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    if let url = provider as? URL {
                        DispatchQueue.main.async {
                            placeholderContext.commitInsertion(dataSourceUpdates: { (insertionIndexPath) in
                                self.urls.insert(url, at: insertionIndexPath.item)
                                self.aspectRatios[url.absoluteString] = aspectRatio
                            })
                        }
                    } else {
                        placeholderContext.deletePlaceholder()
                    }
                }
            }
        }
    }
    
    func imageDropFailed(_ sender: ImageCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: sender) {
            urls.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            if let cell = sender as? ImageCollectionViewCell {
                if let destination = segue.destination as? ImageViewController {
                    destination.image = cell.imageView.image
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if indexOfImageGallery != nil {
            imageGalleriesTableViewController?.imageGalleries[indexOfImageGallery!] = urls
        }
    }
    
    var imageGalleriesTableViewController: ImageGalleryTableViewController?
    
    var indexOfImageGallery : Int?

}
