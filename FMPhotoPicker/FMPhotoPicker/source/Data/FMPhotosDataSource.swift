//
//  FMPhotosDataSource.swift
//  FMPhotoPicker
//
//  Created by c-nguyen on 2018/02/01.
//  Copyright © 2018 Tribal Media House. All rights reserved.
//

import Foundation
import Photos

class FMPhotosDataSource {
    private var fetchResult: PHFetchResult<PHAsset>
    private var forceCropType: FMCroppable?
    private var selectedPhotoIndexes: [Int]
    private var cachedFMAssets = [Int: FMPhotoAsset]()
    
    init(fetchResult: PHFetchResult<PHAsset>, forceCropType: FMCroppable?) {
        self.fetchResult = fetchResult
        self.forceCropType = forceCropType
        self.selectedPhotoIndexes = []
    }
    
    public func setSeletedForPhoto(atIndex index: Int) {
        if self.selectedPhotoIndexes.firstIndex(where: { $0 == index }) == nil {
            self.selectedPhotoIndexes.append(index)
        }
    }
    
    public func unsetSeclectedForPhoto(atIndex index: Int) {
        if let indexInSelectedIndex = self.selectedPhotoIndexes.firstIndex(where: { $0 == index }) {
            self.selectedPhotoIndexes.remove(at: indexInSelectedIndex)
        }
    }
    
    public func selectedIndexOfPhoto(atIndex index: Int) -> Int? {
        return self.selectedPhotoIndexes.firstIndex(where: { $0 == index })
    }
    
    public func numberOfSelectedPhoto() -> Int {
        return self.selectedPhotoIndexes.count
    }
    
    public func mediaTypeForPhoto(atIndex index: Int) -> FMMediaType? {
        return self.photo(atIndex: index)?.mediaType
    }
    
    public func countSelectedPhoto(byType: FMMediaType) -> Int {
        return self.getSelectedPhotos().filter { $0.mediaType == byType }.count
    }
    
    public func affectedSelectedIndexs(changedIndex: Int) -> [Int] {
        return Array(self.selectedPhotoIndexes[changedIndex...])
    }

    public func getSelectedPhotos() -> [FMPhotoAsset] {
        var result = [FMPhotoAsset]()
        self.selectedPhotoIndexes.forEach {
            if let photo = self.photo(atIndex: $0) {
                result.append(photo)
            }
        }
        return result
    }
    
    public var numberOfPhotos: Int {
        return self.fetchResult.count
    }
    
    public func photo(atIndex index: Int) -> FMPhotoAsset? {
        guard index < self.fetchResult.count, index >= 0 else { return nil }
        if let fmAsset = cachedFMAssets[index] {
            return fmAsset
        }
        let phAsset = fetchResult.object(at: index)
        let fmAsset = FMPhotoAsset(asset: phAsset, forceCropType: forceCropType)
        cachedFMAssets[index] = fmAsset
        return fmAsset
    }
    
    public func index(ofPhoto photo: FMPhotoAsset) -> Int? {
        guard let asset = photo.asset else { return nil }
        return fetchResult.index(of: asset)
    }
    
    public func contains(photo: FMPhotoAsset) -> Bool {
        guard let asset = photo.asset else { return false }
        return fetchResult.index(of: asset) != NSNotFound
    }
    
}
