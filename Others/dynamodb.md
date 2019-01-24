### Dynamo DB

<span style="background-color:cyan">Reading material</span>  
&#9635; [What Is Amazon
DynamoDB?](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html)
 -- Start page of DynamoDB

&#9635; [Amazon DynamoDB: How It
Works](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.html)
 -- The entrance to Dynamo DB theory

&#9745; [Introduction to DynamoDB
Concepts](http://docs.aws.amazon.com/amazondynamodb/latest/gettingstartedguide/quick-intro.html)
 -- Quick introduction to Dynamo DB basic consept

&#9745; [DynamoDB Core
Components](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html)
 -- The above basic consept with nice examples
* A table of Dynamo DB can have one or two keys only (partition key and sort/range key).  
* Queries must specify those keys or it will fail(?)  
* **Secandary Index**
  * To query with attributes other than primary key, secondary index can be added to the table and
specify values for those key.  
  * Index is like an extract of the *base table*. Index must hold the primary key of base table and
other attributes can be added optionally.  
  * Global index:
    * 2 attributes that are different from primary key of the table.
  * Local index:
    * 2 attributes, one is same at the partition key and the other is different from sort/range key.
  * You can define up to 5 global secondary indexes and 5 local secondary indexes per table
* Dynamo DB table's keys are restricted to String, Number or Binary. Other attributes can have any
kind of value including nested attributes (it's like nested json).  

&#9744; [Improving Data Access with Secondary
Indexes](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/SecondaryIndexes.html)
 -- more detail on Secondary Index

&#9744; [Limits in
DynamoDB](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Limits.html)


&#9745; [Time To Live](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/TTL.html)  
(I read mobile version which is less detailed)
*Time To Live (TTL)* can be enabled on a table at no extra cost.  
*TTL* is like expiry date (time) of an item.
An attributes which is epoc time can represent *TTL* and when the current time passed the *TTL*, the
item will be deleted.  
There is a time lag up to 48 hours depending on the *throuput* of the table and availability of the
resources.  

&#9744; [Throughput Capacity for Reads and
Writes](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.ProvisionedThroughput.html)
 -- How much resource *Read* and *Write* uses(?)

&#9744; [Item Sizes and Capacity Unit
Consumption](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/CapacityUnitCalculations.html)
 -- How to determine throughput(?)

&#9744; [Java Code
Samples](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/CodeSamples.Java.html)  

&#9745; [Java and
DynamoDB](http://docs.aws.amazon.com/amazondynamodb/latest/gettingstartedguide/GettingStarted.Java.html)
 -- Tutorial with java  
 All examples are to access database directory (ie without using mapper)

&#9635; [The DynamoDBMapper
Class](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBMapper.Methods.html)
 -- Some methods of DynamoDBMapper class are explained

<mark>TODO</mark> <span style="color: green"></span>  
&#9635; Setup DynamoDB  
&#8192;&#8192;&#9745; Install Dynamo DB plugin to eclipse  
&#8192;&#8192;&#9744; Create get, put and query function  
&#8192;&#8192;&#9744; What happens if get(Class, key) specifying only partition key is called? E.g. Test.class, "2"  
&#9744; Create table with secondary index and play with it  
&#8192;&#8192;&#9744; Is it possible to retrieve data from index with the entity class of base table?  
&#8192;&#8192;&#9744; What happens if some items do not have values on attributes that are secondary index?  
&#8192;&#8192;&#9744; How about duplicate index?  
&#8192;&#8192;&#9744; Is it possible to force not full in java code using annotation or something?  
&#9744; batchDelete() - is it really up to 25 items? How about other batch...()?  
&#9744; [Try nested attributes (like nested json) and how to handle it using entity
class](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html)  
&#9744; Find out how to increment a data  
&#9744; Find out how to update particular data  
