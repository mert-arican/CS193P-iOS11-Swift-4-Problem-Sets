//
//  ImageGalleryTableViewController.swift
//  Assignment 5
//
//  Created by Mert Arıcan on 1.05.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController, GalleryTableViewCellDelegate {
    
    func cellNameChanged(_ sender: GalleryTableViewCell) {
        if let indexPath = tableView.indexPath(for: sender), let text = sender.textField.text {
            if indexPath.section == 0 {
                self.imageGalleryNames[indexPath.row] = text
            } else {
                self.recentlyDeletedNames[indexPath.row] = text
            }
        }
    }
    
    var imageGalleries = [[URL]]()
    
    var imageGalleryNames = [String]()
    
    var recentlyDeleted = [[URL]]()
    
    var recentlyDeletedNames = [String]()
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Image Galleries"
        case 1: return "Recently Deleted"
        default : return ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return imageGalleries.count
        case 1: return recentlyDeleted.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        if let galleryCell = cell as? GalleryTableViewCell {
            switch indexPath.section {
            case 0: galleryCell.textField.text = imageGalleryNames[indexPath.row]
            case 1: galleryCell.textField.text = recentlyDeletedNames[indexPath.row]
            default: break
            }
            galleryCell.delegate = self
        }
        return cell
    }
    
    @IBAction func addRow(_ sender: UIBarButtonItem) {
        tableView.performBatchUpdates({
            imageGalleries.append([URL]())
            imageGalleryNames.append(uniqueGalleryName)
            tableView.insertRows(at: [IndexPath(row: imageGalleries.count-1, section: 0)], with: .automatic)
        })
    }
    
    var uniqueGalleryName: String {
        return "Image Gallery".madeUnique(withRespectTo: imageGalleryNames)
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        let undelete = UIContextualAction(style: .destructive, title: "undelete") { [weak self] (UIContextualAction, UIView, (Bool) -> Void) in
            if self?.recentlyDeleted[indexPath.row] != nil {
                self?.imageGalleries.append((self?.recentlyDeleted.remove(at: indexPath.row))!)
                self?.imageGalleryNames.append((self?.recentlyDeletedNames.remove(at: indexPath.row))!)
                self?.tableView.moveRow(at: indexPath, to: IndexPath(row: (self?.imageGalleries.count)!-1, section: 0))
            }
        }
        undelete.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1) ; undelete.title = "undelete"
        return UISwipeActionsConfiguration(actions: [undelete])
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                recentlyDeleted.append(imageGalleries.remove(at: indexPath.row))
                recentlyDeletedNames.append(imageGalleryNames.remove(at: indexPath.row))
                tableView.moveRow(at: indexPath, to: IndexPath(row: recentlyDeleted.count-1, section: 1))
            } else {
                recentlyDeleted.remove(at: indexPath.row)
                recentlyDeletedNames.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? GalleryTableViewCell {
            if tableView.indexPath(for: cell)?.section == 1 { return false }
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseGallery" {
            if let cell = sender as? GalleryTableViewCell {
                if let navcon = segue.destination as? UINavigationController {
                    if let destination = navcon.visibleViewController as? ImageGalleryCollectionViewController, let index = tableView.indexPath(for: cell)?.row {
                        destination.urls = imageGalleries[index]
                        destination.imageGalleriesTableViewController = self
                        destination.indexOfImageGallery = index
                    }
                }
            }
        }
    }

}
