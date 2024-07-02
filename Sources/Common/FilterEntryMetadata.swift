//
//  FilterEntryMetadata.swift
//  
//
//  Created by Dominic Go on 6/27/24.
//

import Foundation

public struct FilterEntryMetadata {

  public var filterTypeRaw: String;
  public var identityValues: Dictionary<String, Any>;
  public var requestedValues: Dictionary<String, Any>;
  public var configurationValues: Dictionary<String, Any>;
  public var filterTypeParsed: LayerFilterType?;
  
  init(
    filterTypeRaw: String,
    identityValues: Dictionary<String, Any>,
    requestedValues: Dictionary<String, Any>,
    configurationValues: Dictionary<String, Any>,
    filterTypeParsed: LayerFilterType?
  ) {
    self.filterTypeRaw = filterTypeRaw;
    self.identityValues = identityValues;
    self.requestedValues = requestedValues;
    self.configurationValues = configurationValues;
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
    self.identityValues = filterValuesIdentity;
    self.requestedValues = filterValuesCurrent;
    self.configurationValues = filterValuesConfig;
    
    self.filterTypeParsed = .init(fromWrapper: wrapper);
  };
};
