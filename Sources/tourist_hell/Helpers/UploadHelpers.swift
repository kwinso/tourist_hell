//
//  UploadHelpers.swift
//  tourist_hell
//
//  Created by Ruslan on 23.04.2025.
//

import Vapor


/// Intended entry point for naming files
/// - Parameter headers: Source `HTTPHeaders`
/// - Returns: `String` with best guess file name.
func uploadFilename(ext: String) -> String {
    return "upload-\(UUID().uuidString).\(ext)"
}


///// Creates the upload directory as part of the working directory
///// - Parameters:
/////   - directoryName: sub-directory name
/////   - app: Application
///// - Returns: name of the directory
//func configureUploadDirectory(named directoryName: String = "Uploads/", for app: Application) -> EventLoopFuture<String> {
//    let createdDirectory = app.eventLoopGroup.next().makePromise(of: String.self)
//    var uploadDirectoryName = app.directory.workingDirectory
//    if directoryName.last != "/" {
//        uploadDirectoryName += "/"
//    }
//    uploadDirectoryName += directoryName
//    do {
//        try FileManager.default.createDirectory(atPath: uploadDirectoryName,
//                                                withIntermediateDirectories: true,
//                                                attributes: nil)
//        createdDirectory.succeed(uploadDirectoryName)
//    } catch {
//        createdDirectory.fail(FileError.couldNotSave(reason: error.localizedDescription))
//    }
//    return createdDirectory.futureResult
//}
