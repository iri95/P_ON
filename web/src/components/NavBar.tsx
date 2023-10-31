import Link from 'next/link';
import Image from 'next/image';
import styles from './NavBar.module.css';

export default function nav() {
  return (
    <header>
      <Link href="/">
        <Image alt="Pinky 핑키" src="/Pinky/Pinky1.png" width={50} height={50} />
        <span>P:ON</span>
      </Link>
      <nav>
        {/* <section>
          <Link href="/#section1">section1</Link>
          <Link href="/#section2">section2</Link>
          <Link href="/#section3">section3</Link>
        </section> */}
        <Link className={styles.navItem} href="/">
          앱 소개
        </Link>
        <Link className={styles.navItem} href="/how-to-use">
          이용 방법
        </Link>
        <Link className={styles.navItem} href="/faq">
          FAQ
        </Link>
      </nav>
    </header>
  );
}
