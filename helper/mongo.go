package helper

import (
	"context"
	"fmt"
	config "liveClass/config"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

type MongoWrapper struct {
	mongodb    *config.MongoDB
	database   string
	collection string
}

func NewMongoWrapper(mongodb *config.MongoDB, database, collection string) *MongoWrapper {
	return &MongoWrapper{
		mongodb:    mongodb,
		database:   database,
		collection: collection,
	}
}

func (w *MongoWrapper) getCollection() (*mongo.Collection, error) {
	client, err := w.mongodb.GetClient()
	if err != nil {
		return nil, fmt.Errorf("failed to get MongoDB client: %w", err)
	}
	return client.Database(w.database).Collection(w.collection), nil
}

func (w *MongoWrapper) InsertOne(ctx context.Context, document interface{}) (*mongo.InsertOneResult, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	collection, err := w.getCollection()
	if err != nil {
		return nil, err
	}

	result, err := collection.InsertOne(ctx, document)
	if err != nil {
		return nil, fmt.Errorf("failed to insert document: %w", err)
	}
	return result, nil
}

func (w *MongoWrapper) FindOne(ctx context.Context, filter bson.M) (*mongo.SingleResult, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	collection, err := w.getCollection()
	if err != nil {
		return nil, err
	}

	result := collection.FindOne(ctx, filter)
	if result.Err() != nil {
		return nil, fmt.Errorf("failed to find document: %w", result.Err())
	}
	return result, nil
}

func (w *MongoWrapper) FindAll(ctx context.Context, filter bson.M) (*mongo.Cursor, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	collection, err := w.getCollection()
	if err != nil {
		return nil, err
	}

	cursor, err := collection.Find(ctx, filter)
	if err != nil {
		return nil, fmt.Errorf("failed to find documents: %w", err)
	}
	return cursor, nil
}

func (w *MongoWrapper) UpdateOne(ctx context.Context, filter bson.M, update bson.M) (*mongo.UpdateResult, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	collection, err := w.getCollection()
	if err != nil {
		return nil, err
	}

	result, err := collection.UpdateOne(ctx, filter, bson.M{"$set": update})
	if err != nil {
		return nil, fmt.Errorf("failed to update document: %w", err)
	}
	return result, nil
}

func (w *MongoWrapper) DeleteOne(ctx context.Context, filter bson.M) (*mongo.DeleteResult, error) {
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	collection, err := w.getCollection()
	if err != nil {
		return nil, err
	}

	result, err := collection.DeleteOne(ctx, filter)
	if err != nil {
		return nil, fmt.Errorf("failed to delete document: %w", err)
	}
	return result, nil
}
