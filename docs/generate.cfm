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
--->
<cfscript>
	readme = fileOpen(expandPath("/README.md"), "write");
</cfscript>

<cfsavecontent variable="header">
<!--
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
-->

Sesame
======

> *"Then he thought within himself: "I too will try the virtue of those magical words and see if at my bidding the door will open and close." So he called out aloud, "Open, Sesame!" And no sooner had he spoken than straightway the portal flew open and he entered within."*<br/>
>	- [Ali Baba and the Forty Thieves, translated by Sir Richard Burton, 1850][1].

*Sesame* is a library of functions for use with closures.

All functions start with an underscore, so as to not collide with already existing ColdFusion or functions that you may have written in your page or component.

It currently has 4 sections:

- Collections: for the use with arrays and structs
- Functions: for the use with other functions and closures.
- Numbers: for use with numbers and general looping
- Concurrency: To make threading operations easier
</cfsavecontent>


<cfsavecontent variable="footer">


Contributions
-------------
Please feel free to fork this project and contribute.

Do note that the readme is generated by the `generate.cfm` file, which creates the documentation from the function hint meta data.
So if your functions are properly commented, the documentation can be updated automatically.

Therefore, if you want to contribute to the documentation, please do so in the relevent functions comments, so that it ends up in the README.md on regeneration.

Thanks!!!

[1]: http://classiclit.about.com/library/bl-etexts/arabian/bl-arabian-alibaba.htm
</cfsavecontent>

<cfsavecontent variable="concurrencyDesc">
Functions for working with threads and concurrent programmings

*Please Note*: To use this concurrency library, there will need to be a mapping to /sesame, or /sesame will need to be in the root of your project, as there are components
that need to be instantiated to interact with the Java concurrency libraries.
</cfsavecontent>

<cfscript>
	fileWrite(readme, header);

	sections =
	[
			{file = "collections.cfm", title="Collections", description="Functions that allow you manipulate and use structs and arrays much easier"}
			,{file = "functions.cfm", title="Functions", description="Functions that allow you to manipulate other functions / closures"}
			,{file = "numbers.cfm", title="Numbers", description="Functions for working with numbers and general looping"}
			,{file = "concurrency.cfm", title="Concurrency", description=concurrencyDesc}
	];
</cfscript>

<cfloop array="#sections#" index="section">
	<cfinclude template="../sesame/#section.file#" />

<cfoutput>
	<cfsavecontent variable="sectionMD">

#### #section.title# ####

#section.description#
	</cfsavecontent>
</cfoutput>

	<cfscript>
		fileWrite(readme, sectionMD);
		keys = structKeyArray(variables);
		arraySort(keys, "textnocase");
	</cfscript>

	<cfloop array="#keys#" index="key">
		<cfset item = variables[key] />
		<cfif isCustomFunction(item) and !Lcase(key).startsWith("_cffunccfthread")>
			<cfscript>
				structDelete(variables, key);
				meta = getMetadata(item);

				label = meta.name & "(";
				params = "";
				arrayEach(meta.parameters, function(it)
				{
					param = it.name;

					if(!StructKeyExists(it, "type"))
					{
						param = "any #param#";
					}
					else
					{
						param = it.type & " " & param;
					}

					if(!structKeyExists(it, "required") || !it.required)
					{
						param = "[#param#]";
					}

					params = listAppend(params, param, ", ");
				}
				);

				label &= replace(params, ",", ", ", "all") & ") : ";

				if(!structKeyExists(meta, "returnType"))
				{
					label &= "any";
				}
				else
				{
					label &= meta.returnType;
				}
			</cfscript>

			<cfoutput>
			<cfsavecontent variable="itemMD">

###### #label# ######

#meta.hint#
#chr(10)#
<cfloop array="#meta.parameters#" index="param">
* #param.name# - #param.hint#
</cfloop>
			</cfsavecontent>
			</cfoutput>

			<cfscript>
				fileWrite(readme, itemMD);
			</cfscript>

		</cfif>
	</cfloop>


</cfloop>

<cfscript>
	fileWrite(readme, footer);

	fileClose(readme);
</cfscript>
Done!
