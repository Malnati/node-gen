// demo/sspa/src/dashboard.tsx
import type { CSSProperties, JSX } from 'react';
import { useEffect, useMemo, useState } from 'react';
import { navigateToUrl } from 'single-spa';

type DiscoveryApplication = {
  name: string;
  module: string;
  route: string;
  title: string;
  description: string;
};

const containerStyle: CSSProperties = {
  maxWidth: '1080px',
  margin: '0 auto',
  padding: '24px 16px',
};

const cardsStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
  gap: '12px',
};

const cardStyle: CSSProperties = {
  border: '1px solid #D0D7DE',
  borderRadius: '10px',
  padding: '16px',
  cursor: 'pointer',
  background: '#FFFFFF',
};

const mountStyle: CSSProperties = {
  marginTop: '20px',
  paddingTop: '20px',
  borderTop: '1px solid #D0D7DE',
};

export function Dashboard(): JSX.Element {
  const [applications, setApplications] = useState<DiscoveryApplication[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const discoveryBaseUrl = import.meta.env.VITE_DISCOVERY_BASE_URL || 'http://localhost:3015';
  const applicationsUrl = useMemo(
    () => `${discoveryBaseUrl}/api/discovery/applications`,
    [discoveryBaseUrl]
  );

  useEffect(() => {
    const run = async () => {
      try {
        const response = await fetch(applicationsUrl);
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }

        const payload = (await response.json()) as DiscoveryApplication[];
        setApplications(payload);
      } catch (err) {
        const message = err instanceof Error ? err.message : String(err);
        setError(message);
      } finally {
        setLoading(false);
      }
    };

    run().catch((err) => {
      setError(err instanceof Error ? err.message : String(err));
      setLoading(false);
    });
  }, [applicationsUrl]);

  return (
    <div style={containerStyle}>
      <h1>SSPA Dynamic Discovery</h1>
      <p>Cards descobertos via endpoint remoto.</p>

      {loading ? <p>Carregando...</p> : null}
      {error ? <p>Erro no discovery: {error}</p> : null}

      <section style={cardsStyle}>
        {applications.map((application) => (
          <article
            key={application.name}
            style={cardStyle}
            onClick={() => navigateToUrl(application.route)}
          >
            <h3>{application.title || application.name}</h3>
            <p>{application.description}</p>
            <small>{application.route}</small>
          </article>
        ))}
      </section>

      <section style={mountStyle}>
        {applications.map((application) => (
          <div key={application.name} id={`single-spa-application:${application.name}`}></div>
        ))}
      </section>
    </div>
  );
}
