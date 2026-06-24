package sqlite

import (
	"database/sql"
	"localcode/internal/domain"
)

type SQLiteSolutionRepository struct {
	db *sql.DB
}

func NewSQLiteSolutionRepository(db *sql.DB) *SQLiteSolutionRepository {
	return &SQLiteSolutionRepository{db: db}
}

func (r *SQLiteSolutionRepository) FindByProblemId(problemId string) (*domain.Solution, error) {
	row := r.db.QueryRow(
		"SELECT problem_id, code, language FROM solutions WHERE problem_id = ?",
		problemId,
	)
	var s domain.Solution
	if err := row.Scan(&s.ProblemID, &s.Code, &s.Language); err != nil {
		if err == sql.ErrNoRows {
			return nil, nil
		}
		return nil, err
	}
	return &s, nil
}
