#!/bin/sh

sed -i 's/ChatGPT Web/Hello World/g' /app/index.html
sed -i '/Footer/d' /app/src/views/chat/layout/sider/index.vue
