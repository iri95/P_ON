import Link from 'next/link';

export default function nav() {
  return (
    <nav>
      <Link href="/">홈</Link>|<Link href="mobile">모바일</Link>
    </nav>
  );
}
