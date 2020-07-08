
import Foundation
import MobileCoreServices

public typealias MultipartFormData = () -> [BodyPart]

public typealias HTTPHeaders = [String: String]

private func mimeType(forPathExtension pathExtension: String) -> String {
    if let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
        let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue() {
        return contentType as String
    }
    
    return "application/octet-stream"
}

private func contentHeaders(withName name: String, fileName: String? = nil, mimeType: String? = nil) -> [String: String] {
    var disposition = "form-data; name=\"\(name)\""
    if let fileName = fileName { disposition += "; filename=\"\(fileName)\"" }
    
    var headers = ["Content-Disposition": disposition]
    if let mimeType = mimeType { headers["Content-Type"] = mimeType }
    
    return headers
}

public struct BodyPart {
    public let headers: HTTPHeaders
    public let bodyStream: InputStream
    public let bodyContentLength: UInt64
    
    public init(headers: HTTPHeaders, bodyStream: InputStream, bodyContentLength: UInt64) {
        self.headers = headers
        self.bodyStream = bodyStream
        self.bodyContentLength = bodyContentLength
    }
}

extension BodyPart {
    public init(string: String, name: String) {
        self.init(data: string.data(using: String.Encoding.utf8)!, name: name)
    }
    
    public init(data: Data, name: String, fileName: String? = nil, mimeType: String? = nil) {
        let headers = contentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        let stream = InputStream(data: data)
        let length = UInt64(data.count)
        self.init(headers: headers, bodyStream: stream, bodyContentLength: length)
    }
    
    public init(fileURL: URL, name: String) throws {
        let fileName = fileURL.lastPathComponent
        let pathExtension = fileURL.pathExtension
        
        if !fileName.isEmpty && !pathExtension.isEmpty {
            let mime = mimeType(forPathExtension: pathExtension)
            try self.init(fileURL: fileURL, name: name, fileName: fileName, mimeType: mime)
        } else {
            throw BodyPartError.filenameInvalid(in: fileURL)
        }
    }
    
    public init(fileURL: URL, name: String, fileName: String, mimeType: String) throws {
        let headers = contentHeaders(withName: name, fileName: fileName, mimeType: mimeType)
        
        //============================================================
        //                 Check 1 - is file URL?
        //============================================================
        
        guard fileURL.isFileURL else {
            throw BodyPartError.urlLInvalid(url: fileURL)
        }
        
        //============================================================
        //              Check 2 - is file URL reachable?
        //============================================================
        
        do {
            let isReachable = try fileURL.checkPromisedItemIsReachable()
            guard isReachable else {
                throw BodyPartError.fileNotReachable(at: fileURL)
            }
        } catch {
            throw BodyPartError.fileNotReachableWithError(atURL: fileURL, error: error)
        }
        
        //============================================================
        //            Check 3 - is file URL a directory?
        //============================================================
        
        var isDirectory: ObjCBool = false
        let path = fileURL.path
        
        guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) && !isDirectory.boolValue else {
            throw BodyPartError.fileIsDirectory(at: fileURL)
        }
        
        //============================================================
        //          Check 4 - can the file size be extracted?
        //============================================================
        
        let bodyContentLength: UInt64
        
        do {
            guard let fileSize = try FileManager.default.attributesOfItem(atPath: path)[.size] as? NSNumber else {
                throw BodyPartError.fileSizeNotAvailable(at: fileURL)
            }
            
            bodyContentLength = fileSize.uint64Value
        }
        catch {
            throw BodyPartError.fileSizeQueryFailedWithError(forURL: fileURL, error: error)
        }
        
        //============================================================
        //       Check 5 - can a stream be created from file URL?
        //============================================================
        
        guard let stream = InputStream(url: fileURL) else {
            throw BodyPartError.inputStreamCreationFailed(for: fileURL)
        }
        
        self.init(headers: headers, bodyStream: stream, bodyContentLength: bodyContentLength)
    }
}

public enum BodyPartError: Error {
    case urlLInvalid(url: URL)
    case filenameInvalid(in: URL)
    case fileNotReachable(at: URL)
    case fileNotReachableWithError(atURL: URL, error: Error)
    case fileIsDirectory(at: URL)
    case fileSizeNotAvailable(at: URL)
    case fileSizeQueryFailedWithError(forURL: URL, error: Error)
    case inputStreamCreationFailed(for: URL)
}
