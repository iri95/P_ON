import Head from 'next/head';

export default function page() {
  return (
    <div>
      <Head>
        <title>My Page</title>
      </Head>

      <iframe src="http://k9e102.p.ssafy.io:5000" width="100%" height="500px" style={{ border: 'solid black' }} />
      {/* <iframe src="https://www.google.com" width="100%" height="500px" style={{ border: 0 }} /> */}
    </div>
  );
}
