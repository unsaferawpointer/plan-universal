//
//  DataPublisher.swift
//  Plan Universal
//
//  Created by Anton Cherkasov on 18.04.2024.
//

import Foundation
import CoreData
import Combine

struct FetchedResultsPublisher<Entity: NSManagedObject> {

	/// The managed object context to monitor
	private let managedObjectContext: NSManagedObjectContext

	private let predicate: NSPredicate?

	/// Creates a publisher that retains the managed object context passed to it.
	/// - Parameter managedObjectContext: the managed object context to monitor
	public init<T: CoreDataFilter>(managedObjectContext: NSManagedObjectContext, filter: T) where T.Entity == Entity {
		self.managedObjectContext = managedObjectContext
		self.predicate = filter.predicate
	}
}

// MARK: - Publisher
extension FetchedResultsPublisher: Publisher {

	typealias Output = [Entity]

	typealias Failure = Never

	func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, [Entity] == S.Input {
		subscriber.receive(subscription: FetchedResultsSubscription(
			subscriber: subscriber,
			entity: Entity.self,
			managedObjectContext: managedObjectContext,
			predicate: predicate
		))
	}
}

final class FetchedResultsSubscription<SubscriberType: Subscriber, Entity: NSManagedObject>:
	NSObject, Subscription, NSFetchedResultsControllerDelegate where SubscriberType.Input == [Entity] {

	/// Cancellable for the internal subscription that pushes updates entity lists to the subscribers.
	private var subjectCancellable: AnyCancellable?
	private var subscriber: SubscriberType?

	/// The managed object context to be monitored with an NSFetchedResultsController
	private var managedObjectContext: NSManagedObjectContext?

	/// The fetched results controller responsible to manage updates for a given entity type
	private var fetchedResultsController: NSFetchedResultsController<Entity>?

	/// The entity type that is monitored, defines the Output type.
	private var entity: Entity.Type

	private var predicate: NSPredicate?

	/// Internal buffer of the latest set of entities of the fetched results controller
	private var subject = CurrentValueSubject<[Entity], Never>([])

	func request(_ demand: Subscribers.Demand) {

		// When a demand is sent this means we should re-send the latest buffer, since
		// subscribing can happen later after the initialization.
		subject.send(subject.value)
	}

	func cancel() {
		subjectCancellable?.cancel()
		subjectCancellable = nil

		// Clean up any strong references
		fetchedResultsController = nil
		managedObjectContext = nil
		subscriber = nil
	}

	init(subscriber: SubscriberType, entity: Entity.Type, managedObjectContext: NSManagedObjectContext, predicate: NSPredicate?) {
		self.managedObjectContext = managedObjectContext
		self.entity = entity
		self.subscriber = subscriber
		self.predicate = predicate

		super.init()

		createFetchedResultsController()

		subjectCancellable = subject
			.sink { [weak self] in
				guard let self = self, let subscriber = self.subscriber else {
					assertionFailure("Subscription deallocated early.")
					return
				}
				_ = subscriber.receive($0)
			}
	}

	/// Sets up the fetched results controller with a fetch request and the specified managed object context.
	private func createFetchedResultsController() {
		guard let managedObjectContext = managedObjectContext else {
			preconditionFailure("The managed object context should only be nil after cancelling the subscription.")
		}

		guard let request = entity.fetchRequest() as? NSFetchRequest<Entity> else {
			preconditionFailure("We should always be able to get the correctly typed fetch request.")
		}

		request.predicate = predicate

		// Since we do not know anything about the entity, we are not able to add sorting to the fetch.
		// In future updates one could add protocol requirements to sort by common properties of entities.
		request.sortDescriptors = []

		let fetchedResultsController = NSFetchedResultsController(
			fetchRequest: request,
			managedObjectContext: managedObjectContext,
			sectionNameKeyPath: nil,
			cacheName: nil
		)

		fetchedResultsController.delegate = self
		self.fetchedResultsController = fetchedResultsController

		do {
			try fetchedResultsController.performFetch()
			let objects = fetchedResultsController.fetchedObjects

			// Push initial set of objects to the subject
			subject.send(objects ?? [])

		} catch {

			// Surface unexpected errors in debug builds
			assertionFailure(error.localizedDescription)
		}
	}

	// MARK: - NSFetchedResultsControllerDelegate

	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

		// Whenever the controller receives object changes, we push them to the subject which in turn
		// will send the objects to the receiver(s).
		if let objects = controller.fetchedObjects as? [Entity] {
			subject.send(objects)
		}
	}
}

extension NSManagedObjectContext {

	/// Publisher that emits lists of entities of the defined entity type of the source managed object context
	/// whenever updates to the objects occur.
	/// - Parameter entity: The entity type to receive updates for
	/// - Returns: Publisher that emits up-to-date lists of the entities.
	func publisher<Entity: NSManagedObject, Filter: CoreDataFilter>(
		for entity: Entity.Type, filter: Filter
	) -> FetchedResultsPublisher<Entity> where Filter.Entity == Entity {
		FetchedResultsPublisher(managedObjectContext: self, filter: filter)
	}
}
