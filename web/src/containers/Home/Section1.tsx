import Image from 'next/image';
import styles from './Home.module.scss';
import GoogleBtn from './downloadBtn';

export default function Section1() {
  return (
    <div className={styles.section1}>
      <div className={styles.screenshots}>
        <div className={styles.screen}>
          <div>홈화면</div>
        </div>
        <div className={`${styles.screen}`}>
          <div>핑키화면</div>
        </div>
        <div className={`${styles.screen}`}>
          <div>추억화면</div>
        </div>
      </div>

      <div className={styles.text}>
        <div className={styles.title}>
          <Image src="/P_ON.png" alt="P:ON 로고" objectFit="contain" fill quality={100} />
        </div>
        <p className={styles.description}>
          <span>약속의 시작</span>을 완벽하게 연결합니다!
        </p>
        <GoogleBtn />
      </div>
    </div>
  );
}
