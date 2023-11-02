import Link from 'next/link';

import styles from './Footer.module.scss';

export default function Footer() {
  return (
    <footer className={styles.footer}>
      <div className={styles.content}>
        <div className={styles.company}>와니비니</div>
        <div>
          <ul className={styles['footer-nav']}>
            <li>
              <Link href="/#" scroll={false}>
                개인정보처리방침
              </Link>
            </li>
            <li>
              <Link href="/#" scroll={false}>
                서비스 이용약관
              </Link>
            </li>
          </ul>
          <ul className={styles['footer-info']}>
            <li>
              <p>
                <span>대표</span>
                <span>정수완</span>
              </p>
            </li>
            <li>
              <p>
                <span>이메일</span>
                <span>waniviny@gmain.com</span>
              </p>
            </li>
            <li>
              <p>
                <span>주소</span>
                <span>부산광역시 강서구 송정동 녹산산업중로 333</span>
              </p>
            </li>
          </ul>
        </div>
      </div>
    </footer>
  );
}
