import type { Metadata } from 'next';
import Nav from '@/components/NavBar';
import '@/styles/reset.css';
import '@/styles/globals.css';

export const metadata: Metadata = {
  title: { template: 'P:ON | %s', default: 'P:ON | 약속 및 일정 관리 앱' },
  description:
    'P:ON은 손쉬운 약속 생성과 친구 초대, 공유 링크를 통한 함께 약속 만들기를 위한 앱입니다. 일정 관리를 위한 캘린더와 일정 관련 챗봇 Pinky를 제공합니다.',
  keywords: ['P:ON', 'Pinky', '플랜온', '핑키', '와니비니'],
  // TODO: og태그 title, image, description
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <meta name="google-site-verification" content="wXqbRHLSsIryb4TbVEEEO2uBOcxygcDOzvgwhJbvlxw" />
        <meta name="naver-site-verification" content="8e3fcf0a7a62a2254e119fe92a0e27afbc44a297" />
        <meta httpEquiv="Content-Security-Policy" content="upgrade-insecure-requests" />
      </head>
      <body>
        <Nav />
        <main>{children}</main>
      </body>
    </html>
  );
}
