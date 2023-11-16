import Image from 'next/image';
import styles from './mobile.module.scss';
import GoogleBtn from '../Home/downloadBtn';

export default function index() {
  return (
    <div className={styles['mobile-container']}>
      <div className={styles.image}>
        <Image
          src="/Pinkys.png"
          alt="핑키 배경"
          layout="fill"
          style={{ objectFit: 'cover' }}
          objectPosition="center"
          quality={100}
          priority
        />
      </div>

      <div className={styles.text}>
        <p> ⁕ 실제 서비스가 아닌 데모 버전입니다</p>
        <p>
          <span>P:ON</span>을 다운받고
        </p>
        <p>직접 사용해보세요</p>
        <GoogleBtn />
      </div>

      <div className={`${styles.device} ${styles.note8}`}>
        <div className={styles.inner} />
        <div className={styles.overflow}>
          <div className={styles.shadow} />
        </div>
        <div className={styles.speaker} />
        <div className={styles.sleep} />
        <div className={styles.volume} />
        <div className={styles.screen}>
          <iframe title="mobileDemo" src="https://p-on.site/wanyviny" width="100%" height="100%" />
        </div>
      </div>
    </div>
  );
}
