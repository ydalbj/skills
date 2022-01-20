##### ObjectMapper
ObjectMapper类是Jackson库的主要类，它提供一些功能将数据集或对象转换的实现。
它将使用JsonParser和JsonGenerator实例来实现JSON的实际读/写。

1. Java对象，集合转JSON
```java
         ObjectMapper objectMapper = new ObjectMapper();
 
         User user = new User();
         user.setName("张三");
         user.setAge(20);
         user.setSex("男");
 
         List<User> userList = new ArrayList<>();
         userList.add(user);
 
         // 对象转换为JSON
         String userJsonString = objectMapper.writeValueAsString(user);16 
         // 集合转换为JSON
         String userListJsonString = objectMapper.writeValueAsString(userList);20 }
```

2. JSON转对象，集合
```java
	// JOSN转对象（java对象）
         User newUser = objectMapper.readValue(userJsonString, User.class);
 
         // JOSN转集合（集合）
         List<User> list = objectMapper.readValue(userListJsonString, new TypeReference<List<User>>(){});
```
3.  json转JsonNode、ObjectNode

 - Jackson的JsonNode和ObjectNode两个类，前者是不可变的，一般用于读取。后者可变，一般用于创建Json对象图。
```java
// json转JsonNode
        JsonNode jsonNode = objectMapper.readTree(userJsonString);
        String sex = jsonNode.get("sex").asText();

        // JsonNode转ObjectNode
        ObjectNode objectNode = (ObjectNode)jsonNode;

        // json转JsonNode
        JsonNode jsonNodeList = objectMapper.readTree(userListJsonString);

        // JsonNode转ObjectNode
        ArrayNode arrayNode = (ArrayNode)jsonNodeList;
```

4. jsonNode转对象、集合
```java
	// json转JsonNode
        JsonNode jsonNode = objectMapper.readTree(userJsonString);
        String sex = jsonNode.get("sex").asText();

        // JsonNode转ObjectNode
        ObjectNode objectNode = (ObjectNode)jsonNode;

        // json转JsonNode
        JsonNode jsonNodeList = objectMapper.readTree(userListJsonString);

        // JsonNode转ObjectNode
        ArrayNode arrayNode = (ArrayNode)jsonNodeList;
```

参考：[Java使用ObjectMapper的简单示例](https://www.cnblogs.com/wgx519/p/13688615.html)