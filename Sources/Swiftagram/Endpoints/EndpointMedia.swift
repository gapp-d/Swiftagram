//
//  EndpointMedia.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 14/03/2020.
//

import Foundation

import ComposableRequest

public extension Endpoint {
    /// A `struct` holding reference to `media` `Endpoint`s. Requires authentication.
    struct Media {
        /// The base endpoint.
        private static let base = Endpoint.version1.media.appendingDefaultHeader()

        // MARK: Info
        /// A media matching `identifier`'s info.
        /// - parameter identifier: A `String` holding reference to a valid media identifier.
        public static func summary(for identifier: String) -> Disposable<MediaCollection> {
            return base.appending(path: identifier).info.prepare(process: MediaCollection.self).locking(Secret.self)
        }

        /// The permalinkg for the media matching `identifier`.
        /// - parameter identifier: A `String` holding reference to a valid media identifier.
        public static func permalink(for identifier: String) -> Disposable<Wrapper> {
            return base.appending(path: identifier).permalink.prepare().locking(Secret.self)
        }

        /// A `struct` holding reference to `media` `Endpoint`s reguarding posts. Requires authentication.
        public struct Posts {
            /// A list of all users liking the media matching `identifier`.
            /// - parameters:
            ///     - identifier: A `String` holding reference to a valid post media identifier.
            ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
            public static func likers(for identifier: String, startingAt page: String? = nil) -> Paginated<UserCollection> {
                return base.appending(path: identifier)
                    .likers
                    .paginating(process: UserCollection.self, value: page)
                    .locking(Secret.self)
            }

            /// A list of all comments the media matching `identifier`.
            /// - parameters:
            ///     - identifier: A `String` holding reference to a valid post media identifier.
            ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
            public static func comments(for identifier: String, startingAt page: String? = nil) -> Paginated<CommentCollection> {
                return base.appending(path: identifier)
                    .comments
                    .paginating(process: CommentCollection.self, value: page)
                    .locking(Secret.self)
            }

            /// Save the media metching `identifier`.
            /// - parameter identifier: A `String` holding reference to a valid media identifier.
            public static func save(_ identifier: String) -> Disposable<Status> {
                return base
                    .appending(path: identifier)
                    .appending(path: "save/")
                    .replacing(method: .post)
                    .prepare(process: Status.self)
                    .locking(Secret.self)
            }

            /// Unsave the media metching `identifier`.
            /// - parameter identifier: A `String` holding reference to a valid media identifier.
            public static func unsave(_ identifier: String) -> Disposable<Status> {
                return base
                    .appending(path: identifier)
                    .appending(path: "unsave/")
                    .replacing(method: .post)
                    .prepare(process: Status.self)
                    .locking(Secret.self)
            }

            /// Like the comment matching `identifier`.
            /// - parameter identifier: A `String` holding reference to a valid comment identfiier.
            public static func like(comment identifier: String) -> Disposable<Status> {
                return base
                    .appending(path: identifier)
                    .appending(path: "comment_like/")
                    .replacing(method: .post)
                    .prepare(process: Status.self)
                    .locking(Secret.self)
            }

            /// Unlike the comment matching `identifier`.
            /// - parameter identifier: A `String` holding reference to a valid comment identfiier.
            public static func unlike(comment identifier: String) -> Disposable<Status> {
                return base
                    .appending(path: identifier)
                    .appending(path: "comment_unlike/")
                    .replacing(method: .post)
                    .prepare(process: Status.self)
                    .locking(Secret.self)
            }
        }

        /// A `struct` holding reference to `media` `Endpoint`s reguarding stories. Requires authentication.
        public struct Stories {
            /// A list of all viewers for the story matching `identifier`.
            /// - parameters:
            ///     - identifier: A `String` holding reference to a valid post media identifier.
            ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
            public static func viewers(for identifier: String, startingAt page: String? = nil) -> Paginated<UserCollection> {
                return base.appending(path: identifier)
                    .appending(path: "list_reel_media_viewer")
                    .paginating(process: UserCollection.self, value: page)
                    .locking(Secret.self)
            }

            /// Archived stories.
            /// - parameter page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
            public static func archived(startingAt page: String? = nil) -> Paginated<TrayItemCollection> {
                return Endpoint.version1
                    .archive
                    .reel
                    .day_shells
                    .appendingDefaultHeader()
                    .paginating(process: TrayItemCollection.self, value: page)
                    .locking(Secret.self)
            }
        }
    }
}
