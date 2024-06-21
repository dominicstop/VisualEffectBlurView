//
//  VisualEffectDescriptorWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//
import Foundation
import DGSwiftUtilities

/// Wrapper for: `_UIVisualEffectDescriptor`
///
@available(iOS 13, *)
public class VisualEffectDescriptorWrapper: PrivateObjectWrapper<
  NSObject,
  VisualEffectDescriptorWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    case filterEntries;
    case addFilterEntry;
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectDescriptor
          return "X1VJVmlzdWFsRWZmZWN0RGVzY3JpcHRvcg==";
          
        case .filterEntries:
          // filterEntries
          return "ZmlsdGVyRW50cmllcw==";
          
        case .addFilterEntry:
          // addFilterEntry:
          return "YWRkRmlsdGVyRW50cnk6";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  public var filterEntries: NSArray? {
    try? self.performSelector(
      usingEncodedString: .filterEntries,
      type: NSArray.self
    );
  };
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var filterEntriesWrapped: [VisualEffectFilterEntryWrapper]? {
    guard let filterEntriesRaw = self.filterEntries else {
      return nil;
    };
    
    return filterEntriesRaw.compactMap {
      .init(objectToWrap: $0 as AnyObject);
    };
  };
  
  // MARK: - Wrapped Methods
  // -----------------------
  
  /// Selector:
  /// `-(void)addFilterEntry:(id)arg1`
  public func addFilterEntry(_ filter: Any) throws {
    try self.performSelector(
      usingEncodedString: .addFilterEntry,
      withArg1: filter
    );
  };
};
