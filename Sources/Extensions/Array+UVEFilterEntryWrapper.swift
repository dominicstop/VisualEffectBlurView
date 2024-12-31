//
//  Array+UVEFilterEntryWrapper.swift
//  
//
//  Created by Dominic Go on 9/18/24.
//

import Foundation


public extension Array where Element == UVEFilterEntryWrapper {

  typealias FilterEntryTypePair = (
    filterType: LayerFilterType,
    filterTypeIndex: Int,
    filterEntryWrapped: Element
  );
  
  func paired(
    withFilterTypes filterTypes: [LayerFilterType],
    shouldUseReferenceEqualityForImageComparison: Bool = false
  ) -> (
    orphanedFilterEntries: Self,
    orphanedFilterTypes: [LayerFilterType],
    matches: [FilterEntryTypePair]
  ) {
    var orphanedFilterEntries: Self = [];
    
    let matches: [FilterEntryTypePair] = self.compactMap { filterEntryWrapped in
      let match = filterTypes.enumerated().first {
        guard $0.element.decodedFilterName == filterEntryWrapped.filterKind else {
          return false;
        };
        
        if !shouldUseReferenceEqualityForImageComparison {
          return true;
        };
        
        let filterEntryAsLayerType =
          LayerFilterType(fromWrapper: filterEntryWrapped);
      
        switch ($0.element, filterEntryAsLayerType) {
          case (
            let .variadicBlur(_, maskImageNext, _, _, _),
            let .variadicBlur(_, maskImageCurrent, _, _, _)
          ):
            return maskImageNext === maskImageCurrent;
            
            default:
              return true;
        };
      };
      
      guard let match = match else {
        orphanedFilterEntries.append(filterEntryWrapped);
        return nil;
      };
      
      return (
        filterType: match.element,
        filterTypeIndex: match.offset,
        filterEntryWrapped: filterEntryWrapped
      );
    };
    
    let orphanedFilterTypes = filterTypes.filter { filter in
      let match = matches.first {
        filter.decodedFilterName == $0.filterType.decodedFilterName;
      };
      
      return match == nil;
    };
    
    return (orphanedFilterEntries, orphanedFilterTypes, matches);
  };
  
  func onlyElementsWithMatches(
    withFilterTypes filterTypes: [LayerFilterType]
  ) -> Self {
    self.paired(withFilterTypes: filterTypes).matches.map {
      $0.filterEntryWrapped;
    };
  };
  
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
