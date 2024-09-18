//
//  Array+UVEFilterEntryWrapper.swift
//  
//
//  Created by Dominic Go on 9/18/24.
//

import Foundation


public extension Array where Element == UVEFilterEntryWrapper {
  
  func updateFilterValuesRequested(with newFilter: LayerFilterType) throws {
    let filterMatch = self.first {
      guard let filter = LayerFilterType(fromWrapper: $0) else {
        return false;
      };
      
      return filter.decodedFilterName == newFilter.decodedFilterName;
    };
    
    guard let filterMatch = filterMatch else {
      throw VisualEffectBlurViewError(
        errorCode: .unexpectedNilValue,
        description: "No matching filter found for provided filter",
        extraDebugValues: [
          "newFilter": newFilter.decodedFilterName ?? "N/A",
        ]
      );
    };
    
    let filterValuesRequested =
      NSDictionary(dictionary: newFilter.filterValuesRequested);
    
    try filterMatch.setFilterValuesRequested(filterValuesRequested);
  };
};
