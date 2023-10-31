import Link from 'next/link';

export default function nav() {
  return (
    <nav>
      <Link href="#section1">section1</Link>
      <Link href="#section2">section2</Link>
      <Link href="#section3">section3</Link>
      <Link href="#section4">section4</Link>
      <Link href="#section5">section5</Link>
    </nav>
  );
}
