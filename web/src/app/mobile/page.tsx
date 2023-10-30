import Head from 'next/head';

export default function page() {
  return (
    <div>
      <Head>
        <title>My Page</title>
        <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests" />
      </Head>

      <iframe
        title="mobileWeb"
        src="http://k9e102.p.ssafy.io:5000"
        width="100%"
        height="500px"
        style={{ border: 'solid black' }}
      />
      <iframe
        title="mobileWeb"
        src="http://k9e102.p.ssafy.io:9090"
        width="100%"
        height="500px"
        style={{ border: 'solid black' }}
      />
      <iframe
        title="mobileWeb"
        src="http://k9e102.p.ssafy.io"
        width="100%"
        height="500px"
        style={{ border: 'solid black' }}
      />
      {/* <iframe src="https://www.google.com" width="100%" height="500px" style={{ border: 0 }} /> */}
    </div>
  );
}
