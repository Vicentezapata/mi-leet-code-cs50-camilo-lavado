import { useState } from 'react';
import { fetchSolution, type Solution } from '@/api/solutions';

export function useSolution(problemId: string) {
  const [solution, setSolution] = useState<Solution | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const load = async () => {
    if (solution) return; // already loaded
    setIsLoading(true);
    setError(null);
    try {
      const data = await fetchSolution(problemId);
      setSolution(data);
    } catch {
      setError('No se pudo cargar la solución.');
    } finally {
      setIsLoading(false);
    }
  };

  return { solution, isLoading, error, load };
}
