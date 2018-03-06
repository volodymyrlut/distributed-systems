1. Ok
2. Напишіть запит, який виведіть усі товари (відображення у JSON)
```
db.getCollection('products').find({})
```
3. Підрахуйте скільки товарів певної категорії

QUERY:

```
db.getCollection('products').aggregate(
   [
      {
        $group : {
           _id : { category: "$category" },
           count: { $sum: 1 }
        }
      }
   ]
)
```

OUTPUT:

```
/* 1 */
{
    "_id" : {
        "category" : "Laptop"
    },
    "count" : 1.0
}

/* 2 */
{
    "_id" : {
        "category" : "Phone"
    },
    "count" : 3.0
}
```

4. Напишіть запити, які вибирають товари за різними критеріям і їх сукупності: категорія та ціна (в проміжку), розмір (наприклад розмір взуття або діагональ екрану) або модель, конструкція з використанням in

Телефони від 400 до 600

QUERY:

```
db.getCollection('products').find( { category: "Phone", price: { $gt: 400, $lt: 700 } } )
```

OUTPUT:
```
/* 1 */
{
    "_id" : ObjectId("5a9df19cb3ddffadeb11d257"),
    "category" : "Phone",
    "model" : "iPhone 6",
    "producer" : "Apple",
    "price" : 600
}
```

Виробник in "Samsung", "Apple":

```
db.getCollection('products').find( { category: "Phone", producer: { $in: ["Apple", "Samsung"] } } )
```

```
/* 1 */
{
    "_id" : ObjectId("5a9df19cb3ddffadeb11d257"),
    "category" : "Phone",
    "model" : "iPhone 6",
    "producer" : "Apple",
    "price" : 600
}

/* 2 */
{
    "_id" : ObjectId("5a9df1adb3ddffadeb11d258"),
    "category" : "Phone",
    "model" : "iPhone X",
    "producer" : "Apple",
    "price" : 1000
}

/* 3 */
{
    "_id" : ObjectId("5a9df1eab3ddffadeb11d25a"),
    "category" : "Phone",
    "model" : "Galaxy",
    "producer" : "Samsung",
    "price" : 800
}
```

5. Виведіть список всіх виробників товарів без повторів

```
db.getCollection('products').distinct("producer")
```

```
/* 1 */
[
    "Apple",
    "Samsung"
]
```

6. Оновить певні товари, змінивши існуючі значення і додайте нові властивості (характеристики) товару за певним критерієм

Змінимо ціну на всі продукти епл - додамо по 200 баксів на кожен

```
db.getCollection('products').update({"producer": "Apple"}, { $inc: { "price": 200 } }, {"multi": true} )
```

```
Updated 3 existing record(s) in 2ms
```

7. Знайдіть товари у яких є (присутнє поле) певні властивості

```
db.getCollection('products').find({"used": {$exists: true}})
```

```
/* 1 */
{
    "_id" : ObjectId("5a9df19cb3ddffadeb11d257"),
    "category" : "Phone",
    "model" : "iPhone 6",
    "producer" : "Apple",
    "price" : 2400.0,
    "used" : true
}

/* 2 */
{
    "_id" : ObjectId("5a9df1eab3ddffadeb11d25a"),
    "category" : "Phone",
    "model" : "Galaxy",
    "producer" : "Samsung",
    "price" : 800,
    "used" : false
}
```

Part 2.

1. Створіть кілька замовлень з різними наборами товарів, але так щоб один з товарів був у декількох замовленнях

2. Виведіть всі замовлення

```
db.getCollection('orders').find({})
```

```
/* 1 */
{
    "_id" : ObjectId("5a9dfafcb3ddffadeb11d25b"),
    "order_number" : 201513,
    "date" : ISODate("2015-04-15T00:34:20.201Z"),
    "total_sum" : 1923.4,
    "customer" : {
        "name" : "Andrii",
        "surname" : "Rodinov",
        "phones" : [
            9876543,
            1234567
        ],
        "address" : "PTI, Peremohy 37, Kyiv, UA"
    },
    "payment" : {
        "card_owner" : "Andrii Rodionov",
        "cardId" : 12345678
    },
    "order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1adb3ddffadeb11d258")
        },
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1eab3ddffadeb11d25a")
        }
    ]
}

/* 2 */
{
    "_id" : ObjectId("5a9dfb43b3ddffadeb11d25c"),
    "order_number" : 201513,
    "date" : ISODate("2015-04-15T00:34:20.201Z"),
    "total_sum" : 53.4,
    "customer" : {
        "name" : "John",
        "surname" : "Doe",
        "phones" : [
            9876543,
            1234567
        ],
        "address" : "PTI, Peremohy 37, Kyiv, UA"
    },
    "payment" : {
        "card_owner" : "John Doe",
        "cardId" : 12345678
    },
    "order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("552bc0f7bbcdf26a32e99954")
        },
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1adb3ddffadeb11d258")
        }
    ]
}

/* 3 */
{
    "_id" : ObjectId("5a9dfbabb3ddffadeb11d25d"),
    "order_number" : 201513,
    "date" : ISODate("2015-04-15T00:34:20.201Z"),
    "total_sum" : 2500.4,
    "customer" : {
        "name" : "Kovalyk",
        "surname" : "Tetiana",
        "phones" : [
            9876543,
            1234567
        ],
        "address" : "PTI, Peremohy 37, Kyiv, UA"
    },
    "payment" : {
        "card_owner" : "Zhdanova Olena",
        "cardId" : 12345678
    },
    "order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1d0b3ddffadeb11d259")
        }
    ]
}
```

3. Виведіть замовлення з вартістю більше певного значення


```
db.getCollection('orders').find({"total_sum": {$gt: 1000}})
```

```
/* 1 */
{
    "_id" : ObjectId("5a9dfafcb3ddffadeb11d25b"),
    "order_number" : 201513,
    "date" : ISODate("2015-04-15T00:34:20.201Z"),
    "total_sum" : 1923.4,
    "customer" : {
        "name" : "Andrii",
        "surname" : "Rodinov",
        "phones" : [
            9876543,
            1234567
        ],
        "address" : "PTI, Peremohy 37, Kyiv, UA"
    },
    "payment" : {
        "card_owner" : "Andrii Rodionov",
        "cardId" : 12345678
    },
    "order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1adb3ddffadeb11d258")
        },
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1eab3ddffadeb11d25a")
        }
    ]
}

/* 2 */
{
    "_id" : ObjectId("5a9dfbabb3ddffadeb11d25d"),
    "order_number" : 201513,
    "date" : ISODate("2015-04-15T00:34:20.201Z"),
    "total_sum" : 2500.4,
    "customer" : {
        "name" : "Kovalyk",
        "surname" : "Tetiana",
        "phones" : [
            9876543,
            1234567
        ],
        "address" : "PTI, Peremohy 37, Kyiv, UA"
    },
    "payment" : {
        "card_owner" : "Zhdanova Olena",
        "cardId" : 12345678
    },
    "order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1d0b3ddffadeb11d259")
        }
    ]
}
```


4. Знайдіть замовлення зроблені одним замовником

```
db.getCollection('orders').find({"customer.name": "Kovalyk", "customer.surname": "Tetiana",})
```

```
/* 1 */
{
    "_id" : ObjectId("5a9dfbabb3ddffadeb11d25d"),
    "order_number" : 201513,
    "date" : ISODate("2015-04-15T00:34:20.201Z"),
    "total_sum" : 2500.4,
    "customer" : {
        "name" : "Kovalyk",
        "surname" : "Tetiana",
        "phones" : [
            9876543,
            1234567
        ],
        "address" : "PTI, Peremohy 37, Kyiv, UA"
    },
    "payment" : {
        "card_owner" : "Zhdanova Olena",
        "cardId" : 12345678
    },
    "order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1d0b3ddffadeb11d259")
        }
    ]
}
```

5. Знайдіть всі замовлення з певним товаром (товарами) (шукати можна по ObjectId)

```
db.getCollection('orders').find({"order_items_id.$id": {$in: [ObjectId("5a9df1adb3ddffadeb11d258")]}})
```

```
/* 1 */
{
    "_id" : ObjectId("5a9dfafcb3ddffadeb11d25b"),
    "order_number" : 201513,
    "date" : ISODate("2015-04-15T00:34:20.201Z"),
    "total_sum" : 1923.4,
    "customer" : {
        "name" : "Andrii",
        "surname" : "Rodinov",
        "phones" : [
            9876543,
            1234567
        ],
        "address" : "PTI, Peremohy 37, Kyiv, UA"
    },
    "payment" : {
        "card_owner" : "Andrii Rodionov",
        "cardId" : 12345678
    },
    "order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1adb3ddffadeb11d258")
        },
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1eab3ddffadeb11d25a")
        }
    ]
}

/* 2 */
{
    "_id" : ObjectId("5a9dfb43b3ddffadeb11d25c"),
    "order_number" : 201513,
    "date" : ISODate("2015-04-15T00:34:20.201Z"),
    "total_sum" : 53.4,
    "customer" : {
        "name" : "John",
        "surname" : "Doe",
        "phones" : [
            9876543,
            1234567
        ],
        "address" : "PTI, Peremohy 37, Kyiv, UA"
    },
    "payment" : {
        "card_owner" : "John Doe",
        "cardId" : 12345678
    },
    "order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("552bc0f7bbcdf26a32e99954")
        },
        {
            "$ref" : "products",
            "$id" : ObjectId("5a9df1adb3ddffadeb11d258")
        }
    ]
}
```

6. Додайте в усі замовлення з певним товаром ще один товар і збільште існуючу вартість замовлення на Х

```
db.getCollection('orders').update({"order_items_id.$id": {$in: [ObjectId("5a9df1adb3ddffadeb11d258")]}}, {$push: {"order_items_id": {"$ref": "products", "$id": ObjectId("5a9df1d0b3ddffadeb11d259")}}, $inc: {"total_sum": 3000}}, {"multi": true})
```

```
Updated 2 existing record(s) in 2ms
```

7. Виведіть кількість товарів в певному замовленні

```
db.getCollection('orders').aggregate([{$match: { _id: ObjectId("5a9dfafcb3ddffadeb11d25b")}}, {$project: { count: { $size: "$order_items_id" }}}])
```

```
/* 1 */
{
    "_id" : ObjectId("5a9dfafcb3ddffadeb11d25b"),
    "count" : 3
}
```

8. Виведіть тільки власників і номери кредитних карт, вартість замовлень яких перевищує певну суму

```
db.getCollection('orders').find({ "total_sum": { $gt: 2800 } }, { "payment.card_owner": 1, "payment.cardId": 1 }, {"multi": true})
```

```
/* 1 */
{
    "_id" : ObjectId("5a9dfafcb3ddffadeb11d25b"),
    "payment" : {
        "card_owner" : "Andrii Rodionov",
        "cardId" : 12345678
    }
}

/* 2 */
{
    "_id" : ObjectId("5a9dfb43b3ddffadeb11d25c"),
    "payment" : {
        "card_owner" : "John Doe",
        "cardId" : 12345678
    }
}
```

9. Hmmmmm, I need to think on it

10.

```
db.getCollection('orders').updateMany({}, {$set: {"customer.surname": "Lut"}})
```

```
/* 1 */
{
    "acknowledged" : true,
    "matchedCount" : 3.0,
    "modifiedCount" : 3.0
}
```



