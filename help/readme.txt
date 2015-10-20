#Launch mongodb

nohup mongod --noprealloc --smallfiles --dbpath ./data_db/ >>mongo_log.log &

#Launch node

nohup node Prueba.js >>node_log.log &
