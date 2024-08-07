//
//  UVEDescriptorWrapper.swift
//  
//
//  Created by Dominic Go on 6/19/24.
//
import Foundation
import DGSwiftUtilities

/// Wrapper for: `_UIVisualEffectDescriptor`
/// Old name: `VisualEffectDescriptorWrapper`
///
@available(iOS 13, *)
public class UVEDescriptorWrapper: PrivateObjectWrapper<
  NSObject,
  UVEDescriptorWrapper.EncodedString
> {

  public enum EncodedString: PrivateObjectWrappingEncodedString {
    case className;
    
    /// `filterEntries`
    case getterFilterItems;
    
    /// `addFilterEntry`
    case methodInsertFilterItem;
    
    /// `setFilterEntries`
    case methodSetFilterItems;
    
    // TODO:
    // `setViewEffects`, `viewEffects`
    // `setUnderlays`, `underlays`
    // `setOverlays`, `overlays`
    
    public var encodedString: String {
      switch self {
        case .className:
          // _UIVisualEffectDescriptor
          return "X1VJVmlzdWFsRWZmZWN0RGVzY3JpcHRvcg==";
        
        case .getterFilterItems:
          // filterEntries
          return "ZmlsdGVyRW50cmllcw==";
          
        case .methodInsertFilterItem:
          // addFilterEntry:
          return "YWRkRmlsdGVyRW50cnk6";
          
        case .methodSetFilterItems:
          // setFilterEntries:
          return "c2V0RmlsdGVyRW50cmllczo=";
      };
    };
  };
  
  // MARK: - Wrapped Properties
  // --------------------------
  
  public var filterItems: NSArray? {
    try? self.performSelector(
      usingEncodedString: .getterFilterItems,
      type: NSArray.self
    );
  };
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var filterItemsWrapped: [UVEFilterEntryWrapper]? {
    guard let filterEntriesRaw = self.filterItems else {
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
  ///
  public func insertFilterItem(_ filter: Any) throws {
    try self.performSelector(
      usingEncodedString: .methodInsertFilterItem,
      withArg1: filter
    );
  };
  
  /// Selector:
  /// `-(void)setFilterEntries:(NSArray *)arg1:`
  ///
  public func setFilterItems(_ items: [AnyObject]) throws {
    try self.performSelector(
      usingEncodedString: .methodSetFilterItems,
      withArg1: items as NSArray
    );
  };
  
  /// Selector:
  /// `-(void)setFilterEntries:(NSArray *)arg1:`
  ///
  public func setFilterItems(_ wrappedItems: [UVEFilterEntryWrapper]) throws {
    let items = wrappedItems.compactMap {
      $0.wrappedObject;
    };
    
    try self.setFilterItems(items);
  };
};
