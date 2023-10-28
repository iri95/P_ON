import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import Nav from '@/components/NavBar';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'P:ON',
  description: '핑키가 관리하는 약속 및 일정 관리 앱',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <meta name="google-site-verification" content="wXqbRHLSsIryb4TbVEEEO2uBOcxygcDOzvgwhJbvlxw" />
        <meta name="naver-site-verification" content="8e3fcf0a7a62a2254e119fe92a0e27afbc44a297" />
      </head>
      <body className={inter.className}>
        <Nav />
        {children}
      </body>
    </html>
  );
}
