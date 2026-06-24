package usecases

import (
	"localcode/internal/application/ports"
	"localcode/internal/domain"
)

type FetchSolutionUseCase struct {
	Repo ports.SolutionRepository
}

func NewFetchSolutionUseCase(r ports.SolutionRepository) *FetchSolutionUseCase {
	return &FetchSolutionUseCase{Repo: r}
}

func (uc *FetchSolutionUseCase) Execute(problemId string) (*domain.Solution, error) {
	return uc.Repo.FindByProblemId(problemId)
}
