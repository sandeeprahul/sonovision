const String homeScreenJson = '''
{
  "widgets": [
    {
      "widgetType": "search"
    },
    {
      "widgetType": "banners",
      "data": [
        {
          "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8",
          "type": "product",
          "targetId": "p101",
          "title": "New MacBook Pro"
        },
        {
          "image": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9",
          "type": "category",
          "targetId": "c202",
          "title": "Smart Home Devices"
        },
        {
          "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32",
          "type": "product",
          "targetId": "p103",
          "title": "Gaming Laptops"
        }
      ]
    },
    {
      "widgetType": "sale",
      "data": {
        "image": "https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb",
        "endTime": "2025-04-10T23:59:59Z",
        "title": "Flash Sale",
        "subtitle": "Up to 50% off on selected items"
      }
    },
    {
      "widgetType": "group",
      "type": "product",
      "label": "Trending Products",
      "data": [
        {
          "id": "p101",
          "name": "AirPods Pro",
          "image": "https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb",
          "price": 199.99,
          "originalPrice": 249.99,
          "isNew": true
        },
        {
          "id": "p102",
          "name": "Samsung S23 Ultra",
          "image": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9",
          "price": 999.99,
          "originalPrice": 1199.99,
          "isNew": false
        },
        {
          "id": "p103",
          "name": "iPad Air",
          "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8",
          "price": 599.99,
          "originalPrice": 699.99,
          "isNew": true
        }
      ]
    },
    {
      "widgetType": "group",
      "type": "category",
      "label": "Popular Categories",
      "data": [
        {
          "id": "c201",
          "name": "Phones & Tablets",
          "icon": "phone_android",
          "image": "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9"
        },
        {
          "id": "c202",
          "name": "Laptops & PCs",
          "icon": "laptop",
          "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8"
        },
        {
          "id": "c203",
          "name": "Audio & Sound",
          "icon": "headphones",
          "image": "https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb"
        },
        {
          "id": "c204",
          "name": "Smart Watches",
          "icon": "watch",
          "image": "https://images.unsplash.com/photo-1516035069371-29a1b244cc32"
        }
      ]
    },
    {
      "widgetType": "group",
      "type": "product",
      "label": "Best Sellers",
      "data": [
        {
          "id": "p201",
          "name": "MacBook Pro M2",
          "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8",
          "price": 1299.99,
          "originalPrice": 1499.99,
          "isNew": true
        },
        {
          "id": "p202",
          "name": "Sony WH-1000XM4",
          "image": "https://images.unsplash.com/photo-1572569511254-d8f925fe2cbb",
          "price": 349.99,
          "originalPrice": 399.99,
          "isNew": false
        }
      ]
    }
  ]
}
'''; 