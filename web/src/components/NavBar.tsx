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
          <Image priority alt="p-on logo" src="/pon-logo.png" fill style={{ objectFit: 'contain' }} quality={100} />
        </div>
        <div className={styles.small}>
          <Image priority alt="p-on logo" src="/Pinky/Pinky1.png" fill style={{ objectFit: 'contain' }} quality={100} />
        </div>
      </Link>
      <nav className={styles['nav-items']}>
        <ul>
          <li className={`${styles['nav-item']} ${active === '/' ? styles.active : ''}`}>
            <Link href="/" className={styles['main-item']}>
              서비스 소개
              {active === '/' && <div className={styles.line} />}
            </Link>
            <ul className={styles.dropdown}>
              {['약속', '소통', '추억', '챗봇', '일정'].map((item, index) => (
                <li key={item}>
                  <Link style={{ display: 'inline-block', width: '100%' }} href={`/#section${index + 1}`}>
                    {item}
                  </Link>
                </li>
              ))}
            </ul>
          </li>
          <li
            className={`${styles['nav-item']} ${active === '/how-to-use' || active === '/mobile' ? styles.active : ''}`}
          >
            <Link href="/mobile" scroll className={styles['main-item']}>
              미리보기
              {(active === '/how-to-use' || active === '/mobile') && <div className={styles.line} />}
            </Link>
            {/* <ul className={styles.dropdown}>
              <li>
                <Link scroll href="/how-to-use">
                  P:ON 사용법
                </Link>
              </li>
              <li>
                <Link scroll href="/mobile">
                  미리보기
                </Link>
              </li>
            </ul> */}
          </li>
          <li className={`${styles['nav-item']} ${active === '/faq' ? styles.active : ''}`}>
            <Link href="/faq" scroll className={styles['main-item']}>
              FAQ
              {active === '/faq' && <div className={styles.line} />}
            </Link>
          </li>
        </ul>
      </nav>
    </header>
  );
}
