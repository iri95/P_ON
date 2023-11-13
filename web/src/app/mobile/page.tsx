import Head from 'next/head';
import Mobile from '@/containers/Mobile';

export default function page() {
  return (
    <div className="container">
      <Head>
        <title>P:ON Demo</title>
      </Head>
      <Mobile />
    </div>
  );
}
