//
//  FetchedObjectsViewModel.swift
//  INEZ
//
//  Created by Veit Progl on 15.12.19.
//  Copyright © 2019 Veit Progl. All rights reserved.
//

import Foundation
import CoreData
import Combine

public class FetchedObjectsViewModel<ResultType: NSFetchRequestResult>: NSObject, NSFetchedResultsControllerDelegate, ObservableObject {
    private let fetchedResultsController: NSFetchedResultsController<ResultType>
    
    init(fetchedResultsController: NSFetchedResultsController<ResultType>) {
        self.fetchedResultsController = fetchedResultsController
        // Should be called from subclasses of NSObject.
        super.init()
        // Configure the view model to receive updates from Core Data.
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    // MARK: BindableObject
//        var didChange = PassthroughSubject<Void, Never>()
    public var objectWillChange = ObservableObjectPublisher()
    // MARK: NSFetchedResultsControllerDelegate
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objectWillChange.send()
    }
    var fetchedObjects: [ResultType] {
        return fetchedResultsController.fetchedObjects ?? []
    }
    override public func willChangeValue(forKey key: String) {
        super.willChangeValue(forKey: key)
        self.objectWillChange.send()
    }
}
