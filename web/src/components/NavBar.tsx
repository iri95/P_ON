'use client';

import Link from 'next/link';
import Image from 'next/image';
import { usePathname } from 'next/navigation';
import { useEffect, useState } from 'react';
import styles from './NavBar.module.scss';

export default function Nav() {
  const pathname = usePathname();
  const [active, setActive] = useState(pathname);

  useEffect(() => {
    setActive(pathname);
  }, [pathname]);

  return (
    <header className={styles['nav-container']}>
      <Link href="/" className={styles['nav-icon']}>
        <div className={styles.big}>
          <Image alt="p-on logo" src="/pon-logo.png" fill objectFit="contain" quality={100} />
        </div>
        <div className={styles.small}>
          <Image alt="p-on logo" src="/Pinky/Pinky1.png" fill objectFit="contain" quality={100} />
        </div>
      </Link>
      <nav className={styles['nav-items']}>
        <ul>
          <li className={`${styles['nav-item']} ${active === '/' ? styles.active : ''}`}>
            <Link href="/" scroll={false} className={styles['main-item']}>
              서비스 소개
              {active === '/' && <div className={styles.line} />}
            </Link>
            <ul className={styles.dropdown}>
              <li>
                <Link href="#section1">Section1</Link>
              </li>
              <li>
                <Link href="#section2">Section2</Link>
              </li>
              <li>
                <Link href="#section3">Section3</Link>
              </li>
              <li>
                <Link href="#section4">Section4</Link>
              </li>
            </ul>
          </li>
          <li
            className={`${styles['nav-item']} ${active === '/how-to-use' || active === '/mobile' ? styles.active : ''}`}
          >
            <Link href="/how-to-use" scroll={false} className={styles['main-item']}>
              가이드
              {(active === '/how-to-use' || active === '/mobile') && <div className={styles.line} />}
            </Link>
            <ul className={styles.dropdown}>
              <li>
                <Link href="/how-to-use">P:ON 사용법</Link>
              </li>
              <li>
                <Link href="/mobile">미리보기</Link>
              </li>
            </ul>
          </li>
          <li className={`${styles['nav-item']} ${active === '/faq' ? styles.active : ''}`}>
            <Link href="/faq" scroll={false} className={styles['main-item']}>
              FAQ
              {active === '/faq' && <div className={styles.line} />}
            </Link>
          </li>
        </ul>
      </nav>
    </header>
  );
}
