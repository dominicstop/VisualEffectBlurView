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
  
  init?(fromWrapper wrapper: VisualEffectFilterEntryWrapper) {
    guard let filterTypeString = wrapper.filterType,
          let identityValues = wrapper.identityValues as? Dictionary<String, Any>,
          let requestedValues = wrapper.requestedValues as? Dictionary<String, Any>,
          let configurationValues = wrapper.configurationValues as? Dictionary<String, Any>
    else {
      return nil;
    };
    
    self.filterTypeRaw = filterTypeString;
    self.identityValues = identityValues;
    self.requestedValues = requestedValues;
    self.configurationValues = configurationValues;
    
    self.filterTypeParsed = .init(fromWrapper: wrapper);
  };
};
