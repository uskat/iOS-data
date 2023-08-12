
import Foundation
import CoreData

protocol CoreDataProtocol: AnyObject {
    func addPostToFavorites(_ post: Post) -> Bool
    func fetchPosts(predicate: NSPredicate?) -> [PostCoreDataModel]
    func deletePost(predicate: NSPredicate?) -> Bool
}

extension CoreDataProtocol {
    func fetchPosts() -> [PostCoreDataModel] {
        self.fetchPosts(predicate: nil)
    }
    
    func deletePost() -> Bool {
        self.deletePost(predicate: nil)
    }
}

final class CoreDataService {
    
    let objectModel: NSManagedObjectModel
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    // 4. NSManagedObjectContext
    private lazy var context: NSManagedObjectContext = {
        $0.persistentStoreCoordinator = self.persistentStoreCoordinator
        return $0
    }(NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType))
    static let shared = CoreDataService()
    
    private init() { //при иниц CoreDataService будет иниц-ся база данных (хранилище)
        
        // 1. NSManagedObjectModel
        guard let url = Bundle.main.url(forResource: "Navigation", withExtension: "momd") else {
            fatalError("  ++++ There is no xcdatamodeld file. ++++  ")
        }
        
        //let path = url.pathExtension //momd
        guard let name = try? url.deletingPathExtension().lastPathComponent else {
            fatalError()
        } // CoreDataNavigation. -> убрали расширение
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("  +++ Can't create NSManagedObjectModel +++  ")
        }
        self.objectModel = model
        
        // 2. NSPersistentStoreCoordinator
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        // 3. NSPersistentStore
        let storeName = name + ".sqlite" // CoreDataNavigation.sqlite
        let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first //
        let persistentStoreUrl = documentsDirectoryUrl?.appendingPathComponent(storeName) //сохраняем базу данных PersistentStore в директории Документы пользователя
        print("✅", persistentStoreUrl)
        
        guard let persistentStoreUrl = persistentStoreUrl else { return }
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: true] // опция: при изменении атрибутов каких-либо сущностей миграция будет происходить автоматически
        do {   // с помощью координатора добавляем новое хранилище
            try self.persistentStoreCoordinator.addPersistentStore(
                type: .sqlite,           // тип хранилища
                at: persistentStoreUrl,  // путь к хранилищу (создали выше)
                options: options)        // с опциями
        } catch {
            fatalError("  +++ Can't create NSPersistentStore +++  ")
        }
    }
}

extension CoreDataService: CoreDataProtocol {
    func addPostToFavorites(_ post: Post) -> Bool {
        let choosenPosts = self.fetchPosts(predicate: NSPredicate(format: "id == %@", post.id))
        guard choosenPosts.isEmpty else {
            return false
        }
        
        let postCoreDataModel = PostCoreDataModel(context: self.context)
        postCoreDataModel.id = post.id
        postCoreDataModel.author = post.author
        postCoreDataModel.imageName = post.imageName
        postCoreDataModel.postDescription = post.postDescription
        postCoreDataModel.likes = post.likes
        postCoreDataModel.views = post.views
        
        guard self.context.hasChanges else {
            return false
        }
        
        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
    
    func fetchPosts(predicate: NSPredicate?) -> [PostCoreDataModel] {
        let fetchRequest = PostCoreDataModel.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let storedPost = try self.context.fetch(fetchRequest)
            return storedPost
        } catch {
            return []
        }
    }
    
    func deletePost(predicate: NSPredicate?) -> Bool {
        let choosenPosts = self.fetchPosts(predicate: predicate)
        
        choosenPosts.forEach {
            self.context.delete($0)
        }
        
        guard self.context.hasChanges else {
            return false
        }
        
        do {
            try self.context.save()
            return true
        } catch {
            return false
        }
    }
}
