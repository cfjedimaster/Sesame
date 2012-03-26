<!---
	Copyright 2012 Mark Mandel

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	   http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.



	Functions pertaining to collections - Structs/Arrays
--->
<cfscript>
	/**
	 * collect data from one array into a whole new array. Transform closure should return the item that i
	 * to be added to the new array.
	 *
	 * @data the array to collect from
	 * @transform closure to return the item for the new array
	 */
	public array function _collect(required any data, required function transform)
	{
		var collection = [];

		if(isArray(arguments.data))
		{
			ArrayEach(arguments.data, function(it)
			{
				ArrayAppend(collection, transform(it));
			});
		}
		else if(isStruct(arguments.data))
		{
			StructEach(arguments.data, function(k, v)
			{
				ArrayAppend(collection, transform(k, v));
			});
		}

		return collection;
	};
	
	/**
	 * collect data from an array or a struct into a new struct.
	 * The transform function can return either a Map, with a single key to be used as the key, and a 2nd level struct,
	 * or an array, where the 1st index in the key, and the 2nd is the value.
	 *
	 * @data the array / struct to collect from
	 * @transform the closure to create the map entry.
	 */
	public struct function _collectEntries(required any data, required function transform)
	{
		var collection = {};
		var _transform = arguments.transform; //so we can reach it later

		var addToCollection = function(required any item)
		{
			if(isArray(arguments.item))
			{
				StructInsert(collection, arguments.item[1], arguments.item[2], true);
			}
			else if(isStruct(arguments.item))
			{
				var key = structKeyList(arguments.item);
				StructInsert(collection, key, arguments.item[key], true);
			}
		};

		if(isArray(arguments.data))
		{
			ArrayEach(arguments.data, function(it) { addToCollection( _transform(it) ); });
		}
		else if(isStruct(arguments.data))
		{
			StructEach(arguments.data, function(k, v) { addToCollection( _transform(k, v) ); });
		}

		return collection;
	}
	
	/**
	 * Take an array/struct and group the data into a grouped struct. The closure should return the key that
	 * the data should be grouped by.
	 * For arrays, this will return a struct of arrays.
	 * For structs, this will return a struct of structures.
	 *
	 * @data the array / struct
	 * @grouping the closure to return the group key.
	 */
	public struct function _groupBy(required any data, required function grouping)
	{
		var collection = {};
		var _grouping = arguments.grouping; //save for later

		if(isArray(arguments.data))
		{
			ArrayEach(arguments.data, function(it)
			{
				var key = _grouping(it);
				if(!structKeyExists(collection, key))
				{
					collection[key] = [];
				}
				ArrayAppend(collection[key], it);
			});
		}
		else if(isStruct(arguments.data))
		{
			StructEach(arguments.data, function(k, v)
			{
				var key = _grouping(k, v);
				if(!structKeyExists(collection, key))
				{
					collection[key] = {};
				}
				collection[key][arguments.k] = arguments.v;
			});
		}

		return collection;
	}
	
</cfscript>