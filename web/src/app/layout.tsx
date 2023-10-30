import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import Nav from '@/components/NavBar';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: { template: 'P:ON | %s', default: 'P:ON | 약속 및 일정 관리 앱' },
  description:
    'P:ON은 손쉽게 약속을 생성하고, 친구들을 초대하거나 공유링크를 생성하여 함께 약속을 만들어가는 앱입니다. P:ON은 캘린더 기능을 갖추고 있어 개인의 일정 관리를 원할하게 할 수 있습니다. P:ON은 일정 관련 챗봇 핑키(Pinky)를 제공하여 약속 및 일정에 관련된 정보를 빠르고 편리하게 얻을 수 있습니다.',
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
      <body className={inter.className}>
        <Nav />
        {children}
      </body>
    </html>
  );
}
