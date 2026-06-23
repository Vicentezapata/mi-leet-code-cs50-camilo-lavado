import { useState, useEffect } from 'react';
import { api } from '@/api/client';

export interface WeekContent {
  slug: string;
  week: number;
  lectura: string;
  complemento: string;
  glosario: string;
}

export function useContent(slug: string) {
  const [content, setContent] = useState<WeekContent | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    setIsLoading(true);
    setError(null);
    api.get(`/content/${slug}`)
      .then((res: any) => {
        setContent(res.data);
      })
      .catch((err: Error) => {
        setError(err);
      })
      .finally(() => {
        setIsLoading(false);
      });
  }, [slug]);

  return { content, isLoading, error };
}
