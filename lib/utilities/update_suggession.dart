// // my own logic
import 'package:flutter/material.dart';

List<String> updateSuggestions(
    TextEditingValue textEditingValue, Iterable list) {
  if (textEditingValue.text.isEmpty) {
    return const Iterable<String>.empty().toList();
  }
  return list
      .where((dynamic item) {
        return item
                .toString()
                .toLowerCase()
                .substring(0, textEditingValue.text.length)
                .compareTo(textEditingValue.text.toLowerCase()) ==
            0;
      })
      // map() used to transform the elements of a collection and produce a new collection.
      .map((dynamic item) => item.toString())
      .toList();
}



/*
In Flutter, the map() method is used to transform and manipulate the elements of 
a collection (such as a List, Set, or Iterable) and produce a new collection with 
the transformed values. It allows you to apply a function to each element of the 
collection and create a new collection based on the results of those transformations. 
 */
