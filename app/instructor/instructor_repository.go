package instructor

import (
	"github.com/CHINMAYVIVEK/liveClass/helper"
)

type InstructorRepository struct {
	db *helper.PostgresWrapper
}

func NewRepository(db *helper.PostgresWrapper) *InstructorRepository {
	return &InstructorRepository{db: db}
}
