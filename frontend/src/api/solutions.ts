import { api } from './client';

export interface Solution {
  problem_id: string;
  code: string;
  language: string;
}

export async function fetchSolution(problemId: string): Promise<Solution> {
  const res = await api.get<{ data: Solution }>(`/problems/${problemId}/solution`);
  return res.data;
}
