package usecases

import (
	"fmt"
	"io/ioutil"
	"path/filepath"
	"strconv"
)

type WeekContent struct {
	Slug        string `json:"slug"`
	Week        int    `json:"week"`
	Lectura     string `json:"lectura"`
	Complemento string `json:"complemento"`
	Glosario    string `json:"glosario"`
}

type FetchContentUseCase struct {
	BaseDir string
}

func NewFetchContentUseCase(baseDir string) *FetchContentUseCase {
	return &FetchContentUseCase{
		BaseDir: baseDir,
	}
}

// Execute accepts a slug that is either a week number ("0"..."10") or a named
// module slug ("ciberseguridad"). Numeric slugs map to "semana-N" directories;
// named slugs map to a directory with the same name.
func (uc *FetchContentUseCase) Execute(slug string) (*WeekContent, error) {
	var weekDir string
	weekNum := -1

	if n, err := strconv.Atoi(slug); err == nil {
		weekNum = n
		weekDir = filepath.Join(uc.BaseDir, fmt.Sprintf("semana-%d", n))
	} else {
		weekDir = filepath.Join(uc.BaseDir, slug)
	}

	lectura, err := readFileIfExists(filepath.Join(weekDir, "lectura.md"))
	if err != nil {
		return nil, fmt.Errorf("error reading lecture: %w", err)
	}

	complemento, err := readFileIfExists(filepath.Join(weekDir, "complemento.md"))
	if err != nil {
		return nil, fmt.Errorf("error reading complement: %w", err)
	}

	glosario, err := readFileIfExists(filepath.Join(weekDir, "glosario.md"))
	if err != nil {
		return nil, fmt.Errorf("error reading glossary: %w", err)
	}

	return &WeekContent{
		Slug:        slug,
		Week:        weekNum,
		Lectura:     lectura,
		Complemento: complemento,
		Glosario:    glosario,
	}, nil
}

func readFileIfExists(path string) (string, error) {
	bytes, err := ioutil.ReadFile(path)
	if err != nil {
		return "", nil
	}
	return string(bytes), nil
}
