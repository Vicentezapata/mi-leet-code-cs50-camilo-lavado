import { useState } from 'react';
import { Link } from 'react-router-dom';
import { useProblems } from '@/hooks/useProblems';
import { useSubmissions } from '@/hooks/useSubmissions';
import { ProblemList } from '@/components/problems/ProblemList';
import { GamificationStats } from '@/components/dashboard/GamificationStats';
import { useProgress } from '@/hooks/useProgress';

const ALL_WEEKS = [
  { slug: '0',             label: 'Semana 0',  topic: 'Scratch' },
  { slug: '1',             label: 'Semana 1',  topic: 'C' },
  { slug: '2',             label: 'Semana 2',  topic: 'Arreglos' },
  { slug: '3',             label: 'Semana 3',  topic: 'Algoritmos' },
  { slug: '4',             label: 'Semana 4',  topic: 'Memoria' },
  { slug: '5',             label: 'Semana 5',  topic: 'Estructuras de Datos' },
  { slug: '6',             label: 'Semana 6',  topic: 'Python' },
  { slug: '7',             label: 'Semana 7',  topic: 'SQL' },
  { slug: '8',             label: 'Semana 8',  topic: 'HTML / CSS / JS' },
  { slug: '9',             label: 'Semana 9',  topic: 'Flask' },
  { slug: '10',            label: 'Semana 10', topic: 'Emoji y Unicode' },
  { slug: 'ciberseguridad', label: 'Módulo',   topic: 'Ciberseguridad' },
];

export function CatalogPage() {
  const [weekFilter, setWeekFilter] = useState<number | null>(null);
  const [difficultyFilter, setDifficultyFilter] = useState('all');
  const { data: problemsData, isLoading: problemsLoading, error: problemsError } = useProblems(weekFilter ?? undefined, difficultyFilter);
  const { data: submissionsData, isLoading: submissionsLoading, error: submissionsError } = useSubmissions();
  const { data: progressData } = useProgress();
  
  const problems = problemsData?.data ?? [];
  const submissions = submissionsData?.data ?? [];

  const isLoading = problemsLoading || submissionsLoading;
  const error = problemsError || submissionsError;

  return (
    <div className="relative min-h-full overflow-y-auto">
      <div className="absolute top-0 left-0 w-full h-[500px] bg-gradient-to-b from-local-primary/20 to-transparent pointer-events-none -z-10"></div>
      
      <div className="max-w-6xl mx-auto px-6 py-12">
        <div className="mb-12 text-center">
          <h1 className="text-4xl md:text-5xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-white to-gray-400 mb-4 tracking-tight">
            Explora los Problemas
          </h1>
          <p className="text-lg text-local-muted max-w-2xl mx-auto">
            Domina la programación resolviendo los retos oficiales de CS50. Desde C hasta Python, todo evaluado en tiempo real de forma segura.
          </p>
        </div>

        <div className="glass-panel p-4 mb-8 flex flex-wrap items-center gap-4 bg-local-panel/40 border border-white/5">
          <div className="flex items-center gap-3">
            <label htmlFor="week-filter" className="text-sm font-medium text-local-muted">Semana</label>
            <select
              id="week-filter"
              value={weekFilter ?? ''}
              onChange={(e) => {
                const v = e.target.value;
                setWeekFilter(v === '' ? null : Number(v));
              }}
              className="bg-black/30 border border-white/5 rounded-lg px-3 py-1.5 text-sm text-local-text focus:outline-none focus:border-local-primary cursor-pointer"
            >
              <option value="">Todas las semanas</option>
              <option value={0}>Semana 0 — Scratch</option>
              <option value={1}>Semana 1 — C</option>
              <option value={2}>Semana 2 — Arreglos</option>
              <option value={3}>Semana 3 — Algoritmos</option>
              <option value={4}>Semana 4 — Memoria</option>
              <option value={5}>Semana 5 — Estructuras de Datos</option>
              <option value={6}>Semana 6 — Python</option>
              <option value={7}>Semana 7 — SQL</option>
              <option value={8}>Semana 8 — HTML/CSS/JS</option>
              <option value={9}>Semana 9 — Flask</option>
              <option value={10}>Semana 10 — Emoji</option>
            </select>
          </div>
          <div className="flex items-center gap-3">
            <label htmlFor="difficulty-filter" className="text-sm font-medium text-local-muted">Dificultad</label>
            <select
              id="difficulty-filter"
              value={difficultyFilter}
              onChange={(e) => setDifficultyFilter(e.target.value)}
              className="bg-black/30 border border-white/5 rounded-lg px-3 py-1.5 text-sm text-local-text focus:outline-none focus:border-local-primary cursor-pointer"
            >
              <option value="all">Todas las dificultades</option>
              <option value="Easy">Fácil</option>
              <option value="Medium">Media</option>
              <option value="Hard">Difícil</option>
            </select>
          </div>
        </div>

        {/* Navegación de teoría — todas las semanas */}
        <div className="glass-panel p-5 mb-8 bg-local-panel/40 border border-white/5">
          <p className="text-xs font-semibold uppercase tracking-wider text-local-muted mb-3">Teoría del curso</p>
          <div className="flex flex-wrap gap-2">
            {ALL_WEEKS.map(({ slug, label, topic }) => (
              <Link
                key={slug}
                to={`/weeks/${slug}`}
                className="flex flex-col px-3 py-2 rounded-lg bg-white/5 hover:bg-local-primary/20 border border-white/10 hover:border-local-primary/50 transition-all text-left"
              >
                <span className="text-xs text-local-muted font-medium">{label}</span>
                <span className="text-sm text-white font-semibold">{topic}</span>
              </Link>
            ))}
          </div>
        </div>

        <GamificationStats />

        {progressData && (
          <div className="glass-panel p-4 mb-8 bg-local-panel/40 border border-white/5">
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-semibold text-local-muted uppercase tracking-wider">
                Progreso General
              </span>
              <span className="text-sm text-local-muted">
                {progressData.summary.solved} / {progressData.summary.total} resueltos
              </span>
            </div>
            <div className="w-full bg-black/30 rounded-full h-3 overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-local-primary to-local-accent rounded-full transition-all duration-500"
                style={{ width: `${progressData.summary.total > 0 ? (progressData.summary.solved / progressData.summary.total) * 100 : 0}%` }}
              />
            </div>
            <div className="flex gap-4 mt-2 text-xs text-local-muted">
              <span>✅ {progressData.summary.solved} resueltos</span>
              <span>🔄 {progressData.summary.in_progress} en progreso</span>
              <span>⬜ {progressData.summary.not_attempted} sin intentar</span>
            </div>
          </div>
        )}
        
        <ProblemList problems={problems} submissions={submissions} isLoading={isLoading} error={error as Error | null} weekFilter={weekFilter} />
      </div>
    </div>
  );
}
