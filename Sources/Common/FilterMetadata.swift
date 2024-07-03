//
//  FilterEntryMetadata.swift
//  
//
//  Created by Dominic Go on 6/27/24.
//

import Foundation

public struct FilterMetadata {

  public var filterTypeRaw: String;
  public var filterTypeParsed: LayerFilterType?;
  
  /// Old name: `identityValues`
  public var filterValuesIdentity: Dictionary<String, Any>;
  
   /// Old name: `requestedValues`
  public var filterValuesRequested: Dictionary<String, Any>;
  
   /// Old name: `configurationValues`
  public var filterValuesConfig: Dictionary<String, Any>;
  
  // MARK: - Init
  // ------------
  
  init(
    filterTypeRaw: String,
    identityValues: Dictionary<String, Any>,
    requestedValues: Dictionary<String, Any>,
    configurationValues: Dictionary<String, Any>,
    filterTypeParsed: LayerFilterType?
  ) {
    self.filterTypeRaw = filterTypeRaw;
    self.filterValuesIdentity = identityValues;
    self.filterValuesRequested = requestedValues;
    self.filterValuesConfig = configurationValues;
    self.filterTypeParsed = filterTypeParsed;
  };
  
  init?(fromWrapper wrapper: UVEFilterEntryWrapper) {
    guard let filterKind = wrapper.filterKind,
          let filterValuesIdentity =
            wrapper.filterValuesIdentity as? Dictionary<String, Any>,
            
          let filterValuesCurrent =
            wrapper.filterValuesCurrent as? Dictionary<String, Any>,
            
          let filterValuesConfig =
            wrapper.filterValuesConfig as? Dictionary<String, Any>
    else {
      return nil;
    };
    
    self.filterTypeRaw = filterKind;
    self.filterValuesIdentity = filterValuesIdentity;
    self.filterValuesRequested = filterValuesCurrent;
    self.filterValuesConfig = filterValuesConfig;
    
    self.filterTypeParsed = .init(fromWrapper: wrapper);
  };
};
