//
//  File.swift
//  
//
//  Created by Dominic Go on 9/18/23.
//

import Foundation


protocol HashedStringDecodable: RawRepresentable where RawValue == String  {

  var encodedString: String { get };
  
  var decodedString: String? { get };
};


fileprivate var decodedStringCache: Dictionary<String, String> = [:];

extension HashedStringDecodable {

  var decodedString: String? {
    let encodedString = self.encodedString;
    
    if let decodedString = decodedStringCache[encodedString] {
      return decodedString;
    };
    
    guard let data = Data(base64Encoded: encodedString),
          let decodedString = String(data: data, encoding: .utf8)
    else {
      #if DEBUG
      print(
        "HashedStringDecodable.decodedString",
        "\n- rawValue: \(self.rawValue)",
        "\n- encodedString: \(encodedString)",
        "\n- couldn't decode string",
        "\n"
      );
      #endif
      return nil;
    };
    
    decodedStringCache[encodedString] = decodedString;
    return decodedString;
  };
};
